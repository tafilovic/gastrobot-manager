# RestoBot — WebSocket & Notification Specification

> Hand this document to mobile (iOS/Android) and web teams.  
> All real-time notifications arrive on **two channels in parallel**: WebSocket (Socket.IO) when the app is in the foreground, and Firebase Cloud Messaging (FCM) when the app is backgrounded or the user is offline.

---

## 1. WebSocket Connection

### Library
The server uses **Socket.IO**. Use an official Socket.IO client library:

| Platform | Library |
|----------|---------|
| Web | `socket.io-client` (npm) |
| iOS (Swift) | `socket.io-client-swift` |
| Android (Kotlin/Java) | `socket.io-client-java` |
| React Native | `socket.io-client` (npm) |

### Connection URL & Handshake

```
ws://<SERVER_HOST>:<PORT>
```

Connect with **query parameters** in the handshake:

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `userId` | string (UUID) | **Yes** | The authenticated user's ID |
| `venueId` | string (UUID) | **Yes** | The venue the user is currently working at |

**Example (JavaScript)**:
```js
import { io } from 'socket.io-client';

const socket = io('https://api.example.com', {
  query: {
    userId: 'a1b2c3d4-...',
    venueId: 'e5f6a7b8-...',
  },
  transports: ['websocket'], // recommended: skip polling
});
```

**Example (Swift)**:
```swift
let manager = SocketManager(
  socketURL: URL(string: "https://api.example.com")!,
  config: [.log(false), .compress, .connectParams(["userId": userId, "venueId": venueId])]
)
let socket = manager.defaultSocket
socket.connect()
```

**Example (Kotlin)**:
```kotlin
val options = IO.Options().apply {
  query = "userId=$userId&venueId=$venueId"
  transports = arrayOf(WebSocket.NAME)
}
val socket = IO.socket("https://api.example.com", options)
socket.connect()
```

### Connection Lifecycle

| Event | What happens |
|-------|-------------|
| Server validates `userId` | The server calls the user lookup service. If the user does not exist, the connection is **immediately disconnected**. |
| Successful connect | The server stores your socket keyed by `userId`. A user can only have **one active connection** at a time — reconnecting replaces the previous socket. |
| Disconnect | The server removes the socket entry. Reconnect normally to restore it. |

There is **no authentication token** in the WebSocket handshake — authentication is based on the `userId` being present in the database. Secure the connection by only passing a valid `userId` obtained from a successful REST login.

### CORS
CORS is enabled globally (`cors: true`). Any origin can connect.

---

## 2. Listening for Notifications

The server emits **two Socket.IO event names**:

| Event name | Who receives it | Description |
|------------|----------------|-------------|
| `notification` | All roles | Standard notifications (orders, reservations, bill requests, etc.) |
| `bot_response` | Customer/user | Result of a chatbot-created reservation via RabbitMQ |

### Standard notification listener

```js
socket.on('notification', (payload) => {
  console.log(payload);
  // See Section 4 for all possible payload shapes
});
```

### Bot response listener

```js
socket.on('bot_response', (payload) => {
  // payload.type === 'reservation_created'
  // See Section 4.10 for shape
});
```

---

## 3. Firebase Push Notifications (FCM)

When the user is **not connected via WebSocket**, the server sends a Firebase Cloud Messaging push notification instead.

### Register FCM Token

After login, call this REST endpoint to register the device token:

```
POST /v1/notifications/register-token
Authorization: Bearer <JWT>
Content-Type: application/json

{
  "token": "<FCM_device_token>",   // string, 100–4096 chars
  "platform": "ios" | "android" | "web"   // optional but strongly recommended
}
```

Re-register the token whenever Firebase rotates it.

### FCM Payload Structure

The server sends platform-specific messages:

#### Android (data-only, high priority)
```json
{
  "data": {
    "id": "<notification_id>",
    "title": "<title_string>",
    "body": "<JSON-stringified body object>",
    "type": "<notification_type>",
    "entityId": "<order_or_reservation_id>"
  },
  "android": { "priority": "high" }
}
```

> **Android note**: The server sends **data-only** (no `notification` block) so that `onMessageReceived` fires in both foreground and background. Your Android app must build and display a local notification from the `data` map.

#### iOS / Web (notification + data)
```json
{
  "data": {
    "id": "<notification_id>",
    "title": "<title_string>",
    "body": "<JSON-stringified body object>",
    "type": "<notification_type>",
    "entityId": "<order_or_reservation_id>"
  },
  "notification": {
    "title": "<title_string>",
    "body": "<body.message or JSON-stringified body>"
  },
  "apns": {
    "payload": {
      "aps": { "sound": "default", "badge": 1, "mutableContent": true }
    }
  }
}
```

> **Parsing the body field**: The `data.body` field is always a **JSON string**. Parse it with `JSON.parse(data.body)` to get the structured object shown in Section 4.

### Token Lifecycle
- The server automatically removes expired/invalid tokens (`messaging/registration-token-not-registered`, `messaging/invalid-argument`).
- You do not need to handle these errors client-side; just re-register when Firebase gives you a new token.

---

## 4. Notification Payload Reference

Every notification (WebSocket or FCM) follows this top-level shape:

```ts
interface Notification {
  id: string;                    // UUID, stored in DB
  title: string;                 // i18n key or plain text
  body: Record<string, any>;     // varies by type — see below
  type: string;                  // notification category
  entityId?: string;             // related order/reservation/table UUID
  isSeen: boolean;               // false on creation
  venueId?: string;              // venue UUID (when relevant)
  createdAt: string;             // ISO 8601 timestamp
  updatedAt: string;
}
```

The `title` field is an **i18n key** in most cases. Translate it on the client using your localisation system. The `body` often contains a `messageKey` field that is also an i18n key with interpolation variables equal to the other fields in `body`.

---

### 4.1 New Order — Waiter

**Trigger**: A customer confirms a new order.  
**Recipients**: Waiters assigned to the table's region (with fallbacks to region-assigned waiters, then all venue waiters).  
**Event**: `notification`

```json
{
  "id": "uuid",
  "title": "order.for_table",
  "body": {
    "table": "A5",
    "items": [
      { "productName": "Pizza Margherita", "quantity": 2 },
      { "productName": "Beer", "quantity": 3 }
    ],
    "venueId": "uuid",
    "venueName": "Restaurant ABC",
    "orderId": "uuid",
    "reservationId": "uuid"   // only present if order belongs to a reservation
  },
  "type": "order",            // or "reservation" if tied to a reservation
  "entityId": "orderId",      // or reservationId if reservation order
  "isSeen": false
}
```

---

### 4.2 New Order — Kitchen (Chefs)

**Trigger**: A customer confirms a new order that contains food items.  
**Recipients**: Active chefs on staff schedule (fallback: all venue chefs).  
**Event**: `notification`

```json
{
  "id": "uuid",
  "title": "order.kitchen_for_table",
  "body": {
    "table": "A5",
    "items": [
      { "productName": "Pizza Margherita", "quantity": 2 }
    ],
    "orderId": "uuid",
    "reservationId": "uuid"   // only if reservation order
  },
  "type": "order",
  "entityId": "orderId",
  "isSeen": false
}
```

---

### 4.3 New Order — Bar (Bartenders)

**Trigger**: A customer confirms a new order that contains drink items.  
**Recipients**: Active bartenders on staff schedule (fallback: all venue bartenders).  
**Event**: `notification`

```json
{
  "id": "uuid",
  "title": "order.bar_for_table",
  "body": {
    "table": "A5",
    "items": [
      { "productName": "Beer", "quantity": 3 }
    ],
    "orderId": "uuid",
    "reservationId": "uuid"   // only if reservation order
  },
  "type": "order",
  "entityId": "orderId",
  "isSeen": false
}
```

---

### 4.4 Food Ready — Waiter

**Trigger**: Kitchen marks food items as ready.  
**Recipients**: Waiters for the table.  
**Event**: `notification`

```json
{
  "id": "uuid",
  "title": "food_ready.title",
  "body": {
    "messageKey": "food_ready.body",
    "orderId": "uuid",
    "table": "A5",
    "items": ["Pizza Margherita", "Salad"],
    "type": "food_ready"
  },
  "type": "order",
  "entityId": "orderId",
  "isSeen": false
}
```

> `body.items` is a **string array** (just names, no quantities).

---

### 4.5 Drinks Ready — Waiter

**Trigger**: Bar marks drink items as ready.  
**Recipients**: Waiters for the table.  
**Event**: `notification`

```json
{
  "id": "uuid",
  "title": "drinks_ready.title",
  "body": {
    "messageKey": "drinks_ready.body",
    "orderId": "uuid",
    "table": "A5",
    "items": ["Beer", "Cocktail"],
    "type": "drinks_ready"
  },
  "type": "order",
  "entityId": "orderId",
  "isSeen": false
}
```

---

### 4.6 Bill Request — Waiter

**Trigger**: Customer requests the bill at their table.  
**Recipients**: Waiters for the table.  
**Event**: `notification`

```json
{
  "id": "uuid",
  "title": "bill_request.title",
  "body": {
    "messageKey": "bill_request.body",
    "table": "A5",
    "tableId": "uuid",
    "paymentType": "cash",
    "type": "bill_request"
  },
  "type": "bill_request",
  "entityId": "tableId",
  "isSeen": false
}
```

---

### 4.7 Order Completion Time — Waiter

**Trigger**: A manager sets the estimated preparation time for an order.  
**Recipients**: Waiters for the table.  
**Event**: `notification`

```json
{
  "id": "uuid",
  "title": "order.completion_time",
  "body": {
    "time": "15 minutes",
    "orderId": "uuid"
  },
  "type": null,
  "entityId": null,
  "isSeen": false
}
```

---

### 4.8 Kitchen ETA — Waiter (item accepted by kitchen)

**Trigger**: Kitchen accepts an order item (with or without estimated prep time).  
**Recipients**: Waiters for the table.  
**Event**: `notification`

```json
{
  "id": "uuid",
  "title": "order_item.eta_title",
  "body": {
    "messageKey": "order_item.eta_body",         // or "order_item.eta_body_no_time" if no time
    "table": "A5",
    "productName": "Pizza Margherita",
    "minutes": 15,                               // null if no time provided
    "orderId": "uuid",
    "itemId": "uuid",
    "estimatedTime": 15,                         // null if no time provided
    "type": "kitchen_estimate"
  },
  "type": "order",
  "entityId": "orderId",
  "isSeen": false
}
```

---

### 4.9 Item Accepted — Customer

**Trigger**: Kitchen/bar accepts a specific order item.  
**Recipients**: The customer who placed the order.  
**Event**: `notification`

```json
{
  "id": "uuid",
  "title": "order_item.accepted_title",
  "body": {
    "messageKey": "order_item.accepted_body",
    "productName": "Pizza Margherita",
    "orderId": "uuid",
    "itemId": "uuid",
    "venueName": "Restaurant ABC",
    "estimatedTime": 15    // only present if provided
  },
  "type": "item_accepted",
  "entityId": "orderId",
  "isSeen": false
}
```

---

### 4.10 Item Rejected — Customer

**Trigger**: Kitchen/bar rejects a specific order item.  
**Recipients**: The customer who placed the order.  
**Event**: `notification`

```json
{
  "id": "uuid",
  "title": "order_item.rejected_title",
  "body": {
    "messageKey": "order_item.rejected_customer_body",
    "productName": "Pizza Margherita",
    "orderId": "uuid",
    "itemId": "uuid",
    "reason": "Out of stock",              // null if no reason given
    "reasonKey": null,                     // "order_item.rejection_default_reason" if no reason given
    "venueName": "Restaurant ABC",
    "orderStatus": "rejected"             // overall order status after rejection
  },
  "type": "item_rejection",
  "entityId": "orderId",
  "isSeen": false
}
```

---

### 4.11 Item Rejected — Waiter

**Trigger**: Kitchen/bar rejects a specific order item.  
**Recipients**: Waiters for the table (only if venue setting `waiterActsAsBartender` is false).  
**Event**: `notification`

```json
{
  "id": "uuid",
  "title": "order_item.rejected_waiter_title",
  "body": {
    "messageKey": "order_item.rejected_waiter_body",
    "table": "A5",
    "productName": "Pizza Margherita",
    "orderId": "uuid",
    "itemId": "uuid",
    "reason": "Out of stock",              // null if no reason given
    "reasonKey": null,                     // "order_item.rejection_default_reason" if no reason given
    "orderStatus": "rejected",
    "type": "item_rejection"
  },
  "type": "order",
  "entityId": "orderId",
  "isSeen": false
}
```

---

### 4.12 Order Confirmed — Customer

**Trigger**: Staff confirms a pending order.  
**Recipients**: The customer who placed the order.  
**Event**: `notification`

```json
{
  "id": "uuid",
  "title": "order.confirmed",
  "body": {
    "orderId": "uuid",
    "orderNumber": 42,
    "table": "A5",
    "status": "confirmed",
    "venueId": "uuid",
    "venueName": "Restaurant ABC",
    "reservationId": "uuid"    // only if tied to a reservation
  },
  "type": "order",
  "entityId": "orderId",
  "isSeen": false
}
```

---

### 4.13 Order Rejected — Customer

**Trigger**: Staff rejects a pending order.  
**Recipients**: The customer who placed the order.  
**Event**: `notification`

```json
{
  "id": "uuid",
  "title": "order.rejected",
  "body": {
    "orderId": "uuid",
    "orderNumber": 42,
    "table": "A5",
    "status": "rejected",
    "rejectionNote": "Kitchen is closed",
    "venueId": "uuid",
    "venueName": "Restaurant ABC",
    "reservationId": "uuid"    // only if tied to a reservation
  },
  "type": "order",
  "entityId": "orderId",
  "isSeen": false
}
```

---

### 4.14 Reservation Created — Customer (new request sent to managers)

**Trigger**: Customer submits a new reservation request. Sent to managers/admins of the venue.  
**Recipients**: Venue managers/admins.  
**Event**: `notification`

```json
{
  "id": "uuid",
  "title": "reservation.new_request",
  "body": {
    "reservationId": "uuid",
    "reservationNumber": "ABC123",
    "table": "N/A",
    "time": "2026-05-15T19:00:00.000Z",
    "people": 4,
    "venueId": "uuid",
    "venueName": "Restaurant ABC",
    "orderId": "uuid"    // only if reservation includes a pre-order
  },
  "type": "reservation",
  "entityId": "reservationId",
  "isSeen": false
}
```

---

### 4.15 Reservation Confirmed — Customer

**Trigger**: Staff confirms a reservation.  
**Recipients**: The customer who made the reservation.  
**Event**: `notification`

```json
{
  "id": "uuid",
  "title": "reservation.confirmed",
  "body": {
    "reservationId": "uuid",
    "reservationNumber": "ABC123",
    "table": "T5",             // assigned table name
    "status": "confirmed",
    "venueId": "uuid",
    "venueName": "Restaurant ABC",
    "orderId": "uuid"          // only if reservation has a linked order
  },
  "type": "reservation",
  "entityId": "reservationId",
  "isSeen": false
}
```

---

### 4.16 Reservation Rejected — Customer

**Trigger**: Staff rejects a reservation request.  
**Recipients**: The customer who made the reservation.  
**Event**: `notification`

```json
{
  "id": "uuid",
  "title": "reservation.rejected",
  "body": {
    "reservationId": "uuid",
    "reservationNumber": "ABC123",
    "status": "rejected",
    "reason": "No available tables",
    "venueId": "uuid",
    "venueName": "Restaurant ABC",
    "orderId": "uuid"    // only if tied to an order
  },
  "type": "reservation",
  "entityId": "reservationId",
  "isSeen": false
}
```

---

### 4.17 Reservation Reminder — Customer

**Trigger**: Automated cron job — runs every hour, sends reminder ~8 hours before reservation start.  
**Recipients**: The customer with a confirmed reservation.  
**Condition**: Venue must have `sendReservationReminders` enabled in settings.  
**Event**: `notification`

```json
{
  "id": "uuid",
  "title": "reservation_reminder.title",
  "body": {
    "messageKey": "reservation_reminder.body",
    "reservationNumber": "ABC123",
    "venue": "Restaurant ABC",
    "time": "2026-05-15T19:00:00.000Z",
    "people": 4,
    "table": "T5, T6"    // comma-separated if multiple tables
  },
  "type": "reservation_reminder",
  "entityId": "reservationId",
  "isSeen": false
}
```

---

### 4.18 Kitchen Prep Alert — Chef (reservation-linked order)

**Trigger**: Automated cron job — reminds kitchen to start preparation for a reservation order.  
**Recipients**: Active chefs on staff schedule (fallback: all venue chefs).  
**Event**: `notification`

```json
{
  "id": "uuid",
  "title": "kitchen.start_preparation_title",
  "body": {
    "messageKey": "kitchen.start_preparation_body",
    "reservationNumber": "ABC123",
    "time": "19:00",              // formatted HH:MM
    "orderId": "uuid",
    "orderNumber": 42,
    "table": "T5",
    "reservationStart": "2026-05-15T19:00:00.000Z",
    "type": "kitchen_prep_alert"
  },
  "type": "kitchen",
  "entityId": "orderId",
  "isSeen": false
}
```

---

### 4.19 Bulk Import Complete — Manager (WebSocket only)

**Trigger**: A bulk product/menu import finishes.  
**Recipients**: All connected managers for the venue (WebSocket only, no DB record saved).  
**Event**: `notification`

```json
{
  "message": "Bulk import completed: 25 products and 30 menu items created across 5 categories.",
  "venueId": "uuid",
  "productsCreated": 25,
  "menuItemsCreated": 30,
  "categoriesCreated": 5
}
```

> This notification does **not** follow the standard `Notification` entity shape — it is sent directly via WebSocket and is not persisted to the database.

---

### 4.20 Bot Reservation Created (event: `bot_response`)

**Trigger**: A chatbot creates a reservation via RabbitMQ messaging.  
**Recipients**: The user who interacted with the bot.  
**Event**: `bot_response` ← different event name!

```json
{
  "type": "reservation_created",
  "userId": "uuid",
  "body": {
    "reservationId": "uuid",
    "conversationId": "uuid",
    "reservationNumber": "ABC123",
    "reservationStart": "2026-05-15T19:00:00.000Z"
  },
  "message": "Reservation created successfully"
}
```

---

## 5. Notification Types Summary Table

| `type` | `body.type` | Sent to | Trigger |
|--------|-------------|---------|---------|
| `order` | _(none)_ | Waiter | New order placed |
| `order` | _(none)_ | Chef | New order with food items |
| `order` | _(none)_ | Bartender | New order with drink items |
| `order` | `food_ready` | Waiter | Kitchen marks food as ready |
| `order` | `drinks_ready` | Waiter | Bar marks drinks as ready |
| `bill_request` | `bill_request` | Waiter | Customer requests bill |
| `order` | `kitchen_estimate` | Waiter | Kitchen accepts item (with ETA) |
| `order` | `item_rejection` | Waiter | Kitchen/bar rejects an item |
| `item_accepted` | _(none)_ | Customer | Kitchen/bar accepts item |
| `item_rejection` | _(none)_ | Customer | Kitchen/bar rejects item |
| `order` | _(none)_ | Customer | Order confirmed by staff |
| `order` | _(none)_ | Customer | Order rejected by staff |
| `reservation` | _(none)_ | Manager/Admin | New reservation request |
| `reservation` | _(none)_ | Customer | Reservation confirmed |
| `reservation` | _(none)_ | Customer | Reservation rejected |
| `reservation_reminder` | _(none)_ | Customer | 8 h before reservation (automated) |
| `kitchen` | `kitchen_prep_alert` | Chef | Prep-time alert for reservation (automated) |

---

## 6. REST API for Notifications

Base URL: `/v1/notifications`

### 6.1 Register FCM Token
```
POST /v1/notifications/register-token
Authorization: Bearer <JWT>

Body:
{
  "token": string,           // required, 100–4096 chars
  "platform": "ios" | "android" | "web"   // optional but recommended
}
```

### 6.2 Get My Notifications
```
GET /v1/notifications
Authorization: Bearer <JWT>

Query params (all optional):
  page          integer    default: 1
  limit         integer    default: 10
  startDate     ISO date   filter by createdAt >=
  endDate       ISO date   filter by createdAt <=
  type          string     comma-separated, e.g. "order,reservation"
  bodyType      string     comma-separated values matched against body.type JSON field
  excludeType   string     comma-separated types to exclude
  excludeBodyType string   comma-separated body.type values to exclude
  isSeen        boolean    filter by read status

Response:
{
  "notifications": [ Notification ],
  "pagination": {
    "totalCount": number,
    "hasNextPage": boolean
  },
  "numberOfUnseenNotifications": number
}
```

### 6.3 Mark One Notification as Read
```
PATCH /v1/notifications/:id
(no auth required)

Response: updated Notification object
```

### 6.4 Mark All Notifications as Read
```
PATCH /v1/notifications
Authorization: Bearer <JWT>

Response: array of updated Notification objects
```

### 6.5 Mark All as Read (with filters)
```
PATCH /v1/notifications/read-all
Authorization: Bearer <JWT>

Query params (all optional, same as GET):
  type, bodyType, excludeType, excludeBodyType

Response: array of updated Notification objects
```

### 6.6 Set Order Preparation Time
```
PATCH /v1/notifications/order-time/:orderId
Authorization: Bearer <JWT>

Body: { "time": "15 minutes" }

Response: sends notification to waiters, returns notification object
```

---

## 7. Notification Routing Logic

Understanding who receives what helps with debugging:

```
New order confirmed
  ├── Waiter notification  → waiters on active staff schedule for the table's region
  │                          → fallback: region-assigned waiters
  │                          → fallback: all venue waiters
  ├── Chef notification    → chefs on active staff schedule
  │                          → fallback: all venue chefs
  └── Bartender notification → bartenders on active staff schedule
                              → fallback: all venue bartenders

For each target user:
  ├── If connected via WebSocket → send via socket.emit('notification', payload)
  └── If NOT connected           → send via FCM push notification
                                   (only if FCM token registered for at least one session)
```

All notifications are also **saved to the database** (except the bulk-import notification in section 4.19).

---

## 8. Reconnection Recommendations

| Scenario | Recommendation |
|----------|---------------|
| App comes to foreground | Reconnect with the same `userId` and `venueId` |
| User switches venue | Disconnect and reconnect with the new `venueId` |
| User logs out | Call `socket.disconnect()` |
| Network interruption | Use Socket.IO built-in auto-reconnect (`reconnection: true`) |
| Server restart | Socket.IO will retry; no special handling needed |

**Important**: The server tracks **one socket per userId**. If the same user connects from two devices simultaneously, the second connection replaces the first. Only one device will receive WebSocket notifications at a time. FCM handles all devices via registered tokens.

---

## 9. i18n Keys Reference

These are the `title` and `body.messageKey` values used in notifications. Provide translations for each.

| Key | Context |
|-----|---------|
| `order.for_table` | New order — waiter |
| `order.kitchen_for_table` | New order — chef |
| `order.bar_for_table` | New order — bartender |
| `order.completion_time` | Estimated completion time |
| `order.confirmed` | Order confirmed — customer |
| `order.rejected` | Order rejected — customer |
| `food_ready.title` | Food ready — waiter |
| `food_ready.body` | Food ready body (items: string[]) |
| `drinks_ready.title` | Drinks ready — waiter |
| `drinks_ready.body` | Drinks ready body (items: string[]) |
| `bill_request.title` | Bill request — waiter |
| `bill_request.body` | Bill request body (table, paymentType) |
| `order_item.eta_title` | Item accepted by kitchen — waiter |
| `order_item.eta_body` | ETA body with minutes (productName, minutes) |
| `order_item.eta_body_no_time` | ETA body without time (productName) |
| `order_item.accepted_title` | Item accepted — customer |
| `order_item.accepted_body` | Item accepted body (productName, venueName) |
| `order_item.rejected_title` | Item rejected — customer |
| `order_item.rejected_customer_body` | Rejection body (productName, reason) |
| `order_item.rejected_waiter_title` | Item rejected — waiter |
| `order_item.rejected_waiter_body` | Rejection body for waiter (table, productName) |
| `order_item.rejection_default_reason` | Default rejection reason (no specific reason given) |
| `reservation.new_request` | New reservation request — manager |
| `reservation.confirmed` | Reservation confirmed — customer |
| `reservation.rejected` | Reservation rejected — customer |
| `reservation_reminder.title` | Reminder title — customer |
| `reservation_reminder.body` | Reminder body (reservationNumber, venue, time, people, table) |
| `kitchen.start_preparation_title` | Kitchen prep alert title — chef |
| `kitchen.start_preparation_body` | Kitchen prep alert body (reservationNumber, time) |

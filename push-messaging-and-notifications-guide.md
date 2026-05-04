# Notification i18n — Backend Changes

All notification `title` fields and body message strings are now **translation keys** instead of hardcoded English text. The `body` object contains all dynamic values needed for interpolation.

---

## Structure

Every notification now follows this shape:

```json
{
  "title": "translation.key",
  "body": {
    "messageKey": "translation.key.for.body.message",
    "dynamicValue1": "...",
    "dynamicValue2": "..."
  },
  "type": "order | reservation | ...",
  "entityId": "uuid"
}
```

- `title` — always a translation key
- `body.messageKey` — translation key for the main body message (present when there is a human-readable sentence in the body)
- All other `body` fields — dynamic values for interpolation

---

## Keys Reference

### Orders

| `title` key | `body.messageKey` | Dynamic values in `body` |
|---|---|---|
| `order.for_table` | — | `table`, `items[]`, `venueId`, `venueName` |
| `order.kitchen_for_table` | — | `table`, `items[]` |
| `order.bar_for_table` | — | `table`, `items[]` |
| `order.rejected` | — | `orderNumber`, `table`, `status`, `rejectionNote`, `venueId`, `venueName` |
| `order.confirmed` | — | `orderNumber`, `table`, `status`, `venueId`, `venueName` |
| `order.completion_time` | — | `time`, `orderId` |

### Order Items

| `title` key | `body.messageKey` | Dynamic values in `body` |
|---|---|---|
| `order_item.rejected_title` | `order_item.rejected_customer_body` | `productName`, `orderId`, `itemId`, `reason`, `venueName`, `orderStatus` |
| `order_item.rejected_waiter_title` | `order_item.rejected_waiter_body` | `table`, `productName`, `orderId`, `itemId`, `reason`, `orderStatus` |
| `order_item.eta_title` | `order_item.eta_body` | `table`, `productName`, `minutes`, `orderId`, `itemId`, `estimatedTime` |
| `order_item.accepted_title` | `order_item.accepted_body` | `productName`, `orderId`, `itemId`, `venueName`, `estimatedTime?` |

### Reservations

| `title` key | `body.messageKey` | Dynamic values in `body` |
|---|---|---|
| `reservation.new_request` | — | `reservationNumber`, `table`, `time`, `people`, `venueId`, `venueName` |
| `reservation.confirmed` | — | `reservationNumber`, `reservationId`, `table`, `status`, `venueId`, `venueName` |
| `reservation.rejected` | — | `reservationNumber`, `reservationId`, `status`, `reason`, `venueId`, `venueName` |
| `reservation.cancelled` | — | `reservationNumber`, `reservationId`, `status`, `venueId`, `venueName` |
| `reservation_reminder.title` | `reservation_reminder.body` | `reservationNumber`, `venue`, `time`, `people`, `table` |

### Kitchen

| `title` key | `body.messageKey` | Dynamic values in `body` |
|---|---|---|
| `kitchen.start_preparation_title` | `kitchen.start_preparation_body` | `reservationNumber`, `time`, `orderId`, `orderNumber`, `table` |

### Food & Drinks

| `title` key | `body.messageKey` | Dynamic values in `body` |
|---|---|---|
| `food_ready.title` | `food_ready.body` | `table`, `items[]`, `orderId` |
| `drinks_ready.title` | `drinks_ready.body` | `table`, `items[]`, `orderId` |

---

## English Translations (suggested)

```json
{
  "order.for_table": "Order for table {{table}}",
  "order.kitchen_for_table": "Kitchen Order for table {{table}}",
  "order.bar_for_table": "Bar Order for table {{table}}",
  "order.rejected": "Order {{orderNumber}} rejected",
  "order.confirmed": "Order {{orderNumber}} confirmed",
  "order.completion_time": "Order completion time",

  "order_item.rejected_title": "Item Rejected: {{productName}}",
  "order_item.rejected_customer_body": "We're sorry, but \"{{productName}}\" is currently unavailable. It has been removed from your order bill.",
  "order_item.rejected_waiter_title": "Item Rejected: {{table}}",
  "order_item.rejected_waiter_body": "\"{{productName}}\" was rejected and removed from the order.",
  "order_item.eta_title": "ETA Set: {{table}}",
  "order_item.eta_body": "Kitchen set {{minutes}} min estimate for {{productName}}",
  "order_item.accepted_title": "Item Accepted: {{productName}}",
  "order_item.accepted_body": "\"{{productName}}\" has been accepted and is being prepared.",

  "reservation.new_request": "New Reservation Request",
  "reservation.confirmed": "Reservation {{reservationNumber}} confirmed",
  "reservation.rejected": "Reservation {{reservationNumber}} rejected",
  "reservation.cancelled": "Reservation {{reservationNumber}} cancelled",
  "reservation_reminder.title": "Reservation Reminder",
  "reservation_reminder.body": "Your reservation is in 8 hours",

  "kitchen.start_preparation_title": "Start Preparation: Reservation Order",
  "kitchen.start_preparation_body": "Time to prepare food for Reservation #{{reservationNumber}}. Guests arrive at {{time}}.",

  "food_ready.title": "Food Ready: Table {{table}}",
  "food_ready.body": "{{items}} are ready to serve.",

  "drinks_ready.title": "Drinks Ready: Table {{table}}",
  "drinks_ready.body": "{{items}} are ready at the bar."
}
```

---

## Example Payloads

### order.for_table
Sent to: **waiters** when a new order is placed.
```json
{
  "title": "order.for_table",
  "body": {
    "table": "5",
    "items": [
      { "productName": "Burger", "quantity": 2 },
      { "productName": "Fries", "quantity": 1 }
    ],
    "venueId": "a1b2c3",
    "venueName": "Brrm Restaurant"
  },
  "type": "order",
  "entityId": "order-uuid"
}
```

### order.kitchen_for_table
Sent to: **kitchen staff** when a new order has food items.
```json
{
  "title": "order.kitchen_for_table",
  "body": {
    "table": "5",
    "items": [
      { "productName": "Burger", "quantity": 2 }
    ]
  },
  "type": "order",
  "entityId": "order-uuid"
}
```

### order.bar_for_table
Sent to: **bar staff** when a new order has drink items.
```json
{
  "title": "order.bar_for_table",
  "body": {
    "table": "5",
    "items": [
      { "productName": "Cola", "quantity": 2 }
    ]
  },
  "type": "order",
  "entityId": "order-uuid"
}
```

### order.confirmed
Sent to: **customer** when their order is confirmed.
```json
{
  "title": "order.confirmed",
  "body": {
    "orderId": "order-uuid",
    "orderNumber": "1042",
    "table": "5",
    "status": "CONFIRMED",
    "venueId": "a1b2c3",
    "venueName": "Brrm Restaurant"
  },
  "type": "order",
  "entityId": "order-uuid"
}
```

### order.rejected
Sent to: **customer** when their order is rejected.
```json
{
  "title": "order.rejected",
  "body": {
    "orderId": "order-uuid",
    "orderNumber": "1042",
    "table": "5",
    "status": "REJECTED",
    "rejectionNote": "Kitchen is closed",
    "venueId": "a1b2c3",
    "venueName": "Brrm Restaurant"
  },
  "type": "order",
  "entityId": "order-uuid"
}
```

### order.completion_time
Sent to: **waiters** when estimated completion time is set.
```json
{
  "title": "order.completion_time",
  "body": {
    "time": "20:30",
    "orderId": "order-uuid"
  },
  "type": null,
  "entityId": null
}
```

---

### order_item.rejected_title (customer)
Sent to: **customer** when a specific item is rejected.
```json
{
  "title": "order_item.rejected_title",
  "body": {
    "messageKey": "order_item.rejected_customer_body",
    "productName": "Burger",
    "orderId": "order-uuid",
    "itemId": "item-uuid",
    "reason": "Out of stock",
    "venueName": "Brrm Restaurant",
    "orderStatus": "CONFIRMED"
  },
  "type": "item_rejection",
  "entityId": "order-uuid"
}
```

### order_item.rejected_waiter_title (waiter)
Sent to: **waiters** when a specific item is rejected.
```json
{
  "title": "order_item.rejected_waiter_title",
  "body": {
    "messageKey": "order_item.rejected_waiter_body",
    "table": "5",
    "productName": "Burger",
    "orderId": "order-uuid",
    "itemId": "item-uuid",
    "reason": "Out of stock",
    "orderStatus": "CONFIRMED",
    "type": "item_rejection"
  },
  "type": "order",
  "entityId": "order-uuid"
}
```

### order_item.eta_title
Sent to: **waiters** when kitchen sets a prep time estimate.
```json
{
  "title": "order_item.eta_title",
  "body": {
    "messageKey": "order_item.eta_body",
    "table": "5",
    "productName": "Burger",
    "minutes": 15,
    "orderId": "order-uuid",
    "itemId": "item-uuid",
    "estimatedTime": 15,
    "type": "kitchen_estimate"
  },
  "type": "order",
  "entityId": "order-uuid"
}
```

### order_item.accepted_title
Sent to: **customer** when their item is accepted by kitchen.
```json
{
  "title": "order_item.accepted_title",
  "body": {
    "messageKey": "order_item.accepted_body",
    "productName": "Burger",
    "orderId": "order-uuid",
    "itemId": "item-uuid",
    "venueName": "Brrm Restaurant",
    "estimatedTime": 15
  },
  "type": "item_accepted",
  "entityId": "order-uuid"
}
```

---

### reservation.new_request
Sent to: **venue staff (waiters/managers)** when a customer creates a reservation.
```json
{
  "title": "reservation.new_request",
  "body": {
    "reservationNumber": "R-0042",
    "table": "N/A",
    "time": "2025-06-15T19:00:00.000Z",
    "people": 4,
    "venueId": "a1b2c3",
    "venueName": "Brrm Restaurant"
  },
  "type": "reservation",
  "entityId": "reservation-uuid"
}
```

### reservation.confirmed
Sent to: **customer** when their reservation is confirmed.
```json
{
  "title": "reservation.confirmed",
  "body": {
    "reservationId": "reservation-uuid",
    "reservationNumber": "R-0042",
    "table": "Table 3",
    "status": "CONFIRMED",
    "venueId": "a1b2c3",
    "venueName": "Brrm Restaurant"
  },
  "type": "reservation",
  "entityId": "reservation-uuid"
}
```

### reservation.rejected
Sent to: **customer** when their reservation is rejected.
```json
{
  "title": "reservation.rejected",
  "body": {
    "reservationId": "reservation-uuid",
    "reservationNumber": "R-0042",
    "status": "REJECTED",
    "reason": "No available tables",
    "venueId": "a1b2c3",
    "venueName": "Brrm Restaurant"
  },
  "type": "reservation",
  "entityId": "reservation-uuid"
}
```

### reservation.cancelled
Sent to: **venue staff (waiters/managers)** when a customer cancels their reservation.
```json
{
  "title": "reservation.cancelled",
  "body": {
    "reservationId": "reservation-uuid",
    "reservationNumber": "R-0042",
    "status": "CANCELLED",
    "venueId": "a1b2c3",
    "venueName": "Brrm Restaurant"
  },
  "type": "reservation",
  "entityId": "reservation-uuid"
}
```

### reservation_reminder.title
Sent to: **customer** 8 hours before their reservation.
```json
{
  "title": "reservation_reminder.title",
  "body": {
    "messageKey": "reservation_reminder.body",
    "reservationNumber": "R-0042",
    "venue": "Brrm Restaurant",
    "time": "2025-06-15T19:00:00.000Z",
    "people": 4,
    "table": "Table 3"
  },
  "type": "reservation_reminder",
  "entityId": "reservation-uuid"
}
```

---

### kitchen.start_preparation_title
Sent to: **kitchen staff** when it's time to start preparing a reservation order.
```json
{
  "title": "kitchen.start_preparation_title",
  "body": {
    "messageKey": "kitchen.start_preparation_body",
    "reservationNumber": "R-0042",
    "time": "07:00 PM",
    "orderId": "order-uuid",
    "orderNumber": "1042",
    "table": "Table 3",
    "reservationStart": "2025-06-15T19:00:00.000Z",
    "type": "kitchen_prep_alert"
  },
  "type": "kitchen",
  "entityId": "order-uuid"
}
```

---

### food_ready.title
Sent to: **waiters** when kitchen marks items as ready.
```json
{
  "title": "food_ready.title",
  "body": {
    "messageKey": "food_ready.body",
    "table": "5",
    "items": ["Burger", "Fries"],
    "orderId": "order-uuid",
    "type": "food_ready"
  },
  "type": "order",
  "entityId": "order-uuid"
}
```

### drinks_ready.title
Sent to: **waiters** when bar marks drinks as ready.
```json
{
  "title": "drinks_ready.title",
  "body": {
    "messageKey": "drinks_ready.body",
    "table": "5",
    "items": ["Cola", "Beer"],
    "orderId": "order-uuid",
    "type": "drinks_ready"
  },
  "type": "order",
  "entityId": "order-uuid"
}
```

---

## How to Use on the Client

```js
// 1. Receive notification
const { title, body } = notification;

// 2. Translate title using the key
const translatedTitle = t(title, { ...body });

// 3. If body has a messageKey, translate that too
const translatedMessage = body.messageKey ? t(body.messageKey, { ...body }) : null;
```

The client reads `title` as a translation key, looks up the translation, and interpolates values from `body`.
Same pattern applies for `body.messageKey`.

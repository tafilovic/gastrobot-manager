# Notifications API — New Filter Parameters

This document describes new filtering capabilities added to two notification endpoints. Both endpoints now support filtering by the notification's `type` column AND by the `type` field nested inside the JSON `body` column. In addition to the **include** filters (`type`, `bodyType`), there are now **exclude** filters (`excludeType`, `excludeBodyType`) for both endpoints.

All filters accept either a single value or a **comma-separated list** of values. When multiple filters are provided, they are combined with AND — a notification must satisfy every supplied filter to be returned/updated. Exclude filters are `NULL`-safe: notifications whose `type` (or `body.type`) is `NULL` are still returned and are not filtered out by `excludeType` / `excludeBodyType`.

---

## 1. `GET /notifications`

Returns the current user's notifications with pagination.

### Query parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `page` | number | No | Page number (default: `1`) |
| `limit` | number | No | Items per page (default: `10`) |
| `startDate` | ISO date | No | Filter by creation date — lower bound |
| `endDate` | ISO date | No | Filter by creation date — upper bound |
| `type` | string | No | Filter by `notification.type`. Accepts single value or comma-separated list. |
| `bodyType` | string | No | Filter by `notification.body.type`. Accepts single value or comma-separated list. |
| `excludeType` | string | No | **(new)** Exclude `notification.type` value(s). Accepts single value or comma-separated list. |
| `excludeBodyType` | string | No | **(new)** Exclude `notification.body.type` value(s). Accepts single value or comma-separated list. |
| `isSeen` | boolean | No | Filter by seen/unseen status |

### Examples

```
GET /notifications?type=order
GET /notifications?type=order,reservation
GET /notifications?bodyType=food_ready
GET /notifications?bodyType=food_ready,bill_request
GET /notifications?type=order&bodyType=food_ready
GET /notifications?type=order,reservation&bodyType=food_ready,bill_request&isSeen=false&page=1&limit=20

# New — exclude
GET /notifications?excludeType=bill_request
GET /notifications?excludeType=bill_request,order_accepted
GET /notifications?excludeBodyType=food_ready
GET /notifications?excludeBodyType=food_ready,bill_request
GET /notifications?type=order&excludeBodyType=food_ready
```

### Response

Unchanged. Returns:

```json
{
  "notifications": [ /* Notification[] */ ],
  "pagination": {
    "totalCount": 0,
    "hasNextPage": false
  },
  "numberOfUnseenNotifications": 0
}
```

---

## 2. `PATCH /notifications/read-all`

Marks all unseen notifications for the current user as read, optionally filtered.

### Query parameters

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `type` | string | No | Filter by `notification.type`. Accepts single value or comma-separated list. |
| `bodyType` | string | No | Filter by `notification.body.type`. Accepts single value or comma-separated list. |
| `excludeType` | string | No | **(new)** Exclude `notification.type` value(s) from being marked as read. Comma-separated for multiple. |
| `excludeBodyType` | string | No | **(new)** Exclude `notification.body.type` value(s) from being marked as read. Comma-separated for multiple. |

If all filters are omitted, all unseen notifications for the user are marked as read.

### Examples

```
PATCH /notifications/read-all
PATCH /notifications/read-all?type=order
PATCH /notifications/read-all?type=order,reservation
PATCH /notifications/read-all?bodyType=food_ready
PATCH /notifications/read-all?bodyType=food_ready,bill_request
PATCH /notifications/read-all?type=order&bodyType=food_ready

# New — exclude
PATCH /notifications/read-all?excludeType=bill_request
PATCH /notifications/read-all?excludeBodyType=food_ready
PATCH /notifications/read-all?excludeType=bill_request&excludeBodyType=food_ready
```

Typical use case: "mark everything as read except bill requests" → `PATCH /notifications/read-all?excludeType=bill_request`.

### Response

Unchanged. Returns the array of notifications that were updated.

---

## Difference between `type` and `bodyType`

A notification record has two relevant fields:

- `type` — top-level column on the `notifications` table (e.g. `order`, `reservation`, `bill_request`).
- `body` — JSON column. Some notifications include a `type` inside this JSON to describe a more specific sub-category (e.g. `body.type = "food_ready"` while the top-level `type = "order"`).

### Example notification

```json
{
  "id": "uuid",
  "title": "food_ready.title",
  "type": "order",
  "entityId": "ORD-123",
  "body": {
    "messageKey": "food_ready.body",
    "orderId": "ORD-123",
    "table": "T5",
    "items": ["Pizza"],
    "type": "food_ready"
  },
  "isSeen": false
}
```

- `?type=order` → matches this notification.
- `?bodyType=food_ready` → matches this notification.
- `?type=order&bodyType=food_ready` → matches this notification.
- `?type=reservation` → does NOT match.
- `?excludeType=order` → does NOT match (excluded).
- `?excludeBodyType=food_ready` → does NOT match (excluded).
- `?excludeType=bill_request` → matches (not in the excluded list).

---

## Known `type` values

Top-level `type` values currently produced by the backend include:

- `order`
- `reservation`
- `order_accepted`
- `order_awaiting_user_confirmation`
- `bill_request`

## Known `bodyType` values

Values that may appear in `body.type`:

- `food_ready`
- `bill_request`

This list is not exhaustive — new values may be added as features evolve.

---

## Notes for the client team

- Comma-separated lists must not include spaces around commas, or they should be URL-encoded. The backend trims whitespace, but encoding is still recommended.
- All filters are optional and can be combined freely with each other and with the existing parameters (`page`, `limit`, `startDate`, `endDate`, `isSeen`).
- Include and exclude filters can be combined. If a value appears in both `type` and `excludeType` for the same request, the exclude wins (the row is filtered out).
- Exclude filters are `NULL`-safe — notifications that have no `type` or no `body.type` are **not** removed by `excludeType` / `excludeBodyType`.
- No breaking changes — existing single-value `type=...` calls continue to work exactly as before.

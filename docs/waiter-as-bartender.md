# Waiter Acts As Bartender

A per-venue setting that lets a `WAITER` user perform bartender actions on bar routes. Designed for smaller venues that do not have a dedicated bartender on staff.

When the setting is **off** (default): bar endpoints reject `WAITER` users with `403 Forbidden`. Only `BARTENDER`, `MANAGER`, `ADMIN`, `ROOT` can use them.

When the setting is **on**: `WAITER` users at that venue can additionally call all `/venues/:venueId/bar/*` endpoints. All other venues remain unaffected.

The setting is **per-venue**, not global. A user with the `WAITER` role only gains bar access on venues where the flag is enabled.

---

## 1. Setting Definition

**Field:** `waiterActsAsBartender`
**Type:** `boolean`
**Default:** `false`
**Stored on:** `VenueSettings` (one-to-one with Venue)

---

## 2. Reading the Setting

**`GET /v1/venues/:venueId/settings`**

### Response `200` (excerpt)

```json
{
  "id": "uuid",
  "allowReservations": true,
  "allowOrdering": true,
  "allowBot": true,
  "sendReservationReminders": true,
  "allowWaiterToAcceptOrder": true,
  "defaultReservationDuration": 120,
  "orderPrepBufferTime": 60,
  "allowedAnalytics": true,
  "waiterActsAsBartender": false
}
```

---

## 3. Updating the Setting

**`PUT /v1/venues/:venueId/settings`**

### Request Body

Only include fields you want to change — all are optional.

```json
{
  "waiterActsAsBartender": true
}
```

### Response `200`

Returns the full updated `VenueSettings` object (same shape as the `GET` above).

### Response `404`

If no settings record exists for the venue yet — call `POST /venues/:venueId/settings` first to create one.

---

## 4. Creating Settings (if not yet created)

**`POST /venues/:venueId/settings`**

```json
{
  "allowReservations": true,
  "allowOrdering": true,
  "allowBot": true,
  "defaultReservationDuration": 120,
  "orderPrepBufferTime": 60,
  "allowedAnalytics": true,
  "waiterActsAsBartender": false
}
```

If `waiterActsAsBartender` is omitted, it defaults to `false`.

---

## 5. UI Recommendations

### Where to surface the toggle

Add it to the venue settings screen, alongside `allowWaiterToAcceptOrder` and similar staffing-related toggles.

### Suggested labels

- **Label:** "Waiters can manage bar orders"
- **Helper text:** "Enable for smaller venues without a dedicated bartender. Waiters will be able to view and mark drinks as ready in addition to their normal duties."
- **Default state in the form:** off

### Who can change it

The settings endpoint is currently reachable to anyone with venue access — apply the same permissions you already use for the other settings on this page (`MANAGER`, `ADMIN`, `ROOT` typically).

---

## 6. Effect on Bar Endpoints

When the flag is `true`, a `WAITER` at that venue gains access to:

| Endpoint | Method | Action |
|---|---|---|
| `/venues/:venueId/bar/pending` | GET | List pending drink items awaiting acceptance |
| `/venues/:venueId/bar/queue` | GET | List accepted drinks in the active prep queue |
| `/venues/:venueId/bar/ready` | PATCH | Mark drink items as ready (notifies waiters) |

See `docs/ENDPOINTS.md` for full request/response shapes of these endpoints — the contracts do **not** change based on this setting.

When the flag is `false`, the same `WAITER` calling these endpoints receives:

```json
{
  "statusCode": 403,
  "message": "Forbidden"
}
```

---

## 7. Frontend Integration Checklist

- [ ] Add `waiterActsAsBartender` to the venue settings TypeScript model / DTO.
- [ ] Add a toggle to the venue settings UI; bind it to the field above.
- [ ] On save, send the field via `PUT /v1/venues/:venueId/settings`.
- [ ] In the waiter-facing app, read this flag from venue settings on login (or venue selection) and **conditionally show the bar tab/screens** when `waiterActsAsBartender === true` and the user's role is `WAITER`. Bartenders, managers, etc. always see the bar tab.
- [ ] Treat `403` from `/bar/*` endpoints as a signal that the flag was just turned off — refresh settings and hide the bar UI for waiter users.

---

## 8. Behavior Summary

| User role | `waiterActsAsBartender = false` | `waiterActsAsBartender = true` |
|---|---|---|
| `WAITER` | 403 on `/bar/*` | Allowed on `/bar/*` |
| `BARTENDER` | Allowed | Allowed |
| `MANAGER` / `ADMIN` / `ROOT` | Allowed | Allowed |
| Other roles | 403 | 403 |

Default for new venues: `false`.

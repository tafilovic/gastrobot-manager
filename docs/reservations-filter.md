# Reservations — Waiter Role: Filter & API Logic

Ovaj dokument opisuje kako funkcioniše filtriranje rezervacija za **waiter** rolu, uključujući API endpointe, parametre i tipove podataka.

---

## Dvije liste rezervacija

Waiter rola prikazuje rezervacije u **dvije odvojene grupe**:

| Grupa         | Opis                                      |
| ------------- | ----------------------------------------- |
| **Pending**   | Rezervacije koje čekaju obradu            |
| **Processed** | Potvrđene (i ostale obrađene) rezervacije |

---

## 1. Pending rezervacije

### Endpoint

```
GET /v1/venues/{venueId}/reservations
```

### Fiksni parametri (ne mijenjaju se filterom)

```json
{
  "status": "pending",
  "sortBy": "createdAt",
  "sortOrder": "ASC",
  "page": 1,
  "limit": 20
}
```

### Opcioni parametri (dolaze kao props, ne iz filter forme)

| Parametar           | Tip      | Opis                          |
| ------------------- | -------- | ----------------------------- |
| `reservationNumber` | `string` | Pretraga po broju rezervacije |
| `regionId`          | `string` | Filtriranje po regionu        |

> Mobilna aplikacija koristi `PendingReservationsFilters` u `ReservationsProvider` (isti UX kao potvrđene: filter ekran, chipovi, Apply / Reset). API parametri: `reservationNumber`, `regionId` — **bez** `from` / `to`.

---

## 2. Processed rezervacije

### Endpoint

```
GET /v1/venues/{venueId}/reservations
```

### Parametri (iz filter forme)

| Parametar           | Tip            | Default               | Opis                                             |
| ------------------- | -------------- | --------------------- | ------------------------------------------------ |
| `status`            | `string[]`     | `["confirmed"]`       | Za waitera uvijek samo `confirmed` kad je "all"  |
| `sortBy`            | `string`       | `"reservationStart"`  | Sortiranje                                       |
| `sortOrder`         | `string`       | `"DESC"`              | Smjer sortiranja                                 |
| `from`              | `string (ISO)` | Mesec unazad od danas | Početak datumskog opsega                         |
| `to`                | `string (ISO)` | `from + 4 meseca`     | Kraj datumskog opsega (auto ako nije postavljen) |
| `userName`          | `string`       | —                     | Pretraga po imenu korisnika                      |
| `reservationNumber` | `string`       | —                     | Pretraga po broju rezervacije                    |
| `regionId`          | `string`       | —                     | Filtriranje po regionu                           |
| `page`              | `number`       | `1`                   | Stranica (infinite scroll)                       |
| `limit`             | `number`       | `20`                  | Broj rezultata po stranici                       |

### Važno: status logika po roli

```
status = "all"  →  waiter dobija: ["confirmed"]
                    manager/admin dobija: ["confirmed", "rejected"]

status = bilo šta drugo  →  šalje se direktno API-ju
```

Waiter **nikad ne vidi `rejected`** rezervacije u processed listi po defaultu.

### Default datumski opseg

```
from = danas - 1 mesec   (npr. 2026-04-20T00:00:00.000)
to   = from  + 4 meseca  (npr. 2026-08-20T23:59:59.999)
```

---

## 3. Paginacija (Infinite Scroll)

Oba query-a koriste infinite scroll:

```
Stranica 1: page=1, limit=20
Stranica 2: page=2, limit=20
...

Nastavlja se dok: ukupno fetchovano < total (iz response)
```

---

## API Endpointi — pregled

| Akcija             | Metoda | Endpoint                                                   |
| ------------------ | ------ | ---------------------------------------------------------- |
| Lista rezervacija  | `GET`  | `/v1/venues/{venueId}/reservations`                        |
| Detalj rezervacije | `GET`  | `/reservations/{reservationId}`                            |
| Potvrdi            | `PUT`  | `/reservation/{reservationId}/confirm`                     |
| Odbij              | `PUT`  | `/v1/venues/{venueId}/reservations/{reservationId}/reject` |
| Otkaži             | `PUT`  | `/v1/reservations/{reservationId}/cancel`                  |
| Uredi              | `PUT`  | `/v1/reservations/{reservationId}`                         |

---

## Tipovi podataka

### `Reservation`

```ts
{
  id: string
  createdAt: string              // ISO 8601
  updatedAt: string              // ISO 8601
  deletedAt: string | null
  reservationNumber: string      // npr. "RES-00123"
  reservationStart: string       // ISO 8601 — wall clock, ne konvertovati u UTC
  status: "pending" | "confirmed" | "rejected" | "cancelled" | "expired"
  peopleCount: number
  type: "classic" | "wedding" | "engagement" | "birthday" | "funeral" | "other"
  additionalInfo: string | null
  rejectionReason: string | null
  confirmedMessage: string | null
  assignedTableName: string | null
  tables?: Table[]
  region: Region
  user: UserDetail
  order: Order | null
}
```

### `ReservationResponse`

```ts
{
  data: Reservation[]
  total: number
  page?: number
  limit?: number
  hasMore?: boolean
}
```

### Payload: Potvrdi rezervaciju (`PUT /reservation/{id}/confirm`)

```json
{
  "note": "Opcionalna napomena",
  "tableIds": ["table-id-1", "table-id-2"]
}
```

> `tableIds` je **obavezan** i mora sadržati bar jedan ID. Bez selektovanog stola potvrda nije moguća.

### Payload: Odbij rezervaciju (`PUT /v1/venues/{venueId}/reservations/{id}/reject`)

```json
{
  "reason": "Razlog odbijanja"
}
```

### Payload: Uredi rezervaciju (`PUT /v1/reservations/{id}`)

```json
{
  "peopleCount": 4,
  "reservationStart": "2026-06-15T19:00:00.000Z",
  "type": "birthday",
  "additionalInfo": "Napomena",
  "regionId": "region-uuid"
}
```

> Sva polja su opcionalna — šalju se samo ona koja se mijenjaju.

---

## Napomene za mobilni tim

- **`reservationStart`** je ISO string koji se tretira kao **wall clock** — nemojte konvertovati u lokalno vrijeme, čitajte direktno (godina/mjesec/dan/sat/minuta iz stringa).
- **Edit i cancel** su dostupni samo ako rezervacija **nije unutar 24h** od `reservationStart`.
- Waiter može **potvrditi i odbiti** pending rezervacije, ali **ne može otkazati** — to je rezervisano za manager/admin/root role.
- Stale time za query je `10 000ms` (10 sekundi) — nakon toga podaci se refetchuju.

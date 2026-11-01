# ISE Equipment Checkout

A small Vue 3 app for borrowing and returning ISE equipment (laptops, calculators, cameras and so on). Students check out an item with a form, see every current checkout in a list, and mark their own items as returned. Data is stored in Supabase, and a Make.com scenario logs a history event every time an item is checked out or returned.

## Stack

- **Vue 3** with `<script setup>`, built with Vite
- **Tailwind CSS 4** for a responsive layout (one column on phones, two from 640px up)
- **Supabase** for the database, anonymous sign-in and Row Level Security
- **Make.com** for the automation

## How it works

```
Vue form ──insert──▶ Supabase: checkouts
                          │ Database Webhook (INSERT, UPDATE)
                          ▼
                     Make.com: Custom webhook (INSERT or UPDATE)
                          ▼
                     Make.com: Supabase "Create a Row" ──▶ checkout_events
```

### Vue
- `src/App.vue` owns the state, signs in anonymously on load, and reads, inserts and updates rows in Supabase.
- `src/components/CheckoutForm.vue` is the checkout form (`v-model`, validation, emits `submitted`).
- `src/components/CheckoutList.vue` shows all checkouts (`v-for`, status badge, "Mark returned" on your own borrowed items).
- `src/lib/supabase.js` creates the one shared Supabase client.

### Database (`supabase/schema.sql`)
| Table | Role |
|---|---|
| `checkouts` | Primary table. One row per checkout: borrower, student ID, item, due date, status (Borrowed or Returned), owner. |
| `checkout_events` | Supporting table. A history log written by Make: a "created" event when an item is borrowed and a "returned" event when it comes back. `checkout_id` references `checkouts.id`. |

RLS policies let any signed-in user read checkouts, insert only their own, and change only their own from Borrowed to Returned. `checkout_events` is closed to the browser and written only by Make.

### Make.com scenario
1. **Trigger:** Webhooks › Custom webhook, called by a Supabase Database Webhook on INSERT and UPDATE of `public.checkouts`.
2. **Action:** Supabase › Create a Row in `checkout_events`, mapping `record.id` to `checkout_id` and setting `event_type` with `if(type = INSERT; created; returned)`.

This keeps a timeline per item (when it was borrowed and when it was returned), which `checkouts` alone cannot show because its `status` is overwritten.

## Run it locally

```sh
npm install
cp .env.example .env.local   # then fill in your Supabase URL and publishable key
npm run dev
```

Run `supabase/schema.sql` once in the Supabase SQL Editor and enable anonymous sign-ins (Authentication › Sign In / Providers).

## Screenshots

See the `screenshots/` folder: the form, the checkout list, both Supabase tables with sample rows, and the Make.com scenario.

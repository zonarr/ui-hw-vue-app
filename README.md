# ISE Equipment Checkout

A small Vue 3 app for borrowing and returning ISE equipment (laptops, calculators, cameras and so on). Students check out an item with a form, see every current checkout in a list, and mark their own items as returned. Data is stored in Supabase, and a Make.com scenario logs an event for every new checkout.

## Stack

- **Vue 3** with `<script setup>`, built with Vite
- **Tailwind CSS 4** for a responsive layout (one column on phones, two from 640px up)
- **Supabase** for the database, anonymous sign-in and Row Level Security
- **Make.com** for the automation

## How it works

```
Vue form ──insert──▶ Supabase: checkouts
                          │ Database Webhook (INSERT)
                          ▼
                     Make.com: Custom webhook
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
| `checkout_events` | Supporting table. One "created" event per checkout, written by Make. `checkout_id` references `checkouts.id`. |

RLS policies let any signed-in user read checkouts, insert only their own, and change only their own from Borrowed to Returned. `checkout_events` is closed to the browser and written only by Make.

### Make.com scenario
1. **Trigger:** Webhooks › Custom webhook, called by a Supabase Database Webhook on INSERT into `public.checkouts`.
2. **Action:** Supabase › Create a Row in `checkout_events`, mapping `record.id` to `checkout_id` and `event_type` to `created`.

## Run it locally

```sh
npm install
cp .env.example .env.local   # then fill in your Supabase URL and publishable key
npm run dev
```

Run `supabase/schema.sql` once in the Supabase SQL Editor and enable anonymous sign-ins (Authentication › Sign In / Providers).

## Screenshots

See the `screenshots/` folder: the form, the checkout list, both Supabase tables with sample rows, and the Make.com scenario.

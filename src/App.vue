<script setup>
import { ref, onMounted } from 'vue'
import { supabase } from './lib/supabase'
import CheckoutForm from './components/CheckoutForm.vue'
import CheckoutList from './components/CheckoutList.vue'

const message = ref('Choose an action to get started.')
const currentView = ref('home')
const userId = ref(null)

onMounted(async () => {
  const { data, error } = await supabase.auth.getSession()
  if (error) {
    message.value = 'Sign-in error: ' + error.message
    return
  }

  let session = data.session
  if (!session) {
    const result = await supabase.auth.signInAnonymously()
    if (result.error) {
      message.value = 'Sign-in error: ' + result.error.message
      return
    }
    session = result.data.session
  }

  userId.value = session.user.id
  message.value = 'Supabase sign-in ready.'
  await loadCheckouts()
})

function startCheckout() {
  currentView.value = 'form'
}

function browseCheckouts() {
  currentView.value = 'list'
  loadCheckouts()
}

function goHome() {
  currentView.value = 'home'
}

const checkouts = ref([])
const saving = ref(false)

// Turn a database row (snake_case) into the shape the components use (camelCase).
function toCheckout(row) {
  return {
    id: row.id,
    borrowerName: row.borrower_name,
    studentId: row.student_id,
    item: row.item,
    dueDate: row.due_date,
    status: row.status,
    isMine: row.owner_id === userId.value,
  }
}

async function loadCheckouts() {
  const { data, error } = await supabase
    .from('checkouts')
    .select('*')
    .order('created_at', { ascending: false })

  if (error) {
    message.value = 'Could not load checkouts: ' + error.message
    return
  }

  checkouts.value = data.map(toCheckout)
}

async function handleSubmitted(newCheckout) {
  if (!userId.value) {
    message.value = 'Still signing in. Please try again in a moment.'
    return
  }

  if (saving.value) return
  saving.value = true

  const { data, error } = await supabase
    .from('checkouts')
    .insert({
      owner_id: userId.value,
      borrower_name: newCheckout.borrowerName.trim(),
      student_id: newCheckout.studentId.trim(),
      item: newCheckout.item,
      due_date: newCheckout.dueDate,
    })
    .select()
    .single()

  saving.value = false

  if (error) {
    message.value = 'Could not save checkout: ' + error.message
    return
  }

  checkouts.value.unshift(toCheckout(data))
  message.value = `${data.borrower_name} checked out: ${data.item} (due ${data.due_date}).`
  goHome()
}

async function handleReturn(id) {
  const { data, error } = await supabase
    .from('checkouts')
    .update({ status: 'Returned' })
    .eq('id', id)
    .select()
    .single()

  if (error) {
    message.value = 'Could not mark as returned: ' + error.message
    return
  }

  const checkout = checkouts.value.find((c) => c.id === id)
  checkout.status = data.status
}
</script>

<template>
  <div class="min-h-screen bg-slate-50 text-slate-900">
    <div class="mx-auto max-w-2xl px-4 py-8 sm:py-12">
      <h1 class="mb-6 text-2xl font-bold sm:text-3xl">ISE Equipment Checkout</h1>

      <main v-if="currentView === 'home'" class="space-y-4">
        <div class="grid gap-3 sm:grid-cols-2">
          <button
            type="button"
            class="rounded-lg bg-blue-600 px-4 py-3 font-medium text-white hover:bg-blue-700"
            @click="startCheckout"
          >
            Check out an item
          </button>
          <button
            type="button"
            class="rounded-lg border border-slate-300 bg-white px-4 py-3 font-medium hover:bg-slate-100"
            @click="browseCheckouts"
          >
            View checkouts
          </button>
        </div>
        <p role="status" class="text-slate-600">{{ message }}</p>
      </main>

      <main v-else-if="currentView === 'form'">
        <CheckoutForm :saving="saving" @submitted="handleSubmitted" @cancel="goHome" />
      </main>

      <main v-else>
        <CheckoutList :checkouts="checkouts" @return="handleReturn" @cancel="goHome" />
      </main>
    </div>
  </div>
</template>

<style scoped></style>

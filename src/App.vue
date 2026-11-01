<script setup>
import { ref } from 'vue'
import CheckoutForm from './components/CheckoutForm.vue'
import CheckoutList from './components/CheckoutList.vue'

const message = ref('Choose an action to get started.')
const currentView = ref('home')

function startCheckout() {
  currentView.value = 'form'
}

function browseCheckouts() {
  currentView.value = 'list'
}

function goHome() {
  currentView.value = 'home'
}

const checkouts = ref([])

function handleSubmitted(newCheckout) {
  checkouts.value.push({ ...newCheckout, id: Date.now(), status: 'Borrowed' })
  message.value = `${newCheckout.borrowerName} checked out a ${newCheckout.item}.`
  goHome()
}

function handleReturn(id) {
  const checkout = checkouts.value.find((c) => c.id === id)
  checkout.status = 'Returned'
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
        <CheckoutForm @submitted="handleSubmitted" @cancel="goHome" />
      </main>

      <main v-else>
        <CheckoutList :checkouts="checkouts" @return="handleReturn" @cancel="goHome" />
      </main>
    </div>
  </div>
</template>

<style scoped></style>

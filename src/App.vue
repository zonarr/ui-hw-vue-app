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
  <h1>ISE Equipment Checkout</h1>

  <main v-if="currentView === 'home'">
    <button type="button" @click="startCheckout">Check out an item</button>
    <button type="button" @click="browseCheckouts">View checkouts</button>
    <p role="status">{{ message }}</p>
  </main>

  <main v-else-if="currentView === 'form'">
    <CheckoutForm @submitted="handleSubmitted" @cancel="goHome" />
  </main>

  <main v-else>
    <CheckoutList :checkouts="checkouts" @return="handleReturn" @cancel="goHome" />
  </main>
</template>

<style scoped></style>

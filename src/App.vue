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
</script>

<template>
  <h1>ISE Equipment Checkout</h1>

  <main v-if="currentView === 'home'">
    <button type="button" @click="startCheckout">Check out an item</button>
    <button type="button" @click="browseCheckouts">View checkouts</button>
    <p role="status">{{ message }}</p>
  </main>

  <main v-else-if="currentView === 'form'">
    <CheckoutForm @cancel="goHome" />
  </main>

  <main v-else>
    <CheckoutList @cancel="goHome" />
  </main>
</template>

<style scoped></style>

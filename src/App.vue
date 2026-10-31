<script setup>
import { ref } from 'vue'

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
    <h2>Check out an item</h2>
    <p>The form goes here.</p>
    <button type="button" @click="goHome">Back</button>
  </main>

  <main v-else>
    <h2>Current checkouts</h2>
    <p>The list goes here.</p>
    <button type="button" @click="goHome">Back</button>
  </main>
</template>

<style scoped></style>

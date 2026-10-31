<script setup>
const emit = defineEmits(['cancel'])

function cancel() {
  emit('cancel')
}
</script>

<template>
  <section>
    <h2>Current checkouts</h2>
    <p>The list goes here.</p>
    <button type="button" @click="cancel">Back</button>
  </section>
</template>

<script setup>
const emit = defineEmits(['cancel'])

function cancel() {
  emit('cancel')
}
</script>

<template>
  <section>
    <h2>Check out an item</h2>
    <p>The form goes here.</p>
    <button type="button" @click="cancel">Back</button>
  </section>
</template>

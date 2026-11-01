<script setup>
defineProps({
  checkouts: {
    type: Array,
    required: true,
  },
})

const emit = defineEmits(['return', 'cancel'])

function markReturned(id) {
  emit('return', id)
}

function cancel() {
  emit('cancel')
}
</script>

<template>
  <section>
    <h2>Current checkouts</h2>

    <p v-if="checkouts.length === 0">No checkouts yet.</p>

    <ul v-else>
      <li v-for="checkout in checkouts" :key="checkout.id">
        <strong>{{ checkout.item }}</strong>
        borrowed by {{ checkout.borrowerName }} ({{ checkout.studentId }}), due
        {{ checkout.dueDate }}

        <span :class="checkout.status === 'Borrowed' ? 'text-amber-600' : 'text-green-600'">
          {{ checkout.status }}
        </span>

        <button
          v-if="checkout.status === 'Borrowed'"
          type="button"
          @click="markReturned(checkout.id)"
        >
          Mark returned
        </button>
      </li>
    </ul>

    <button type="button" @click="cancel">Back</button>
  </section>
</template>

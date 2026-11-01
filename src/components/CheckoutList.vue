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
  <section class="space-y-4">
    <h2 class="text-xl font-semibold">Current checkouts</h2>

    <p v-if="checkouts.length === 0" class="rounded-xl bg-white p-5 text-slate-600 shadow-sm">
      No checkouts yet.
    </p>

    <ul v-else class="space-y-3">
      <li
        v-for="checkout in checkouts"
        :key="checkout.id"
        class="flex flex-col gap-3 rounded-xl bg-white p-4 shadow-sm sm:flex-row sm:items-center sm:justify-between"
      >
        <div>
          <p class="font-semibold">{{ checkout.item }}</p>
          <p class="text-sm text-slate-600">
            {{ checkout.borrowerName }} ({{ checkout.studentId }}) · due {{ checkout.dueDate }}
          </p>
        </div>

        <div class="flex items-center gap-3">
          <span
            class="rounded-full px-3 py-1 text-xs font-medium"
            :class="
              checkout.status === 'Borrowed'
                ? 'bg-amber-100 text-amber-800'
                : 'bg-green-100 text-green-800'
            "
          >
            {{ checkout.status }}
          </span>

          <button
            v-if="checkout.status === 'Borrowed' && checkout.isMine"
            type="button"
            class="rounded-lg border border-slate-300 px-3 py-1 text-sm hover:bg-slate-100"
            @click="markReturned(checkout.id)"
          >
            Mark returned
          </button>
        </div>
      </li>
    </ul>

    <button
      type="button"
      class="rounded-lg border border-slate-300 bg-white px-4 py-2 font-medium hover:bg-slate-100"
      @click="cancel"
    >
      Back
    </button>
  </section>
</template>

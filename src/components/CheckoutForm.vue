<script setup>
import { reactive, ref } from 'vue'

const emit = defineEmits(['submitted', 'cancel'])

const items = ['Laptop', 'Calculator', 'HDMI adapter', 'Camera', 'Tripod']

const form = reactive({
  borrowerName: '',
  studentId: '',
  item: '',
  dueDate: '',
})

const errorMessage = ref('')

function submitForm() {
  const values = Object.values(form)
  const hasEmptyField = values.some((value) => value.trim() === '')

  if (hasEmptyField) {
    errorMessage.value = 'Please fill in every field.'
    return
  }

  errorMessage.value = ''
  emit('submitted', { ...form })
}

function cancel() {
  emit('cancel')
}
</script>

<template>
  <section class="rounded-xl bg-white p-5 shadow-sm sm:p-6">
    <h2 class="mb-4 text-xl font-semibold">Check out an item</h2>

    <form class="space-y-4" @submit.prevent="submitForm">
      <div class="grid gap-4 sm:grid-cols-2">
        <label class="block text-sm font-medium">
          Your name
          <input v-model="form.borrowerName" type="text" class="field" />
        </label>

        <label class="block text-sm font-medium">
          Student ID
          <input v-model="form.studentId" type="text" class="field" />
        </label>

        <label class="block text-sm font-medium">
          Item
          <select v-model="form.item" class="field">
            <option value="">Choose an item</option>
            <option v-for="item in items" :key="item" :value="item">{{ item }}</option>
          </select>
        </label>

        <label class="block text-sm font-medium">
          Due date
          <input v-model="form.dueDate" type="date" class="field" />
        </label>
      </div>

      <p v-if="errorMessage" role="alert" class="text-sm text-red-600">{{ errorMessage }}</p>

      <div class="flex flex-col gap-3 sm:flex-row">
        <button
          type="submit"
          class="rounded-lg bg-blue-600 px-4 py-2 font-medium text-white hover:bg-blue-700"
        >
          Check out
        </button>
        <button
          type="button"
          class="rounded-lg border border-slate-300 px-4 py-2 font-medium hover:bg-slate-100"
          @click="cancel"
        >
          Back
        </button>
      </div>
    </form>
  </section>
</template>

<style scoped>
@reference 'tailwindcss';

.field {
  @apply mt-1 block w-full rounded-lg border border-slate-300 px-3 py-2 font-normal focus:border-blue-500 focus:outline-none;
}
</style>

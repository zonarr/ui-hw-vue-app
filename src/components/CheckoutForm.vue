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
  <section>
    <h2>Check out an item</h2>

    <form @submit.prevent="submitForm">
      <label>
        Your name
        <input v-model="form.borrowerName" type="text" />
      </label>

      <label>
        Student ID
        <input v-model="form.studentId" type="text" />
      </label>

      <label>
        Item
        <select v-model="form.item">
          <option value="">Choose an item</option>
          <option v-for="item in items" :key="item" :value="item">{{ item }}</option>
        </select>
      </label>

      <label>
        Due date
        <input v-model="form.dueDate" type="date" />
      </label>

      <p v-if="errorMessage" role="alert">{{ errorMessage }}</p>

      <button type="submit">Check out</button>
      <button type="button" @click="cancel">Back</button>
    </form>
  </section>
</template>

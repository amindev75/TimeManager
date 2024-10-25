<!-- UserWorkingTimeTable.vue -->
<template>
  <div v-if="props.workingTimes.length > 0" class="mt-5">
    <table id="workingTimesTable" class="table table-striped">
      <thead>
        <tr>
          <th>Date</th>
          <th>Heure de départ</th>
          <th>Heure d'arrivée</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="workingTime in props.workingTimes" :key="workingTime.id">
          <td>{{ new Date(workingTime.start).toLocaleDateString() }}</td>
          <td>{{ new Date(workingTime.start).toLocaleTimeString() }}</td>
          <td>{{ new Date(workingTime.end_w).toLocaleTimeString() }}</td>
        </tr>
      </tbody>
    </table>
  </div>
</template>

<script setup>
import { onMounted, nextTick } from "vue";
import "datatables.net-bs5";
import $ from "jquery";

// eslint-disable-next-line
const props = defineProps({
  workingTimes: {
    type: Array,
    required: true,
  },
});

const initializeDataTable = () => {
  const table = document.getElementById("workingTimesTable");
  if (table) {
    $(table).DataTable().destroy();
    $(table).DataTable({
      language: {
        url: "//cdn.datatables.net/plug-ins/1.13.7/i18n/fr-FR.json",
      },
    });
    $("#workingTimesTable_wrapper").css("padding", "20px");
  }
};

onMounted(() => {
  nextTick(() => {
    initializeDataTable();
  });
});
</script>

<style scoped>
.container-fluid {
  max-width: 100%;
  padding: 0 15px;
}
</style>

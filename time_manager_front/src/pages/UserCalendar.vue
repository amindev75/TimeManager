<!-- UserCalendar.vue -->
<template>
  <div id="calendar"></div>
</template>

<script setup>
import { onMounted } from "vue";
import { Calendar } from "@fullcalendar/core";
import dayGridPlugin from "@fullcalendar/daygrid";

onMounted(() => {
  let calendarEl = document.getElementById("calendar");
  let calendar = new Calendar(calendarEl, {
    plugins: [dayGridPlugin],
    initialView: "dayGridMonth",
  });
  calendar.render();
});
</script>

<style scoped>
#calendar {
  max-width: 900px;
  margin: 0 auto;
}
</style>

<template>
  <div style="margin: 8vh">
    <div class="row mb-4">
      <div class="col-md-4 chart-container">
        <Bar :key="chartKey" :data="barData" :options="chartOptions" />
      </div>
      <div class="col-md-4 chart-container">
        <Doughnut :data="doughnutData" :options="doughnutOptions" />
      </div>
      <div class="col-md-4 chart-container">
        <Line :data="lineData" :key="chartKey" :options="lineOptions" />
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from "vue";
import {
  Chart as ChartJS,
  Title,
  Tooltip,
  Legend,
  ArcElement,
  BarElement,
  CategoryScale,
  LinearScale,
  PointElement,
  LineElement,
} from "chart.js";
import { Bar, Doughnut, Line } from "vue-chartjs";
import axios from "axios";

// eslint-disable-next-line
const props = defineProps({
  userId: {
    type: String,
    required: true,
  },
});

ChartJS.register(
  Title,
  Tooltip,
  Legend,
  BarElement,
  CategoryScale,
  ArcElement,
  LinearScale,
  PointElement,
  LineElement
);

const chartKey = ref(0);

// Fonctions utilitaires
const getRandomColors = () => {
  const colors = [];
  for (let i = 0; i < 12; i++) {
    const randomColor = `hsl(${Math.random() * 360}, 100%, 75%)`;
    colors.push(randomColor);
  }
  return colors;
};

const getLast12Months = () => {
  const months = [
    "Janvier",
    "Février",
    "Mars",
    "Avril",
    "Mai",
    "Juin",
    "Juillet",
    "Août",
    "Septembre",
    "Octobre",
    "Novembre",
    "Décembre",
  ];
  const result = [];
  const today = new Date();
  let currentMonth = today.getMonth();
  for (let i = 0; i < 12; i++) {
    result.unshift(months[currentMonth]);
    currentMonth = (currentMonth - 1 + 12) % 12;
  }
  return result;
};

// Configuration des graphiques
const chartOptions = {
  responsive: true,
  maintainAspectRatio: false,
  plugins: {
    legend: { position: "top" },
    title: { display: true, text: "Jours Travaillés par Mois" },
  },
  scales: { y: { beginAtZero: true } },
};

const doughnutOptions = {
  responsive: true,
  maintainAspectRatio: false,
  plugins: {
    legend: { position: "top" },
    title: { display: true, text: "Pourcentage des heures hors standard" },
  },
};

const lineOptions = {
  responsive: true,
  maintainAspectRatio: false,
  plugins: {
    legend: { position: "top" },
    title: { display: true, text: "Moyenne d'heures travaillées" },
  },
  scales: { y: { beginAtZero: true } },
};

// Données des graphiques
const barData = ref({
  labels: getLast12Months(),
  datasets: [
    {
      label: `Jours travaillés (${new Date().getFullYear()})`,
      backgroundColor: getRandomColors(),
      data: [],
    },
  ],
});

const doughnutData = ref({
  labels: ["Heures standards (8h - 16h)", "Heures hors standard"],
  datasets: [
    {
      data: [0, 0],
      backgroundColor: ["#36A2EB", "#FF6384"],
      hoverBackgroundColor: ["#36A2EB", "#FF6384"],
    },
  ],
});

const lineData = ref({
  labels: getLast12Months(),
  datasets: [
    {
      label: `Moyenne d'heures travaillées`,
      backgroundColor: "rgba(75, 192, 192, 0.2)",
      borderColor: "rgba(75, 192, 192, 1)",
      borderWidth: 2,
      fill: true,
      data: [],
    },
  ],
});

const fetchWorkedDays = async () => {
  if (!props.userId) return;

  try {
    const token = localStorage.getItem("authToken");
    const headers = { Authorization: `Bearer ${token}` };

    // Fetch worked days
    const response = await axios.get(
      `http://localhost:4000/api/stats/${props.userId}/worked_days_by_month`,
      { headers }
    );
    barData.value.datasets[0].data = Array.from({ length: 12 }, (v, i) => {
      return response.data.worked_days_by_month[i] || 0;
    });

    // Fetch percentage outside standard hours
    const percentageResponse = await axios.get(
      `http://localhost:4000/api/stats/${props.userId}/calculate_percentage_working_times_outside_standard_hours`,
      { headers }
    );
    const percentageOutside =
      percentageResponse.data.percentage_outside_standard_hours;
    doughnutData.value.datasets[0].data = [
      100 - percentageOutside,
      percentageOutside,
    ];

    // Fetch average hours
    const averageHoursResponse = await axios.get(
      `http://localhost:4000/api/stats/${props.userId}/calculate_average_hours_worked_by_month`,
      { headers }
    );
    lineData.value.datasets[0].data = Array.from({ length: 12 }, (v, i) => {
      return averageHoursResponse.data.average_hours_by_month[i] || 0;
    });

    barData.value.datasets[0].backgroundColor = getRandomColors();
    chartKey.value += 1;
  } catch (error) {
    console.error("Erreur lors de la récupération des statistiques :", error);
  }
};

onMounted(async () => {
  await fetchWorkedDays();
});
</script>

<style scoped>
.chart-container {
  height: 300px;
  padding: 10px;
  background-color: #f8f9fa;
  border-radius: 5px;
}

canvas {
  max-width: 100% !important;
  height: auto !important;
}
</style>

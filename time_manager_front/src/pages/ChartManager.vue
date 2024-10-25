<template>
  <div class="container-fluid mt-5">
    <div class="d-flex">
      <b-sidebar
        id="sidebar"
        title="Menu"
        shadow
        :bg-variant="'dark'"
        :text-variant="'light'"
        :backdrop="true"
      >
        <b-button block variant="secondary" @click="setView('stats')">
          Statistiques
        </b-button>
        <b-button block variant="secondary" @click="setView('workingTimes')">
          Working Times
        </b-button>
        <b-button block variant="secondary" @click="setView('calendar')">
          Emploi du Temps
        </b-button>
        <b-button
          v-if="userRole !== '0'"
          :variant="userClock.status ? 'danger' : 'primary'"
          block
          @click="toggleClockStatus"
        >
          <span>{{ userClock.status ? "check-out" : "check-in" }}</span>
        </b-button>
        <b-button block variant="danger" @click="logout">
          <i class="fas fa-sign-out-alt"></i> Déconnexion
        </b-button>
      </b-sidebar>

      <b-button variant="primary" @click="$bvSidebar.show('sidebar')">
        <i class="fas fa-bars"></i> Ouvrir le Menu
      </b-button>

      <div class="content flex-grow-1">
        <h1 class="text-center mb-5">Gestion de {{ username }}</h1>

        <UserStatisticsChart
          v-if="currentView === 'stats'"
          :userId="userId"
          :workingTimes="workingTimes"
        />
        <UserWorkingTimeTable
          v-if="currentView === 'workingTimes'"
          :workingTimes="workingTimes"
        />
        <UserCalendar v-if="currentView === 'calendar'" />
      </div>
    </div>
  </div>
</template>

<script>
export default {
  data() {
    return {
      currentView: "stats",
      // vos autres variables ici
    };
  },
  methods: {
    setView(view) {
      this.currentView = view;
    },
    toggleClockStatus() {
      // logique pour basculer l'état du clock
    },
    logout() {
      // logique pour la déconnexion
    },
  },
};
</script>

<script setup>
import { ref, onMounted } from "vue";
import { useRouter, useRoute } from "vue-router";
import axios from "axios";
import { useToast } from "vue-toastification";
import UserStatisticsChart from "./UserStatisticsChart.vue";
import UserWorkingTimeTable from "./UserWorkingTimeTable.vue";
import UserCalendar from "./UserCalendar.vue"; // Nouveau sous-composant FullCalendar

const router = useRouter();
const route = useRoute();
const toast = useToast();
const userId = route.params.userid;
const username = ref("");
const userClock = ref({});
const workingTimes = ref([]);

const currentView = ref("stats");
const userRole = localStorage.getItem("userRole");
async function logout() {
  try {
    const token = localStorage.getItem("authToken");
    if (!token) {
      toast.error("Aucun token trouvé, vous êtes peut-être déjà déconnecté.");
      return;
    }
    await axios.delete("http://localhost:4000/api/logout", {
      headers: { Authorization: `Bearer ${token}` },
    });
    localStorage.removeItem("authToken");
    toast.success("Déconnexion réussie.");

    await router.push("/");
  } catch (error) {
    console.error("Erreur lors de la déconnexion :", error);
    toast.error("Erreur lors de la déconnexion. Veuillez réessayer.");
  }
}

const fetchUserDetails = async () => {
  try {
    const token = localStorage.getItem("authToken");
    const response = await axios.get(
      `http://localhost:4000/api/users/${userId}`,
      {
        headers: { Authorization: `Bearer ${token}` },
      }
    );
    if (response.data && response.data.data) {
      username.value = response.data.data.username;
      await getWorkingTimes(response.data.data.id);
    }
  } catch (error) {
    console.error(
      "Erreur lors de la récupération des détails de l'utilisateur :",
      error
    );
  }
};

const fetchUserClock = async () => {
  try {
    const token = localStorage.getItem("authToken");
    const response = await axios.get(
      `http://localhost:4000/api/clocks/${userId}`,
      {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      }
    );

    if (response.data && response.data.data) {
      userClock.value = response.data.data;
    }
  } catch (error) {
    toast.error("Erreur lors du chargement de la clock du user.");
  }
};

const toggleClockStatus = async () => {
  try {
    const token = localStorage.getItem("authToken");
    const res = await axios.put(
      `http://localhost:4000/api/clocks/${userId}/toggle_status`,
      {},
      {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      }
    );
    if (res.data && res.data.clock) {
      toast.success("Statut changé avec succès.");
      userClock.value = res.data.clock;
    }
  } catch (error) {
    toast.error("Erreur lors du changement de statut de travail.");
  }
};

const getWorkingTimes = async (userId) => {
  try {
    const token = localStorage.getItem("authToken");
    const response = await axios.get(
      `http://localhost:4000/api/workingtime/${userId}`,
      {
        headers: { Authorization: `Bearer ${token}` },
      }
    );
    workingTimes.value = response.data.data || [];
    return workingTimes.value;
  } catch (error) {
    console.error(
      "Erreur lors de la récupération des temps de travail :",
      error
    );
    return [];
  }
};

const setView = (view) => {
  currentView.value = view;
};

onMounted(async () => {
  await fetchUserDetails();
  await fetchUserClock();
});
</script>

<style scoped>
.sidebar {
  width: 200px;
  padding: 10px;
  background-color: #f8f9fa;
}
.content {
  padding-left: 20px;
}
</style>

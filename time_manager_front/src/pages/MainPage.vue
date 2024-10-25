<script setup>
import { ref, onMounted } from "vue";
import { useRouter } from "vue-router";
import { useToast } from "vue-toastification";
import { authService } from "@/services/auth";

const router = useRouter();
const email = ref("");
const password = ref("");
const errorMessage = ref("");
const toast = useToast();

onMounted(() => {
  const token = localStorage.getItem("authToken");
  const lastPage = localStorage.getItem("lastPage") || "/";
  if (token) {
    router.push(lastPage);
    toast.error("Vous êtes déjà connecté.");
  }
});

const login = async () => {
  try {
    const response = await authService.login(email.value, password.value);

    const token = response.data.token;
    const userRole = response.data.user.role;
    const userID = response.data.user.id;

    toast.success("Connexion réussie.");

    localStorage.setItem("authToken", token);
    localStorage.setItem("userRole", userRole);
    localStorage.setItem("userId", userID);

    // Redirection basée sur le rôle de l'utilisateur
    let redirectPath = "/";
    if (userRole === 2) {
      redirectPath = "/admin";
    } else if (userRole === 1) {
      redirectPath = "/manager";
    } else {
      redirectPath = `/chartManager/${userID}`;
    }

    localStorage.setItem("lastPage", redirectPath); // Stocke la dernière page visitée
    router.push(redirectPath);
  } catch (error) {
    toast.error("Erreur lors de la connexion. Vérifiez vos identifiants.");
  }
};
</script>

<template>
  <div class="container mt-5">
    <h1 class="text-center mb-5">Bienvenue sur Time Manager</h1>

    <div class="login-form mb-5">
      <h3 class="text-center">Connexion</h3>

      <!-- Ajout de l'élément <form> pour la soumission -->
      <form @submit.prevent="login">
        <div class="form-group mb-3">
          <label for="email">Email</label>
          <input
            v-model="email"
            type="email"
            class="form-control"
            id="email"
            placeholder="Entrez votre email"
            required
          />
        </div>

        <div class="form-group mb-3">
          <label for="password">Mot de passe</label>
          <input
            v-model="password"
            type="password"
            class="form-control"
            id="password"
            placeholder="Entrez votre mot de passe"
            required
          />
        </div>

        <!-- Le bouton reste inchangé -->
        <button type="submit" class="btn btn-primary btn-block">
          Se connecter
        </button>

        <div v-if="errorMessage" class="alert alert-danger mt-3">
          {{ errorMessage }}
        </div>
      </form>
    </div>
  </div>
</template>

<style scoped>
.container {
  padding: 20px;
}

h1 {
  margin-bottom: 40px;
}

.login-form {
  max-width: 400px;
  margin: 0 auto;
}

.btn {
  padding: 10px 20px;
}

.alert {
  text-align: center;
}
</style>

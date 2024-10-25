<template>
  <div
      class="card card-hover position-relative"
      @click="viewStats(user.id)"
  >
    <div :class="`card-body border border-3 rounded ${user.role === 0 ? 'border-secondary' : user.role === 1 ? 'border-primary' : 'border-warning'}`">
      <h5 class="card-title" style="display: flex; justify-content: space-between;">
        {{ user.username }}
        <span :class="`border border-5 rounded-circle ${clock?.status ? 'border-success' : 'border-danger'}`"
        style="width: 8px; height: 8px; display: block;"
        ></span>
      </h5>
      <p class="card-text">Email: {{ user.email }}</p>

      <div class="d-flex justify-content-between">
        <button class="btn btn-primary" @click.stop="openEditModal(user)">
          <i class="fas fa-edit"></i>
        </button>
        <button class="btn btn-danger" @click.stop="deleteUser(user.id)">
          <i class="fas fa-trash-alt"></i>
        </button>
        <button
            :class="clock?.status ? 'btn btn-danger ms-2' : 'btn btn-primary ms-2'"
            @click.stop="updateClock(user.id)"
        >
          <span>{{ clock?.status ? "check-out" : "check-in" }}</span>
        </button>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  // eslint-disable-next-line vue/multi-word-component-names
  name: "User",
  props: {
    user: {
      type: Object,
      required: true,
    },
    clock: {
      type: Object,
      required: true,
    }
  },
  methods: {
    viewStats(userId) {
      this.$emit("view-stats", userId);
    },

    openEditModal(user) {
      this.$emit("edit-user", user);
    },

    deleteUser(userId) {
      this.$emit("delete-user", userId);
    },
    updateClock(userId) {
      this.$emit("update-clock", userId);
    },
  },
};
</script>

<style scoped>
.card-hover {
  transition: box-shadow 0.3s ease-in-out;
}

.card-hover:hover {
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
  cursor: pointer;
}
</style>

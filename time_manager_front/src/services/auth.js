import api from "./api";

export const authService = {
  login(email, password) {
    return api.post("/api/login", { email, password });
  },
};

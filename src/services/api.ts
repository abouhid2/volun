import axios from "axios";
import { Event, Participation } from "../types";

const API_URL = "http://localhost:3001/api/v1";

export const api = {
  events: {
    getAll: () => axios.get<Event[]>(`${API_URL}/events`),
    get: (id: number) => axios.get<Event>(`${API_URL}/events/${id}`),
    create: (data: Omit<Event, "id">) =>
      axios.post<Event>(`${API_URL}/events`, { event: data }),
    update: (id: number, data: Partial<Event>) =>
      axios.put<Event>(`${API_URL}/events/${id}`, { event: data }),
    delete: (id: number) => axios.delete(`${API_URL}/events/${id}`),
  },
  participations: {
    create: (eventId: number, data: Omit<Participation, "id" | "eventId">) =>
      axios.post<Participation>(`${API_URL}/events/${eventId}/participations`, {
        participation: data,
      }),
    update: (eventId: number, id: number, data: Partial<Participation>) =>
      axios.put<Participation>(
        `${API_URL}/events/${eventId}/participations/${id}`,
        { participation: data }
      ),
    delete: (eventId: number, id: number) =>
      axios.delete(`${API_URL}/events/${eventId}/participations/${id}`),
  },
}; 
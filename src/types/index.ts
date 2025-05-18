export interface Event {
  id: number;
  title: string;
  description: string;
  date: string;
  location: string;
}

export interface Participation {
  id: number;
  eventId: number;
  userId: number;
  status: "going" | "not_going" | "maybe";
} 
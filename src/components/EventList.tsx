import React, { useEffect, useState } from "react";
import { Container, Typography, Button, Box } from "@mui/material";
import { Add as AddIcon } from "@mui/icons-material";
import { Event, Participation } from "../types";
import { api } from "../services/api";
import { EventCard } from "./EventCard";
import { EventForm } from "./EventForm";
import { ParticipationButton } from "./ParticipationButton";

export const EventList: React.FC = () => {
  const [events, setEvents] = useState<Event[]>([]);
  const [isFormOpen, setIsFormOpen] = useState(false);
  const [selectedEvent, setSelectedEvent] = useState<Event | undefined>();
  const userId = 1; // This would come from authentication in a real app

  useEffect(() => {
    fetchEvents();
  }, []);

  const fetchEvents = async () => {
    try {
      const response = await api.events.getAll();
      setEvents(response.data);
    } catch (error) {
      console.error("Failed to fetch events:", error);
    }
  };

  const handleCreateEvent = async (eventData: Omit<Event, "id">) => {
    try {
      await api.events.create(eventData);
      fetchEvents();
    } catch (error) {
      console.error("Failed to create event:", error);
    }
  };

  const handleUpdateEvent = async (id: number, eventData: Partial<Event>) => {
    try {
      await api.events.update(id, eventData);
      fetchEvents();
    } catch (error) {
      console.error("Failed to update event:", error);
    }
  };

  const handleDeleteEvent = async (id: number) => {
    try {
      await api.events.delete(id);
      fetchEvents();
    } catch (error) {
      console.error("Failed to delete event:", error);
    }
  };

  const handleParticipationChange = async (
    eventId: number,
    status: Participation["status"]
  ) => {
    try {
      await api.participations.create(eventId, {
        user_id: userId,
        status,
      });
      fetchEvents();
    } catch (error) {
      console.error("Failed to update participation:", error);
    }
  };

  return (
    <Container maxWidth="md" sx={{ py: 4 }}>
      <Box sx={{ display: "flex", justifyContent: "space-between", mb: 4 }}>
        <Typography variant="h4" component="h1">
          Events
        </Typography>
        <Button
          variant="contained"
          startIcon={<AddIcon />}
          onClick={() => {
            setSelectedEvent(undefined);
            setIsFormOpen(true);
          }}
        >
          Create Event
        </Button>
      </Box>

      {events.map((event) => (
        <Box key={event.id} sx={{ mb: 3 }}>
          <EventCard
            event={event}
            onEdit={(event) => {
              setSelectedEvent(event);
              setIsFormOpen(true);
            }}
            onDelete={handleDeleteEvent}
          />
          <Box sx={{ mt: -1, ml: 2 }}>
            <ParticipationButton
              eventId={event.id}
              userId={userId}
              onStatusChange={(status) =>
                handleParticipationChange(event.id, status)
              }
            />
          </Box>
        </Box>
      ))}

      <EventForm
        open={isFormOpen}
        onClose={() => {
          setIsFormOpen(false);
          setSelectedEvent(undefined);
        }}
        onSubmit={(eventData) =>
          selectedEvent
            ? handleUpdateEvent(selectedEvent.id, eventData)
            : handleCreateEvent(eventData)
        }
        initialData={selectedEvent}
      />
    </Container>
  );
};

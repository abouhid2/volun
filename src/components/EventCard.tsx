import React from "react";
import {
  Card,
  CardContent,
  CardActions,
  Typography,
  Button,
  Box,
} from "@mui/material";
import { Event } from "../types";
import { format } from "date-fns";

interface EventCardProps {
  event: Event;
  onEdit: (event: Event) => void;
  onDelete: (eventId: number) => void;
}

export const EventCard: React.FC<EventCardProps> = ({
  event,
  onEdit,
  onDelete,
}) => {
  return (
    <Card sx={{ minWidth: 275, mb: 2 }}>
      <CardContent>
        <Typography variant="h5" component="div">
          {event.title}
        </Typography>
        <Typography sx={{ mb: 1.5 }} color="text.secondary">
          {format(new Date(event.date), "PPP")} at {event.location}
        </Typography>
        <Typography variant="body2">{event.description}</Typography>
      </CardContent>
      <CardActions>
        <Box
          sx={{ display: "flex", justifyContent: "flex-end", width: "100%" }}
        >
          <Button size="small" onClick={() => onEdit(event)}>
            Edit
          </Button>
          <Button size="small" color="error" onClick={() => onDelete(event.id)}>
            Delete
          </Button>
        </Box>
      </CardActions>
    </Card>
  );
};

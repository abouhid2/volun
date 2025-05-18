import React, { useState } from "react";
import {
  Button,
  Menu,
  MenuItem,
  ListItemIcon,
  ListItemText,
} from "@mui/material";
import {
  CheckCircle,
  Cancel,
  HelpOutline,
  ExpandMore,
} from "@mui/icons-material";
import { Participation } from "../types";

interface ParticipationButtonProps {
  eventId: number;
  userId: number;
  currentStatus?: string;
  onStatusChange: (status: Participation["status"]) => void;
}

export const ParticipationButton: React.FC<ParticipationButtonProps> = ({
  eventId,
  userId,
  currentStatus,
  onStatusChange,
}) => {
  const [anchorEl, setAnchorEl] = useState<null | HTMLElement>(null);

  const handleClick = (event: React.MouseEvent<HTMLButtonElement>) => {
    setAnchorEl(event.currentTarget);
  };

  const handleClose = () => {
    setAnchorEl(null);
  };

  const handleStatusSelect = (status: Participation["status"]) => {
    onStatusChange(status);
    handleClose();
  };

  const getButtonColor = () => {
    switch (currentStatus) {
      case "going":
        return "success";
      case "not_going":
        return "error";
      case "maybe":
        return "warning";
      default:
        return "primary";
    }
  };

  const getButtonText = () => {
    switch (currentStatus) {
      case "going":
        return "Going";
      case "not_going":
        return "Not Going";
      case "maybe":
        return "Maybe";
      default:
        return "Respond";
    }
  };

  return (
    <>
      <Button
        variant="contained"
        color={getButtonColor()}
        onClick={handleClick}
        endIcon={<ExpandMore />}
      >
        {getButtonText()}
      </Button>
      <Menu anchorEl={anchorEl} open={Boolean(anchorEl)} onClose={handleClose}>
        <MenuItem onClick={() => handleStatusSelect("going")}>
          <ListItemIcon>
            <CheckCircle color="success" />
          </ListItemIcon>
          <ListItemText>Going</ListItemText>
        </MenuItem>
        <MenuItem onClick={() => handleStatusSelect("not_going")}>
          <ListItemIcon>
            <Cancel color="error" />
          </ListItemIcon>
          <ListItemText>Not Going</ListItemText>
        </MenuItem>
        <MenuItem onClick={() => handleStatusSelect("maybe")}>
          <ListItemIcon>
            <HelpOutline color="warning" />
          </ListItemIcon>
          <ListItemText>Maybe</ListItemText>
        </MenuItem>
      </Menu>
    </>
  );
};

# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

- Ruby version

- System dependencies

- Configuration

- Database creation

- Database initialization

- How to run the test suite

- Services (job queues, cache servers, search engines, etc.)

- Deployment instructions

- ...

# Volun API Documentation

## Authentication Endpoints

### Register

- **POST** `/api/v1/auth/register`
- Register a new user
- Body: `{ "name": "string", "email": "string", "password": "string" }`

### Login

- **POST** `/api/v1/auth/login`
- Login with existing user
- Body: `{ "email": "string", "password": "string" }`

## Entities

### List Entities

- **GET** `/entities`
- List all entities

### Get Entity

- **GET** `/entities/:id`
- Get entity details

### Create Entity

- **POST** `/entities`
- Create a new entity
- Body: `{ "name": "string", "description": "string", "logo_url": "string", "website": "string", "address": "string", "phone": "string", "email": "string" }`

### Update Entity

- **PUT/PATCH** `/entities/:id`
- Update entity details
- Body: Same as create

### Delete Entity

- **DELETE** `/entities/:id`
- Delete an entity

### Duplicate Entity

- **POST** `/entities/:id/duplicate`
- Duplicate an entity with all its events
- Creates a copy of the entity and all its associated events

## Events

### List Events

- **GET** `/entities/:entity_id/events`
- List all events for an entity

### Get Event

- **GET** `/events/:id`
- Get event details

### Create Event

- **POST** `/entities/:entity_id/events`
- Create a new event
- Body: `{ "title": "string", "description": "string", "date": "datetime", "time": "datetime", "location": "string" }`

### Update Event

- **PUT/PATCH** `/events/:id`
- Update event details
- Body: Same as create

### Delete Event

- **DELETE** `/events/:id`
- Delete an event

### Duplicate Event

- **POST** `/events/:id/duplicate`
- Duplicate an event with all its participants, cars, and donations
- Creates a copy of the event and all its associated resources

## Participants

### List Participants

- **GET** `/events/:event_id/participants`
- List all participants for an event

### Create Participant

- **POST** `/events/:event_id/participants`
- Add a new participant
- Body: `{ "name": "string", "status": "string", "car_id": "integer" }`
- Status options: "going", "not_going", "maybe"

### Update Participant

- **PUT/PATCH** `/events/:event_id/participants/:id`
- Update participant details
- Body: Same as create

### Delete Participant

- **DELETE** `/events/:event_id/participants/:id`
- Remove a participant

## Cars

### List Cars

- **GET** `/events/:event_id/cars`
- List all cars for an event

### Create Car

- **POST** `/events/:event_id/cars`
- Add a new car
- Body: `{ "driver_name": "string", "seats": "integer" }`

### Update Car

- **PUT/PATCH** `/events/:event_id/cars/:id`
- Update car details
- Body: Same as create

### Delete Car

- **DELETE** `/events/:event_id/cars/:id`
- Remove a car

### Clean Car Seats

- **POST** `/events/:event_id/cars/:id/clean_seats`
- Remove all participants from a car except specified drivers
- Body: `{ "driver_ids": ["integer"] }`

### Clean Car Donations

- **POST** `/events/:event_id/cars/:id/clean_donations`
- Remove all donations from a car

## Donations

### List Donations

- **GET** `/events/:event_id/donations`
- List all donations for an event

### Create Donation

- **POST** `/events/:event_id/donations`
- Add a new donation
- Body: `{ "donation_type": "string", "quantity": "decimal", "unit": "string", "description": "string", "car_id": "integer" }`
- Donation types: "drinks", "food", "dog_food", "cleaning_supplies", "medical_supplies", "clothing", "other"
- Units: "kg", "g", "l", "ml", "units", "boxes", "bags"

### Update Donation

- **PUT/PATCH** `/events/:event_id/donations/:id`
- Update donation details
- Body: Same as create

### Delete Donation

- **DELETE** `/events/:event_id/donations/:id`
- Remove a donation

### Duplicate Donation

- **POST** `/events/:event_id/donations/:id/duplicate`
- Create a copy of an existing donation
- The new donation will be associated with the same event and user

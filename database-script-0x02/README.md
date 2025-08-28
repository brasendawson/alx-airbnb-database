# Property Booking Database Seed Data

## Overview
This repository contains the `seed.sql` file, which populates the property booking database with sample data. The database is designed for a platform similar to Airbnb, managing users, properties, bookings, payments, reviews, and messages. The schema is normalized to Third Normal Form (3NF), and the seed data reflects real-world usage with multiple users, properties, and related records.

## Purpose
The `seed.sql` file provides sample data to:
- Test the database schema functionality.
- Simulate real-world scenarios (e.g., multiple users with different roles, bookings with varied statuses, partial payments).
- Facilitate development and testing of applications using the database.

## Schema Reference
The seed data is designed for the following schema (defined in `schema.sql`):
- **User**: Stores user information (e.g., name, email, role).
- **Property**: Stores property details hosted by users.
- **Booking**: Records bookings with historical pricing (booked_pricepernight).
- **Payment**: Tracks payments for bookings, supporting partial payments.
- **Review**: Stores user reviews for properties.
- **Message**: Manages communication between users.

### Schema Details
- **Tables**: User, Property, Booking, Payment, Review, Message.
- **Constraints**: Primary keys (UUID), foreign keys, NOT NULL, UNIQUE (User.email), CHECK (e.g., Review.rating 1-5).
- **Indexes**: On primary keys, User.email, Property.property_id, Booking.property_id, Booking.booking_id, Payment.booking_id.

## Sample Data Description

### User
- 5 users: 2 hosts, 2 guests, 1 admin.
- Example: John Doe (host), Jane Smith (guest), Admin User (admin).
- Includes realistic names, emails, and phone numbers (some NULL).

### Property
- 3 properties hosted by 2 hosts (John Doe and Alice Brown).
- Example: "Cozy Beach Cottage" in Miami, "Urban Loft" in New York, "Mountain Cabin" in Aspen.
- Varied pricepernight values (150.00–200.00).

### Booking
- 3 bookings by 2 guests (Jane Smith and Bob Johnson) for different properties.
- Example: Jane books the cottage for 4 nights, Bob books the cabin for 5 nights.
- Includes booked_pricepernight to preserve historical pricing, with statuses (confirmed, pending).

### Payment
- 3 payments for 2 bookings, including a split payment for one booking.
- Example: Jane pays 600.00 (split into two 300.00 payments) for the cottage, Bob pays 900.00 for the cabin.
- Uses different payment methods (credit_card, paypal, stripe).

### Review
- 2 reviews by guests for different properties.
- Example: Jane gives 5 stars to the cottage, Bob gives 4 stars to the cabin.
- Includes realistic comments and ratings (4–5).

### Message
- 3 messages between guests and hosts.
- Example: Jane asks John about cottage availability, John responds; Bob asks Alice about pets.
- Reflects typical communication in a booking platform.

## Setup Instructions
1. **Prerequisites**:
   - PostgreSQL (version 9.6 or later).
   - The database schema must be created first (use `schema.sql`).
2. **Create Database**:
   ```sql
   CREATE DATABASE property_booking;
   \c property_booking
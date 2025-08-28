# Property Booking Database Schema

## Overview
This repository contains the SQL Data Definition Language (DDL) for a property booking system database, designed for a platform similar to Airbnb. The schema manages users, properties, bookings, payments, reviews, and messages, ensuring data integrity and optimal performance through normalization, constraints, and indexing. The database is normalized to **Third Normal Form (3NF)** to eliminate redundancies and transitive dependencies.

## Schema Description
The database consists of six tables: `User`, `Property`, `Booking`, `Payment`, `Review`, and `Message`. Each table includes appropriate data types, primary keys, foreign keys, constraints, and indexes as described below.

### Tables and Attributes

#### User
- **user_id**: UUID (Primary Key, Indexed)
- **first_name**: VARCHAR (NOT NULL)
- **last_name**: VARCHAR (NOT NULL)
- **email**: VARCHAR (UNIQUE, NOT NULL)
- **password_hash**: VARCHAR (NOT NULL)
- **phone_number**: VARCHAR (NULL)
- **role**: VARCHAR (NOT NULL, CHECK: 'guest', 'host', 'admin')
- **created_at**: TIMESTAMP (DEFAULT CURRENT_TIMESTAMP)

#### Property
- **property_id**: UUID (Primary Key, Indexed)
- **host_id**: UUID (Foreign Key referencing User(user_id))
- **name**: VARCHAR (NOT NULL)
- **description**: TEXT (NOT NULL)
- **location**: VARCHAR (NOT NULL)
- **pricepernight**: DECIMAL (NOT NULL)
- **created_at**: TIMESTAMP (DEFAULT CURRENT_TIMESTAMP)
- **updated_at**: TIMESTAMP (DEFAULT CURRENT_TIMESTAMP)

#### Booking
- **booking_id**: UUID (Primary Key, Indexed)
- **property_id**: UUID (Foreign Key referencing Property(property_id))
- **user_id**: UUID (Foreign Key referencing User(user_id))
- **start_date**: DATE (NOT NULL)
- **end_date**: DATE (NOT NULL)
- **booked_pricepernight**: DECIMAL (NOT NULL)
- **status**: VARCHAR (NOT NULL, CHECK: 'pending', 'confirmed', 'canceled')
- **created_at**: TIMESTAMP (DEFAULT CURRENT_TIMESTAMP)

#### Payment
- **payment_id**: UUID (Primary Key, Indexed)
- **booking_id**: UUID (Foreign Key referencing Booking(booking_id))
- **amount**: DECIMAL (NOT NULL)
- **payment_date**: TIMESTAMP (DEFAULT CURRENT_TIMESTAMP)
- **payment_method**: VARCHAR (NOT NULL, CHECK: 'credit_card', 'paypal', 'stripe')
- **created_at**: TIMESTAMP (DEFAULT CURRENT_TIMESTAMP)

#### Review
- **review_id**: UUID (Primary Key, Indexed)
- **property_id**: UUID (Foreign Key referencing Property(property_id))
- **user_id**: UUID (Foreign Key referencing User(user_id))
- **rating**: INTEGER (NOT NULL, CHECK: rating >= 1 AND rating <= 5)
- **comment**: TEXT (NOT NULL)
- **created_at**: TIMESTAMP (DEFAULT CURRENT_TIMESTAMP)

#### Message
- **message_id**: UUID (Primary Key, Indexed)
- **sender_id**: UUID (Foreign Key referencing User(user_id))
- **recipient_id**: UUID (Foreign Key referencing User(user_id))
- **message_body**: TEXT (NOT NULL)
- **sent_at**: TIMESTAMP (DEFAULT CURRENT_TIMESTAMP)

### Relationships
- **User - Property (Hosts)**: One User (host) can host many Properties (1:N, via host_id).
- **User - Booking (Books)**: One User can make many Bookings (1:N, via user_id).
- **Property - Booking (Booked)**: One Property can have many Bookings (1:N, via property_id).
- **Booking - Payment (Paid For)**: One Booking can have multiple Payments (1:N, via booking_id).
- **User - Review (Writes)**: One User can write many Reviews (1:N, via user_id).
- **Property - Review (Reviewed)**: One Property can have many Reviews (1:N, via property_id).
- **User - Message (Sends/Receives)**: One User can send and receive many Messages (1:N for sender_id and recipient_id, effectively N:N between Users).

### Constraints
- **Primary Keys**: UUID for each table, ensuring unique records.
- **Foreign Keys**: Enforce referential integrity (e.g., host_id references User.user_id).
- **NOT NULL**: Applied to mandatory fields (e.g., email, name, amount).
- **UNIQUE**: Applied to User.email to prevent duplicates.
- **CHECK**: Enforces valid values for role, status, payment_method, and rating (1-5).
- **DEFAULT**: Sets created_at, updated_at, payment_date, and sent_at to the current timestamp.

### Indexes
- **Primary Keys**: Automatically indexed (e.g., user_id, property_id).
- **Additional Indexes**:
  - idx_user_email: On User.email for fast email lookups.
  - idx_property_property_id: On Property.property_id for joins.
  - idx_booking_property_id: On Booking.property_id for property-based queries.
  - idx_booking_booking_id: On Booking.booking_id for payment joins.
  - idx_payment_booking_id: On Payment.booking_id for payment queries.

## Normalization
The schema is in **3NF**:
- **1NF**: All attributes are atomic, and each table has a primary key.
- **2NF**: No partial dependencies, as all tables use single-column primary keys.
- **3NF**: Transitive dependencies eliminated. The original Booking.total_price was removed (as it depended on start_date, end_date, and Property.pricepernight), and booked_pricepernight was added to store the price at booking time, ensuring direct dependency on booking_id. Payment.amount is retained, assuming it supports partial payments or fees.

## Setup Instructions
1. **Prerequisites**: Install PostgreSQL (version 9.6 or later recommended).
2. **Create Database**:
   ```sql
   CREATE DATABASE property_booking;
   \c property_booking
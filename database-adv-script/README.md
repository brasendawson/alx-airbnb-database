# SQL Joins Practice

This repository contains SQL queries designed to demonstrate the practical use of different `JOIN` operations on a relational database schema typical of a property rental platform (like Airbnb).

## Database Schema Overview

The queries are written for a schema with at least the following tables and key columns:

### `users`
- `user_id` (PRIMARY KEY)
- `name`
- `email`

### `bookings`
- `booking_id` (PRIMARY KEY)
- `guest_id` (FOREIGN KEY to `users.user_id`)
- `check_in_date`
- `check_out_date`
- `status`

### `properties`
- `property_id` (PRIMARY KEY)
- `title`
- `price_per_night`

### `reviews`
- `review_id` (PRIMARY KEY)
- `property_id` (FOREIGN KEY to `properties.property_id`)
- `rating`
- `comment`
- `created_at`

## Queries

The file `joins_queries.sql` contains three main queries:

### 1. INNER JOIN
**Objective:** Retrieve all bookings along with the information of the users who made them.
**Logic:** An `INNER JOIN` ensures we only get records where a match exists in both the `bookings` and `users` tables. Bookings without a valid user or users without bookings are excluded.
**Use Case:** Generating a list of confirmed bookings with guest details for hosts or administrators.

### 2. LEFT JOIN
**Objective:** Retrieve all properties and any reviews they might have, including properties that have not been reviewed yet.
**Logic:** A `LEFT JOIN` keeps all records from the `properties` table (the left table), and fetches matching records from the `reviews` table. If no review exists, the columns from the `reviews` table will return `NULL`.
**Use Case:** Displaying a property listing page, where you want to show the property regardless of whether it has reviews.

### 3. FULL OUTER JOIN
**Objective:** Retrieve a complete set of all users and all bookings, showing the relationship where it exists.
**Logic:** A `FULL OUTER JOIN` returns all records when there is a match in either the `users` or `bookings` table. This means:
- Users who have made bookings (shows user + booking info).
- Users who have NOT made any bookings (booking columns will be `NULL`).
- Bookings that for some reason are not linked to a user in the `users` table (user columns will be `NULL`).
**Note:** MySQL does not support `FULL OUTER JOIN`. The provided alternative uses a `UNION` of a `LEFT JOIN` and a `RIGHT JOIN` to achieve the same result.
**Use Case:** Data integrity check to find orphaned bookings or to analyze user booking activity comprehensively.

## How to Run

1.  Ensure you have a SQL database server running (e.g., PostgreSQL, MySQL).
2.  Set up the necessary tables (`users`, `bookings`, `properties`, `reviews`) and populate them with sample data.
3.  Open your database management tool (e.g., `psql`, `mysql` CLI, phpMyAdmin, DBeaver).
4.  Copy and execute the desired query from `joins_queries.sql`.
5.  Observe the results, noting how each type of `JOIN` affects the result set.

## Key Takeaways

- **INNER JOIN:** For getting only matched data from both tables.
- **LEFT JOIN:** For getting all data from the left table, and matched data from the right table.
- **FULL OUTER JOIN:** For getting all data from both tables, showing the relationship where it exists. Crucial for audits and full data overviews.
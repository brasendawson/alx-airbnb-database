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



# SQL Subqueries Practice: Correlated vs. Non-Correlated

This repository contains SQL queries designed to demonstrate the difference between correlated and non-correlated subqueries using a property rental database schema.

## Database Schema Overview

The queries are written for a schema with the following tables and key columns:

### `users`
- `user_id` (PRIMARY KEY)
- `name`
- `email`

### `bookings`
- `booking_id` (PRIMARY KEY)
- `guest_id` (FOREIGN KEY to `users.user_id`)

### `properties`
- `property_id` (PRIMARY KEY)
- `title`
- `price_per_night`

### `reviews`
- `review_id` (PRIMARY KEY)
- `property_id` (FOREIGN KEY to `properties.property_id`)
- `rating` (e.g., a number from 1 to 5)

## Queries

The file `subqueries.sql` contains two queries:

### 1. Non-Correlated Subquery

**Objective:** Find all properties with an average rating greater than 4.0.

**Explanation:**
- This is a **non-correlated** (or simple) subquery.
- The inner query (`SELECT property_id FROM reviews...`) executes **first and only once**.
- It processes completely on its own, generating a list of `property_id` values that have an average rating above 4.0.
- This final list is then passed to the outer query.
- The outer query uses the `IN` operator to select all properties whose `property_id` is in the list provided by the inner query.
- **Analogy:** It's like getting a list of eligible IDs from one department and then using that list to print full records from another department.

**Use Case:** Filtering a main table based on a pre-computed condition from another table.

### 2. Correlated Subquery

**Objective:** Find users who have made more than 3 bookings.

**Explanation:**
- This is a **correlated** subquery.
- The outer query (`SELECT ... FROM users u`) executes first and gets a row from the `users` table.
- For each row (i.e., for each user), the outer query passes the current user's `user_id` (`u.user_id`) to the inner query.
- The inner query (`SELECT COUNT(*) FROM bookings...`) then executes **once for every single user**. It uses the provided `user_id` to count how many bookings that specific user has made.
- This count is compared to 3. If it's greater, the row from the outer query (the user) is included in the final result.
- **Analogy:** It's like a loop. For each employee, ask HR to count how many projects they've worked on. If the count is high enough, add the employee to the "experienced" list.

**Performance Note:** Correlated subqueries can be slower than joins or non-correlated subqueries for large datasets because the inner query may need to run thousands of times (once per row in the outer query).

## Key Differences

| Feature | Non-Correlated Subquery | Correlated Subquery |
| :--- | :--- | :--- |
| **Execution** | Inner query runs first, **once**. | Inner query runs **once for each row** processed by the outer query. |
| **Dependency** | Independent of the outer query. | Depends on the outer query for its values (e.g., `u.user_id`). |
| **Performance** | Generally faster. | Can be slower, especially on large tables. |
| **Use Case** | Filtering based on a pre-defined list or single value. | Row-by-row evaluation based on a related table. |

## How to Run

1.  Ensure you have a SQL database server running (e.g., PostgreSQL, MySQL).
2.  Set up the necessary tables (`users`, `bookings`, `properties`, `reviews`) and populate them with sample data.
3.  Open your database management tool (e.g., `psql`, `mysql` CLI, DBeaver).
4.  Copy and execute the queries from `subqueries.sql`.
5.  Observe the results and try to understand the execution flow of each query type.


# SQL Aggregations and Window Functions

This repository contains SQL queries that demonstrate the use of aggregation with `GROUP BY` and powerful window functions like `RANK()` and `ROW_NUMBER()`.

## Database Schema Overview

The queries are written for a schema with the following tables and key columns:

### `users`
- `user_id` (PRIMARY KEY)
- `name`
- `email`

### `bookings`
- `booking_id` (PRIMARY KEY)
- `guest_id` (FOREIGN KEY to `users.user_id`)
- `property_id` (FOREIGN KEY to `properties.property_id`)

### `properties`
- `property_id` (PRIMARY KEY)
- `title`
- `price_per_night`

## Queries

The file `aggregations_and_window_functions.sql` contains three queries:

### 1. Aggregation with GROUP BY

**Objective:** Find the total number of bookings made by each user.

**Explanation:**
- The `LEFT JOIN` ensures we include users who have made zero bookings.
- The `GROUP BY` clause collapses all rows into one group per user.
- The `COUNT(b.booking_id)` function counts the number of bookings within each user's group. It's important to count on the joined table's primary key to avoid counting NULLs from the join as zeros.
- This is a classic aggregation that reduces many rows of booking data into a single summary row per user.

**Use Case:** Generating reports on user activity, finding top customers, or analyzing booking trends.

### 2. Window Function (RANK)

**Objective:** Rank properties based on their total number of bookings.

**Explanation:**
- Like the first query, we use a `LEFT JOIN` and `GROUP BY` to calculate `total_bookings` for each property.
- The key difference is the `RANK() OVER (ORDER BY COUNT(b.booking_id) DESC)` clause.
  - `RANK()` is the window function.
  - The `OVER` clause defines the "window" of data the function operates on—in this case, the entire result set.
  - The `ORDER BY` inside the `OVER` clause tells the function how to assign ranks. Here, properties are ranked descending by their booking count.
- Unlike `GROUP BY`, which collapses rows, window functions perform calculations across rows while **preserving the original detail of each row**. Each property row is retained, and a new column (`booking_rank`) is added with its calculated rank.

**Use Case:** Creating leaderboards, identifying most popular items, or performing competitive analysis without losing detailed information.

### 3. Bonus: ROW_NUMBER with Partitioning

**Objective:** Demonstrate partitioning by ranking properties within defined price categories.

**Explanation:**
- This query uses a Common Table Expression (CTE) for clarity to first create a derived table (`property_data`) with a `price_category` column.
- The window function is `ROW_NUMBER() OVER (PARTITION BY price_category ORDER BY total_bookings DESC)`.
  - `PARTITION BY price_category` splits the result set into separate groups (partitions) based on the value of `price_category` ('Budget', 'Mid-Range', 'Luxury').
  - The `ROW_NUMBER()` function then assigns a unique sequential integer (1, 2, 3...) to each row **within its partition**, based on the `ORDER BY` clause.
  - The ranking restarts at 1 for each new partition.
- This shows the power of window functions to perform complex, grouped rankings in a single query.

**Use Case:** Analyzing top performers within different segments or categories (e.g., "Top 5 most booked Budget properties").

## Key Concepts

- **Aggregation with GROUP BY:** Summarizes data, reducing the number of rows returned. Best for getting summary statistics (counts, sums, averages) for groups.
- **Window Functions:** Perform calculations across a set of table rows that are somehow related to the current row. They do not cause rows to become grouped into a single output row—they add a new column to each row. Essential for rankings, running totals, and moving averages.

## How to Run

1.  Ensure you have a SQL database server running (e.g., PostgreSQL, MySQL 8.0+, SQL Server).
2.  Set up the necessary tables (`users`, `bookings`, `properties`) and populate them with sample data.
3.  Open your database management tool (e.g., `psql`, `mysql` CLI, DBeaver).
4.  Copy and execute the queries from `aggregations_and_window_functions.sql`.
5.  Compare the result sets of the aggregation query and the window function query to understand the difference in output structure.
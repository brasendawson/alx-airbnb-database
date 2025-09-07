# Query Optimization Report

## 1. Initial Query

The initial query retrieves all bookings along with user, property, and payment details:

```sql
SELECT b.*, u.*, p.*, pay.*
FROM bookings b
JOIN users u ON b.guest_id = u.id
JOIN properties p ON b.property_id = p.id
LEFT JOIN payments pay ON b.id = pay.booking_id;
```

## 2. Performance Analysis (Before Optimization)

The query was analyzed using `EXPLAIN ANALYZE`:

```sql
EXPLAIN ANALYZE
SELECT b.*, u.*, p.*, pay.*
FROM bookings b
JOIN users u ON b.guest_id = u.id
JOIN properties p ON b.property_id = p.id
LEFT JOIN payments pay ON b.id = pay.booking_id;
```

**Findings:**
- The use of `SELECT *` retrieves unnecessary columns, increasing I/O.
- All columns from all tables are loaded, which is inefficient for large tables.
- The query relies on existing indexes for join columns, but performance can be improved by reducing the data footprint.

## 3. Optimized Query

The query was refactored to select only necessary columns and use explicit column names:

```sql
SELECT b.id AS booking_id, b.check_in_date, b.check_out_date, b.status,
       u.id AS user_id, u.name, u.email,
       p.id AS property_id, p.city, p.country, p.price_per_night,
       pay.id AS payment_id, pay.amount, pay.status AS payment_status
FROM bookings b
JOIN users u ON b.guest_id = u.id
JOIN properties p ON b.property_id = p.id
LEFT JOIN payments pay ON b.id = pay.booking_id;
```

## 4. Performance Analysis (After Optimization)

The optimized query was analyzed using `EXPLAIN ANALYZE`:

```sql
EXPLAIN ANALYZE
SELECT b.id AS booking_id, b.check_in_date, b.check_out_date, b.status,
       u.id AS user_id, u.name, u.email,
       p.id AS property_id, p.city, p.country, p.price_per_night,
       pay.id AS payment_id, pay.amount, pay.status AS payment_status
FROM bookings b
JOIN users u ON b.guest_id = u.id
JOIN properties p ON b.property_id = p.id
LEFT JOIN payments pay ON b.id = pay.booking_id;
```

**Findings:**
- Reduced I/O and memory usage by selecting only relevant columns.
- Query execution time improved due to smaller result set and better use of indexes.
- The query is now more maintainable and efficient.

---

**Conclusion:**

Refactoring complex queries to select only necessary columns and leveraging indexes can significantly improve query performance.

# Partitioning Performance Report

## 1. Partitioning Implementation

The `bookings` table was partitioned by the `check_in_date` column using range partitioning. Separate partitions were created for each year (e.g., 2024, 2025).

## 2. Performance Testing

A query fetching bookings by a date range was tested using `EXPLAIN ANALYZE`:

```sql
EXPLAIN ANALYZE
SELECT * FROM bookings_partitioned
WHERE check_in_date BETWEEN '2025-06-01' AND '2025-06-30';
```

## 3. Observed Improvements

- **Before partitioning:**
  - The query scanned the entire bookings table, resulting in higher I/O and slower performance, especially as the table grew.
- **After partitioning:**
  - The query only scanned the relevant partition(s) for the specified date range.
  - Reduced scan time and improved query performance.
  - Lower I/O and memory usage for date-based queries.

## 4. Conclusion

Partitioning large tables by date can significantly improve the performance of range queries, making the database more scalable and efficient for time-based data.

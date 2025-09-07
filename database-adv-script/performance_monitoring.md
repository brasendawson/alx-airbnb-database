# Database Performance Monitoring and Refinement Report

## 1. Monitoring Frequently Used Queries

### Query 1: Fetch Bookings by Date Range
```sql
EXPLAIN ANALYZE
SELECT * FROM bookings WHERE check_in_date BETWEEN '2025-06-01' AND '2025-06-30';
```

### Query 2: Fetch User Bookings
```sql
EXPLAIN ANALYZE
SELECT * FROM bookings WHERE guest_id = 123;
```

### Query 3: Fetch Properties by City
```sql
EXPLAIN ANALYZE
SELECT * FROM properties WHERE city = 'New York';
```

## 2. Bottleneck Analysis & Recommendations

- **Query 1:**
  - Bottleneck: Full table scan if no index or partitioning on `check_in_date`.
  - Recommendation: Partition table by `check_in_date` (already implemented).
- **Query 2:**
  - Bottleneck: Sequential scan if no index on `guest_id`.
  - Recommendation: Ensure index exists on `guest_id` in `bookings`.
- **Query 3:**
  - Bottleneck: Sequential scan if no index on `city`.
  - Recommendation: Ensure index exists on `city` in `properties`.

## 3. Implemented Changes

- Partitioned `bookings` table by `check_in_date`.
- Created/verified indexes:
  - `CREATE INDEX idx_bookings_guest_id ON bookings(guest_id);`
  - `CREATE INDEX idx_properties_city ON properties(city);`

## 4. Observed Improvements

- Range and guest-based queries on `bookings` now use index/partition scans, reducing execution time.
- Property queries by city now use an index scan, improving performance for location-based searches.

## 5. Conclusion

Continuous monitoring with `EXPLAIN ANALYZE` and schema refinement (indexes, partitioning) leads to measurable improvements in query performance and database scalability.

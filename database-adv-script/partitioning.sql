-- Partitioning the bookings table by check_in_date (start_date)
-- Step 1: Create a new partitioned table
CREATE TABLE bookings_partitioned (
    id SERIAL PRIMARY KEY,
    guest_id INT NOT NULL,
    property_id INT NOT NULL,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    status VARCHAR(50),
    -- ... other columns ...
    -- Add constraints and indexes as needed
) PARTITION BY RANGE (check_in_date);

-- Step 2: Create partitions for each year (example: 2024, 2025)
CREATE TABLE bookings_2024 PARTITION OF bookings_partitioned
    FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

CREATE TABLE bookings_2025 PARTITION OF bookings_partitioned
    FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');

-- Step 3: Example query to test performance on partitioned table
EXPLAIN ANALYZE
SELECT * FROM bookings_partitioned
WHERE check_in_date BETWEEN '2025-06-01' AND '2025-06-30';

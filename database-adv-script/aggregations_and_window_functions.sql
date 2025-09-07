-- 1. Aggregation with GROUP BY: Find the total number of bookings made by each user.
-- This query groups all booking records by the guest_id and counts the rows in each group.
SELECT
    u.user_id,
    u.name AS user_name,
    u.email,
    COUNT(b.booking_id) AS total_bookings
FROM
    users u
LEFT JOIN
    bookings b ON u.user_id = b.guest_id
GROUP BY
    u.user_id, u.name, u.email -- Group by the primary key and descriptive columns
ORDER BY
    total_bookings DESC; -- Order from most to least bookings


-- 2. Window Function (RANK): Rank properties based on the total number of bookings they have received.
-- This query calculates the total bookings per property and then assigns a rank.
SELECT
    p.property_id,
    p.title AS property_title,
    p.price_per_night,
    COUNT(b.booking_id) AS total_bookings,
    RANK() OVER (ORDER BY COUNT(b.booking_id) DESC) AS booking_rank
FROM
    properties p
LEFT JOIN
    bookings b ON p.property_id = b.property_id
GROUP BY
    p.property_id, p.title, p.price_per_night
ORDER BY
    booking_rank; -- Order by the assigned rank


-- 3. Bonus: Window Function (ROW_NUMBER) with partitioning.
-- This ranks properties *within each price category* based on their number of bookings.
-- It demonstrates partitioning, which is a powerful feature of window functions.

-- First, let's create a price category for demonstration.
WITH property_data AS (
    SELECT
        p.property_id,
        p.title,
        p.price_per_night,
        CASE
            WHEN p.price_per_night < 50 THEN 'Budget'
            WHEN p.price_per_night BETWEEN 50 AND 100 THEN 'Mid-Range'
            ELSE 'Luxury'
        END AS price_category,
        COUNT(b.booking_id) AS total_bookings
    FROM
        properties p
    LEFT JOIN
        bookings b ON p.property_id = b.property_id
    GROUP BY
        p.property_id, p.title, p.price_per_night
)
SELECT
    property_id,
    title,
    price_per_night,
    price_category,
    total_bookings,
    ROW_NUMBER() OVER (PARTITION BY price_category ORDER BY total_bookings DESC) AS rank_in_category
FROM
    property_data
ORDER BY
    price_category, rank_in_category;
-- 1. Non-Correlated Subquery: Find all properties where the average rating is greater than 4.0.
-- The inner query runs first, independently, to find property IDs that meet the average rating condition.
-- The outer query then uses that list to get the full details of those properties.

SELECT
    property_id,
    title,
    price_per_night
FROM
    properties
WHERE
    property_id IN (
        -- This is the non-correlated subquery.
        -- It calculates the average rating for each property and filters the group.
        SELECT
            property_id
        FROM
            reviews
        GROUP BY
            property_id
        HAVING
            AVG(rating) > 4.0
    )
ORDER BY
    price_per_night DESC;


-- 2. Correlated Subquery: Find users who have made more than 3 bookings.
-- The inner query runs once for every row in the outer query (for every user).
-- It uses the `u.user_id` from the outer query to count the bookings for that specific user.

SELECT
    user_id,
    name,
    email
FROM
    users u
WHERE
    -- This is the correlated subquery.
    -- It is "correlated" because its inner condition depends on the outer query's current row (`u.user_id`).
    (
        SELECT
            COUNT(*)
        FROM
            bookings b
        WHERE
            b.guest_id = u.user_id -- This links the inner query to the outer query.
    ) > 3
ORDER BY
    name;
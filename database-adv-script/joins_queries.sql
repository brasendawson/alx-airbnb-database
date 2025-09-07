-- 1. INNER JOIN: Retrieve all bookings and the respective users who made those bookings.
-- This will only return bookings that have a valid user associated with them.
SELECT
    b.booking_id,
    b.check_in_date,
    b.check_out_date,
    b.status,
    u.user_id,
    u.name AS guest_name,
    u.email
FROM
    bookings b
INNER JOIN
    users u ON b.guest_id = u.user_id
ORDER BY
    b.booking_id;


-- 2. LEFT JOIN: Retrieve all properties and their reviews, including properties that have no reviews.
-- This ensures that every property is listed, even if it has zero reviews.
SELECT
    p.property_id,
    p.title AS property_title,
    p.price_per_night,
    r.review_id,
    r.rating,
    r.comment,
    r.created_at AS review_date
FROM
    properties p
LEFT JOIN
    reviews r ON p.property_id = r.property_id
ORDER BY
    p.property_id, r.created_at DESC;


-- 3. FULL OUTER JOIN: Retrieve all users and all bookings, even if the user has no booking or a booking is not linked to a user.
-- This is a comprehensive join to see the complete picture of both tables.
-- Note: Some databases (like MySQL) don't support FULL OUTER JOIN directly. An alternative using UNION is provided.
-- Standard FULL OUTER JOIN:
SELECT
    u.user_id,
    u.name,
    u.email,
    b.booking_id,
    b.check_in_date,
    b.check_out_date,
    b.status
FROM
    users u
FULL OUTER JOIN
    bookings b ON u.user_id = b.guest_id
ORDER BY
    u.user_id, b.booking_id;

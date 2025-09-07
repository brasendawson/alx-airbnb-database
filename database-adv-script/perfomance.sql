-- Initial Query: Retrieve all bookings with user, property, and payment details

-- Example: Retrieve bookings for a specific user and property
SELECT b.*, u.*, p.*, pay.*
FROM bookings b
JOIN users u ON b.guest_id = u.id
JOIN properties p ON b.property_id = p.id
LEFT JOIN payments pay ON b.id = pay.booking_id
WHERE b.guest_id = 123 AND b.property_id = 456;

-- Analyze performance before optimization
EXPLAIN ANALYZE
SELECT b.*, u.*, p.*, pay.*
FROM bookings b
JOIN users u ON b.guest_id = u.id
JOIN properties p ON b.property_id = p.id
LEFT JOIN payments pay ON b.id = pay.booking_id
WHERE b.guest_id = 123 AND b.property_id = 456;

-- Optimized Query: Only select necessary columns, use explicit columns, and leverage indexes
SELECT b.id AS booking_id, b.check_in_date, b.check_out_date, b.status,
       u.id AS user_id, u.name, u.email,
       p.id AS property_id, p.city, p.country, p.price_per_night,
       pay.id AS payment_id, pay.amount, pay.status AS payment_status
FROM bookings b
JOIN users u ON b.guest_id = u.id
JOIN properties p ON b.property_id = p.id
LEFT JOIN payments pay ON b.id = pay.booking_id
WHERE b.guest_id = 123 AND b.property_id = 456;

-- Analyze performance after optimization
EXPLAIN ANALYZE
SELECT b.id AS booking_id, b.check_in_date, b.check_out_date, b.status,
       u.id AS user_id, u.name, u.email,
       p.id AS property_id, p.city, p.country, p.price_per_night,
       pay.id AS payment_id, pay.amount, pay.status AS payment_status
FROM bookings b
JOIN users u ON b.guest_id = u.id
JOIN properties p ON b.property_id = p.id
LEFT JOIN payments pay ON b.id = pay.booking_id
WHERE b.guest_id = 123 AND b.property_id = 456;

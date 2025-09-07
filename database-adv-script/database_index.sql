-- Performance Measurement: Before Index Creation
-- (Run this before creating indexes)
EXPLAIN ANALYZE
SELECT * 
FROM bookings 
WHERE property_id = 123 
AND (
	(check_in_date <= '2024-01-10' AND check_out_date > '2024-01-05') 
	OR (check_in_date >= '2024-01-05' AND check_in_date < '2024-01-10')
);

-- Users table indexes
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_users_name ON users(name);

-- Properties table indexes
CREATE INDEX idx_properties_host_id ON properties(host_id);
CREATE INDEX idx_properties_city ON properties(city);
CREATE INDEX idx_properties_country ON properties(country);
CREATE INDEX idx_properties_price_guests ON properties(price_per_night, max_guest_count);

-- Bookings table indexes
CREATE INDEX idx_bookings_property_dates ON bookings(property_id, check_in_date, check_out_date);
CREATE INDEX idx_bookings_guest_id ON bookings(guest_id);
CREATE INDEX idx_bookings_status ON bookings(status);

-- Reviews table indexes
CREATE INDEX idx_reviews_property_id ON reviews(property_id);
CREATE INDEX idx_reviews_property_rating ON reviews(property_id, rating);

-- Performance Measurement: After Index Creation
-- (Run this after creating indexes)
EXPLAIN ANALYZE
SELECT * 
FROM bookings 
WHERE property_id = 123 
AND (
	(check_in_date <= '2024-01-10' AND check_out_date > '2024-01-05') 
	OR (check_in_date >= '2024-01-05' AND check_in_date < '2024-01-10')
);

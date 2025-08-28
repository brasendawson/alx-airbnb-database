-- Insert sample data into User table
INSERT INTO "User" (user_id, first_name, last_name, email, password_hash, phone_number, role, created_at)
VALUES
  ('a1b2c3d4-1234-5678-9abc-def123456789', 'John', 'Doe', 'john.doe@example.com', 'hashed_password1', '555-0101', 'host', '2025-08-01 10:00:00'),
  ('b2c3d4e5-2345-6789-abcd-ef1234567890', 'Jane', 'Smith', 'jane.smith@example.com', 'hashed_password2', '555-0102', 'guest', '2025-08-02 12:00:00'),
  ('c3d4e5f6-3456-7890-bcde-f12345678901', 'Alice', 'Brown', 'alice.brown@example.com', 'hashed_password3', NULL, 'host', '2025-08-03 14:00:00'),
  ('d4e5f6a7-4567-8901-cdef-123456789012', 'Bob', 'Johnson', 'bob.johnson@example.com', 'hashed_password4', '555-0103', 'guest', '2025-08-04 16:00:00'),
  ('e5f6a7b8-5678-9012-def0-234567890123', 'Admin', 'User', 'admin@example.com', 'hashed_password5', '555-0104', 'admin', '2025-08-05 18:00:00');

-- Insert sample data into Property table
INSERT INTO Property (property_id, host_id, name, description, location, pricepernight, created_at, updated_at)
VALUES
  ('f6a7b8c9-6789-0123-ef01-345678901234', 'a1b2c3d4-1234-5678-9abc-def123456789', 'Cozy Beach Cottage', 'A charming cottage by the sea with stunning views.', 'Miami, FL', 150.00, '2025-08-06 09:00:00', '2025-08-06 09:00:00'),
  ('a7b8c9d0-7890-1234-f012-456789012345', 'a1b2c3d4-1234-5678-9abc-def123456789', 'Urban Loft', 'Modern loft in the heart of the city.', 'New York, NY', 200.00, '2025-08-07 11:00:00', '2025-08-07 11:00:00'),
  ('b8c9d0e1-8901-2345-0123-567890123456', 'c3d4e5f6-3456-7890-bcde-f12345678901', 'Mountain Cabin', 'Rustic cabin with mountain views.', 'Aspen, CO', 180.00, '2025-08-08 13:00:00', '2025-08-08 13:00:00');

-- Insert sample data into Booking table
INSERT INTO Booking (booking_id, property_id, user_id, start_date, end_date, booked_pricepernight, status, created_at)
VALUES
  ('c9d0e1f2-9012-3456-1234-678901234567', 'f6a7b8c9-6789-0123-ef01-345678901234', 'b2c3d4e5-2345-6789-abcd-ef1234567890', '2025-09-01', '2025-09-05', 150.00, 'confirmed', '2025-08-10 10:00:00'),
  ('d0e1f2a3-0123-4567-2345-789012345678', 'a7b8c9d0-7890-1234-f012-456789012345', 'b2c3d4e5-2345-6789-abcd-ef1234567890', '2025-09-10', '2025-09-12', 200.00, 'pending', '2025-08-11 12:00:00'),
  ('e1f2a3b4-1234-5678-3456-890123456789', 'b8c9d0e1-8901-2345-0123-567890123456', 'd4e5f6a7-4567-8901-cdef-123456789012', '2025-09-15', '2025-09-20', 180.00, 'confirmed', '2025-08-12 14:00:00');

-- Insert sample data into Payment table
INSERT INTO Payment (payment_id, booking_id, amount, payment_date, payment_method, created_at)
VALUES
  ('f2a3b4c5-2345-6789-4567-901234567890', 'c9d0e1f2-9012-3456-1234-678901234567', 300.00, '2025-08-10 11:00:00', 'credit_card', '2025-08-10 11:00:00'),
  ('a3b4c5d6-3456-7890-5678-012345678901', 'c9d0e1f2-9012-3456-1234-678901234567', 300.00, '2025-08-11 13:00:00', 'paypal', '2025-08-11 13:00:00'),
  ('b4c5d6e7-4567-8901-6789-123456789012', 'e1f2a3b4-1234-5678-3456-890123456789', 900.00, '2025-08-12 15:00:00', 'stripe', '2025-08-12 15:00:00');

-- Insert sample data into Review table
INSERT INTO Review (review_id, property_id, user_id, rating, comment, created_at)
VALUES
  ('c5d6e7f8-5678-9012-7890-234567890123', 'f6a7b8c9-6789-0123-ef01-345678901234', 'b2c3d4e5-2345-6789-abcd-ef1234567890', 5, 'Amazing stay, loved the beach views!', '2025-08-15 10:00:00'),
  ('d6e7f8a9-6789-0123-8901-345678901234', 'b8c9d0e1-8901-2345-0123-567890123456', 'd4e5f6a7-4567-8901-cdef-123456789012', 4, 'Cozy cabin, great location, but Wi-Fi was spotty.', '2025-08-16 12:00:00');

-- Insert sample data into Message table
INSERT INTO Message (message_id, sender_id, recipient_id, message_body, sent_at)
VALUES
  ('e7f8a9b0-7890-1234-9012-456789012345', 'b2c3d4e5-2345-6789-abcd-ef1234567890', 'a1b2c3d4-1234-5678-9abc-def123456789', 'Is the cottage available for September?', '2025-08-05 09:00:00'),
  ('f8a9b0c1-8901-2345-0123-567890123456', 'a1b2c3d4-1234-5678-9abc-def123456789', 'b2c3d4e5-2345-6789-abcd-ef1234567890', 'Yes, it’s available! Please book through the platform.', '2025-08-05 10:00:00'),
  ('a9b0c1d2-9012-3456-1234-678901234567', 'd4e5f6a7-4567-8901-cdef-123456789012', 'c3d4e5f6-3456-7890-bcde-f12345678901', 'Can I bring pets to the cabin?', '2025-08-06 11:00:00');
# Entity-Relationship (ER) Diagram Specification

## Entities and Attributes

### 1. User
- **user_id**: UUID (Primary Key, Indexed)
- **first_name**: VARCHAR (NOT NULL)
- **last_name**: VARCHAR (NOT NULL)
- **email**: VARCHAR (UNIQUE, NOT NULL)
- **password_hash**: VARCHAR (NOT NULL)
- **phone_number**: VARCHAR (NULL)
- **role**: ENUM (guest, host, admin, NOT NULL)
- **created_at**: TIMESTAMP (DEFAULT CURRENT_TIMESTAMP)

### 2. Property
- **property_id**: UUID (Primary Key, Indexed)
- **host_id**: UUID (Foreign Key referencing User(user_id))
- **name**: VARCHAR (NOT NULL)
- **description**: TEXT (NOT NULL)
- **location**: VARCHAR (NOT NULL)
- **pricepernight**: DECIMAL (NOT NULL)
- **created_at**: TIMESTAMP (DEFAULT CURRENT_TIMESTAMP)
- **updated_at**: TIMESTAMP (ON UPDATE CURRENT_TIMESTAMP)

### 3. Booking
- **booking_id**: UUID (Primary Key, Indexed)
- **property_id**: UUID (Foreign Key referencing Property(property_id))
- **user_id**: UUID (Foreign Key referencing User(user_id))
- **start_date**: DATE (NOT NULL)
- **end_date**: DATE (NOT NULL)
- **total_price**: DECIMAL (NOT NULL)
- **status**: ENUM (pending, confirmed, canceled, NOT NULL)
- **created_at**: TIMESTAMP (DEFAULT CURRENT_TIMESTAMP)

### 4. Payment
- **payment_id**: UUID (Primary Key, Indexed)
- **booking_id**: UUID (Foreign Key referencing Booking(booking_id))
- **amount**: DECIMAL (NOT NULL)
- **payment_date**: TIMESTAMP (DEFAULT CURRENT_TIMESTAMP)
- **payment_method**: ENUM (credit_card, paypal, stripe, NOT NULL)

### 5. Review
- **review_id**: UUID (Primary Key, Indexed)
- **property_id**: UUID (Foreign Key referencing Property(property_id))
- **user_id**: UUID (Foreign Key referencing User(user_id))
- **rating**: INTEGER (NOT NULL, CHECK: rating >= 1 AND rating <= 5)
- **comment**: TEXT (NOT NULL)
- **created_at**: TIMESTAMP (DEFAULT CURRENT_TIMESTAMP)

### 6. Message
- **message_id**: UUID (Primary Key, Indexed)
- **sender_id**: UUID (Foreign Key referencing User(user_id))
- **recipient_id**: UUID (Foreign Key referencing User(user_id))
- **message_body**: TEXT (NOT NULL)
- **sent_at**: TIMESTAMP (DEFAULT CURRENT_TIMESTAMP)

## Relationships

1. **User - Property (Hosts)**
   - **Description**: A User (typically with role 'host') can host multiple Properties.
   - **Type**: One-to-Many
   - **Connection**: User.user_id → Property.host_id
   - **Cardinality**: 1:N

2. **User - Booking (Books)**
   - **Description**: A User can make multiple Bookings.
   - **Type**: One-to-Many
   - **Connection**: User.user_id → Booking.user_id
   - **Cardinality**: 1:N

3. **Property - Booking (Booked)**
   - **Description**: A Property can have multiple Bookings.
   - **Type**: One-to-Many
   - **Connection**: Property.property_id → Booking.property_id
   - **Cardinality**: 1:N

4. **Booking - Payment (Paid For)**
   - **Description**: A Booking can have one or more Payments.
   - **Type**: One-to-Many
   - **Connection**: Booking.booking_id → Payment.booking_id
   - **Cardinality**: 1:N

5. **User - Review (Writes)**
   - **Description**: A User can write multiple Reviews.
   - **Type**: One-to-Many
   - **Connection**: User.user_id → Review.user_id
   - **Cardinality**: 1:N

6. **Property - Review (Reviewed)**
   - **Description**: A Property can have multiple Reviews.
   - **Type**: One-to-Many
   - **Connection**: Property.property_id → Review.property_id
   - **Cardinality**: 1:N

7. **User - Message (Sends/Receives)**
   - **Description**: A User can send multiple Messages (as sender) and receive multiple Messages (as recipient). This is a self-referential relationship.
   - **Type**: Many-to-Many (via two One-to-Many relationships)
   - **Connections**:
     - User.user_id → Message.sender_id (Sends)
     - User.user_id → Message.recipient_id (Receives)
   - **Cardinality**: 1:N for both Sends and Receives (effectively N:N between Users via Messages)

## Notes for ER Diagram Visualization
- **Entities**: Represent as rectangles with attributes listed inside. Underline primary keys (e.g., user_id) and mark foreign keys with "FK".
- **Relationships**: Use lines with crow’s foot notation (single line for "one," crow’s foot for "many") to indicate cardinality.
- **Constraints**: Note constraints like UNIQUE (email in User), CHECK (rating in Review), and NOT NULL in parentheses next to attributes.
- **Indexes**: Primary keys are indexed automatically. Additional indexes (e.g., email, property_id) can be noted in a legend or near attributes.
- **Visualization**: Use a tool like Draw.io to draw entities, connect them with labeled relationship lines, and annotate cardinality and constraints.
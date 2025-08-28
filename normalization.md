# Database Normalization to Third Normal Form (3NF)

## Objective
Apply normalization principles to ensure the database schema is in the Third Normal Form (3NF) by reviewing the schema for redundancies or violations, adjusting the design if necessary, and explaining the normalization steps.

## Original Schema Review
The original database schema consists of the following tables:

### User
- **user_id**: UUID (Primary Key, Indexed)
- **first_name**: VARCHAR (NOT NULL)
- **last_name**: VARCHAR (NOT NULL)
- **email**: VARCHAR (UNIQUE, NOT NULL)
- **password_hash**: VARCHAR (NOT NULL)
- **phone_number**: VARCHAR (NULL)
- **role**: ENUM (guest, host, admin, NOT NULL)
- **created_at**: TIMESTAMP (DEFAULT CURRENT_TIMESTAMP)

### Property
- **property_id**: UUID (Primary Key, Indexed)
- **host_id**: UUID (Foreign Key referencing User(user_id))
- **name**: VARCHAR (NOT NULL)
- **description**: TEXT (NOT NULL)
- **location**: VARCHAR (NOT NULL)
- **pricepernight**: DECIMAL (NOT NULL)
- **created_at**: TIMESTAMP (DEFAULT CURRENT_TIMESTAMP)
- **updated_at**: TIMESTAMP (ON UPDATE CURRENT_TIMESTAMP)

### Booking
- **booking_id**: UUID (Primary Key, Indexed)
- **property_id**: UUID (Foreign Key referencing Property(property_id))
- **user_id**: UUID (Foreign Key referencing User(user_id))
- **start_date**: DATE (NOT NULL)
- **end_date**: DATE (NOT NULL)
- **total_price**: DECIMAL (NOT NULL)
- **status**: ENUM (pending, confirmed, canceled, NOT NULL)
- **created_at**: TIMESTAMP (DEFAULT CURRENT_TIMESTAMP)

### Payment
- **payment_id**: UUID (Primary Key, Indexed)
- **booking_id**: UUID (Foreign Key referencing Booking(booking_id))
- **amount**: DECIMAL (NOT NULL)
- **payment_date**: TIMESTAMP (DEFAULT CURRENT_TIMESTAMP)
- **payment_method**: ENUM (credit_card, paypal, stripe, NOT NULL)

### Review
- **review_id**: UUID (Primary Key, Indexed)
- **property_id**: UUID (Foreign Key referencing Property(property_id))
- **user_id**: UUID (Foreign Key referencing User(user_id))
- **rating**: INTEGER (NOT NULL, CHECK: rating >= 1 AND rating <= 5)
- **comment**: TEXT (NOT NULL)
- **created_at**: TIMESTAMP (DEFAULT CURRENT_TIMESTAMP)

### Message
- **message_id**: UUID (Primary Key, Indexed)
- **sender_id**: UUID (Foreign Key referencing User(user_id))
- **recipient_id**: UUID (Foreign Key referencing User(user_id))
- **message_body**: TEXT (NOT NULL)
- **sent_at**: TIMESTAMP (DEFAULT CURRENT_TIMESTAMP)

## Normalization Principles
To achieve 3NF, the schema must satisfy:

1. **First Normal Form (1NF)**: Attributes are atomic, and each table has a primary key.
2. **Second Normal Form (2NF)**: Must be in 1NF, and non-key attributes must depend on the entire primary key (no partial dependencies).
3. **Third Normal Form (3NF)**: Must be in 2NF, and no non-key attribute depends on another non-key attribute (no transitive dependencies).

## Normalization Analysis

### 1NF Check
- **Atomic Attributes**: All attributes (e.g., VARCHAR, UUID, DECIMAL, ENUM, TEXT, TIMESTAMP, DATE, INTEGER) are atomic with no repeating groups or arrays.
- **Primary Keys**: Each table has a single-column UUID primary key (e.g., user_id, property_id), which is indexed.
- **Conclusion**: The schema satisfies 1NF.

### 2NF Check
- **Composite Keys**: All tables use single-column primary keys (UUIDs), so there are no composite keys.
- **Partial Dependencies**: With no composite keys, partial dependencies are not possible.
- **Conclusion**: The schema satisfies 2NF.

### 3NF Check
- **Transitive Dependencies**: A non-key attribute depending on another non-key attribute instead of the primary key violates 3NF.
- **Table Analysis**:
  - **User**: All attributes (first_name, last_name, email, etc.) depend on user_id. The UNIQUE constraint on email prevents redundancy. **No transitive dependencies**.
  - **Property**: All attributes (host_id, name, description, etc.) depend on property_id. The foreign key host_id references User(user_id), which is not a transitive dependency. **No transitive dependencies**.
  - **Booking**: Attributes depend on booking_id, but **total_price** is likely derived from Property.pricepernight and the duration (end_date - start_date). This creates a transitive dependency: total_price → start_date, end_date, pricepernight (from Property). Storing total_price risks inconsistency if pricepernight changes.
  - **Payment**: Attributes depend on payment_id, but **amount** may depend on Booking.total_price, potentially creating a transitive dependency (amount → total_price → start_date, end_date, pricepernight). If amount equals total_price, it’s redundant.
  - **Review**: All attributes depend on review_id. The CHECK constraint on rating ensures integrity. **No transitive dependencies**.
  - **Message**: All attributes depend on message_id. The foreign keys sender_id and recipient_id reference User(user_id), but no non-key attribute depends on another non-key attribute. **No transitive dependencies**.

### Identified Issues
1. **Booking.total_price**: This derived attribute depends on Property.pricepernight and the duration (end_date - start_date), creating a transitive dependency and risking inconsistency if pricepernight changes after a booking is made.
2. **Payment.amount**: If amount is always equal to Booking.total_price (or a function of it), it introduces redundancy and a potential transitive dependency. If amount supports partial payments or fees, it may be independent.

## Adjustments to Achieve 3NF
To eliminate transitive dependencies:

1. **Booking.total_price**:
   - **Action**: Remove total_price from the Booking table to avoid the transitive dependency.
   - **Solution**: Calculate total_price dynamically using Property.pricepernight and the duration (end_date - start_date). To preserve historical pricing (e.g., if pricepernight changes), add a new attribute, **booked_pricepernight** (DECIMAL, NOT NULL), to store the pricepernight at the time of booking. This depends directly on booking_id, satisfying 3NF.
   - **Rationale**: Storing booked_pricepernight avoids redundancy and ensures consistency, as total_price can be computed as booked_pricepernight × (end_date - start_date).

2. **Payment.amount**:
   - **Action**: Retain amount, assuming it supports partial payments or additional fees (e.g., taxes, service charges), making it independent of Booking.total_price.
   - **Solution**: Document that amount depends on payment_id and may differ from the computed total_price. If amount always equals total_price, it could be removed and derived from Booking data, but this is not assumed here.
   - **Rationale**: Keeping amount allows flexibility for partial payments or fees, avoiding redundancy if treated as an independent attribute.

## Normalized Schema
The adjusted schema removes Booking.total_price and adds booked_pricepernight to Booking. The PostgreSQL schema is provided below for reference, though the focus here is the Markdown explanation.

```sql
-- Creating User table
CREATE TABLE "User" (
    user_id UUID PRIMARY KEY,
    first_name VARCHAR NOT NULL,
    last_name VARCHAR NOT NULL,
    email VARCHAR NOT NULL UNIQUE,
    password_hash VARCHAR NOT NULL,
    phone_number VARCHAR,
    role ENUM('guest', 'host', 'admin') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Creating Property table
CREATE TABLE Property (
    property_id UUID PRIMARY KEY,
    host_id UUID REFERENCES "User"(user_id),
    name VARCHAR NOT NULL,
    description TEXT NOT NULL,
    location VARCHAR NOT NULL,
    pricepernight DECIMAL NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Creating Booking table (total_price removed, booked_pricepernight added)
CREATE TABLE Booking (
    booking_id UUID PRIMARY KEY,
    property_id UUID REFERENCES Property(property_id),
    user_id UUID REFERENCES "User"(user_id),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    booked_pricepernight DECIMAL NOT NULL,
    status ENUM('pending', 'confirmed', 'canceled') NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Creating Payment table
CREATE TABLE Payment (
    payment_id UUID PRIMARY KEY,
    booking_id UUID REFERENCES Booking(booking_id),
    amount DECIMAL NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    payment_method ENUM('credit_card', 'paypal', 'stripe') NOT NULL
);

-- Creating Review table
CREATE TABLE Review (
    review_id UUID PRIMARY KEY,
    property_id UUID REFERENCES Property(property_id),
    user_id UUID REFERENCES "User"(user_id),
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Creating Message table
CREATE TABLE Message (
    message_id UUID PRIMARY KEY,
    sender_id UUID REFERENCES "User"(user_id),
    recipient_id UUID REFERENCES "User"(user_id),
    message_body TEXT NOT NULL,
    sent_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Creating indexes
CREATE INDEX idx_user_email ON "User"(email);
CREATE INDEX idx_property_property_id ON Property(property_id);
CREATE INDEX idx_booking_property_id ON Booking(property_id);
CREATE INDEX idx_booking_booking_id ON Booking(booking_id);
CREATE INDEX idx_payment_booking_id ON Payment(booking_id);
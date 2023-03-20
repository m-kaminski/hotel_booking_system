
--- PostgreSQL

--- https://editor.datatables.net/generator/
CREATE EXTENSION IF NOT EXISTS pgcrypto;

CREATE TABLE IF NOT EXISTS "hotel" (
    "id"                SERIAL,
    "name"              TEXT,
    "address"           TEXT,
    "image"             VARCHAR(1024), -- for header of hotel website
    PRIMARY KEY( id )
);

CREATE TABLE IF NOT EXISTS "hotel_image" (
    "id"                SERIAL,
    "url"               VARCHAR(1024),
    "order"             INTEGER, -- how images are ordered
    "hotel_fk"          INTEGER REFERENCES "hotel",
    PRIMARY KEY( id )
);

-- add hotel_settings table with following:
CREATE TABLE IF NOT EXISTS "hotel_settings" (
    "id"                SERIAL,
    "checkin_time"      TIME WITH TIME ZONE, -- i.e. 11am
    "checkout_time"     TIME WITH TIME ZONE, -- i.e. 3pm
    "base_rate"         NUMERIC(10,5),
    "sales_tax"         NUMERIC(9,5),
    "resort_fee"        NUMERIC(9,2),
    "star_rating"       INT,
    "timezone_name"     VARCHAR(32), -- per pg_timezone_names
    "hotel_fk"          INTEGER REFERENCES "hotel",
    PRIMARY KEY( id )
);

-- if a hotel consists of more than one buildings, it's a many-1 relationship -- 
CREATE TABLE IF NOT EXISTS "building" (
    "id"                SERIAL,
    "identifier"        text, -- descriptive text --
    "name"              text,
    "address"           text,
    "hotel_fk"          INTEGER REFERENCES "hotel",
    PRIMARY KEY( id )
);

CREATE TABLE IF NOT EXISTS "building_image" (
    "id"                SERIAL,
    "url"               VARCHAR(1024),
    "building_fk"       INTEGER REFERENCES "building",
    "order"             INTEGER,
    PRIMARY KEY( id )
);

-- a room type --
CREATE TABLE IF NOT EXISTS "room_type" (
    "id"                SERIAL,
    "sqft"              INTEGER,
    "name"              TEXT,
    "description"       TEXT, -- descriptive text (highlight facing, amenities etc)
    "smoking"           BOOLEAN,
    "beds"              SMALLINT,
    "disability"        BOOLEAN,
    "base_rate"         NUMERIC(10,5),
    "hotel_fk"          INTEGER REFERENCES "hotel",
    PRIMARY KEY( id )
);

CREATE TABLE IF NOT EXISTS "room_image" (
    "id"                SERIAL,
    "url"               VARCHAR(1024),
    "room_type_fk"      INTEGER REFERENCES "room_type",
    "order"             INTEGER,
    PRIMARY KEY( id )
);

CREATE TABLE IF NOT EXISTS "room" (
    "id"                SERIAL,
    "room_number"       VARCHAR(10),
    "floor"             INTEGER,
    "building_fk"       INTEGER REFERENCES "building", -- building room is in
    "room_type_fk"      INTEGER REFERENCES "room_type",
    PRIMARY KEY( id )
);

-- guest but maybe also member of hotel team
CREATE TABLE IF NOT EXISTS "person" (
    "id"                SERIAL,
    "legal_first_name"  VARCHAR(64),
    "legal_middle_name" VARCHAR(64),
    "legal_last_name"   VARCHAR(64),
    "preferred_name"    VARCHAR(64),
    "email"             VARCHAR(64) NOT NULL UNIQUE,
    "phone_num"         BIGINT,
    "phone_country_code" SMALLINT,
    "password"          VARCHAR(70),
    PRIMARY KEY( id )
);

-- some enums to describe state of booking
CREATE TYPE booking_type AS ENUM (
    'normal', -- commercial booking, for a fee
    'free',   -- free booking
    'reward', -- booking for a reward points
    'special' -- no guest, but room is out of order for some reason
);

CREATE TYPE booking_status AS ENUM (
    'pending', -- not checked in yet, not confirmed
    'confirmed', -- booking confirmed, paid for
    'checked_in',   -- checked in
    'checked_out', -- 
    'booted' -- guest booted from a hotel due to some bad behavior or lack of payment
    'canceled' -- booking is canceled
    --- other states to add
);

-- before checkin booking typically refers to a generic room type rather than specific room number
CREATE TABLE IF NOT EXISTS "booking" (
    "id"                SERIAL,
    "checkin"           TIMESTAMP WITH TIME ZONE,
    "checkout"          TIMESTAMP WITH TIME ZONE,
    "adults"            SMALLINT,
    "children"          SMALLINT,
    "type"              booking_type,
    "hotel_fk"          INTEGER REFERENCES "hotel",
    "room_fk"           INTEGER REFERENCES "room", -- bookings refer to room type, unless checked in
    "room_type_fk"      INTEGER REFERENCES "room_type",
    "person_fk"         INTEGER REFERENCES "person", -- either a guest or whoever in hotel crew
    PRIMARY KEY( id )
);


CREATE TABLE IF NOT EXISTS "booking_notes" (
    "id"                SERIAL,
    "time"              TIMESTAMP WITH TIME ZONE,
    "note"              TEXT,
    "status"            booking_status, -- status change for a booking
    "person_fk"         INTEGER REFERENCES "person",
    "booking_fk"        INTEGER REFERENCES "booking" NOT NULL,
    PRIMARY KEY( id )   
);

-- fees may be assessed against specific person and booking (in most cases, but may be against person without specific booking)
CREATE TABLE IF NOT EXISTS "booking_fees" ( -- fees asessed
    "id"                SERIAL,
    "time"              TIMESTAMP WITH TIME ZONE,
    "item"              TEXT, 
    "amount"            NUMERIC(9,2),
    "currency"          VARCHAR(10),
    "paid"              BOOLEAN,
    "booking_fk"        INTEGER REFERENCES "booking",
    "person_fk"         INTEGER REFERENCES "person",
    PRIMARY KEY( id )
);
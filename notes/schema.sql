
--- PostgreSQL

--- https://editor.datatables.net/generator/

CREATE TABLE IF NOT EXISTS "hotel" (
	"id"                SERIAL,
	"name"              text,
    "image"             text,
	"address"           text,
	PRIMARY KEY( id )
);

-- if a hotel consists of more than one buildings, it's a many-1 relationship -- 
CREATE TABLE IF NOT EXISTS "building" (
	"id"                SERIAL,
	"identifier"        text, -- descriptive text --
	"image"             text,
	"name"              text,
	"address"           text,
	"hotel_fk"          INTEGER REFERENCES "hotel",
	PRIMARY KEY( id )
);

-- a room type --
CREATE TABLE IF NOT EXISTS "room_type" (
	"id"                SERIAL,
	"sqft"              bigint,
    "name"              text,
	"description"       text, -- descriptive text (highlight facing, amenities etc)
    "smoking"           boolean,
    "beds"              smallint,
    "disability"        boolean,
	"hotel_fk"          INTEGER REFERENCES "hotel",
	PRIMARY KEY( id )
);

CREATE TABLE IF NOT EXISTS "room" (
	"id"                SERIAL,
	"room_number"       varchar(10),
	"floor"             bigint,
	"building_fk"       INTEGER REFERENCES "building", -- building room is in
	"room_type_fk"      INTEGER REFERENCES "room_type",
	PRIMARY KEY( id )
);

CREATE TABLE IF NOT EXISTS "guest" (
    "id"                SERIAL,
    "legal_first_name"  varchar(64),
    "legal_middle_name" varchar(64),
    "legal_last_name"   varchar(64),
    "preferred_name"    varchar(64),
    "email"             varchar(64),
	PRIMARY KEY( id )
);

CREATE TABLE IF NOT EXISTS "booking" (
	"id"                serial,
	"checkin"           timestamp,
	"checkout"          timestamp,
	"hotel_fk"          INTEGER REFERENCES "hotel",
	"room_fk"           INTEGER REFERENCES "room", -- bookings refer to room type, unless checked in
	"room_type_fk"      INTEGER REFERENCES "room_type",
	"guest_fk"          INTEGER REFERENCES "guest",
	PRIMARY KEY( id )
);


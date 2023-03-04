


--- Define hotel

INSERT INTO hotel (name, image, address) 
        VALUES ('The Overlook Hotel', 'OverlookHotel.jpg', 
        '333 E Wonderview Ave, Estes Park, CO 80517');
INSERT INTO building (identifier, name, address, hotel_fk)
         VALUES ('The main building of the hotel', 'Main',  
         '333 E Wonderview Ave, Estes Park, CO 80517',
         (SELECT id FROM hotel ORDER BY id DESC LIMIT 1));

-- Add hotel rooms by types

INSERT INTO room_type (sqft, name, description, smoking, beds, disability, hotel_fk) 
        VALUES (300, 'Single queen bed', 
        'Nice north facing room that will accommodate any traveller. Affordable accomodation with premier service of The Overlook Hotel.', 
        false, 1, false,
        (SELECT id FROM hotel ORDER BY id DESC LIMIT 1));
INSERT INTO room (room_number, floor) VALUES 
    ('100', 1),
    ('101', 1),
    ('200', 2);
UPDATE room SET room_type_fk=(SELECT id FROM room_type ORDER BY id DESC LIMIT 1) WHERE room_type_fk IS NULL;

INSERT INTO room_type (sqft, name, description, smoking, beds, disability, hotel_fk) 
        VALUES (300, 'Single queen bed - for smokers', 
        'Nice north facing room that will accommodate any traveller.', 
        true, 1, false,
        (SELECT id FROM hotel ORDER BY id DESC LIMIT 1));
INSERT INTO room (room_number, floor) VALUES 
    ('201', 2);
UPDATE room SET room_type_fk=(SELECT id FROM room_type ORDER BY id DESC LIMIT 1) WHERE room_type_fk IS NULL;

INSERT INTO room_type (sqft, name, description, smoking, beds, disability, hotel_fk) 
        VALUES (460, 'Single king bed', 
        'South facing room with bath tub and a large king bed, will provide the most luxurious acommodation available at The Overlook Hotel.', 
        false, 1, false,
        (SELECT id FROM hotel ORDER BY id DESC LIMIT 1));
INSERT INTO room (room_number, floor) VALUES 
    ('102', 1),
    ('103', 1),
    ('104', 1),
    ('105', 1);
UPDATE room SET room_type_fk=(SELECT id FROM room_type ORDER BY id DESC LIMIT 1) WHERE room_type_fk IS NULL;

INSERT INTO room_type (sqft, name, description, smoking, beds, disability, hotel_fk) 
        VALUES (520, 'Two queen beds', 
        'South facing room with bath tub, shower and two queen beds, perfect for larger families or couples in complicated relationship.', 
        true, 2, false,
        (SELECT id FROM hotel ORDER BY id DESC LIMIT 1));
INSERT INTO room (room_number, floor) VALUES 
    ('202', 2),
    ('203', 2),
    ('204', 2),
    ('205', 2);
UPDATE room SET room_type_fk=(SELECT id FROM room_type ORDER BY id DESC LIMIT 1) WHERE room_type_fk IS NULL;
UPDATE room SET building_fk=(SELECT id FROM building ORDER BY id DESC LIMIT 1) WHERE building_fk IS NULL;


--- This is how we select number of each room type
--- SELECT room_type_fk, COUNT(*) FROM room GROUP BY room_type_fk;
--- 
--- if we want to display name of room type
-- SELECT T.*, R.count FROM 
--       (SELECT room_type_fk, COUNT(*) AS count FROM room GROUP BY room_type_fk) as R 
--       JOIN room_type T ON R.room_type_fk = T.id;

INSERT INTO booking (checkin, checkout, hotel_fk, room_type_fk) 
       VALUES
       ('Wed Mar 03 2023 16:00:00', 'Sat Mar 04 2023 11:00:00', 1, 9);   

INSERT INTO booking (checkin, checkout, hotel_fk, room_type_fk) 
       VALUES
       ('Wed Mar 01 2023 16:00:00', 'Sat Mar 04 2023 11:00:00', 1, 8),    
       ('Wed Mar 01 2023 16:00:00', 'Sat Mar 05 2023 11:00:00', 1, 8),
       ('Wed Mar 04 2023 16:00:00', 'Sat Mar 06 2023 11:00:00', 1, 8),   
       ('Wed Mar 04 2023 16:00:00', 'Sat Mar 11 2023 11:00:00', 1, 8);       

----
---    1  2  3  4  5  6  7  8  9  10 11
---    -A AA AA AC CC C-
---    -B BB BB BB B-
---             -D DD DD DD DD DD DD D=


--- To select all of the booking within given range:
-- SELECT * FROM booking WHERE (checkin, checkout) OVERLAPS (date '2023-03-05', date '2023-03-06');

--- To select count of bookings for any given period
-- SELECT id, checkin, (SELECT COUNT(1) FROM booking b WHERE ab.checkin BETWEEN b.checkin AND b.checkout) FROM booking ab;

--- select number of bookings per room type within date range

-- SELECT dd, booking.room_type_fk, COUNT(booking.id) FROM booking, generate_series(timestamp '2023-03-01 16:00:00', timestamp '2023-03-011 16:00:00', '1 day'::interval) 
-- AS dd WHERE dd BETWEEN booking.checkin AND booking.checkout GROUP BY dd, booking.room_type_fk;
-- SELECT bookings_in_time.room_type_fk, MAX(count) FROM
-- (
--   SELECT dd, booking.room_type_fk, COUNT(booking.id) 
--        FROM booking, generate_series(timestamp '2023-03-01 16:00:00', timestamp '2023-03-011 16:00:00', '1 day'::interval) 
--        AS dd WHERE dd 
--        BETWEEN booking.checkin AND booking.checkout GROUP BY dd, booking.room_type_fk) as bookings_in_time 
-- GROUP BY bookings_in_time.room_type_fk;




--- Define hotel
INSERT INTO hotel (id, name, image, address) 
        VALUES (1, 'The Overlook Hotel', 'OverlookHotel.jpg', 
        '333 E Wonderview Ave, Estes Park, CO 80517');
INSERT INTO building (id, identifier, name, address, hotel_fk)
         VALUES (1, 'The main building of the hotel', 'Main',  
         '333 E Wonderview Ave, Estes Park, CO 80517', 1);
INSERT INTO hotel_settings(id, checkin_time, checkout_time, base_rate, sales_tax, resort_fee, star_rating, timezone_name, hotel_fk)
        VALUES(1, '11:00', '16:00', 0.0025, 0.029, 9.70, 3, 'America/Denver', 1);


-- add hotel_settings table with following:
CREATE TABLE IF NOT EXISTS "hotel_settings" {
    "id"                SERIAL,
    "checkin_time"      TIME WITH TIME ZONE, -- i.e. 11am
    "checkout_time"     TIME WITH TIME ZONE, -- i.e. 3pm
    "base_rate"         NUMERIC(9,2),
    "sales_tax"         NUMERIC(9,5),
    "resort_fee"        NUMERIC(9,2),
    "star_rating"       INT
    "timezone_name"     VARCHAR(32), -- per pg_timezone_names
    "hotel_fk"          INTEGER REFERENCES "hotel",
    PRIMARY KEY( id )
};         
-- Add hotel rooms by types

-- Nonsmoking room with single queen bed
INSERT INTO room_type (id, sqft, name, description, smoking, beds, disability, hotel_fk) 
        VALUES (1, 300, 'Single queen bed', 
        'Nice north facing room that will accommodate any traveller. Affordable accomodation with premier service of The Overlook Hotel.', 
        false, 1, true,
        (SELECT id FROM hotel ORDER BY id DESC LIMIT 1));
INSERT INTO room (room_number, floor, room_type_fk, building_fk) VALUES 
        ('100', 1, 1, 1),
        ('101', 1, 1, 1),
        ('200', 2, 1, 1);
        
-- smoking room with single queen bed
INSERT INTO room_type (id, sqft, name, description, smoking, beds, disability, hotel_fk) 
        VALUES (2, 300, 'Single queen bed - for smokers', 
        'Nice north facing room that will accommodate any traveller.', 
        true, 1, false,
        (SELECT id FROM hotel ORDER BY id DESC LIMIT 1));
INSERT INTO room (room_number, floor, room_type_fk, building_fk) VALUES 
        ('201', 2, 2, 1);

-- nonsmoking room with a single king bed
INSERT INTO room_type (id, sqft, name, description, smoking, beds, disability, hotel_fk) 
        VALUES (3, 460, 'Single king bed', 
        'South facing room with bath tub and a large king bed, will provide the most luxurious acommodation available at The Overlook Hotel.', 
        false, 1, false,
        (SELECT id FROM hotel ORDER BY id DESC LIMIT 1));
INSERT INTO room (room_number, floor, room_type_fk, building_fk) VALUES 
        ('102', 1, 3, 1),
        ('103', 1, 3, 1),
        ('104', 1, 3, 1),
        ('105', 1, 3, 1);

-- nonsmoking room wth double queen beds
INSERT INTO room_type (id, sqft, name, description, smoking, beds, disability, hotel_fk) 
        VALUES (4, 520, 'Two queen beds', 
        'South facing room with bath tub, shower and two queen beds, perfect for larger families or couples in complicated relationship.', 
        true, 2, false,
        (SELECT id FROM hotel ORDER BY id DESC LIMIT 1));
INSERT INTO room (room_number, floor, room_type_fk, building_fk) VALUES 
        ('202', 2, 4, 1),
        ('203', 2, 4, 1),
        ('204', 2, 4, 1),
        ('205', 2, 4, 1);

--- This is how we select number of each room type
--- SELECT room_type_fk, COUNT(*) FROM room GROUP BY room_type_fk;
--- 
--- if we want to display name of room type
-- SELECT T.*, R.count FROM 
--       (SELECT room_type_fk, COUNT(*) AS count FROM room GROUP BY room_type_fk) as R 
--       JOIN room_type T ON R.room_type_fk = T.id;


-- PERSONS

INSERT INTO person (id, legal_first_name, legal_middle_name, legal_last_name, preferred_name, email, password) 
          VALUES (1, 'John', 'Daniel', 'Torrance', 'Jack', 'jack.torrance@test.com', crypt('johnspassword', gen_salt('bf'))),
                 (2, 'Danny', null, 'Torrance', null, 'danny.torrance@test.com', crypt('dannypassword', gen_salt('bf'))),
                 (3, 'Wendy', null, 'Torrance', null, 'wendy.torrance@test.com', crypt('wendypassword', gen_salt('bf'))),
                 (4, 'Dick', null, 'Hallorann', null, 'dick.hallorann@test.com', crypt('dickpassword', gen_salt('bf'))),
                 (5, 'Delbert', null, 'Grady', null, 'delbertgrady@test.com', crypt('delbertpassword', gen_salt('bf')));


--- Following statements can facilitate authentication; first will return ID, second will not
-- SELECT id FROM person WHERE email = 'jack.torrance@test.com' AND password = crypt('johnspassword', password);
-- SELECT id FROM person WHERE email = 'jack.torrance@test.com' AND password = crypt('badpassword', password);

-- BOOKINGS
INSERT INTO booking (checkin, checkout, type, guest_fk, hotel_fk, room_type_fk) 
       VALUES
       ('Wed Mar 03 2023 16:00:00', 'Sat Mar 04 2023 11:00:00', 'normal', 1, 1, 2);   

INSERT INTO booking (checkin, checkout, type, guest_fk, hotel_fk, room_type_fk) 
       VALUES
       ('Wed Mar 01 2023 16:00:00', 'Sat Mar 04 2023 11:00:00', 'normal', 1, 1, 1),    
       ('Wed Mar 01 2023 16:00:00', 'Sat Mar 05 2023 11:00:00', 'normal', 1, 1, 1),
       ('Wed Mar 04 2023 16:00:00', 'Sat Mar 06 2023 11:00:00', 'normal', 1, 1, 1),   
       ('Wed Mar 04 2023 16:00:00', 'Sat Mar 11 2023 11:00:00', 'normal', 1, 1, 1);       

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

--
-- SELECT bookings_in_time.room_type_fk, MAX(count) FROM
-- (
--   SELECT dd, booking.room_type_fk, COUNT(booking.id) 
--        FROM booking, generate_series(timestamp '2023-03-01 16:00:00', timestamp '2023-03-011 16:00:00', '1 day'::interval) 
--        AS dd WHERE dd 
--        BETWEEN booking.checkin AND booking.checkout GROUP BY dd, booking.room_type_fk) as bookings_in_time 
-- GROUP BY bookings_in_time.room_type_fk;


-- Select available rooms


/* Select list of available rooms given range of dates
SELECT types.*,
       rooms.count,
       booked_rooms.max
FROM
  (SELECT room_type_fk,
          COUNT(*) AS COUNT
   FROM room
   GROUP BY room_type_fk) AS rooms
JOIN room_type types ON rooms.room_type_fk = types.id
LEFT JOIN
  (SELECT bookings_in_time.room_type_fk,
          MAX(COUNT)
   FROM
     (SELECT dd,
             booking.room_type_fk,
             COUNT(booking.id)
      FROM booking,
           generate_series(timestamp '2023-03-01 16:00:00', timestamp '2023-03-03 16:00:00', '1 day'::interval) AS dd
      WHERE dd BETWEEN booking.checkin AND booking.checkout
      GROUP BY dd,
               booking.room_type_fk) AS bookings_in_time
   GROUP BY bookings_in_time.room_type_fk) AS booked_rooms ON booked_rooms.room_type_fk = types.id
WHERE booked_rooms.max < rooms.count
  OR booked_rooms.max IS NULL;
*/



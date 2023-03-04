


--- Define hotel

INSERT INTO hotel (name, image, address) 
        VALUES ('The Overlook Hotel', 'OverlookHotel.jpg', 
        '333 E Wonderview Ave, Estes Park, CO 80517');
INSERT INTO building (identifier, image, name, address, hotel_fk)
         VALUES ('the main building of the hotel', 'OverlookHotel.jpg', 'main',  
         '333 E Wonderview Ave, Estes Park, CO 80517',
         (SELECT id FROM hotel ORDER BY id DESC LIMIT 1));

-- Add hotel rooms by types

INSERT INTO room_type (sqft, name, description, smoking, beds, disability, hotel_fk) 
        VALUES (300, 'Single queen bed', 
        'Nice north facing room that will accommodate any traveller', 
        false, 1, false,
        (SELECT id FROM hotel ORDER BY id DESC LIMIT 1));
INSERT INTO room (room_number, floor) VALUES 
    ('100', 1),
    ('101', 1),
    ('200', 2);
UPDATE room SET room_type_fk=(SELECT id FROM room_type ORDER BY id DESC LIMIT 1) WHERE room_type_fk IS NULL;

INSERT INTO room_type (sqft, name, description, smoking, beds, disability, hotel_fk) 
        VALUES (300, 'Single queen bed - for smokers', 
        'Nice north facing room that will accommodate any traveller', 
        true, 1, false,
        (SELECT id FROM hotel ORDER BY id DESC LIMIT 1));
INSERT INTO room (room_number, floor) VALUES 
    ('201', 2);
UPDATE room SET room_type_fk=(SELECT id FROM room_type ORDER BY id DESC LIMIT 1) WHERE room_type_fk IS NULL;

INSERT INTO room_type (sqft, name, description, smoking, beds, disability, hotel_fk) 
        VALUES (460, 'Single king bed', 
        'South facing room with bath tub and a large king bed', 
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
        'South facing room with bath tub and a large king bed', 
        true, 2, false,
        (SELECT id FROM hotel ORDER BY id DESC LIMIT 1));
INSERT INTO room (room_number, floor) VALUES 
    ('202', 2),
    ('203', 2),
    ('204', 2),
    ('205', 2);
UPDATE room SET room_type_fk=(SELECT id FROM room_type ORDER BY id DESC LIMIT 1) WHERE room_type_fk IS NULL;

UPDATE room SET building_fk=(SELECT id FROM building ORDER BY id DESC LIMIT 1) WHERE building_fk IS NULL;

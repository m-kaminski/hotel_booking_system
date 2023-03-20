package com.hbrs.booking.service;

import java.time.Instant;
import java.time.format.DateTimeFormatter;
import java.time.temporal.TemporalAccessor;
import java.util.Date;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.hbrs.booking.service.persistence.Rooms;


@RestController	
public class BookRooms {
    
	private Rooms rooms;
	BookRooms() {
		rooms = new Rooms();
	}


	public static java.sql.Timestamp getDay(String input)
	{

		TemporalAccessor ta = DateTimeFormatter.ISO_INSTANT.parse(input);
		Instant i = Instant.from(ta);
		Date d = Date.from(i);
		java.sql.Timestamp sqlDate = new java.sql.Timestamp(d.getTime());
		return sqlDate;
	}

	@GetMapping("/bookrooms")
	public String bookrooms(@RequestParam(value = "checkin") String requestCheckin, 
    @RequestParam(value = "checkout") String requestCheckout, 
    @RequestParam(value = "room_type") int roomType) {

		String checkin;
		String checkout;
		checkin = requestCheckin;
		checkout = requestCheckout;
		
		rooms.bookRoom(getDay(checkin), getDay(checkout), 1, roomType);

        return "Booked";
	}
}

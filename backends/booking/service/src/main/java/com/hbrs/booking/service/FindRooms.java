package com.hbrs.booking.service;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.Instant;
import java.time.format.DateTimeFormatter;
import java.time.temporal.TemporalAccessor;
import java.util.Date;
import java.util.List;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import com.hbrs.booking.service.persistence.Rooms;

@RestController	
public class FindRooms {

	private Rooms rooms;
	FindRooms() {
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

	@GetMapping("/findrooms")
	public List<RoomType> findrooms(@RequestParam(value = "checkin") String requestCheckin, @RequestParam(value = "checkout") String requestCheckout) {

		String checkin;
		String checkout;
		checkin = requestCheckin;
		checkout = requestCheckout;
		System.out.println("Finding rooms from " + requestCheckin + " to " + requestCheckout);

		return rooms.getRoomsAva(getDay(checkin), getDay(checkout));
	}
}


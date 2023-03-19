package com.hbrs.booking.service;

import java.time.Instant;
import java.time.format.DateTimeFormatter;
import java.time.temporal.TemporalAccessor;
import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.hbrs.booking.service.persistence.HotelSettings;
import com.hbrs.booking.service.persistence.Rooms;

@RestController	
public class FindRooms {

	private Rooms rooms;
	private HotelSettings hotelSettings;
	FindRooms() {
		rooms = new Rooms();
		hotelSettings = new HotelSettings();
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
		List<RoomType> roomList = rooms.getRoomsAva(getDay(checkin), getDay(checkout));
		HotelSettingsType settings = hotelSettings.getHotelSettings(1);
		return roomList.stream()
						.map(room -> {return new RoomType(
							room.id(),
							room.sqft(),
							room.name(),
							room.description(),
							room.smoking(),
							room.beds(),
							room.disability(),
							room.count(),
							room.max(),
							room.sqft() * settings.base_rate());})        
						.collect(Collectors.toList()); 
	}
}

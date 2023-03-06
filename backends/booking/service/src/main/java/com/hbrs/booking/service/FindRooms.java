package com.hbrs.booking.service;

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

	@GetMapping("/findrooms")
	public List<RoomType> findrooms(@RequestParam(value = "name", defaultValue = "World") String name) {
		return rooms.getRooms();
	}
}


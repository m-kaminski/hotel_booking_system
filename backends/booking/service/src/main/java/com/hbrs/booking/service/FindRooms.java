package com.hbrs.booking.service;

import java.util.concurrent.atomic.AtomicLong;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import java.util.List;
import java.util.ArrayList;
@RestController
public class FindRooms {

	private static final String template = "Hello, %s!";
	private final AtomicLong counter = new AtomicLong();

	@GetMapping("/findrooms")
	public List<RoomType> findrooms(@RequestParam(value = "name", defaultValue = "World") String name) {

		List<RoomType> response = new ArrayList<>();
		response.add(new RoomType(1, 400, "Room 1", "foo", true, 1, true));
		response.add(new RoomType(1, 500, "Room 2", "foo", false, 2, true));
		return response;
	}
}
//public record RoomType(long id, long sqft, String name, String description, boolean smoking, int beds, boolean disability) { }


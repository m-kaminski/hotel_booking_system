package com.hbrs.booking.service.persistence;
import java.sql.*;
import java.util.List;
import java.util.ArrayList;
import com.hbrs.booking.service.RoomType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
//import org.springframework.jdbc.core.JdbcTemplate;
 

public class Rooms {

    public List<RoomType> getRooms() {

		List<RoomType> response = new ArrayList<>();
		response.add(new RoomType(1, 400, "Room 1", "foo", true, 1, true));
		response.add(new RoomType(1, 500, "Room 2", "foo", false, 2, true));
        return response;        
    }
}
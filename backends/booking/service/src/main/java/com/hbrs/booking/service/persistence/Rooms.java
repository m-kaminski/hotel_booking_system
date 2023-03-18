package com.hbrs.booking.service.persistence;

import java.sql.*;
import java.util.List;
import java.util.ArrayList;
import com.hbrs.booking.service.RoomType;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import com.hbrs.booking.service.persistence.DataSource;

public class Rooms {
    //private Connection conn;

    public Rooms() {

    }

    public List<RoomType> getRooms() {
        String SQL_SELECT = "SELECT T.*, R.count FROM"
                + "(SELECT room_type_fk, COUNT(*) AS count FROM room GROUP BY room_type_fk) as R "
                + "JOIN room_type T ON R.room_type_fk = T.id";
        List<RoomType> response = new ArrayList<>();


        try (PreparedStatement preparedStatement = DataSource.getConnection().prepareStatement(SQL_SELECT)) {

            ResultSet resultSet = preparedStatement.executeQuery();

            while (resultSet.next()) {

                long id = resultSet.getLong("id");
                int sqft = resultSet.getInt("sqft");
                String name = resultSet.getString("name");
                String description = resultSet.getString("description");
                boolean smoking = resultSet.getBoolean("smoking");
                int beds = resultSet.getInt("beds");
                boolean disability = resultSet.getBoolean("disability");
                response.add(new RoomType(id, sqft, name, description, smoking, beds, disability));

            }

        } catch (SQLException e) {
            System.err.format("SQL State: %s\n%s", e.getSQLState(), e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
        }
        return response;
    }
}
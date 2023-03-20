package com.hbrs.booking.service.persistence;

import java.sql.*;
import java.util.List;
import java.util.ArrayList;
import com.hbrs.booking.service.RoomType;
import java.sql.SQLException;

public class Rooms {

    public Rooms() {

    }

    public List<RoomType> getRooms() {
        String SQL_SELECT = "SELECT T.*, R.count FROM"
                + "(SELECT room_type_fk, COUNT(*) AS count FROM room GROUP BY room_type_fk) as R "
                + "JOIN room_type T ON R.room_type_fk = T.id";
        List<RoomType> response = new ArrayList<>();


        Connection conn = null;
        try {
            conn = DataSource.getConnection();
            PreparedStatement preparedStatement = conn.prepareStatement(SQL_SELECT);
            ResultSet resultSet = preparedStatement.executeQuery();

            while (resultSet.next()) {

                long id = resultSet.getLong("id");
                int sqft = resultSet.getInt("sqft");
                String name = resultSet.getString("name");
                String description = resultSet.getString("description");
                boolean smoking = resultSet.getBoolean("smoking");
                int beds = resultSet.getInt("beds");
                boolean disability = resultSet.getBoolean("disability");
                response.add(new RoomType(id, sqft, name, description, smoking, beds, disability, 0, 0, 0));

            }

        } catch (SQLException e) {
            System.err.format("SQL State: %s\n%s", e.getSQLState(), e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
        }
        try {
            if (conn != null) {
                conn.close();
            }
        } catch (SQLException e) {
            System.err.format("Can't close connection: SQL State: %s\n%s", e.getSQLState(), e.getMessage());
        }
        
        return response;
    }

    public void bookRoom(Timestamp checkin, Timestamp checkout, int guest, int roomType) {
        String SQL_SELECT = "BEGIN WORK;\n"
                + "LOCK TABLE booking IN EXCLUSIVE MODE;\n"
        
                + "INSERT INTO booking (checkin, checkout, type, guest_fk, hotel_fk, room_type_fk) "
                + "SELECT '" + checkin.toString() + "', '" + checkout.toString() + "', 'normal', 1, 1, "+String.valueOf(roomType)+"\n"
                + "WHERE EXISTS(\n"
                    + "SELECT \n"
                    + "       rooms.room_type_fk,\n"
                    + "       rooms.count,\n"
                    + "       booked_rooms.max\n"
                    + "FROM\n"
                    + "(SELECT room_type_fk,\n"
                    + "          COUNT(*) AS COUNT\n"
                    + "   FROM room WHERE room_type_fk="+String.valueOf(roomType)+"\n"
                    + "   GROUP BY room_type_fk) AS rooms \n"
                    + "LEFT JOIN\n"
                    + "  (SELECT bookings_in_time.room_type_fk,\n"
                    + "          MAX(COUNT)\n"
                    + "   FROM\n"
                    + "     (SELECT dd,\n"
                    + "             booking.room_type_fk,\n"
                    + "             COUNT(booking.id)\n"
                    + "      FROM booking,\n"
                    + "           generate_series(timestamp '" + checkin.toString() + "', timestamp '" + checkout.toString() + "', '1 day'::interval) AS dd\n"
                    + "      WHERE dd BETWEEN booking.checkin AND booking.checkout \n"
                    + "      GROUP BY dd,\n"
                    + "               booking.room_type_fk) AS bookings_in_time\n"
                    + "   GROUP BY bookings_in_time.room_type_fk) AS booked_rooms ON booked_rooms.room_type_fk = rooms.room_type_fk\n"
                    + "   WHERE rooms.count > booked_rooms.max OR booked_rooms.max IS NULL);\n"
                + "COMMIT WORK;";               
        Connection conn = null;
        try {
            conn = DataSource.getConnection();
            PreparedStatement preparedStatement = conn.prepareStatement(SQL_SELECT);
            preparedStatement.executeUpdate();

        } catch (SQLException e) {
            System.err.format("SQL State: %s\n%s", e.getSQLState(), e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
        }
        try {
            if (conn != null) {
                conn.close();
            }
        } catch (SQLException e) {
            System.err.format("Can't close connection: SQL State: %s\n%s", e.getSQLState(), e.getMessage());
        }

    }

    public List<RoomType> getRoomsAva(Timestamp checkin, Timestamp checkout) {
        String SQL_SELECT = "SELECT types.*,\n" 
                + "       rooms.count,\n" 
                + "       booked_rooms.max\n" 
                + "FROM\n"
                + "  (SELECT room_type_fk,\n" 
                + "          COUNT(*) AS COUNT\n" 
                + "   FROM room\n"
                + "   GROUP BY room_type_fk) AS rooms\n" 
                + "JOIN room_type types ON rooms.room_type_fk = types.id\n"
                + "LEFT JOIN\n" 
                + "  (SELECT bookings_in_time.room_type_fk,\n"
                 + "          MAX(COUNT)\n" 
                 + "   FROM\n"
                + "     (SELECT dd,\n" 
                + "             booking.room_type_fk,\n" 
                + "             COUNT(booking.id)\n"
                + "      FROM booking,\n" 
                + "           generate_series(timestamp '" + checkin.toString() + "', \n"
                + "                           timestamp '" + checkout.toString() + "', '1 day'::interval) AS dd\n"
                + "      WHERE dd BETWEEN booking.checkin AND booking.checkout\n" 
                + "      GROUP BY dd,\n"
                + "               booking.room_type_fk) AS bookings_in_time\n"
                + "   GROUP BY bookings_in_time.room_type_fk) AS booked_rooms ON booked_rooms.room_type_fk = types.id\n"
                + "WHERE booked_rooms.max < rooms.count\n" 
                + "  OR booked_rooms.max IS NULL;\n";
        List<RoomType> response = new ArrayList<>();

        Connection conn = null;
        try {
            conn = DataSource.getConnection();
            PreparedStatement preparedStatement = conn.prepareStatement(SQL_SELECT);
            ResultSet resultSet = preparedStatement.executeQuery();

            while (resultSet.next()) {

                long id = resultSet.getLong("id");
                int sqft = resultSet.getInt("sqft");
                String name = resultSet.getString("name");
                String description = resultSet.getString("description");
                boolean smoking = resultSet.getBoolean("smoking");
                int beds = resultSet.getInt("beds");
                boolean disability = resultSet.getBoolean("disability");
                int count = resultSet.getInt("count");
                int max = resultSet.getInt("max");
                response.add(new RoomType(id, sqft, name, description, smoking, beds, disability, count, max, 0));

            }

        } catch (SQLException e) {
            System.err.format("SQL State: %s\n%s", e.getSQLState(), e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
        }

        try {
            if (conn != null) {
                conn.close();
            }
        } catch (SQLException e) {
            System.err.format("Can't close connection: SQL State: %s\n%s", e.getSQLState(), e.getMessage());
        }
        return response;
    }
}
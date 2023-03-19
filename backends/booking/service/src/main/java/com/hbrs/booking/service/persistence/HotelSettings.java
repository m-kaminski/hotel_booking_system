package com.hbrs.booking.service.persistence;

import java.sql.*;
import java.sql.SQLException;
import com.hbrs.booking.service.HotelSettingsType;

public class HotelSettings {
    public HotelSettingsType getHotelSettings(long id) {
        String SQL_SELECT = "SELECT * FROM hotel_settings WHERE hotel_fk = "+String.valueOf(id)+";";
        HotelSettingsType response = null;



        Connection conn = null;
        try {
            conn = DataSource.getConnection();
            PreparedStatement preparedStatement = conn.prepareStatement(SQL_SELECT);
            ResultSet resultSet = preparedStatement.executeQuery();

            while (resultSet.next()) {

                response = new HotelSettingsType(resultSet.getLong("id"),
                resultSet.getTime("checkin_time"),
                resultSet.getTime("checkout_time"),
                resultSet.getFloat("base_rate"),
                resultSet.getFloat("sales_tax"),
                resultSet.getFloat("resort_fee"),
                resultSet.getInt("star_rating"),
                resultSet.getString("timezone_name"));

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
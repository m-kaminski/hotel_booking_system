package com.hbrs.booking.service.persistence;

import java.sql.*;
import java.sql.SQLException;

public class Persons {

    public Long validatePassword(String email, String password) {
        String SQL_SELECT = "SELECT id FROM person WHERE email = '"+email+"'"
        + " AND password = crypt('"+password+"', password)";
        Long response = -1L;


        try (PreparedStatement preparedStatement = DataSource.getConnection().prepareStatement(SQL_SELECT)) {

            ResultSet resultSet = preparedStatement.executeQuery();

            while (resultSet.next()) {

                long id = resultSet.getLong("id");
                response = id;

            }

        } catch (SQLException e) {
            System.err.format("SQL State: %s\n%s", e.getSQLState(), e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
        }
        return response;
    }
}

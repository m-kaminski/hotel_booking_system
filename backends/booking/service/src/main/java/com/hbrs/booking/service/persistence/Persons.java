package com.hbrs.booking.service.persistence;

import java.sql.*;
import java.sql.SQLException;

import com.hbrs.booking.service.Person;

public class Persons {

    public Person validatePassword(String email, String password) {
        String SQL_SELECT = "SELECT * FROM person WHERE email = '"+email+"'"
        + " AND password = crypt('"+password+"', password)";
        Person response = null;


        try (PreparedStatement preparedStatement = DataSource.getConnection().prepareStatement(SQL_SELECT)) {

            ResultSet resultSet = preparedStatement.executeQuery();

            while (resultSet.next()) {

                response = new Person(resultSet.getLong("id"),
                resultSet.getString("legal_first_name"),
                resultSet.getString("legal_middle_name"),
                resultSet.getString("legal_last_name"),
                resultSet.getString("preferred_name"),
                resultSet.getString("email"),
                resultSet.getLong("phone_num"),
                resultSet.getShort("phone_country_code"));

            }

        } catch (SQLException e) {
            System.err.format("SQL State: %s\n%s", e.getSQLState(), e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
        }
        return response;
    }
    
    public Person getPersonById(long id) {
        String SQL_SELECT = "SELECT * FROM person WHERE id = "+String.valueOf(id)+";";
        Person response = null;


        try (PreparedStatement preparedStatement = DataSource.getConnection().prepareStatement(SQL_SELECT)) {

            ResultSet resultSet = preparedStatement.executeQuery();

            while (resultSet.next()) {

                response = new Person(resultSet.getLong("id"),
                resultSet.getString("legal_first_name"),
                resultSet.getString("legal_middle_name"),
                resultSet.getString("legal_last_name"),
                resultSet.getString("preferred_name"),
                resultSet.getString("email"),
                resultSet.getLong("phone_num"),
                resultSet.getShort("phone_country_code"));

            }

        } catch (SQLException e) {
            System.err.format("SQL State: %s\n%s", e.getSQLState(), e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
        }
        return response;
    }
}

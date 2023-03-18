package com.hbrs.booking.service.persistence;

import java.sql.Connection;
import java.sql.SQLException;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

public class DataSource {

    private static HikariConfig config = new HikariConfig( "src/main/resources/datasource.properties" );
    private static HikariDataSource ds;
///            conn = DriverManager.getConnection("jdbc:postgresql://127.0.0.1:5432/hbrs", "DB LOGIN", "DB PASSWORD");

    static {
        ds = new HikariDataSource( config );
    }

    private DataSource() {}

    public static Connection getConnection() throws SQLException {
        return ds.getConnection();
    }
}
package com.hbrs.booking.service.persistence;

import java.sql.Connection;
import java.sql.SQLException;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;

public class DataSource {

    private static HikariConfig config = new HikariConfig( "src/main/resources/datasource.properties" );
    private static HikariDataSource ds;

    static {
        ds = new HikariDataSource( config );
    }

    
    private DataSource() {    }

    public static Connection getConnection() throws SQLException {
        return ds.getConnection();
    }
}
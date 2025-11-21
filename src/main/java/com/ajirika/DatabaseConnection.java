package com.ajirika;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseConnection {
    // For remote use on sandbox
    // private static final String URL = "jdbc:postgresql://sandbox:5432/ajirika";
    // private static final String USER = "postgres";
    // private static final String PASSWORD = "Invent2k";

    // For remote use on live
    private static final String URL = "jdbc:postgresql://kifaru:5432/ajirika";
    private static final String USER = "postgres";
    private static final String PASSWORD = "Invent2k";

    // For local usage
    // private static final String URL = "jdbc:postgresql://localhost:5432/your_db_name";
    // private static final String USER = "your_username";
    // private static final String PASSWORD = "your_local_password";

    // Optional: Load driver once
    static {
        try {
            Class.forName("org.postgresql.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}

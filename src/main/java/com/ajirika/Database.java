package com.ajirika;

import java.sql.*;

public class Database {

  public static User getUserByEmail(String email) {

    String sql = "SELECT id, email, password, firstname FROM signup_details WHERE email = ?";

    try (Connection conn = DatabaseConnection.getConnection();
        PreparedStatement stmt = conn.prepareStatement(sql)) {

      stmt.setString(1, email);

      ResultSet rs = stmt.executeQuery();

      if (rs.next()) {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setEmail(rs.getString("email"));
        user.setPassword(rs.getString("password"));
        user.setFirstname(rs.getString("firstname"));
        return user;
      }

    } catch (Exception e) {
      e.printStackTrace();
    }

    return null; // user not found
  }
}

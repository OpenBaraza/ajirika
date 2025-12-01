package org.ajirika;

import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/addAttendee")
public class LaunchAttendeeServlet extends HttpServlet {
  private static final long serialVersionUID = 1L;

  protected void doPost(HttpServletRequest request, HttpServletResponse response)
      throws ServletException, IOException {

    String fullName = request.getParameter("full_name");
    String email = request.getParameter("email_address");
    String countryCode = request.getParameter("country_code");
    String phoneNumber = request.getParameter("phone_number");

    String sql = "INSERT INTO launch_attendees (full_name, email, country_code, phone_number) VALUES (?, ?, ?, ?)";
    String dbConfig = "java:/comp/env/jdbc/database";
    DatabaseConnection dbConn = new DatabaseConnection(dbConfig);
    Connection conn = dbConn.getConnection();

    try{
      PreparedStatement stmt = conn.prepareStatement(sql);
      stmt.setString(1, fullName);
      stmt.setString(2, email);
      stmt.setString(3, countryCode);
      stmt.setString(4, phoneNumber);

      stmt.executeUpdate();
      stmt.close();
    } catch (Exception e) {
      e.printStackTrace();
    }
    response.sendRedirect("index.jsp?success=true");
  }
}

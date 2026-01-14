package org.processCV;

import java.util.Map;
import java.util.LinkedHashMap;
import java.io.PrintWriter;
import java.io.BufferedReader;
import java.io.IOException;

import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.ServletConfig;
import jakarta.servlet.ServletContext;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.Part;

import org.json.JSONObject;
import org.json.JSONArray;

import org.baraza.DB.BDB;
import org.baraza.DB.BQuery;

@MultipartConfig
@WebServlet("/processCV")
public class uploadProcess extends HttpServlet {
    BDB db = null;
	String orgId = "0";
	String userID = "0";

    readCV rCV;
	analyzeCV aCV;
	breakdownCV bCV;
	analyzeHeaders aH;

	private String getLoggedInUserId(HttpServletRequest request) {
		try {
			// 1. Get username from Tomcat authentication
			String username = request.getUserPrincipal().getName();
			System.out.println("Logged in user from uploadProcess: " + username);

			// 2. Query database for entity_id
			String sql = "SELECT entity_id FROM entitys WHERE user_name = '" + username + "'";
			BQuery rs = new BQuery(db, sql);

			if (rs.moveNext()) {
				return rs.getString("entity_id");
			} else {
				System.out.println("No entity found for username: " + username);
				return "-1";
			}
		} catch (Exception e) {
			e.printStackTrace();
			return "-1";
		}
	}
	
	public void init(ServletConfig config) throws ServletException {
		super.init(config);
		
		db = new BDB("java:/comp/env/jdbc/database");
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
		doGet(request, response);
	}

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        ServletContext context = getServletContext();
		
		if(!db.isValid()) db.reconnect("java:/comp/env/jdbc/database");

		// Fetch real logged in user ID
		userID = getLoggedInUserId(request);
		System.out.println("Resolved userID in uploadProcess = " + userID);
		

		if(orgId == null) orgId = "0";
		if(userID == null) userID = "-1";
		
		JSONObject jResp =  new JSONObject();

        Part filePart = request.getPart("cvFile");

        System.out.println("File name: " + filePart.getSubmittedFileName());
        System.out.println("Content type: " + filePart.getContentType());
        System.out.println("File size: " + filePart.getSize());
		
    }
}

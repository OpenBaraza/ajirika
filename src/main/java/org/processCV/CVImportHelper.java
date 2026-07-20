package org.processCV;

import java.util.LinkedHashMap;
import java.util.Map;

import org.baraza.DB.BDB;
import org.baraza.DB.BQuery;
import org.json.JSONArray;
import org.json.JSONObject;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class CVImportHelper {

    public static boolean saveForLoggedInUser(BDB db, String orgId, String entityId, JSONObject cv) {
        if (db == null || entityId == null || entityId.equals("-1")) return false;
        try {
            JSONObject info = cv.optJSONObject("personal_info");
            String phone = (info != null) ? info.optString("phone", "") : "";

            Map<String, String> mPersonal = new LinkedHashMap<>();
            if (!phone.isEmpty()) mPersonal.put("applicant_phone", phone);
            mPersonal.put("cv_data", cv.toString());
            String updateCols = phone.isEmpty() ? "cv_data = ?" : "applicant_phone = ?, cv_data = ?";
            String updSql = "UPDATE applicants SET " + updateCols + " WHERE entity_id = ?";
            db.saveRecWithWhere(updSql, mPersonal, entityId);

            saveEducationAndEmployment(db, orgId, entityId, cv);
            return true;
        } catch (Exception ex) {
            ex.printStackTrace();
            return false;
        }
    }

    public static void saveForNewUser(BDB db, String email, JSONObject cv) {
        if (db == null || email == null || email.isEmpty()) return;
        try {
            JSONObject info = cv.optJSONObject("personal_info");
            String phone = (info != null) ? info.optString("phone", "") : "";

            Map<String, String> m = new LinkedHashMap<>();
            if (!phone.isEmpty()) m.put("applicant_phone", phone);
            m.put("cv_data", cv.toString());

            String updateCols = phone.isEmpty() ? "cv_data = ?" : "applicant_phone = ?, cv_data = ?";
            String sql = "UPDATE applicants SET " + updateCols + " WHERE applicant_email = ?";
            db.saveRecWithWhere(sql, m, email);

            String entityId = null;
            try (PreparedStatement idPs = db.getDB().prepareStatement(
                    "SELECT entity_id FROM applicants WHERE applicant_email = ?")) {
                idPs.setString(1, email);
                try (ResultSet idRs = idPs.executeQuery()) {
                    if (idRs.next()) entityId = idRs.getString("entity_id");
                }
            }
            if (entityId != null) {
                saveEducationAndEmployment(db, "0", entityId, cv);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }

    private static void saveEducationAndEmployment(BDB db, String orgId, String entityId, JSONObject cv) throws SQLException {
        try (PreparedStatement delEdu = db.getDB().prepareStatement("DELETE FROM education WHERE entity_id = ?")) {
            delEdu.setInt(1, Integer.parseInt(entityId));
            delEdu.executeUpdate();
        }
        JSONArray education = cv.optJSONArray("education");
        if (education != null) {
            for (int i = 0; i < education.length(); i++) {
                JSONObject e = education.getJSONObject(i);
                String school = e.optString("institution", "");
                if (school.isEmpty()) continue;
                Map<String, String> m = new LinkedHashMap<>();
                m.put("org_id", orgId);
                m.put("entity_id", entityId);
                m.put("education_class_id", e.optString("edu-level", "8"));
                m.put("name_of_school", school);
                m.put("date_from", e.optString("edu-from", ""));
                m.put("date_to", e.optString("edu-to", ""));
                m.put("examination_taken", e.optString("certification", ""));
                db.saveRec("INSERT INTO education (org_id, entity_id, education_class_id, name_of_school, date_from, date_to, examination_taken) VALUES (?,?,?,?,?,?,?)", m);
            }
        }

        try (PreparedStatement delEmp = db.getDB().prepareStatement("DELETE FROM employment WHERE entity_id = ?")) {
            delEmp.setInt(1, Integer.parseInt(entityId));
            delEmp.executeUpdate();
        }
    }
}
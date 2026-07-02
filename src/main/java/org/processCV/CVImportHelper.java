package org.processCV;

import java.util.LinkedHashMap;
import java.util.Map;

import org.baraza.DB.BDB;
import org.baraza.DB.BQuery;
import org.json.JSONArray;
import org.json.JSONObject;

public class CVImportHelper {

    public static boolean saveForLoggedInUser(BDB db, String orgId, String entityId, JSONObject cv) {
        if (db == null || entityId == null || entityId.equals("-1")) return false;
        try {
            JSONObject info = cv.optJSONObject("personal_info");
            String phone = (info != null) ? info.optString("phone", "") : "";

            // Update applicants: phone + raw cv_data
            Map<String, String> mPersonal = new LinkedHashMap<>();
            if (!phone.isEmpty()) mPersonal.put("applicant_phone", phone);
            mPersonal.put("cv_data", cv.toString());
            String updateCols = phone.isEmpty() ? "cv_data = ?" : "applicant_phone = ?, cv_data = ?";
            String updSql = "UPDATE applicants SET " + updateCols + " WHERE entity_id = '" + entityId + "'";
            db.saveRec(updSql, mPersonal);

            // Education: insert only if table is empty for this user
            BQuery eduCheck = new BQuery(db, "SELECT COUNT(*) as cnt FROM education WHERE entity_id = " + entityId);
            boolean eduEmpty = eduCheck.moveNext() && "0".equals(eduCheck.getString("cnt"));
            eduCheck.close();
            if (eduEmpty) {
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
            }

            // Employment: insert only if table is empty for this user
            BQuery empCheck = new BQuery(db, "SELECT COUNT(*) as cnt FROM employment WHERE entity_id = " + entityId);
            boolean empEmpty = empCheck.moveNext() && "0".equals(empCheck.getString("cnt"));
            empCheck.close();
            if (empEmpty) {
                JSONArray experience = cv.optJSONArray("experience");
                if (experience != null) {
                    for (int i = 0; i < experience.length(); i++) {
                        JSONObject e = experience.getJSONObject(i);
                        String role = e.optString("role", "");
                        String desc = e.optString("description", "");
                        if (role.isEmpty() && desc.isEmpty()) continue;
                        String position = role.isEmpty()
                            ? desc.substring(0, Math.min(100, desc.length())) : role;
                        Map<String, String> m = new LinkedHashMap<>();
                        m.put("org_id", orgId);
                        m.put("entity_id", entityId);
                        m.put("employers_name", "Unspecified");
                        m.put("position_held", position);
                        m.put("details", desc);
                        m.put("date_from", java.time.LocalDate.now().toString());
                        db.saveRec("INSERT INTO employment (org_id, entity_id, employers_name, position_held, details, date_from) VALUES (?,?,?,?,?,?)", m);
                    }
                }
            }

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
            String sql = "UPDATE applicants SET " + updateCols + " WHERE applicant_email = '" + email + "'";
            db.saveRec(sql, m);
        } catch (Exception ex) {
            ex.printStackTrace();
        }
    }
}
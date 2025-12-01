/**
 * @author      Dennis W. Gichangi <dennis@openbaraza.org>
 * @version     2011.0329
 * @since       1.6
 * website		www.openbaraza.org
 * The contents of this file are subject to the GNU Lesser General Public License
 * Version 3.0 ; you may use this file in compliance with the License.
 */
package org.baraza.DB;

import java.util.logging.Logger;
import java.util.List;
import java.util.ArrayList;
import java.util.Map;
import java.util.HashMap;
import java.util.Vector;
import java.math.BigDecimal;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;
import java.sql.DriverManager;
import java.sql.Clob;
import java.sql.Time;
import java.sql.Types;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.Statement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import org.json.JSONObject;
import org.json.JSONArray;

public class BDB {
	Logger log = Logger.getLogger(BDB.class.getName());
    static Logger log2 = Logger.getLogger(BDB.class.getName());
	Connection db = null;
	DatabaseMetaData dbmd = null;
	String dbTemplate = null;
	String dbschema = null;
	int dbType = 1;
	String orgID = null;
	List<String> fullAudit;
	Map<String, String> configs;

	private String lastErrorMsg = null;
	private String lDBclass;
	private String lDBpath;
	private String lDBuser;
	private String lDBpassword;
	private boolean readOnly = false;

	public BDB(String dbclass, String dbpath, String dbuser, String dbpassword) {
		fullAudit =  new ArrayList<String>();
		connectDB(dbclass, dbpath, dbuser, dbpassword);
	}

	// initialize the database and web output
	public BDB(String datasource) {
		connectDB(datasource);
	}

	public void connectDB(String datasource) {
		fullAudit =  new ArrayList<String>();
		try {
			InitialContext cxt = new InitialContext();
			DataSource ds = (DataSource) cxt.lookup(datasource);
			db = ds.getConnection();
			dbmd = db.getMetaData();
			String dbtype = dbmd.getDatabaseProductName();
			if(dbtype.toLowerCase().indexOf("oracle") >= 0) dbType = 2;
			if(dbtype.toLowerCase().indexOf("mysql") >= 0) dbType = 3;
		} catch (SQLException ex) {
			log.severe("Cannot connect to this database : datasource " + datasource + " : " + ex);
        } catch (NamingException ex) {
			log.severe("Cannot pick on the database : datasource " + datasource + " : " + ex);
        }
	}

	public void connectDB(String dbclass, String dbpath, String dbuser, String dbpassword) {
		if(dbclass.toLowerCase().indexOf("oracle")>=0) dbType = 2;
		if(dbclass.toLowerCase().indexOf("mysql")>=0) dbType = 3;

		lDBclass = dbclass;
		lDBpath = dbpath;
		lDBuser = dbuser;
		lDBpassword = dbpassword;

		try {
			Class.forName(dbclass);  
			db = DriverManager.getConnection(dbpath, dbuser, dbpassword);
			dbmd = db.getMetaData();

			if(dbschema != null) {
				Statement exst = db.createStatement();
				exst.execute("ALTER session set current_schema=" + dbschema);
				exst.close();
			}
		} catch (ClassNotFoundException ex) {
			log.severe("Cannot find the database driver classes. : path " + dbpath + " : " + ex);
		} catch (SQLException ex) {
			log.severe("Database connection SQL Error : path " + dbpath + " : " + ex);
		}
	}
	
	public void setSchema(String dbSchema) {
		this.dbschema = dbSchema;

		if(dbschema != null) {
			try {
				Statement exst = db.createStatement();
				if(dbType == 1) exst.execute("set search_path to '" + dbschema + "'");
				else exst.execute("ALTER session set current_schema=" + dbschema);
				exst.close();
			} catch (SQLException ex) {
				log.severe("Database connection SQL Error : " + ex);
			}
		}
	}

	public void reconnect(String datasource) {
		close();
		connectDB(datasource);
	}

	public void reconnect() {
		close();
		connectDB(lDBclass, lDBpath, lDBuser, lDBpassword);
	}

	public ResultSet readQuery(String mysql) {
		return readQuery(mysql, -1);
	}

	public ResultSet readQuery(String mysql, int limit) {
		ResultSet rs = null;

		try {
			Statement st = db.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
			if(limit > 0) st.setFetchSize(limit);
			rs = st.executeQuery(mysql);
		} catch (SQLException ex) {
			log.severe("Database readQuery error : " + ex);
		}

		return rs;
	}

	public String executeFunction(String mysql) {
		String ans = null;

		try {
			Statement st = db.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
			ResultSet rs = st.executeQuery(mysql);

			if(rs.next()) ans = rs.getString(1);
			rs.close();
			st.close();
		} catch (SQLException ex) {
			ans = null;
			lastErrorMsg = ex.getMessage();
			log.severe("Database executeFunction error : " + ex);
			log.severe("SQL : " + mysql);
		}

		return ans;
	}
	
	public String executeFunction(String mysql, boolean readOnly) {
		String ans = null;

		Statement st = null;
		ResultSet rs = null;
		try {
			st = db.createStatement(ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_READ_ONLY);
			rs = st.executeQuery(mysql);

			if(rs.next()) ans = rs.getString(1);
		} catch (SQLException ex) {
			ans = null;
			lastErrorMsg = ex.getMessage();
			log.severe("Database executeFunction error : " + ex);
		} finally {
			if (rs != null) {
				try { rs.close(); } catch (Exception ex) { }
				rs = null;
			}
			if (st != null) {
				try { st.close(); } catch (Exception ex) { }
				st = null;
			}
		}

		// Close the handles
		try {
			if(rs != null) rs.close();
			if(st != null) st.close();
		} catch (SQLException ex) {}

		return ans;
	}

	public String executeQuery(String mysql) {
		String rst = null;

		try {
			Statement st = db.createStatement();
			st.execute(mysql);
			st.close();
		} catch (SQLException ex) {
			rst = ex.toString();
			lastErrorMsg = ex.toString();
			log.severe("Database executeQuery error : " + ex);
		}

		return rst;
	}

	public String executeAutoKey(String mysql) {
		String rst = null;

		try {
			Statement st = db.createStatement();
			st.execute(mysql, Statement.RETURN_GENERATED_KEYS);

			ResultSet rsa = st.getGeneratedKeys();
			if(rsa.next()) rst = rsa.getString(1);

			rsa.close();
			st.close();
		} catch (SQLException ex) {
			rst = null;
			lastErrorMsg = ex.toString();
			log.severe("Database executeAutoKey error : " + ex);
		}

		return rst;
	}

	public String executeUpdate(String updsql) {
		String rst = null;

		try {
			Statement stUP = db.createStatement();
			stUP.executeUpdate(updsql);
			stUP.close();
		} catch (SQLException ex) {
			rst = ex.toString();
			lastErrorMsg = ex.getMessage();
			System.err.println("Database transaction get data error : " + ex);
		}

		return rst;
	}

	public String executeBatch(String mysql) {
		String rst = null;

		try {
			Statement st = db.createStatement();
			String[] lines = mysql.split(";");
			for(String line : lines) {
				if(!"".equals(line.trim()))
					st.addBatch(line);
			}
			st.executeBatch();
			st.close();
		} catch (SQLException ex) {
			rst = ex.toString();
			log.severe("Database executeBatch error : " + ex);
		}

		return rst;
	}

	public Clob createClob() {
		Clob clb = null;
		try {
			clb = db.createClob();
		} catch (SQLException ex) {
			log.severe("Clob Creation error : " + ex);
		}

		return clb;
	}
	
	public Map<String, String> getMapData(String keyField, String valueField, String mySource) {
		Map<String, String> ans = new HashMap<String, String>();

		try {
			Statement st = db.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
			ResultSet rs = st.executeQuery("SELECT " + keyField + ", " + valueField + " FROM " + mySource);

			while(rs.next()) {
				ans.put(rs.getString(keyField), rs.getString(valueField));
			}

			rs.close();
			st.close();
		} catch (SQLException ex) {
			lastErrorMsg = ex.getMessage();
			log.severe("Database executeFunction error : " + ex);
		}

		return ans;
	}

	public Map<String, String> getFieldsData(String fields[], String mysql) {
		Map<String, String> ans = new HashMap<String, String>();

		try {
			Statement st = db.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
			ResultSet rs = st.executeQuery(mysql);

			if(rs.next()) {
				for(String field : fields) ans.put(field.trim(), rs.getString(field.trim()));
			}

			rs.close();
			st.close();
		} catch (SQLException ex) {
			lastErrorMsg = ex.getMessage();
			log.severe("Database executeFunction error : " + ex);
		}

		return ans;
	}

	public Map<String, String> readFields(String myFields, String mySource) {
		String fields[] = myFields.split(",");
		Map<String, String> ans = getFieldsData(fields, "SELECT " + myFields + " FROM " + mySource);

		return ans;
	}
	
	public Vector<Vector<String>> readTable(String mySql) {
		Vector<Vector<String>> ans = new Vector<Vector<String>>();
		try {
			Statement st = db.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
			ResultSet rs = st.executeQuery(mySql);
			ResultSetMetaData rsmd = rs.getMetaData();
			int colCount = rsmd.getColumnCount();
			while(rs.next()) {
				Vector<String> rec = new Vector<String>();
				for(int i = 1; i <= colCount; i++) rec.add(rs.getString(i));
				ans.add(rec);
			}

			rs.close();
			st.close();
		} catch (SQLException ex) {
			log.severe("Database executeFunction error : " + ex);
		}

		return ans;
	}

	public Vector<Vector<String>> readTable(String myFields, String mysource) {
		String fields[] = myFields.split(",");
		String mySql = "SELECT " + myFields + " FROM " + mysource;

		Vector<Vector<String>> ans = new Vector<Vector<String>>();
		try {
			Statement st = db.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
			ResultSet rs = st.executeQuery(mySql);
			while(rs.next()) {
				Vector<String> rec = new Vector<String>();
				for(String field : fields) rec.add(rs.getString(field.trim()));
				ans.add(rec);
			}

			rs.close();
			st.close();
		} catch (SQLException ex) {
			log.severe("Database executeFunction error : " + ex);
		}

		return ans;
	}

	public Map<String, Vector<String>> readTable(String myFields, String mysource, String whereSql, String orderBy, String keyField) {
		String fields[] = myFields.split(",");
		String mySql = "SELECT " + myFields + " FROM " + mysource;
		if(whereSql != null) mySql += " WHERE " + whereSql;
		if(orderBy != null) mySql += " ORDER BY " + orderBy;

		Map<String, Vector<String>> ans = new HashMap<String, Vector<String>>();
		try {
			Statement st = db.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
			ResultSet rs = st.executeQuery(mySql);
			while(rs.next()) {
				Vector<String> rec = new Vector<String>();
				for(String field : fields) rec.add(rs.getString(field.trim()));
				ans.put(rs.getString(keyField), rec);
			}
			rs.close();
			st.close();
		} catch (SQLException ex) {
			log.severe("Database executeFunction error : " + ex);
		}

		return ans;
	}
	
	public JSONArray jsonTable(String myFields, String mySource) {
		String fields[] = myFields.split(",");
		String mySql = "SELECT " + myFields + " FROM " + mySource;
		log.info("JSON SQL : " + mySql);

		JSONArray ans = new JSONArray();
		try {
			Statement st = db.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
			ResultSet rs = st.executeQuery(mySql);
			while(rs.next()) {
				JSONObject jo = new JSONObject();
				for(String field : fields) jo.put(field.trim(), rs.getString(field.trim()));
				ans.put(jo);
			}
			rs.close();
			st.close();
		} catch (SQLException ex) {
			log.severe("Database executeFunction error : " + ex);
			log.severe("SQL " + mySql);
		}

		return ans;
	}

	public JSONObject jsonRow(String myFields, String mySource) {
		String fields[] = myFields.split(",");
		String mySql = "SELECT " + myFields + " FROM " + mySource;
		log.info("JSON SQL : " + mySql);

		JSONObject jo = new JSONObject();
		try {
			Statement st = db.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
			ResultSet rs = st.executeQuery(mySql);
			if(rs.next()) {
				for(String field : fields) jo.put(field.trim(), rs.getString(field.trim()));
			}
			rs.close();
			st.close();
		} catch (SQLException ex) {
			log.severe("Database executeFunction error : " + ex);
			log.severe("SQL " + mySql);
		}

		return jo;
	}
	
	public Vector<String> readColumn(String mySql) {
		Vector<String> ans = new Vector<String>();
		try {
			Statement st = db.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
			ResultSet rs = st.executeQuery(mySql);
			while(rs.next()) ans.add(rs.getString(1));
			rs.close();
			st.close();
		} catch (SQLException ex) {
			log.severe("Database executeFunction error : " + ex);
		}
		return ans;
	}

	public Map<String, String> readRecord(String myFields, String mySource) {
		String fields[] = myFields.split(",");
		String mySql = "SELECT " + myFields + " FROM " + mySource;

		Map<String, String> ans = new HashMap<String, String>();
		try {
			Statement st = db.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
			ResultSet rs = st.executeQuery(mySql);
			if(rs.next()) {
				for(String field : fields)
					ans.put(field.trim(), rs.getString(field.trim()));
			}
			rs.close();
			st.close();
		} catch (SQLException ex) {
			log.severe("Database executeFunction error : " + ex);
		}

		return ans;
	}
	
	public Vector<Map<String, String>> readRecords(String myFields, String mySource) {
		String fields[] = myFields.split(",");
		String mySql = "SELECT " + myFields + " FROM " + mySource;

		Vector<Map<String, String>> ans = new Vector<Map<String, String>>();
		try {
			Statement st = db.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
			ResultSet rs = st.executeQuery(mySql);
			while(rs.next()) {
				Map<String, String> rec = new HashMap<String, String>();
				for(String field : fields) 
					rec.put(field.trim(), rs.getString(field.trim()));
				ans.add(rec);
			}
			rs.close();
			st.close();
		} catch (SQLException ex) {
			log.severe("Database executeFunction error : " + ex);
		}

		return ans;
	}
	
	// Get the table names
	public List<String> getTables() {
		List<String> tableList = new ArrayList<String>();
		try {
			String[] types = {"TABLE"};
        	ResultSet rs = dbmd.getTables(null, dbschema, "%", types);
    		while (rs.next()) {
				String tableName = rs.getString(3);
				if(tableName.indexOf("$")<0)
					tableList.add(tableName);
			}
			rs.close();
		} catch (SQLException ex) {
			log.severe("Table Listing error : " + ex);
		}

		return tableList;
	}

	// Get the view names
	public List<String> getViews() {
		List<String> viewList = new ArrayList<String>();
		try {
			String[] types = {"VIEW"};
        	ResultSet rs = dbmd.getTables(null, dbschema, "%", types);
    		while (rs.next()) viewList.add(rs.getString(3));
			rs.close();
		} catch (SQLException ex) {
			log.severe("Table Listing error : " + ex);
		}

		return viewList;
	}

	public String initCap(String mystr) {
		if(mystr != null) {
			String[] mylines = mystr.toLowerCase().split("_");
			mystr = "";
			for(String myline : mylines) {
				if(myline.length()>0)
					myline = myline.replaceFirst(myline.substring(0, 1), myline.substring(0, 1).toUpperCase());
				mystr += myline + " ";
			}
			mystr = mystr.trim();
		}
		return mystr;
	}
	
	public String getCatalogName() {
		String catalogName = null;
		try {
			catalogName = db.getCatalog();
		} catch(SQLException ex) {
			log.severe("Database name : " + ex);
		}
		
		return catalogName;
	}

	public boolean isValid() {
		boolean dbv = false;
		try {
			if(db != null) {
				Statement tst = db.createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
				ResultSet trs = tst.executeQuery("SELECT 1;");
				if(trs.next()) dbv = true;
				trs.close();
				tst.close();
			}
		} catch (SQLException ex) {
			log.severe("DB Validation Error : " + ex);
		}
		return dbv;
	}
	
	public boolean isFullAudit(String tableName) {
		return fullAudit.contains(tableName);
	}

    public static DataSource getDataSource(String datasource) {
		DataSource ds = null;
		try {
			Context ctx = new InitialContext();
			ds = (DataSource) ctx.lookup(datasource);//"java:comp/env/jdbc/database"
		} catch (NamingException e) {
            log2.severe("Unable to create DataSource : " + e.toString());
		}

		return ds;
	}

	public static Connection getConnection(String datasource) {
        Connection con = null;
		try {
			con = getDataSource(datasource).getConnection();
		} catch (SQLException e) {
            log2.severe("Unable to get Connection : " + e.toString());
		}
		return con;
	}
    
    public static PreparedStatement getStatement(String datasource, String sql) {
		PreparedStatement preparedStatement = null;
		try {
			preparedStatement = getConnection(datasource).prepareStatement(sql);
		} catch (SQLException e) {
            log2.severe("Unable to Prepare Statement : " + e.toString());
		} catch (Exception ex) {
            log2.severe("Error Preparing Statement : " + ex.toString());
		}
		return preparedStatement;
	}
    
    public static PreparedStatement getStatement(Connection con, String sql) {
		PreparedStatement preparedStatement = null;
		try {
			preparedStatement = con.prepareStatement(sql);
		} catch (SQLException e) {
            log2.severe("Unable to Prepare Statement : " + e.toString());
		} catch (Exception ex) {
            log2.severe("Error Preparing Statement : " + ex.toString());
		}
		return preparedStatement;
	}
    
    
    public static Integer executeStatement(PreparedStatement preparedStatement) {
		Integer es = null;
		try {
			es = preparedStatement.executeUpdate(); // execute insert statement
		} catch (SQLException e) {
            log2.severe("Error Executing Statement" + e.getMessage());
			es = null;
		} catch (Exception e1) {
            log2.severe("Error Executing Prepared Statement : " + e1.toString());
			es = null;
		} finally {
			if (preparedStatement != null) {
				Connection conn = null;
				try {
					conn = preparedStatement.getConnection();
                    log2.info("Connection Retrievd");
				} catch (SQLException e) {
                    log2.severe("Failed To Retrieve Connection : " + e.toString());
				}

				try {
					preparedStatement.close();
                    log2.info("Statement Closed");
				} catch (SQLException e) {
                    log2.severe("Error Closing Statement : " + e.toString());
				}

				if (conn != null) {
					try {
						conn.close();
                        log2.info("Connection Closed");
					} catch (SQLException e) {
                        log2.severe("Errot Closing Connection : " + e.toString());
					}
				}
			}
		}
		return es;
	}
	
	public String saveRec(String inSql, Map<String, String> addNewBlock) {
		String errMsg = null;
		String keyFieldId = null;
		String logFieldName = "";

		log.fine("BASE 100 : " + inSql);

		try {
			PreparedStatement ps = db.prepareStatement(inSql, Statement.RETURN_GENERATED_KEYS);
			ResultSetMetaData psmd = ps.getMetaData();
			Map<String, Integer> mFieldCols = new HashMap<String, Integer>();
			for(int i = 1;  i <= psmd.getColumnCount(); i++) mFieldCols.put(psmd.getColumnName(i), i);
		
			String fValue = "";
			int colIndex = 1;
			int typeColIndex = 1;
			int fType = -1;
			int colLen = -1;
			for (String fieldName : addNewBlock.keySet()) {
				logFieldName = fieldName;
				fValue = addNewBlock.get(fieldName);
				typeColIndex = mFieldCols.get(fieldName.toLowerCase());
				fType = psmd.getColumnType(typeColIndex);
				colLen = psmd.getColumnDisplaySize(typeColIndex);
				log.fine("BASE 1010 : " + colIndex + " : " + fieldName + " : " + fValue + " : " + fType + " : " + colLen);

				if(fValue == null) {
					ps.setNull(colIndex, fType);
			    } else if(fValue.length()<1) {
					ps.setNull(colIndex, fType);
			    } else {
					switch(fType) {
		    			case Types.CHAR:
		    			case Types.VARCHAR:
		    			case Types.LONGVARCHAR:
							if(colLen < fValue.length()) {
								if(errMsg == null) errMsg = fieldName + " is too long maximum is : " + colLen;
								else errMsg += "\n<br>" + fieldName + " is too long maximum is : " + colLen;
							}
		        			ps.setString(colIndex, fValue);
							break;
		   				case Types.BIT:
							if(fValue.equals("true")) ps.setBoolean(colIndex, true);
							else ps.setBoolean(colIndex, false);
							break;
		    			case Types.TINYINT:
		    			case Types.SMALLINT:
		    			case Types.INTEGER:
							int ivalue = Integer.valueOf(fValue).intValue();
							ps.setInt(colIndex, ivalue);
							break;
						case Types.NUMERIC:
							BigDecimal bdValue = new BigDecimal(fValue);
							ps.setBigDecimal(colIndex, bdValue);
							break;
				    	case Types.BIGINT:
							long lvalue = Long.valueOf(fValue).longValue();
							ps.setLong(colIndex, lvalue);
							break;
				    	case Types.FLOAT:
				    	case Types.DOUBLE:
						case Types.REAL:
							double dvalue = Double.valueOf(fValue).doubleValue();
							ps.setDouble(colIndex, dvalue);
							break;
				    	case Types.DATE:
							java.sql.Date dtvalue = java.sql.Date.valueOf(fValue);
							ps.setDate(colIndex, dtvalue);
							break;
				    	case Types.TIME:
							java.sql.Time tvalue = Time.valueOf(fValue);
							ps.setTime(colIndex, tvalue);
							break;
						case Types.TIMESTAMP:
							java.sql.Timestamp tsvalue = java.sql.Timestamp.valueOf(fValue);
							ps.setTimestamp(colIndex, tsvalue);
							break;
						case Types.CLOB:
							Clob clb = db.createClob();
							clb.setString(1, fValue);
							ps.setClob(colIndex, clb);
							break;
						default:
		        			ps.setString(colIndex, fValue);
							break;
					}
				}
				colIndex++;
			}
			ps.executeUpdate();

			ResultSet rsb = ps.getGeneratedKeys();
			if(rsb.next()) keyFieldId = rsb.getString(1);
			rsb.close();

			ps.close();
		} catch (SQLException ex) {
			Integer errCode = ex.getErrorCode();
			String errCodeMsg = ex.getMessage(); 
			
			if(errCodeMsg != null) {
				int ePos = errCodeMsg.indexOf("PL/pgSQL");
				if(ePos > 7) errCodeMsg = errCodeMsg.substring(0, ePos - 7);
			}
			
			if(errMsg == null) errMsg = errCodeMsg + "\n";
			else errMsg += "\n<br>" + errCodeMsg + "\n";

			log.severe("The SQL Exeption on new record " + logFieldName + " : " + ex);
			log.severe("The error code " + errCode);
		} catch (NumberFormatException ex) {
			errMsg = logFieldName + " : " + ex.getMessage() + "\n";
			log.severe("Number format exception on field = " + logFieldName + " : value = " + addNewBlock.get(logFieldName) + " : " + ex);
		}

		return keyFieldId;
	}


	public Map<String, String> getConfigs(String configType) {
		Map<String, String> cfgs = new HashMap<String, String>();
		try {
			String mySql = "SELECT config_name, config_value FROM sys_configs WHERE config_type_id = " + configType;
			Statement st = db.createStatement(ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_READ_ONLY);
			ResultSet rs = st.executeQuery(mySql);
			while(rs.next()) cfgs.put(rs.getString("config_name"), rs.getString("config_value"));
			rs.close();
			st.close();
		} catch (SQLException ex) {
			log.severe("Database connection SQL Error : " + ex);
		}
		return cfgs;
	}

	public void makeConfigs() {
		configs = new HashMap<String, String>();
		try {
			String mySql = "SELECT config_name, config_value FROM sys_configs WHERE config_type_id = 1";
			Statement st = db.createStatement(ResultSet.TYPE_FORWARD_ONLY, ResultSet.CONCUR_READ_ONLY);
			ResultSet rs = st.executeQuery(mySql);
			while(rs.next()) configs.put(rs.getString("config_name"), rs.getString("config_value"));
			rs.close();
			st.close();
		} catch (SQLException ex) {
			log.severe("Database connection SQL Error : " + ex);
		}
	}

	public Map<String, String> getConfigs() {
		return configs;
	}
	
	public String getConfig(String configName) {
		return configs.get(configName);
	}

	public Connection getDB() { return db; }
	public DatabaseMetaData getDBMetaData() { return dbmd; }
	public int getDBType() { return dbType; }

	public String getOrgID() { return orgID; }
	public void setOrgID(String orgID) { this.orgID = orgID; }
	public String getDBSchema() { return dbschema; }
	
	public String getLastErrorMsg() {
		String lemsg = null;
		int lemPos = lastErrorMsg.indexOf("Where: PL/pgSQL");
		if((lastErrorMsg != null) && (lemPos > 0)) lemsg = lastErrorMsg.substring(0, lemPos);
		return lemsg; 
	}
	
	public void setReadOnly(boolean readOnly) { this.readOnly = readOnly; }
	public boolean getReadOnly() { return readOnly; }

	public void close() {
		try {
			if(db != null) db.close();
			db = null;
		} catch (SQLException ex) {
			log.severe("SQL Error : " + ex);
		}
	}

}

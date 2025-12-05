/**
 * @author      Dennis W. Gichangi <dennis@openbaraza.org>
 * @version     2011.0329
 * @since       1.6
 * website		www.openbaraza.org
 * The contents of this file are subject to the GNU Lesser General Public License
 * Version 3.0 ; you may use this file in compliance with the License.
 */
package org.baraza.DB;

import java.math.BigDecimal;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Vector;
import java.util.logging.Logger;

import java.sql.Clob;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Time;
import java.sql.Timestamp;
import java.sql.Types;

import org.json.JSONArray;
import org.json.JSONObject;


public class BQuery {
	Logger log = Logger.getLogger(BQuery.class.getName());
	int tableLimit = -1;
	BDB db = null;
	
	Statement st = null;
	ResultSet rs = null;
	ResultSetMetaData rsmd = null;
	boolean isAddNew = false;
	boolean isEdit = false;
	String tableSelect = null;
	String tableName = null;
	String updateTable = null;
	int colnum = 0;
	Vector<Vector<Object>> data;
	Vector<String> titles;
	Vector<String> fieldNames;
	Vector<String> keyFieldData;
	Vector<String> autoFields;
	List<Boolean> columnEdit;
	Map<String, String> params;
	Map<String, String> addNewBlock;
	String keyField = null;
	String keyFieldId = null;
	String mysql = null;
	String auditID = null;
	boolean firstFetch = true;
	boolean noaudit = false;
	boolean readonly = false;
	boolean ifOrg = false;
	int errCode = 0;
	String changeTrack = "";
	
	Integer rowStart = null;
	Integer fertchSize = null;
	
	String view = null;
	
	String orgID = null;
	String userOrg = null;

	public BQuery() {
		init();
	}

	public BQuery(String[] titleArray) {
		init();
		for(String mnName : titleArray) titles.add(mnName);
	}
		
	public BQuery(BDB db, String myfields, String tableName, int limit) {
		init();
		this.db = db;
		this.tableName = tableName;
		tableLimit = limit;
		
		mysql = "SELECT " + myfields +  "\nFROM " + tableName;
		makeQuery();
	}

	public BQuery(BDB db, String mysql) {
		init();
		this.db = db;
		this.mysql = mysql;

		makeQuery();
		
		// Get the table name
		try {
			if(rsmd != null) this.tableName = rsmd.getTableName(1);
		} catch(SQLException ex) {
			log.severe("Get table name exception " + ex);
		}
	}

	public BQuery(BDB db, String mysql, boolean firstFetch) {
		init();
		this.db = db;
		this.mysql = mysql;
		this.firstFetch = firstFetch;

		makeQuery();
		
		// Get the table name
		try {
			if(rsmd != null) this.tableName = rsmd.getTableName(1);
		} catch(SQLException ex) {
			log.severe("Get table name exception " + ex);
		}
	}

	public BQuery(BDB db, String mysql, int limit) {
		init();
		this.db = db;
		this.mysql = mysql;
		tableLimit = limit;

		makeQuery();
	}

	public String addField(String colNames, String colName) {
		if(colName == null) return colNames;
		if(!fieldNames.contains(colName)) {
			colNames += ", " + colName;
			fieldNames.add(colName);
		}
		return colNames;
	}

	public void init() {
		titles = new Vector<String>();
		fieldNames = new Vector<String>();
		keyFieldData = new Vector<String>();
		autoFields = new Vector<String>();
		data = new Vector<Vector<Object>>();
		columnEdit = new ArrayList<Boolean>();

		params = new HashMap<String, String>();
		addNewBlock = new HashMap<String, String>();
	}

	public void makeQuery() {
		
		if(db.getReadOnly()) readonly = true;

		try {
			if(readonly) st = db.getDB().createStatement();
			else st = db.getDB().createStatement(ResultSet.TYPE_SCROLL_SENSITIVE, ResultSet.CONCUR_UPDATABLE);
			if(tableLimit > 0) st.setFetchSize(tableLimit);
			else if(tableLimit == 0) st.setFetchSize(1000);

			rs = st.executeQuery(mysql);
			rsmd = rs.getMetaData();
			colnum = rsmd.getColumnCount();    // Get column numbers
            
			if(view == null) {
				titles = new Vector<String>(getFields());
				fieldNames = new Vector<String>(getFields());
			}

			// Get Auto Field
			getAutoFields();
		} catch (SQLException ex) {
			rs = null;
			log.severe("Get Table read and Metadata Error : " + ex);
			log.severe("SQL " + mysql);
		}
	}

	public void refresh() {
		try {
			rs = st.executeQuery(mysql);
		} catch (SQLException ex) {
			log.severe("Get Table refresh Error : " + ex);
		}
	}

	public void setSQL(String lsql) {
		mysql = lsql;
	}
	
	public boolean moveNext() {
		boolean ans = false;

		try {
			if(rs != null) ans = rs.next();
		} catch (SQLException ex) {
			log.severe("Table " + tableName + " move next error : " + ex);
		}

		return ans;
	}

	public boolean movePrevious() {
		boolean ans = false;

		try {
			if(rs != null) ans = rs.previous();
		} catch (SQLException ex) {
			log.severe("Table " + tableName + " move previous error : " + ex);
		}

		return ans;
	}

	public int getRow() {
		int ans = -1;

		try {
			if(rs != null) ans = rs.getRow();
		} catch (SQLException ex) {
			log.severe("Table move to row error : " + ex);
		}

		return ans;
	}

	public boolean moveFirst() {
		boolean ans = false;

		try {
			if(rs != null) ans = rs.first();
		} catch (SQLException ex) {
			log.severe("Table move first error : " + ex);
		}

		return ans;
	}

	public boolean moveLast() {
		boolean ans = false;

		try {
			if(rs != null) ans = rs.last();
		} catch (SQLException ex) {
			log.severe("Table move last error : " + ex);
		}

		return ans;
	}

	public void beforeFirst() {
		try {
			if(rs != null) rs.beforeFirst();
		} catch (SQLException ex) {
			log.severe("Table move first error : " + ex);
		}
	}


	public boolean isLast() {
		boolean ans = false;
		try {
			if(rs != null) ans = rs.isLast();
		} catch (SQLException ex) {
			log.severe("Table islast check error : " + ex);
		}
		return ans;
	}

	public boolean isFirst() {
		boolean ans = false;
		try {
			if(rs != null) ans = rs.isFirst();
		} catch (SQLException ex) {
			log.severe("Table isFirst check error : " + ex);
		}
		return ans;
	}

	public boolean movePos(int pos) {
		boolean ans = false;

		try {
			if(rs != null) ans = rs.absolute(pos);
		} catch (SQLException ex) {
			log.severe("Table absolute move error : " + ex);
		}

		return ans;
	}

	public void reset() {
		try {
			if(rs != null) rs.beforeFirst();
		} catch (SQLException ex) {
			log.severe("Table move before first data error : " + ex);
		}
	}

	public int rowNumber() {
		int ans = 0;

		try {
			if(rs != null) ans = rs.getRow();
		} catch (SQLException ex) {
			log.severe("Table get row number error : " + ex);
		}

		return ans;
	}

	public String readField(String fieldName) {
		String ans = null;

		try {
			ans = rs.getString(fieldName);
		} catch (SQLException ex) {
			log.severe("Data field read error : " + ex);
		}

		return ans;
	}

	public String readField(int fieldPos) {
		String ans = null;

		try {
			ans = rs.getString(fieldPos);
		} catch (SQLException ex) {
			log.severe("Data field read error : " + ex);
		}

		return ans;
	}

	public String readField(String fieldName, String optData) {
		String ans = readField(fieldName);
		if(ans == null) ans = optData;
		return ans;
	}

	public String readField(int fieldPos, String optData) {
		String ans = readField(fieldPos);
		if(ans == null) ans = optData;
		return ans;
	}

	public String getString(String fieldName) {
		return readField(fieldName);
	}

	public int getInt(String fieldName) {
		int ans = 0;

		try {
			ans = rs.getInt(fieldName);
		} catch (SQLException ex) {
			log.severe("Data field read error : " + ex);
		}

		return ans;
	}

	public Float getFloat(String fieldName) {
		Float ans = 0.0f;

		try {
			ans = rs.getFloat(fieldName);
		} catch (SQLException ex) {
			log.severe("Data field read error : " + ex);
		}

		return ans;
	}

	public Double getDouble(String fieldName) {
		Double ans = 0.0d;

		try {
			ans = rs.getDouble(fieldName);
		} catch (SQLException ex) {
			log.severe("Data field read error : " + ex);
		}

		return ans;
	}

	public Date getDate(String fieldName) {
		Date ans = null;

		try {
			ans = rs.getDate(fieldName);
		} catch (SQLException ex) {
			log.severe("Data field read error : " + ex);
		}

		return ans;
	}

	public Time getTime(String fieldName) {
		Time ans = null;

		try {
			ans = rs.getTime(fieldName);
		} catch (SQLException ex) {
			log.severe("Data field read error : " + ex);
		}

		return ans;
	}
	
	public Timestamp getTimestamp(String fieldName) {
		Timestamp ans = null;

		try {
			ans = rs.getTimestamp(fieldName);
		} catch (SQLException ex) {
			log.severe("Data field read error : " + ex);
		}

		return ans;
	}

	public Boolean getBoolean(String fieldName) {
		Boolean ans = false;

		try {
			ans = rs.getBoolean(fieldName);
		} catch (SQLException ex) {
			log.severe("Data field read error : " + ex);
		}

		return ans;
	}
	
	public String getBoolean(String fieldName, int fType) {
		String ans = "Yes";

		try {
			boolean dans = rs.getBoolean(fieldName);
			if(fType == 1) {
				if(dans) ans = "Yes"; else ans = "No";
			} else if(fType == 2) {
				if(dans) ans = "True"; else ans = "False";
			}
		} catch (SQLException ex) {
			log.severe("Data field read error : " + ex);
		}

		return ans;
	}

	public String getFormatField(int fieldPos) {
		String ans = "";
		int fldPos = fieldPos + 1;
		try {
			int type = getFieldType(fldPos);
			if((type == Types.DATE) || (type == Types.TIME) || (type == Types.TIMESTAMP)) {
				SimpleDateFormat dateParse = new SimpleDateFormat("dd-MMM-yyyy");
				if(rs.getString(fldPos)!=null)
					ans = dateParse.format(rs.getDate(fldPos));
			} else {
				ans = rs.getString(fldPos);
			}

			if(ans == null) ans = "";
		} catch (SQLException ex) {
			log.severe("Data field read error : " + ex);
		}

		return ans;
	}

	public String updateField(String fname, String fvalue) {
		String errMsg = "";
		if(isAddNew) { 
			if(fvalue != null) {
				if(fvalue.length()>0)
					addNewBlock.put(fname, fvalue);
			}
		} else {
			errMsg = updateRecField(fname, fvalue);
		}
		return errMsg;
	}

	public String updateRecField(String fname, String fvalue) {
		String errMsg = "";

		if(isEdit) {
			String oldvalue = readField(fname);
			if(oldvalue == null) {
				if (fvalue == null) return errMsg;
			} else {
				if (oldvalue.equals(fvalue)) return errMsg;
				changeTrack += "," + fname + ":\"" + oldvalue + "\"";
			}
		}
		
        try {
        
			int columnindex = rs.findColumn(fname);
			if(fvalue == null) {
				rs.updateNull(fname);
		    } else if(fvalue.length()<1) {
				rs.updateNull(fname);
		    } else {
				int type = getFieldType(columnindex);
				int colLen = getFieldSize(columnindex);
	
				//System.out.println("BASE 4015 : " + fname + " = " + fvalue + " type = " + type);
				switch(type) {
        			case Types.CHAR:
        			case Types.VARCHAR:
        			case Types.LONGVARCHAR:
        				if(colLen < fvalue.length()) {
							String errFld = fname;
							if(errMsg == null) errMsg = errFld + " is too long maximum is : " + colLen;
							else errMsg += "\n<br>" + errFld + " is too long maximum is : " + colLen;
						}
						
            			rs.updateString(fname, fvalue);
						break;
       				case Types.BIT:
						if(fvalue.equals("true")) rs.updateBoolean(fname, true);
						else rs.updateBoolean(fname, false);
						break;
        			case Types.TINYINT:
        			case Types.SMALLINT:
        			case Types.INTEGER:
						int ivalue = Integer.valueOf(fvalue).intValue();
						rs.updateInt(fname, ivalue);
						break;
					case Types.NUMERIC:
						BigDecimal bdValue = new BigDecimal(fvalue);
						rs.updateBigDecimal(fname, bdValue);
						break;
		        	case Types.BIGINT:
						long lvalue = Long.valueOf(fvalue).longValue();
						rs.updateLong(fname, lvalue);
						break;
		        	case Types.FLOAT:
		        	case Types.DOUBLE:
					case Types.REAL:
						double dvalue = Double.valueOf(fvalue).doubleValue();
						rs.updateDouble(fname, dvalue);
						break;
		        	case Types.DATE:
						java.sql.Date dtvalue = java.sql.Date.valueOf(fvalue);
						rs.updateDate(fname, dtvalue);
						break;
		        	case Types.TIME:
						java.sql.Time tvalue = Time.valueOf(fvalue);
						rs.updateTime(fname, tvalue);
						break;
					case Types.TIMESTAMP:
						java.sql.Timestamp tsvalue = java.sql.Timestamp.valueOf(fvalue);
						rs.updateTimestamp(fname, tsvalue);
						break;
					case Types.CLOB:
						Clob clb = db.createClob();
						clb.setString(1, fvalue);
						rs.updateClob(fname, clb);
						break;
				}
		   	}
        } catch (SQLException ex) {
			errMsg = fname + " : " + ex.getMessage() + "\n";
        	log.severe("The SQL Exeption on update field " + fname + " : " + ex);
        } catch (NumberFormatException ex) {
			errMsg = fname + " : " + ex.getMessage() + "\n";
        	log.severe("Number format exception on field = " + fname + " : value = " + fvalue + " : " + ex);
		}

		return errMsg;
	}
	
	public String updateBytes(String fname, byte[] bdata) {
		String errMsg = null;
		try {
			rs.updateBytes(fname, bdata);
		} catch (SQLException ex) {
			errMsg = fname + " : " + ex.getMessage() + "\n";
        	log.severe("The SQL Exeption on updateBytes field " + fname + " : " + ex);
		}
		return errMsg;
	}
	
	public byte[] getBytes(String fname) {
		try {
			byte[] bdata = rs.getBytes(fname);
			return bdata;
		} catch (SQLException ex) {
        	log.severe("The SQL Exeption on updateBytes field " + fname + " : " + ex);
		}
		
		return null;
	}
	
	public String recDelete() {
		String errMsg = null;
		errCode = 0;
		try {
			String recordid = getKeyField();
			rs.deleteRow();
		} catch (SQLException ex) {
			errMsg = getErrMessage(ex.getMessage()) + "\n";
			errCode = ex.getErrorCode();
			
			int ePos = errMsg.indexOf("PL/pgSQL");
			if(ePos > 7) errMsg = errMsg.substring(0, ePos - 7);
			
       		log.severe("Delete row error : " + ex);
		}

		return errMsg;
	}

	public boolean recAdd() {
		addNewBlock = new HashMap<String, String>();
		isAddNew = true;
		errCode = 0;

		return isAddNew;
	}

	public boolean recEdit() {
		errCode = 0;
		if(!isAddNew) { 
			isEdit = true;			
		}
		return isEdit;
	}

	public String recSave() {
		String errMsg = "";
		errCode = 0;
		try {
			if(isAddNew) {
				errMsg = saveNewRec();

				if(errMsg == null) {
					isAddNew = false;
				}
			} else if(isEdit) {
				rs.updateRow();
				rs.moveToCurrentRow();
				isEdit = false;
			}
 		} catch (SQLException ex) {
			errCode = ex.getErrorCode();
			errMsg = getErrMessage(null);

			if(errMsg == null) {
				errMsg = ex.getMessage();
				int ePos = errMsg.indexOf("PL/pgSQL");
				if(ePos > 7) errMsg = errMsg.substring(0, ePos - 7);
			}
			errMsg += "\n";

			log.severe("Update record error : " + ex);
			log.severe("The error code " + errCode);
		}

		if(errMsg == null) errMsg = "";

		return errMsg;
	}

	public String saveNewRec() {
		String errMsg = null;
		String fname = "";
		String fvalue = "";

		if((ifOrg) && (orgID != null)) {
			if(!addNewBlock.containsKey(orgID)) {
				if(userOrg != null) addNewBlock.put(orgID, userOrg);
				else addNewBlock.put(orgID, "0");
			}
		}
		
		String usql = "INSERT INTO " + tableName + " (";
		if(db.getDBSchema() != null) usql = "INSERT INTO " + db.getDBSchema() + "." + tableName + " (";
		String psql = ") VALUES (";
		boolean ff = true;
		for (String field : addNewBlock.keySet()) {
			if(ff) { ff = false; }
			else { usql += ", "; psql += ", ";}

			usql += field;
			psql += "?";
		}
		usql += psql + ")";
		log.fine("BASE 100 : " + usql);

        try {
			PreparedStatement ps = db.getDB().prepareStatement(usql, Statement.RETURN_GENERATED_KEYS);
			int col = 1;
			int columnindex = -1;
			int type = -1;
			int colLen = -1;
			for (String field : addNewBlock.keySet()) {
				fname = field;
				fvalue = addNewBlock.get(field);
				columnindex = rs.findColumn(field);
				type = getFieldType(columnindex);
				colLen = getFieldSize(columnindex);
				log.fine("BASE 1010 : " + col + " : " + fname + " : " + fvalue + " : " + type + " : " + colLen);
								
				switch(type) {
        			case Types.CHAR:
        			case Types.VARCHAR:
        			case Types.LONGVARCHAR:
						if(colLen < fvalue.length()) {
							String errFld = fname;
							if(errMsg == null) errMsg = errFld + " is too long maximum is : " + colLen;
							else errMsg += "\n<br>" + errFld + " is too long maximum is : " + colLen;
						}
            			ps.setString(col, fvalue);
						break;
       				case Types.BIT:
						if(fvalue.equals("true")) ps.setBoolean(col, true);
						else ps.setBoolean(col, false);
						break;
        			case Types.TINYINT:
        			case Types.SMALLINT:
        			case Types.INTEGER:
						int ivalue = Integer.valueOf(fvalue).intValue();
						ps.setInt(col, ivalue);
						break;
					case Types.NUMERIC:
						BigDecimal bdValue = new BigDecimal(fvalue);
						ps.setBigDecimal(col, bdValue);
						break;
		        	case Types.BIGINT:
						long lvalue = Long.valueOf(fvalue).longValue();
						ps.setLong(col, lvalue);
						break;
		        	case Types.FLOAT:
		        	case Types.DOUBLE:
					case Types.REAL:
						double dvalue = Double.valueOf(fvalue).doubleValue();
						ps.setDouble(col, dvalue);
						break;
		        	case Types.DATE:
						java.sql.Date dtvalue = java.sql.Date.valueOf(fvalue);
						ps.setDate(col, dtvalue);
						break;
		        	case Types.TIME:
						java.sql.Time tvalue = Time.valueOf(fvalue);
						ps.setTime(col, tvalue);
						break;
					case Types.TIMESTAMP:
						java.sql.Timestamp tsvalue = java.sql.Timestamp.valueOf(fvalue);
						ps.setTimestamp(col, tsvalue);
						break;
					case Types.CLOB:
						Clob clb = db.createClob();
						clb.setString(1, fvalue);
						ps.setClob(col, clb);
						break;
					default:
            			ps.setString(col, fvalue);
						break;
				}
				col++;
			}
			ps.executeUpdate();

			ResultSet rsb = ps.getGeneratedKeys();
			if(rsb.next()) {
				keyFieldId = rsb.getString(1);
				//System.out.println(db.getDBType() + " : rowid = '" + keyFieldId + "'");

				moveLast();
			}
			rsb.close();

			ps.close();
        } catch (SQLException ex) {
			errCode = ex.getErrorCode();
			String errCodeMsg = getErrMessage(null);
			if(errCodeMsg == null) errCodeMsg = ex.getMessage();
			
			if(errCodeMsg != null) {
				int ePos = errCodeMsg.indexOf("PL/pgSQL");
				if(ePos > 7) errCodeMsg = errCodeMsg.substring(0, ePos - 7);
			}
			
			if(errMsg == null) errMsg = errCodeMsg + "\n";
			else errMsg += "\n<br>" + errCodeMsg + "\n";

        	log.severe("The SQL Exeption on new record " + fname + " : " + ex);
			log.severe("The error code " + errCode);
        } catch (NumberFormatException ex) {
			errMsg = fname + " : " + ex.getMessage() + "\n";
        	log.severe("Number format exception on field = " + fname + " : value = " + fvalue + " : " + ex);
		}

		return errMsg;
	}
	
	public String getErrMessage(String err) {
		String errCheck =  err;
		if(err == null) errCheck = Integer.toString(errCode);
		String errSql = "SELECT error_message FROM sys_errors WHERE sys_error = '" + errCheck + "';";
		String errAns = db.executeFunction(errSql);
		if(errAns == null) errAns = err;
		return errAns;
	}

	public void cancel() {
		isAddNew = false;
		isEdit = false;
	}

	// Get the table fields
	public List<String> getFields() {
		List<String> fieldList = new ArrayList<String>();
		try {
			for(int column=1; column<=colnum; column++)
				fieldList.add(rsmd.getColumnLabel(column));
 		} catch (SQLException ex) {
			log.severe("Field Name read error : " + ex);
		}

		return fieldList;
	}

	// Get the table fields
	public Vector<String> getAutoFields() {
		autoFields = new Vector<String>();
		try {
			for(int column=1; column<=colnum; column++) {
				if(rsmd.isAutoIncrement(column)) {
					autoFields.add(rsmd.getColumnLabel(column));
				}
			}
 		} catch (SQLException ex) {
			log.severe("Field Name read error : " + ex);
		}

		return autoFields;
	}

	// Get the table fields
	public int getFieldSize(int column) {
		int fieldSize = -1;
		try {
			if (column<=colnum)
				fieldSize = rsmd.getColumnDisplaySize(column);
 		} catch (SQLException ex) {
			log.severe("Field size error : " + ex);
		}
 		
		return fieldSize;
	}

	public int getFieldType(String columnName) {
		int fieldType = -1;
		try {
			int column = rs.findColumn(columnName);
			if (column<=colnum)
				fieldType = rsmd.getColumnType(column);
 		} catch (SQLException ex) {
			log.severe("Field type read error : " + ex);
		}

		return fieldType;
	}

	public int getFieldType(int column) {
		int fieldType = -1;

		try {
			if (column<=colnum)
				fieldType = rsmd.getColumnType(column);
 		} catch (SQLException ex) {
			log.severe("Field type read error : " + ex);
		}

		return fieldType;
	}

	public void readData() {
		readData(-1);
	}

	public void readData(int limit) {
		if(rs == null) return;

		try {
			if(!readonly) rs.beforeFirst();
			int i = 0;
			data.clear();
			keyFieldData.clear();

			while (rs.next()) {
				Vector<Object> newRow = new Vector<Object>();
				for(int column=1; column<=titles.size(); column++)
					newRow.addElement(rs.getObject(column));

				if(keyField != null) keyFieldData.addElement(rs.getString(keyField));

				data.addElement(newRow);
				if((limit>0) & (limit<i)) break;
				i++;
      		}
 		} catch (SQLException ex) {
			log.severe("Field data read error : " + ex);
		}
	}
	
    public int getColumnCount() {
        return titles.size();
    }

    public int getRowCount() {
        return data.size();
    }

	public void removeRow(int aRow) {
		if(aRow >= 0) data.remove(aRow);
	}

	public String getTableName() { return tableName; }

    public String getColumnName(int aCol) { return titles.get(aCol); }

	public Vector<String> getFieldNames() { return fieldNames; }

    public String getFieldName(int aCol) { return fieldNames.get(aCol); }

	public Vector<String> getColumnNames() { return titles; }

	public Vector<String> getKeyFieldData() { return keyFieldData; }

    public void addColumnName(String title) {
		titles.add(title);
    }

    public Object getValueAt(int aRow, int aCol) {
        return data.get(aRow).get(aCol);
    }

	public String getKeyFieldName() {
		return keyField;
	}

	public String getKeyField() {
		String key = null;
		if(keyField != null) key = readField(keyField);

		return key;
	}

	public int insertRow() {
		Vector<Object> dataRow = new Vector<Object>();
		for(int i = 0; i < getColumnCount(); i++) dataRow.add("");
		data.add(dataRow);

		return data.size();
	}

	public int insertRow(Vector<Object> dataRow) {
		data.add(dataRow);

		return data.size();
	}

    public void setValueAt(Object value, int aRow, int aCol) {
		Vector<Object> dataRow = data.elementAt(aRow);
        dataRow.setElementAt(value, aCol);

		// Update database
		if(updateTable != null) {

			String sql = "UPDATE " + updateTable + " SET " + fieldNames.get(aCol);
			if(value == null) sql += " = null";
			else {
				sql += " = '" + value.toString() + "'";
			}

			sql += " WHERE " + getKeyFieldName() + " = '" +  keyFieldData.get(aRow) + "'";
			log.fine(sql);
			db.executeQuery(sql);
		}
	}


	public void clear() { // Get all rows.
		data.clear();
	}

    public Class getColumnClass(int aCol) {
        int type = Types.VARCHAR;
		if(db != null) type = getFieldType(aCol + 1);


        switch(type) {
			case Types.CHAR:
			case Types.VARCHAR:
			case Types.LONGVARCHAR: return String.class;
			case Types.BIT: return Boolean.class; 
			case Types.TINYINT:
			case Types.SMALLINT:
			case Types.INTEGER: return Integer.class;
			case Types.BIGINT: return Long.class;
			case Types.FLOAT:
			case Types.REAL:
			case Types.DOUBLE: return Double.class;
			case Types.TIME: return Time.class;
			case Types.TIMESTAMP: return Timestamp.class;
			case Types.DATE: return Date.class;
			default: return Object.class;
        }
    }

	public String getFormField(int aCol) {
		String coltype = "TEXTFIELD";

		switch(getFieldType(aCol)) {
			case Types.CHAR:
			case Types.VARCHAR:
				coltype = "TEXTFIELD";
				break;
			case Types.LONGVARCHAR:
			case Types.CLOB:
				coltype = "TEXTAREA";
				break;
			case Types.BIT:
				coltype = "CHECKBOX";
				break;
			case Types.TINYINT:
			case Types.SMALLINT:
			case Types.INTEGER:
				coltype = "TEXTFIELD";
				break;
			case Types.BIGINT:
				coltype = "TEXTFIELD";
				break;
			case Types.FLOAT:
			case Types.DOUBLE:
			case Types.REAL:
				coltype = "TEXTDECIMAL";
				break;
			case Types.DATE:
				coltype = "TEXTDATE";
				break;
			case Types.TIME:
				coltype = "SPINTIME";
				break;
			case Types.TIMESTAMP:
				coltype = "TEXTTIMESTAMP";
				break;
		}

		return coltype;
	}

	public String initCap(String mystr) {
		if(mystr != null) {
			mystr = mystr.toLowerCase();
			String[] mylines = mystr.split("_");
			mystr = "";
			for(String myline : mylines) {
				String newline = "";
				if(myline.length()>0) {
					newline = myline.replaceFirst(myline.substring(0, 1), myline.substring(0, 1).toUpperCase());
					if(myline.trim().toUpperCase().equals("ID")) newline = "ID";
					if(myline.trim().toUpperCase().equals("IS")) newline = null;
				}
				if(newline != null) mystr += newline + " ";
			}
			mystr = mystr.trim();
		}
		return mystr;
	}

	public int getDBType() {
		return db.getDBType();
	}

	public List<Boolean> getColumnEdits() {
		return columnEdit;
	}

	public Map<String, String> getParams() {
		for(String param : params.keySet()) params.put(param, readField(param));

		return params;
	}

	public void setTitles(String[] titleArray) {
		titles.clear();
		for(String mnName : titleArray) titles.add(mnName);
	}

	public void setTableName(String tableName) {
		this.tableName = tableName;
	}

	public int getColnum() {
		return colnum;
	}

	public void close() {
		try {
			if(rs != null) rs.close();
			if(st != null) st.close();
			data.clear();
			data = null;
		} catch (SQLException ex) {
			log.severe("SQL Close Error : " + ex);
		}
	}

}

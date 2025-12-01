package org.ajirika;

import java.util.logging.Logger;

import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.SQLException;

public class DatabaseConnection {
	Logger log = Logger.getLogger(DatabaseConnection.class.getName());

    Connection db = null;
	DatabaseMetaData dbmd = null;

    public DatabaseConnection(String datasource) {
		try {
			InitialContext cxt = new InitialContext();
			DataSource ds = (DataSource) cxt.lookup(datasource);
			db = ds.getConnection();
			dbmd = db.getMetaData();
		} catch (SQLException ex) {
			log.severe("Cannot connect to this database : datasource " + datasource + " : " + ex);
        } catch (NamingException ex) {
			log.severe("Cannot pick on the database : datasource " + datasource + " : " + ex);
        }
	}

    public Connection getConnection() {
        return db;
    }
}

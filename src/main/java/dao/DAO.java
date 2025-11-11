package dao;

import java.sql.Connection;
import java.sql.SQLException;

public abstract class DAO {
    public Connection getConnection() throws SQLException {
        return DBConnection.getConnection();
    }

    protected void closeConnection(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                System.out.println("Error closing connection: " + e.getMessage());
            }
        }
    }
}

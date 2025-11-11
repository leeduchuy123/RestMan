package dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private static final String URL = "jdbc:mysql://localhost:3306/rest_man?" +
            "useUnicode=true&" +
            "characterEncoding=UTF-8&" +
            "serverTimezone=UTC";
    private static final String USER = "root";
    private static final String PASSWORD = "1234";
    private static final String DRIVER = "com.mysql.cj.jdbc.Driver";

    private DBConnection() {}

    public static Connection getConnection() throws SQLException {
        Connection connection = null;

        try {
            Class.forName(DRIVER);

            //establish the connection
            connection = DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException e) {
            System.out.println("Database Driver not found: " + DRIVER);
            e.printStackTrace();
        }

        return connection;
    }
}

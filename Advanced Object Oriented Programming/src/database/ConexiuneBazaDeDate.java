package database; //sursa : https://www.youtube.com/watch?v=duEkh8ZsFGs&t=1755s

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class ConexiuneBazaDeDate {
    private static Connection connection;

    private ConexiuneBazaDeDate() {}

    public static Connection get_instance() throws SQLException {
        if(connection == null) {
            String url = "jdbc:mysql://localhost:3306/proiectpao";
            String userName = "root";
            String password = "SRIsri2001";
            connection = DriverManager.getConnection(url, userName, password);
        }
        return connection;
    }
}
// AuthenticationService.java
package org.MiniDev.Login;

import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import DBConnection.DBConnection;
import java.sql.*;

public class AuthenticationService {

    private static final BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();

    public static boolean fetchAuthenticationCheckWithDatabase(String username, String rawPassword) {
        String sql = "SELECT TellerPassword FROM Teller WHERE TellerName = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setString(1, username);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    String hashedPassword = rs.getString("TellerPassword");
                    return encoder.matches(rawPassword, hashedPassword);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    // Method to get the current tellerID
    public static int getCurrenttellerID(String username) {
        String sql = "SELECT tellerID FROM Teller WHERE TellerName = ?";
        try (Connection connection = DBConnection.getConnection();
             PreparedStatement stmt = connection.prepareStatement(sql)) {

            stmt.setString(1, username);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("tellerID");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1; // Return -1 or another appropriate value if the user is not found or an error occurs
    }
}

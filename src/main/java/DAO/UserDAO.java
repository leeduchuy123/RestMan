package DAO;

import Model.LoginBean;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAO extends DAO{
    public String checkLogin(LoginBean loginBean) throws ClassNotFoundException{
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        String result = "unvalidate";

        try {
            conn = getConnection();
            String sql = "SELECT m.username, s.role FROM tblmember m LEFT JOIN tblstaff s ON m.id = s.tblMemberid\n" +
                    "            WHERE m.username = ? AND m.password = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, loginBean.getUsername());
            pstmt.setString(2, loginBean.getPassword());

            System.out.println(pstmt);
            rs = pstmt.executeQuery();

            if(rs.next()) {
                String role = rs.getString("role");
                System.out.println(role);

                if(role == null || role.isEmpty()) {
                    result = "CUSTOMER";
                } else if ("MANAGER".equalsIgnoreCase(role)){
                    result = "MANAGER";
                } else {
                    result = role;
                }
            }
        } catch (SQLException e) {
            System.out.println("Cannot check login the user: " + loginBean.getUsername());
            e.printStackTrace();
            result = "unvalidate";
        }

        return result;
    }
}

package DAO;

import Model.LoginBean;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class LoginDAO extends DAO{
    public boolean validate(LoginBean loginBean) throws ClassNotFoundException{
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        boolean status = false;

        try {
            conn = getConnection();
            pstmt = conn.prepareStatement("select * from tblmember where username = ? and password = ?");
            pstmt.setString(1, loginBean.getUsername());
            pstmt.setString(2, loginBean.getPassword());

            System.out.println(pstmt);
            rs = pstmt.executeQuery();

            status = rs.next();
        } catch (SQLException e) {
            System.out.println("Cannot check login the user: " + loginBean.getUsername());
            e.printStackTrace();
        }

        return status;
    }
}

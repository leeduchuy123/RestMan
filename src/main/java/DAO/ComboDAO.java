package DAO;

import Model.Combo;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ComboDAO extends DAO{
    private final Connection conn;

    public ComboDAO() throws ClassNotFoundException, SQLException {
        conn = getConnection();
    }

    public Combo getComboById(int id) {
        Combo combo = null;
        try (PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM tblcombo WHERE id = ?")) {
            pstmt.setInt(1, id);

            System.out.println(pstmt);

            try (ResultSet rs = pstmt.executeQuery()) {
                if(rs.next()) {
                    combo = new Combo();

                    combo.setId(rs.getInt("id"));
                    combo.setComboname(rs.getString("comboname"));
                    combo.setComboprice(rs.getFloat("comboprice"));
                    combo.setDescription(rs.getString("description"));
                }
            }
        } catch (SQLException e) {
            System.out.println("Cannot get Combo by Id, SQL Error: " + e.getMessage());
            e.printStackTrace();
        }

        return combo;
    }

    private Combo mapResultSetToCombo(ResultSet rs) throws SQLException {
        Combo combo = new Combo();
        combo.setId(rs.getInt("id"));
        combo.setComboname(rs.getString("comboname"));
        combo.setComboprice(rs.getFloat("comboprice"));
        combo.setDescription(rs.getString("description"));

        return combo;
    }

    public List<Combo> getAllCombo() {
        List<Combo> comboList = new ArrayList<>();
        String query = "SELECT id, comboname, comboprice, description FROM tblcombo";

        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            ResultSet rs = pstmt.executeQuery();

            while(rs.next()) {
                Combo combo = mapResultSetToCombo(rs);
                comboList.add(combo);
            }
        } catch(SQLException e) {
            System.out.println("Cannot get Combo");
        }

        return comboList;
    }

    public Combo saveCombo(Combo combo) {
        String query = "INSERT INTO tblcombo (comboname, comboprice, description) VALUES (?, ?, ?)";

        try (PreparedStatement pstmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setString(1, combo.getComboname());
            pstmt.setFloat(2, combo.getComboprice());
            pstmt.setString(3, combo.getDescription());

            int affectedRows = pstmt.executeUpdate();
            if(affectedRows > 0) {
                ResultSet rs = pstmt.getGeneratedKeys();
                if(rs.next()) {
                    int generatedId = rs.getInt(1);
                    combo.setId(generatedId);
                }
            }
        } catch (SQLException e) {
            System.out.println("Lỗi khi thêm Combo: " + e.getMessage());
            combo = null;
        }

        return combo;
    }

}

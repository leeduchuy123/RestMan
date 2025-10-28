package DAO;

import Model.ComboDish;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ComboDishDAO extends DAO {
    private final Connection conn;

    public ComboDishDAO() throws ClassNotFoundException, SQLException {
        conn = getConnection();
    }

    /**
     * Thêm 1 món ăn vào combo (tạo bản ghi trong bảng tblcombodish)
     * @param comboDish đối tượng ComboDish chứa quantity, tblDishId, tblComboId
     * @return ComboDish đã được thêm (có id tự sinh), hoặc null nếu lỗi
     */
    public ComboDish addDishToCombo(ComboDish comboDish) {
        String query = "INSERT INTO tblcombodish (quantity, tblDishId, tblComboId) VALUES (?, ?, ?)";

        try (PreparedStatement pstmt = conn.prepareStatement(query, Statement.RETURN_GENERATED_KEYS)) {
            pstmt.setInt(1, comboDish.getQuantity());
            pstmt.setInt(2, comboDish.getTblDishId());
            pstmt.setInt(3, comboDish.getTblComboId());

            int affectedRows = pstmt.executeUpdate();
            if (affectedRows > 0) {
                try (ResultSet rs = pstmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        comboDish.setId(rs.getInt(1));
                    }
                }
            }
        } catch (SQLException e) {
            System.out.println("Lỗi khi thêm ComboDish: " + e.getMessage());
            e.printStackTrace();
            comboDish = null;
        }

        return comboDish;
    }

    /**
     * Lấy danh sách ComboDish của một combo cụ thể
     * @param comboId id của combo cần lấy danh sách món ăn
     * @return danh sách ComboDish thuộc combo đó
     */
    public List<ComboDish> getComboDishOfCombo(int comboId) {
        List<ComboDish> comboDishList = new ArrayList<>();
        String query = "SELECT id, quantity, tblDishId, tblComboId FROM tblcombodish WHERE tblComboId = ?";

        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, comboId);
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    ComboDish comboDish = new ComboDish();
                    comboDish.setId(rs.getInt("id"));
                    comboDish.setQuantity(rs.getInt("quantity"));
                    comboDish.setTblDishId(rs.getInt("tblDishId"));
                    comboDish.setTblComboId(rs.getInt("tblComboId"));
                    comboDishList.add(comboDish);
                }
            }
        } catch (SQLException e) {
            System.out.println("Lỗi khi lấy danh sách ComboDish của combo: " + e.getMessage());
            e.printStackTrace();
        }

        return comboDishList;
    }

    /**
     * Xoá 1 ComboDish cụ thể khỏi combo (xoá bản ghi khỏi bảng tblcombodish)
     * @param comboDishId id của bản ghi cần xoá
     * @return true nếu xoá thành công, false nếu lỗi
     */
    public boolean deleteComboDishOfCombo(int comboDishId) {
        String query = "DELETE FROM tblcombodish WHERE id = ?";
        boolean success = false;

        try (PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setInt(1, comboDishId);
            int affectedRows = pstmt.executeUpdate();
            success = (affectedRows > 0);
        } catch (SQLException e) {
            System.out.println("Lỗi khi xoá ComboDish: " + e.getMessage());
            e.printStackTrace();
        }

        return success;
    }
}

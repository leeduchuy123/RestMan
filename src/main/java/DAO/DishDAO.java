package DAO;

import Model.Dish;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

public class DishDAO extends DAO {
    private final Connection conn;

    public DishDAO() throws ClassNotFoundException, SQLException {
        conn = getConnection();
    }

    public Dish getDish(int id) {   //get Dish by ID
        Dish dish = null;
        try (PreparedStatement pstmt = conn.prepareStatement("SELECT * FROM tbldish WHERE id = ?")) {

            pstmt.setInt(1, id);

            // Optional: Print the statement for debugging (remove in production)
            System.out.println(pstmt);

            // 2. Execute query and open a new try-with-resources for the ResultSet
            try (ResultSet rs = pstmt.executeQuery()) {

                if(rs.next()) {
                    // **CRITICAL FIX**: Must initialize the Dish object before calling setters.
                    dish = new Dish();

                    // Use your specified setters and column names
                    dish.setId(rs.getInt("id"));
                    dish.setDishname(rs.getString("dishname"));
                    dish.setDishprice(rs.getFloat("dishprice"));
                    dish.setDescription(rs.getString("description"));
                }
            }
        } catch (SQLException e) {
            // Best practice: Print the stack trace for full debugging information
            System.err.println("Cannot get Dish by Id. SQL Error: " + e.getMessage());
            e.printStackTrace();
        }

        return dish;
    }

    public ArrayList<Dish> getDishList(String str) {
        ArrayList<Dish> dishList = new ArrayList<>();

        String sql = "SELECT * FROM tbldish WHERE LOWER(dishname) like ?";

        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, "%" + str.toLowerCase() + "%");
            System.out.println(pstmt);
            int count = 0;

            try (ResultSet rs = pstmt.executeQuery()) {
                while(rs.next()) {
                    Dish dish = new Dish();
                    dish.setId(rs.getInt("id"));
                    dish.setDishname(rs.getString("dishname"));
                    dish.setDishprice(rs.getFloat("dishprice"));
                    dish.setDescription(rs.getString("description"));

                    dishList.add(dish);
                    count++;
                }

                System.out.println(rs.next());
                System.out.println("count the result: " + count);
            }
        } catch (SQLException e) {
            System.err.println("Cannot get Dish List by search token. SQL Error: " + e.getMessage());
        }

        return dishList;
    }
}

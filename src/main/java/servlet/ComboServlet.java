package servlet;

import DAO.ComboDAO;
import DAO.DAO;
import DAO.DishDAO;
import DAO.ComboDishDAO;
import Model.Combo;
import Model.ComboDish;
import Model.Dish;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet(name="ComboServlet", urlPatterns = {"/combo"})
public class ComboServlet extends HttpServlet {
    private ComboDAO comboDAO;
    private DishDAO dishDAO;
    private ComboDishDAO comboDishDAO;

    // Tên thuộc tính Session để lưu danh sách món ăn tạm thời
    private static final String SELECTED_DISHES_SESSION = "selectedDishList";

    @Override
    public void init() throws ServletException {
        try {
            comboDAO = new ComboDAO();
            dishDAO = new DishDAO();
            comboDishDAO = new ComboDishDAO();
        } catch (ClassNotFoundException | SQLException e) {
            System.out.println("Failed to init ComboServlet when create DAOs");
            throw new ServletException("Failed to initialize DAOs.", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");
        String targetJSP = "addComboView.jsp";

        HttpSession session = request.getSession();

        // Đảm bảo Map luôn được khởi tạo trong session
        Map<Dish, Integer> selectedDishes = (Map<Dish, Integer>) session.getAttribute(SELECTED_DISHES_SESSION);
        if (selectedDishes == null) {
            // Dùng LinkedHashMap để giữ thứ tự chèn
            selectedDishes = new LinkedHashMap<>();
            session.setAttribute(SELECTED_DISHES_SESSION, selectedDishes);
        }

        if(action == null) {
            //Hien thi trang lan dau: target van la manageCombo.jsp
            handleManageCombo(request, response);
            return;
        } else if(action.equals("add_dish")) {
            handleAddDishToCombo(request, selectedDishes);
        } else if(action.equals("remove_dish")) {
            handleRemoveDishFromCombo(request, selectedDishes);
        } else if(action.equals("update_quantity")) {
            handleUpdateDishQuantity(request, selectedDishes);
        } else if(action.equals("manage_combo")) {
            handleManageCombo(request, response);
            return;
        }

        request.setAttribute("selectedDishMap", selectedDishes); // Truyền lại Map sang JSP
        RequestDispatcher dispatcher = request.getRequestDispatcher(targetJSP);
        dispatcher.forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
        request.setCharacterEncoding("UTF-8");
        String action = request.getParameter("action");

        if(action != null && action.equals("add")) {
            handleAddCombo(request, response);
        } else if ("delete".equals(action)){
            handleDeleteCombo(request, response);
        }else {
            doGet(request, response);
        }

    }

    // --- Hiển thị danh sách Combo ---
    private void handleManageCombo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        List<Combo> comboList = comboDAO.getAllCombo();
        request.setAttribute("comboList", comboList);
        RequestDispatcher dispatcher = request.getRequestDispatcher("manageComboView.jsp");
        dispatcher.forward(request, response);
    }

    private void handleDeleteCombo(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int comboId = Integer.parseInt(request.getParameter("comboId"));

            boolean success = comboDAO.deleteComboById(comboId);

            if (success) {
                request.setAttribute("successMessage", "Xóa combo thành công!");
            } else {
                request.setAttribute("errorMessage", "Không thể xóa combo (có thể combo không tồn tại).");
            }

        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "ID combo không hợp lệ.");
        }

        // Sau khi xóa xong → hiển thị lại danh sách combo
        handleManageCombo(request, response);
    }

    // --- Logic Xử lý Món ăn trong Combo (Session) ---
    private void handleAddDishToCombo(HttpServletRequest request, Map<Dish, Integer> selectedDishes) {
        try {
            int dishId = Integer.parseInt(request.getParameter("dishId"));
            Dish dish= dishDAO.getDish(dishId);

            if(dish != null) {
                // Duyệt qua Key Set để tìm Dish trùng ID (giả định Dish có equals/hashCode dựa trên ID)
                boolean alreadyExists = selectedDishes.keySet().stream().anyMatch(d -> d.getId() == dishId);

                if(!alreadyExists) {
                    selectedDishes.put(dish, 1);
                }
            } else {
                request.setAttribute("errorMessage", "Không tìm thấy món ăn với ID: " + dishId);
            }
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "ID món ăn không hợp lệ.");
        }
    }

    private void handleRemoveDishFromCombo(HttpServletRequest request, Map<Dish, Integer> selectedDishes) {
        try {
            int dishId = Integer.parseInt(request.getParameter("dishId"));

            selectedDishes.keySet().stream().filter(d -> d.getId() == dishId).findFirst().ifPresent(selectedDishes::remove);
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "ID món ăn không hợp lệ.");
        }
    }

    private void handleUpdateDishQuantity(HttpServletRequest request, Map<Dish, Integer> selectedDishes) {
        try {
            int dishId = Integer.parseInt(request.getParameter("dishId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));

            if (quantity <= 0) {
                request.setAttribute("errorMessage", "Số lượng phải lớn hơn 0.");
                return;
            }

            selectedDishes.keySet().stream().filter(d -> d.getId() == dishId).findFirst().ifPresent(dishToUpdate -> selectedDishes.put(dishToUpdate, quantity));
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "ID hoặc số lượng không hợp lệ.");
        }
    }

    private void handleAddCombo(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        Map<Dish, Integer> selectedDishesMap = (Map<Dish, Integer>) session.getAttribute(SELECTED_DISHES_SESSION);

        if (selectedDishesMap == null || selectedDishesMap.isEmpty()) {
            request.setAttribute("errorMessage", "Combo phải có ít nhất một món ăn.");
            doGet(request, response);
            return;
        }

        String comboName = request.getParameter("comboname");
        float comboPrice;
        try {
            comboPrice = Float.parseFloat(request.getParameter("comboprice"));
        } catch (NumberFormatException e) {
            request.setAttribute("errorMessage", "Giá Combo không hợp lệ.");
            doGet(request, response);
            return;
        }

        Connection conn = null;
        try {
            //Lay connection chung tu dao -> tranh bi trung lap
            conn = comboDAO.getConnection();
            conn.setAutoCommit(false); // bắt đầu transaction

            // 🔹 2. Lưu combo trước
            Combo newCombo = new Combo();
            newCombo.setComboname(comboName);
            newCombo.setComboprice(comboPrice);

            Combo savedCombo = comboDAO.saveCombo(newCombo);

            
            for (Map.Entry<Dish, Integer> entry : selectedDishesMap.entrySet()) {
                ComboDish comboDish = new ComboDish(entry.getValue(), entry.getKey().getId(), savedCombo.getId());
                
                ComboDish savedCoDish = comboDishDAO.addDishToCombo(comboDish);
            }



            // 🔹 4. Commit transaction
            conn.commit();

            // 🔹 5. Dọn dẹp session & gửi thông báo
            session.removeAttribute(SELECTED_DISHES_SESSION);
            request.setAttribute("successMessage", "Tạo Combo thành công!");
        } catch (Exception e) {
            if(conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    System.out.println("Rollback thất bại: " + ex.getMessage());
                }
            }

            request.setAttribute("errorMessage", "Lỗi khi tạo combo: " + e.getMessage());
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            }
        }
        doGet(request, response);
    }
}

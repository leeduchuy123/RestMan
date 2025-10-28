package servlet;

import DAO.ComboDAO;
import DAO.DishDAO;
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
import java.sql.SQLException;
import java.util.*;

@WebServlet(name="ComboServlet", urlPatterns = {"/combo"})
public class ComboServlet extends HttpServlet {
    private ComboDAO comboDAO;
    private DishDAO dishDAO;

    // Tên thuộc tính Session để lưu danh sách món ăn tạm thời
    private static final String SELECTED_DISHES_SESSION = "selectedDishList";

    @Override
    public void init() throws ServletException {
        try {
            comboDAO = new ComboDAO();
            dishDAO = new DishDAO();
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
            //Hien thi trang lan dau: target van la addComboView.jsp
        } else if(action.equals("add_dish")) {
            handleAddDishToCombo(request, selectedDishes);
        } else if(action.equals("remove_dish")) {
            handleRemoveDishFromCombo(request, selectedDishes);
        } else if(action.equals("update_quantity")) {
            handleUpdateDishQuantity(request, selectedDishes);
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
        } else {
            doGet(request, response);
        }

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

        // 1. Tạo đối tượng Combo
        Combo newCombo = new Combo();
        newCombo.setComboname(comboName);
        newCombo.setComboprice(comboPrice);

        Combo savedCombe = comboDAO.saveCombo(newCombo);
        System.out.println("Save combo successful");
    }
}

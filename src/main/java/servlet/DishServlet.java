package servlet;

import dao.DishDAO;
import model.Dish;
import com.google.gson.Gson;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;

@WebServlet(name="DishServlet", urlPatterns = {"/dish"})
public class DishServlet extends HttpServlet {
    private DishDAO dishDAO;
    private final Gson gson = new Gson();

    @Override
    public void init() throws ServletException {
        try {
            // Instantiate the DAO when the servlet starts
            dishDAO = new DishDAO();
        } catch (ClassNotFoundException | SQLException e) {
            System.err.println("Failed to initialize DishDAO.");
            throw new ServletException("Initialization error.", e);
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        //Make sure encoding UTF-8
        request.setCharacterEncoding("UTF-8");

        String searchToken = request.getParameter("searching_token");
        String dishIdParam = request.getParameter("id");

        boolean isAjax = "true".equals(request.getParameter("ajax_request"));

        String targetJSP;

        if(searchToken != null) {
            ArrayList<Dish> dishList = dishDAO.getDishList(searchToken.toLowerCase());
            if(isAjax) {
                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");

                String jsonResponse = gson.toJson(dishList);
                response.getWriter().write(jsonResponse);

                return;
            }
            request.setAttribute("dishList", dishList);
            targetJSP = "findingDishView.jsp";
        } else if(dishIdParam != null) {
            handleDishDetail(request, dishIdParam);
            targetJSP = "dishDetailView.jsp";
        } else {
            //If no search token, pass empty string to show all dishes
            handleDishSearch(request, "");
            targetJSP = "findingDishView.jsp";

            //debug
            String sessionAuth = request.getSession().getAttribute("username").toString();
            System.out.println("This is the user: " + sessionAuth);
        }

        //Forward the request and response
        RequestDispatcher dispatcher = request.getRequestDispatcher("/customer/" + targetJSP);
        dispatcher.forward(request, response);

        //dùng requestDispatcher vì request có thể được giữ nguyên, và chuyển tiếp "nội bộ"
    }

    private void handleDishSearch(HttpServletRequest request, String searchToken) {
        ArrayList<Dish> dishList = dishDAO.getDishList(searchToken.toLowerCase());
        request.setAttribute("dishList", dishList);
    }

    private void handleDishDetail(HttpServletRequest request, String id) {
        try {
            int dishId = Integer.parseInt(id);
            Dish dish = dishDAO.getDish(dishId);

            request.setAttribute("dishDetail", dish);
        } catch(NumberFormatException e) {
            System.out.println("Invalid dish ID format: " + id);
            request.setAttribute("error_message", "Invalid dish ID format.");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        doGet(request, response);
    }
}

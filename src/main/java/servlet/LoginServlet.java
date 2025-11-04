package servlet;

import DAO.UserDAO;
import Model.LoginBean;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDAO userDAO;

    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // The JSP path must be relative to the webapp folder.
        // It points to /webapp/common/login.jsp
        request.getRequestDispatcher("/common/login.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        LoginBean loginBean = new LoginBean(username, password);

        try{
            String ans = userDAO.checkLogin(loginBean);
            if(!"unvalidate".equals(ans)) {
                //Get the current session (create one if it doesn't exit)
                HttpSession session = request.getSession();

                //Store authentication info in session
                session.setAttribute("username", username);
                session.setAttribute("isAuthenticated", true);
                session.setAttribute("role", ans);

                if("MANAGER".equals(ans)) {
                    response.sendRedirect(request.getContextPath() + "/manager/managerView.jsp");
                } else if("CUSTOMER".equals(ans)) {
                    response.sendRedirect( request.getContextPath() + "/customer/customerView.jsp");
                }

//                String sessionAuth = session.getAttribute("username").toString();
//                System.out.println(sessionAuth);
            } else {
                // FAILURE: Set an error message and FORWARD back to the login page
                request.setAttribute("error", "Invalid username or password."); // Set error message
                    request.getRequestDispatcher("/common/login.jsp").forward(request, response);

                // *** DO NOT USE response.sendRedirect("login.jsp"); here ***
                // It's bad practice, you lose the error message, and the path is likely wrong.
            }
        } catch(ClassNotFoundException e) {
            e.printStackTrace();
            response.getWriter().println("Database driver error.");
        }
    }
}

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package AuthenController;

import dal.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.GoogleAccount;
import model.User;

/**
 *
 * @author FPT
 */
public class LoginGoogleServlet extends HttpServlet {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession();
        UserDAO userDAO = new UserDAO();
        String code = request.getParameter("code");
        GoogleLogin google = new GoogleLogin();
        String accessToken = google.getToken(code);
        System.out.println(accessToken);
        GoogleAccount account = google.getUserInfo(accessToken);
        System.out.println(account);
        UserDAO daoUser = new UserDAO();

        try {
            User us = daoUser.convert(account);
            User usDB = userDAO.getUserByEmail(us.getEmail());
            if (usDB == null) {
                daoUser.saveGoogleAccount(us);
                usDB = userDAO.getUserByEmail(us.getEmail());
            }
            session.setAttribute("us", usDB);
            session.setMaxInactiveInterval(60 * 60 * 24);
        } catch (Exception e) {
            e.printStackTrace(); // Print the stack trace to debug any issues
        }

        // Redirect or forward as necessary
        request.getRequestDispatcher("home").forward(request, response);
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

}

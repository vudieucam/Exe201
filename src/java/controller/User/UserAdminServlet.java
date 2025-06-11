/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.User;

import dal.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.UnsupportedEncodingException;
import java.util.List;
import model.User;

/**
 *
 * @author FPT
 */
public class UserAdminServlet extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    // Thay đổi các phương thức doGet và doPost để sử dụng đúng đường dẫn
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        String action = request.getParameter("action");

        try {
            if (action == null) {
                listUsers(request, response);
            } else {
                switch (action) {

                    case "delete":
                        deleteUser(request, response);
                        break;
                    case "deactivate":
                        deactivateUser(request, response);
                        break;
                    default:
                        listUsers(request, response);
                        break;
                }
            }
        } catch (Exception ex) {
            ex.printStackTrace(); // thêm dòng này nếu chưa có
            throw new ServletException(ex);
        }

    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        String action = request.getParameter("action");

        try {
            if (action == null) {
                listUsers(request, response);
            } else {
                switch (action) {
                    case "insert":
                        insertUser(request, response);
                        break;
                    case "update":
                        updateUser(request, response);
                        break;
                    default:
                        listUsers(request, response);
                        break;
                }
            }
        } catch (Exception ex) {
            ex.printStackTrace(); // thêm dòng này nếu chưa có
            throw new ServletException(ex);
        }

    }

    private void listUsers(HttpServletRequest request, HttpServletResponse response)
            throws Exception, ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        List<User> users = userDAO.getAllUsers();
        request.setAttribute("users", users);
        request.getRequestDispatcher("/userAdmin.jsp").forward(request, response);
    }

    private void insertUser(HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        User newUser = extractUserFromRequest(request);

        if (userDAO.checkEmailExists(newUser.getEmail())) {
            // Nếu là yêu cầu từ modal, bạn nên redirect về lại trang và hiển thị thông báo lỗi
            request.setAttribute("errorMessage", "Email đã tồn tại. Vui lòng chọn email khác.");
            listUsers(request, response); // hoặc forward lại trang userAdmin.jsp
            return;
        }

        userDAO.addUser(newUser);
        response.sendRedirect("useradmin");
    }

    private void updateUser(HttpServletRequest request, HttpServletResponse response)
            throws Exception, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        User user = extractUserFromRequest(request);
        user.setId(Integer.parseInt(request.getParameter("id")));
        userDAO.updateUser(user);
        response.sendRedirect("useradmin");
    }

    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
            throws Exception, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        int id = Integer.parseInt(request.getParameter("id"));
        userDAO.deleteUser(id);
        response.sendRedirect("useradmin");
    }

    private void deactivateUser(HttpServletRequest request, HttpServletResponse response)
            throws Exception, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        int id = Integer.parseInt(request.getParameter("id"));
        userDAO.deactivateUser(id);
        response.sendRedirect("useradmin");
    }

    private User extractUserFromRequest(HttpServletRequest request) throws UnsupportedEncodingException {
        request.setCharacterEncoding("UTF-8");
        User user = new User();
        user.setEmail(request.getParameter("email"));
        // Chỉ cập nhật password nếu có giá trị (khi thêm mới hoặc thay đổi password)
        String password = request.getParameter("password");
        if (password != null && !password.isEmpty()) {
            user.setPassword(password);
        }
        user.setFullname(request.getParameter("fullname"));
        user.setPhone(request.getParameter("phone"));
        user.setAddress(request.getParameter("address"));
        user.setRoleId(Integer.parseInt(request.getParameter("role_id")));
        user.setStatus(Boolean.parseBoolean(request.getParameter("status")));

        // Xử lý service_package_id có thể null
        String servicePackageId = request.getParameter("service_package_id");
        if (servicePackageId != null && !servicePackageId.isEmpty()) {
            user.setServicePackageId(Integer.parseInt(servicePackageId));
        } else {
            user.setServicePackageId(0); // hoặc giá trị mặc định
        }

        return user;
    }

}

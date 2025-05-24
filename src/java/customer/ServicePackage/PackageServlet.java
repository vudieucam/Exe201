/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package customer.ServicePackage;

import dal.PackageDAO;
import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;
import model.ServicePackage;
import model.User;

public class PackageServlet extends HttpServlet {

    private PackageDAO PackageDAO = new PackageDAO();
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<ServicePackage> packages = PackageDAO.getAllPackages();
            request.setAttribute("packages", packages);

            // Debug
            System.out.println("Số lượng gói: " + packages.size());
            packages.forEach(p -> System.out.println(p.getName()));

        } catch (SQLException e) {
            request.setAttribute("error", "Không thể tải danh sách gói: " + e.getMessage());
            e.printStackTrace();
        }
        request.getRequestDispatcher("pricing.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");

        if (action != null && action.equals("register")) {
            registerPackage(request, response);
        } else {
            response.sendRedirect("pricing.jsp");
        }
    }

    private void registerPackage(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        try {
            int packageId = Integer.parseInt(request.getParameter("packageId"));

            // Kiểm tra nếu user đã đăng ký gói này rồi
            if (user.getServicePackageId() != null && user.getServicePackageId() == packageId) {
                request.setAttribute("notification", "Bạn đã đăng ký gói này rồi!");
                reloadPackages(request, response);
                return;
            }

            // Kiểm tra nếu user đang cố downgrade gói
            if (user.getServicePackageId() != null && user.getServicePackageId() > packageId) {
                request.setAttribute("notification", "Bạn không thể chuyển xuống gói thấp hơn!");
                reloadPackages(request, response);
                return;
            }

            // Đăng ký gói mới
            boolean success = PackageDAO.registerPackage(user.getId(), packageId);

            if (success) {
                // Cập nhật thông tin user trong session
                user.setServicePackageId(packageId);
                session.setAttribute("user", user);
                request.setAttribute("notification", "Đăng ký gói dịch vụ thành công!");
            } else {
                request.setAttribute("notification", "Đăng ký gói dịch vụ thất bại. Vui lòng thử lại!");
            }

            reloadPackages(request, response);

        } catch (NumberFormatException | SQLException e) {
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            reloadPackages(request, response);
        }
    }

    private void reloadPackages(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            List<ServicePackage> packages = PackageDAO.getAllPackages();
            request.setAttribute("packages", packages);
        } catch (SQLException e) {
            request.setAttribute("error", "Không thể tải danh sách gói: " + e.getMessage());
        }
        request.getRequestDispatcher("pricing.jsp").forward(request, response);
    }
}

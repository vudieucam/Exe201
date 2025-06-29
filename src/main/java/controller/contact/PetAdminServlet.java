/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.contact;

import dal.PetCategoryDAO;
import dal.PetDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import java.io.File;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.List;
import java.util.UUID;
import model.Pet;
import model.PetCategory;

/**
 *
 * @author FPT
 */
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, // 2MB
        maxFileSize = 1024 * 1024 * 10, // 10MB
        maxRequestSize = 1024 * 1024 * 50)   // 50MB
public class PetAdminServlet extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet PetAdminServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet PetAdminServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    private final String UPLOAD_DIR = "uploads/pet_images";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        PetDAO petDAO = new PetDAO();
        PetCategoryDAO categoryDAO = new PetCategoryDAO();

        try {
            if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                petDAO.delete(id);
                response.sendRedirect("petadmin");
                return;
            }

            if ("toggle".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                petDAO.toggleStatus(id);
                response.sendRedirect("petadmin");
                return;
            }

            if ("deleteCat".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                categoryDAO.delete(id);
                response.sendRedirect("petadmin");
                return;
            }

            if ("toggleCat".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                categoryDAO.toggleStatus(id);
                response.sendRedirect("petadmin");
                return;
            }

            // ⚠️ Đây là phần cần try-catch nếu getAllActivePetsAdmin() throws SQLException
            List<Pet> pets = petDAO.getAllActivePetsAdmin();
            List<PetCategory> categories = categoryDAO.getAll();

            request.setAttribute("pets", pets);
            request.setAttribute("categories", categories);
            request.getRequestDispatcher("petAdmin.jsp").forward(request, response);

        } catch (SQLException e) {
            throw new ServletException("Lỗi SQL khi tải danh sách thú cưng hoặc danh mục", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        PetDAO petDAO = new PetDAO();
        PetCategoryDAO categoryDAO = new PetCategoryDAO();
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            String name = request.getParameter("name");
            int categoryId = Integer.parseInt(request.getParameter("categoryId"));
            String gender = request.getParameter("gender");
            String breed = request.getParameter("breed");
            String color = request.getParameter("color");
            String description = request.getParameter("description");

            int age = 0;
            double weight = 0.0;

            try {
                age = Integer.parseInt(request.getParameter("age"));
                weight = Double.parseDouble(request.getParameter("weight"));
            } catch (NumberFormatException e) {
                try {
                    request.setAttribute("error", "Tuổi hoặc cân nặng không hợp lệ.");
                    request.setAttribute("categories", categoryDAO.getAll());
                    request.setAttribute("pets", petDAO.getAllActivePetsAdmin()); // throws SQLException
                    request.getRequestDispatcher("petAdmin.jsp").forward(request, response);
                } catch (SQLException ex) {
                    throw new ServletException("Lỗi SQL khi tải lại danh sách pet và category", ex);
                }
                return;
            }

            // upload ảnh
            Part imagePart = request.getPart("image");
            String imageName = uploadImage(imagePart, request);

            Pet p = new Pet();
            p.setName(name);
            p.setCategoryId(categoryId);
            p.setGender(gender);
            p.setAge(age);
            p.setBreed(breed);
            p.setColor(color);
            p.setWeight(weight);
            p.setDescription(description);
            p.setPrimaryImage(imageName);
            p.setCreatedAt(new Timestamp(System.currentTimeMillis()));
            p.setStatus(true);

            petDAO.insert(p);
        }

        response.sendRedirect("petadmin");
    }

    private String uploadImage(Part part, HttpServletRequest request) throws IOException {
        String fileName = UUID.randomUUID() + "_" + part.getSubmittedFileName();
        String appPath = request.getServletContext().getRealPath("");
        String savePath = appPath + File.separator + UPLOAD_DIR;

        File fileSaveDir = new File(savePath);
        if (!fileSaveDir.exists()) {
            fileSaveDir.mkdirs();
        }

        part.write(savePath + File.separator + fileName);
        return UPLOAD_DIR + "/" + fileName;
    }
}

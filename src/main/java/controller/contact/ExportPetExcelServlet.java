/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.contact;

import dal.PetDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.OutputStream;
import java.sql.SQLException;
import java.util.List;
import model.Pet;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

/**
 *
 * @author FPT
 */
public class ExportPetExcelServlet extends HttpServlet {

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
            out.println("<title>Servlet ExportPetExcelServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ExportPetExcelServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        PetDAO dao = new PetDAO();
        List<Pet> pets;

        try {
            pets = dao.getAllActivePetsAdmin(); // ⚠ Nếu throws SQLException thì cần catch
        } catch (SQLException e) {
            throw new ServletException("Lỗi khi truy vấn dữ liệu thú cưng", e);
        }

        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("Danh sách thú cưng");
        Row header = sheet.createRow(0);

        String[] columns = {"ID", "Tên", "Tuổi", "Giới tính", "Danh mục", "Màu lông", "Cân nặng", "Giống", "Trạng thái"};
        for (int i = 0; i < columns.length; i++) {
            Cell cell = header.createCell(i);
            cell.setCellValue(columns[i]);
        }

        int rowIdx = 1;
        for (Pet p : pets) {
            Row row = sheet.createRow(rowIdx++);
            row.createCell(0).setCellValue(p.getId());
            row.createCell(1).setCellValue(p.getName());
            row.createCell(2).setCellValue(p.getAge());
            row.createCell(3).setCellValue(p.getGender());
            row.createCell(4).setCellValue(p.getCategoryName());
            row.createCell(5).setCellValue(p.getColor());
            row.createCell(6).setCellValue(p.getWeight());
            row.createCell(7).setCellValue(p.getBreed());
            row.createCell(8).setCellValue(p.isStatus() ? "Hiển thị" : "Ẩn");
        }

        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=pets.xlsx");

        try (OutputStream out = response.getOutputStream()) {
            workbook.write(out);
        } finally {
            workbook.close();
        }
    }

}

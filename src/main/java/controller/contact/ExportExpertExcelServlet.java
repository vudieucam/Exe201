/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.contact;

import dal.ExpertDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Expert;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

/**
 *
 * @author FPT
 */
public class ExportExpertExcelServlet extends HttpServlet {

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
            out.println("<title>Servlet ExportExpertExcelServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ExportExpertExcelServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            ExpertDAO edao = new ExpertDAO();
            List<Expert> experts = edao.getAllExperts();  // đã JOIN partners

            Workbook workbook = new XSSFWorkbook();
            Sheet sheet = workbook.createSheet("Danh sách Chuyên Gia");

            // Header
            String[] headers = {
                "STT", "Họ tên", "Vị trí", "Tiểu sử", "Facebook", "Instagram", "Twitter", "Google",
                "Trạng thái", "Ngày tạo",
                "Đối tác", "Email đối tác", "Quốc gia", "Loại đối tác"
            };
            Row header = sheet.createRow(0);
            for (int i = 0; i < headers.length; i++) {
                header.createCell(i).setCellValue(headers[i]);
            }

            // Ghi dữ liệu
            int rowIndex = 1;
            for (Expert e : experts) {
                Row row = sheet.createRow(rowIndex++);
                row.createCell(0).setCellValue(rowIndex - 1); // STT
                row.createCell(1).setCellValue(e.getFullName());
                row.createCell(2).setCellValue(e.getPosition());
                row.createCell(3).setCellValue(e.getBio());
                row.createCell(4).setCellValue(e.getFacebookUrl());
                row.createCell(5).setCellValue(e.getInstagramUrl());
                row.createCell(6).setCellValue(e.getTwitterUrl());
                row.createCell(7).setCellValue(e.getGoogleUrl());
                row.createCell(8).setCellValue(e.isStatus() ? "Hiển thị" : "Đã ẩn");
                row.createCell(9).setCellValue(e.getCreatedAt() != null ? e.getCreatedAt().toString() : "");

                if (e.getPartner() != null) {
                    row.createCell(10).setCellValue(e.getPartner().getName());
                    row.createCell(11).setCellValue(e.getPartner().getEmail());
                    row.createCell(12).setCellValue(e.getPartner().getCountry());
                    row.createCell(13).setCellValue(e.getPartner().getPartnerType());
                } else {
                    row.createCell(10).setCellValue("");
                    row.createCell(11).setCellValue("");
                    row.createCell(12).setCellValue("");
                    row.createCell(13).setCellValue("");
                }
            }

            // Xuất response
            resp.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            resp.setHeader("Content-Disposition", "attachment; filename=ChuyenGia_PetTech.xlsx");
            workbook.write(resp.getOutputStream());
            workbook.close();
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(500, "Lỗi khi xuất Excel: " + e.getMessage());
        }
    }

}

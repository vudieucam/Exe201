/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.contact;

import dal.PartnerDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.util.List;
import model.Partner;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Row;

import org.apache.poi.xssf.usermodel.XSSFWorkbook;

/**
 *
 * @author FPT
 */
public class ExportPartnerExcelServlet extends HttpServlet {
   
    /** 
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code> methods.
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
            out.println("<title>Servlet ExportPartnerExcelServlet</title>");  
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet ExportPartnerExcelServlet at " + request.getContextPath () + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    } 

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            PartnerDAO dao = new PartnerDAO();
            List<Partner> partners = dao.getAll(); // Lấy tất cả đối tác

            Workbook workbook = new XSSFWorkbook();
            Sheet sheet = workbook.createSheet("Danh sách Đối tác");

            // Header
            Row header = sheet.createRow(0);
            String[] columns = {
                "ID", "Tên", "Email", "Phone", "Địa chỉ", "Mô tả",
                "Loại", "Quốc gia", "Ngày hợp tác", "Dự án", "Website", "Logo URL", "Trạng thái", "Ngày tạo"
            };
            for (int i = 0; i < columns.length; i++) {
                header.createCell(i).setCellValue(columns[i]);
            }

            // Data rows
            int rowIndex = 1;
            for (Partner p : partners) {
                Row row = sheet.createRow(rowIndex++);
                row.createCell(0).setCellValue(p.getId());
                row.createCell(1).setCellValue(p.getName());
                row.createCell(2).setCellValue(p.getEmail());
                row.createCell(3).setCellValue(p.getPhone());
                row.createCell(4).setCellValue(p.getAddress());
                row.createCell(5).setCellValue(p.getDescription());
                row.createCell(6).setCellValue(p.getPartnerType());
                row.createCell(7).setCellValue(p.getCountry());
                row.createCell(8).setCellValue(p.getPartnershipDate() != null ? p.getPartnershipDate().toString() : "");
                row.createCell(9).setCellValue(p.getProjectCount());
                row.createCell(10).setCellValue(p.getWebsite());
                row.createCell(11).setCellValue(p.getLogoUrl());
                row.createCell(12).setCellValue(p.isStatus() ? "Đang hợp tác" : "Ngừng hợp tác");
                row.createCell(13).setCellValue(p.getCreatedAt() != null ? p.getCreatedAt().toString() : "");
            }

            // Cấu hình header response
            resp.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            resp.setHeader("Content-Disposition", "attachment; filename=DoiTac_PetTech.xlsx");

            workbook.write(resp.getOutputStream());
            workbook.close();
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(500, "Lỗi khi xuất file Excel");
        }
    }

}

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.Partner;

import dal.ExpertDAO;
import dal.PartnerDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.sql.Date;
import java.sql.SQLIntegrityConstraintViolationException;
import java.util.List;
import model.Expert;
import model.Partner;

/**
 *
 * @author FPT
 */
public class PartnerAdminServlet extends HttpServlet {

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
            out.println("<title>Servlet PartnerAdminServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet PartnerAdminServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }

    private static final int PAGE_SIZE = 10;

    /* ------------ GET: hiển thị ------------ */
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            req.setCharacterEncoding("UTF-8");
            PartnerDAO dao = new PartnerDAO();

            int page = 1;
            String p = req.getParameter("page");
            if (p != null && p.matches("\\d+")) {
                page = Integer.parseInt(p);
            }

            int total = dao.countAll();
            int totalPages = Math.max(1, (int) Math.ceil(total * 1.0 / PAGE_SIZE));
            page = Math.max(1, Math.min(page, totalPages));

            /* data */
            req.setAttribute("partners", dao.getPage(page, PAGE_SIZE));
            req.setAttribute("types", dao.getDistinctPartnerTypes());
            req.setAttribute("countries", dao.getDistinctCountries());
            req.setAttribute("totalPartners", total);
            req.setAttribute("activePartners", dao.countByStatus(true));
            req.setAttribute("inactivePartners", dao.countByStatus(false));
            req.setAttribute("currentPage", page);
            req.setAttribute("totalPages", totalPages);

            ExpertDAO edao = new ExpertDAO();
            List<Expert> experts = edao.getAllExpertsAdmin();  // cần chính xác tên hàm
            req.setAttribute("experts", experts);

            req.getRequestDispatcher("partnersAdmin.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendError(500);
        }
    }

    /* ------------ POST: add / edit / delete / toggle ------------ */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        String action = req.getParameter("action");
        String error = null;

        try {
            PartnerDAO dao = new PartnerDAO();
            ExpertDAO edao = new ExpertDAO();
            switch (action) {
                case "add" ->
                    dao.insert(extractPartner(req));
                case "edit" -> {
                    Partner p = extractPartner(req);
                    p.setId(Integer.parseInt(req.getParameter("id")));
                    dao.update(p);
                }
                case "delete" ->
                    dao.delete(Integer.parseInt(req.getParameter("id")));
                case "toggle" ->
                    dao.toggleStatus(
                            Integer.parseInt(req.getParameter("id")),
                            Boolean.parseBoolean(req.getParameter("status")));
                case "editExpert" -> {
                    Expert e = extractExpert(req);
                    e.setId(Integer.parseInt(req.getParameter("id")));
                    edao.update(e);
                }
                case "toggleExpertStatus" -> {
                    int id = Integer.parseInt(req.getParameter("id"));
                    boolean status = Boolean.parseBoolean(req.getParameter("status"));
                    edao.toggleStatus(id, status);
                }
                case "deleteExpert" -> {
                    int id = Integer.parseInt(req.getParameter("id"));
                    edao.delete(id);
                }
                case "addExpert" -> {
                    Expert e = extractExpert(req);
                    edao.insert(e);
                }

            }
        } catch (SQLIntegrityConstraintViolationException dup) {
            error = "Email đối tác đã tồn tại!";
        } catch (Exception ex) {
            error = "Lỗi: " + ex.getMessage();
        }

        if (error != null) {
            req.setAttribute("error", error);
            doGet(req, resp);                            // forward lại kèm lỗi
        } else {
            resp.sendRedirect("partneradmin?page=" + req.getParameter("page"));
        }
    }

    /* ------------ helper ------------ */
    private Partner extractPartner(HttpServletRequest r) {
        Partner p = new Partner();
        p.setName(r.getParameter("name"));
        p.setEmail(r.getParameter("email"));
        p.setPhone(r.getParameter("phone"));
        p.setAddress(r.getParameter("address"));
        p.setDescription(r.getParameter("description"));
        p.setPartnerType(r.getParameter("partner_type"));      // tiếng Việt
        p.setCountry(r.getParameter("country"));

        String d = r.getParameter("partnership_date");
        p.setPartnershipDate((d == null || d.isBlank()) ? null : Date.valueOf(d));

        p.setProjectCount(Integer.parseInt(r.getParameter("project_count")));
        p.setLogoUrl(r.getParameter("logo_url"));
        p.setWebsite(r.getParameter("website"));
        p.setStatus("active".equals(r.getParameter("status")));
        return p;
    }

    private Expert extractExpert(HttpServletRequest r) {
        Expert e = new Expert();
        e.setFullName(r.getParameter("full_name"));
        e.setPosition(r.getParameter("position"));
        e.setBio(r.getParameter("bio"));
        e.setImageUrl(r.getParameter("image_url"));
        e.setFacebookUrl(r.getParameter("facebook_url"));
        e.setTwitterUrl(r.getParameter("twitter_url"));
        e.setInstagramUrl(r.getParameter("instagram_url"));
        e.setGoogleUrl(r.getParameter("google_url"));
        e.setStatus(true);

        int pid = Integer.parseInt(r.getParameter("partner_id"));
        Partner p = new Partner();
        p.setId(pid);
        e.setPartner(p);

        return e;
    }

}

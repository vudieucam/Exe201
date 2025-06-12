/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.Admin;

import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebListener;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSessionEvent;
import jakarta.servlet.http.HttpSessionListener;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Timestamp;
import java.util.concurrent.atomic.AtomicInteger;

/**
 *
 * @author FPT
 */
@WebListener
public class SessionTrackingListener implements HttpSessionListener {

    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            /* TODO output your page here. You may use following sample code. */
            out.println("<!DOCTYPE html>");
            out.println("<html>");
            out.println("<head>");
            out.println("<title>Servlet CourseDetailAdminServlet</title>");
            out.println("</head>");
            out.println("<body>");
            out.println("<h1>Servlet CourseDetailAdminServlet at " + request.getContextPath() + "</h1>");
            out.println("</body>");
            out.println("</html>");
        }
    }
    private static final AtomicInteger activeSessions = new AtomicInteger();

    public static int getActiveSessions() {
        return activeSessions.get();
    }

    @Override
    public void sessionCreated(HttpSessionEvent se) {
        activeSessions.incrementAndGet();
        se.getSession().setAttribute("sessionStartTime", System.currentTimeMillis());
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent se) {

        activeSessions.decrementAndGet();

        try {
            Long startTime = (Long) se.getSession().getAttribute("sessionStartTime");
            if (startTime == null) {
                return;
            }

            long duration = (System.currentTimeMillis() - startTime) / 1000;

            UserDAO userDAO = new UserDAO();
            Integer userId = (Integer) se.getSession().getAttribute("userId");

            String ip = se.getSession().getAttribute("ipAddress") != null
                    ? se.getSession().getAttribute("ipAddress").toString()
                    : "unknown";

            String ua = se.getSession().getAttribute("userAgent") != null
                    ? se.getSession().getAttribute("userAgent").toString()
                    : "unknown";

            userDAO.saveSessionInfo(
                    userId,
                    se.getSession().getId(),
                    ip,
                    ua,
                    new Timestamp(startTime),
                    new Timestamp(System.currentTimeMillis()),
                    (int) duration
            );
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}

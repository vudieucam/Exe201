/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller.Admin;

import dal.UserDAO;
import jakarta.servlet.annotation.WebListener;
import jakarta.servlet.http.HttpSessionEvent;
import jakarta.servlet.http.HttpSessionListener;
/**
 *
 * @author FPT
 */
public class SessionTrackingListener implements HttpSessionListener {

    @Override
    public void sessionCreated(HttpSessionEvent se) {
        // Ghi lại thời gian bắt đầu phiên
        se.getSession().setAttribute("sessionStartTime", System.currentTimeMillis());
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        // Tính toán thời gian phiên và lưu vào database
        long startTime = (Long) se.getSession().getAttribute("sessionStartTime");
        long duration = (System.currentTimeMillis() - startTime) / 1000; // tính bằng giây

        // Lưu vào bảng user_sessions
        UserDAO userDAO = new UserDAO();
        Integer userId = (Integer) se.getSession().getAttribute("userId");

        userDAO.saveSessionInfo(
                userId,
                se.getSession().getId(),
                se.getSession().getAttribute("ipAddress").toString(),
                se.getSession().getAttribute("userAgent").toString(),
                new java.sql.Timestamp(startTime),
                new java.sql.Timestamp(System.currentTimeMillis()),
                (int) duration
        );
    }
}

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package listener;

import jakarta.servlet.http.HttpServlet;

import jakarta.servlet.http.HttpSessionEvent;
import java.util.concurrent.atomic.AtomicInteger;

/**
 *
 * @author FPT
 */
public class SessionCounterListener extends HttpServlet {

    private static int activeSessions = 0;

    public static int getActiveSessions() {
        return activeSessions;
    }

    
    public void sessionCreated(HttpSessionEvent se) {
        activeSessions++;
        se.getSession().getServletContext().setAttribute("visitorCounter", 
            (Integer) se.getSession().getServletContext().getAttribute("visitorCounter") + 1);
    }

   
    public void sessionDestroyed(HttpSessionEvent se) {
        if (activeSessions > 0) {
            activeSessions--;
        }
    }

}

package controller.Admin;

import dal.CourseDAO;
import dal.PaymentDAO;
import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.*;
import model.*;

public class AdminServlet extends HttpServlet {

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
    private CourseDAO courseDAO;
    private PaymentDAO paymentDAO;
    private UserDAO userDAO;

    @Override
    public void init() throws ServletException {
        courseDAO = new CourseDAO();
        paymentDAO = new PaymentDAO();
        userDAO = new UserDAO();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || (user.getRoleId() != 2 && user.getRoleId() != 3)) {
            response.sendRedirect("authen?action=login");
            return;
        }

        try {
            DashboardStats stats = new DashboardStats();

            // Users
            stats.setTotalUsers((int) userDAO.countAllUsers());
            stats.setActiveUsers(userDAO.countActiveUsers());
            stats.setOnlineUsers(userDAO.countOnlineUsers());
            stats.setUserGrowth(userDAO.calculateUserGrowth());

            // User Distribution
            Map<String, Integer> userActivity = userDAO.getUserDistribution();
            UserActivity ua = new UserActivity(
                    userActivity.getOrDefault("regularUsers", 0),
                    userActivity.getOrDefault("premiumUsers", 0),
                    userActivity.getOrDefault("adminUsers", 0),
                    userActivity.getOrDefault("staffUsers", 0)
            );
            stats.setUserActivity(ua);

            // Revenue
            stats.setMonthlyRevenue(BigDecimal.valueOf(paymentDAO.getMonthlyRevenue()));
            stats.setTotalRevenue(BigDecimal.valueOf(paymentDAO.getTotalRevenue()));

            // Most Viewed Courses
            List<Map<String, Object>> viewedRaw = courseDAO.getMostViewedCourses(5);
            List<CourseStat> mostViewed = new ArrayList<>();
            for (Map<String, Object> row : viewedRaw) {
                mostViewed.add(new CourseStat(
                        (String) row.get("title"),
                        ((Number) row.get("views")).intValue(),
                        ((Number) row.get("avgViewDuration")).intValue()
                ));
            }
            stats.setMostViewedCourses(mostViewed);

            // Highest Rated Courses
            List<Map<String, Object>> ratedRaw = courseDAO.getHighestRatedCourses(5);
            List<CourseStat> highestRated = new ArrayList<>();
            for (Map<String, Object> row : ratedRaw) {
                highestRated.add(new CourseStat(
                        (String) row.get("title"),
                        ((Number) row.get("rating")).doubleValue(),
                        ((Number) row.get("enrollments")).intValue()
                ));
            }
            stats.setHighestRatedCourses(highestRated);

            // Daily Stats
            List<Map<String, Object>> dailyRaw = userDAO.getDailyStats(30);
            List<DailyStat> dailyStats = new ArrayList<>();
            for (Map<String, Object> row : dailyRaw) {
                DailyStat d = new DailyStat();
                d.setDate((Date) row.get("date"));
                d.setVisits(((Number) row.get("visits")).intValue());
                d.setUniqueVisitors(((Number) row.get("uniqueVisitors")).intValue());
                d.setNewUsers(((Number) row.get("newUsers")).intValue());
                d.setAvgDuration(((Number) row.get("avgDuration")).intValue());
                d.setPageViews(((Number) row.get("pageViews")).intValue());
                dailyStats.add(d);
            }
            stats.setDailyStats(dailyStats);

            // Dữ liệu cho biểu đồ truy cập (30 ngày gần nhất)
            List<Map<String, Object>> dailyStatsRaw = userDAO.getDailyStats(30);
            List<Integer> dailyVisits = new ArrayList<>();
            List<Integer> dailyUsers = new ArrayList<>();
            List<String> dailyLabels = new ArrayList<>();

            SimpleDateFormat sdf = new SimpleDateFormat("dd/MM");
            Calendar cal = Calendar.getInstance();
            for (int i = 29; i >= 0; i--) {
                cal.setTime(new Date());
                cal.add(Calendar.DATE, -i);
                Date date = cal.getTime();
                String dateStr = sdf.format(date);
                dailyLabels.add(dateStr);

                boolean found = false;
                for (Map<String, Object> row : dailyStatsRaw) {
                    Date rowDate = (Date) row.get("date");
                    if (sdf.format(rowDate).equals(dateStr)) {
                        dailyVisits.add(((Number) row.get("visits")).intValue());
                        dailyUsers.add(((Number) row.get("uniqueVisitors")).intValue());
                        found = true;
                        break;
                    }
                }

                if (!found) {
                    dailyVisits.add(0);
                    dailyUsers.add(0);
                }
            }

            // Dữ liệu phân bổ người dùng
            Map<String, Integer> userDistribution = userDAO.getUserDistribution();

            // Dữ liệu thời gian học tập trung bình
            List<Map<String, Object>> learningTimeData = courseDAO.getAverageLearningTime();
            List<String> courseTitles = new ArrayList<>();
            List<Integer> avgTimes = new ArrayList<>();

            for (Map<String, Object> row : learningTimeData) {
                courseTitles.add((String) row.get("title"));
                avgTimes.add(((Number) row.get("avg_time")).intValue());
            }

            // Dữ liệu tỉ lệ hoàn thành
            List<Map<String, Object>> completionRates = courseDAO.getCourseCompletionRates();
            List<String> completionCourseTitles = new ArrayList<>();
            List<Double> completionRatesList = new ArrayList<>();

            for (Map<String, Object> row : completionRates) {
                completionCourseTitles.add((String) row.get("title"));
                completionRatesList.add(((Number) row.get("completion_rate")).doubleValue());
            }

            // Truyền dữ liệu về JSP
            request.setAttribute("dailyLabels", dailyLabels);
            request.setAttribute("dailyVisits", dailyVisits);
            request.setAttribute("dailyUsers", dailyUsers);
            request.setAttribute("userDistribution", userDistribution);
            request.setAttribute("courseTitles", courseTitles);
            request.setAttribute("avgTimes", avgTimes);
            request.setAttribute("completionCourseTitles", completionCourseTitles);
            request.setAttribute("completionRates", completionRatesList);

            // Truyền về JSP
            request.setAttribute("stats", stats);
            request.getRequestDispatcher("/Admin.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Không thể tải dữ liệu thống kê");
            request.getRequestDispatcher("/Admin.jsp").forward(request, response);
        }
    }

    // Hàm thủ công để chuyển dữ liệu về JSON string (không cần thư viện ngoài)
    public String toJsonArray(List<String> values) {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < values.size(); i++) {
            sb.append("\"").append(values.get(i)).append("\"");
            if (i < values.size() - 1) {
                sb.append(",");
            }
        }
        sb.append("]");
        return sb.toString();
    }

    public String toJsonArrayInt(List<Integer> values) {
        return values.toString(); // Tự động ra chuỗi [1,2,3]
    }

    public String getDailyStatsJson(List<DailyStat> stats) {
        List<String> labels = Arrays.asList("00:00", "03:00", "06:00", "09:00", "12:00", "15:00", "18:00", "21:00");
        List<Integer> visits = new ArrayList<>();
        List<Integer> users = new ArrayList<>();

        for (DailyStat stat : stats) {
            visits.add(stat.getVisits() / 8);
            users.add(stat.getUniqueVisitors() / 8);
        }

        return "{"
                + "\"dayLabels\":" + toJsonArray(labels) + ","
                + "\"dayVisits\":" + toJsonArrayInt(visits) + ","
                + "\"dayUsers\":" + toJsonArrayInt(users)
                + "}";
    }

    public String getCourseTitlesJson(List<CourseStat> courses) {
        List<String> titles = new ArrayList<>();
        for (CourseStat c : courses) {
            titles.add(c.getTitle());
        }
        return toJsonArray(titles);
    }

    public String getAvgDurationsJson(List<CourseStat> courses) {
        List<Integer> durations = new ArrayList<>();
        for (CourseStat c : courses) {
            durations.add(c.getAvgViewDuration());
        }
        return toJsonArrayInt(durations);
    }

    public String getCompletionRatesJson(List<CourseStat> courses) {

        Random rand = new Random();
        List<Integer> rates = new ArrayList<>();
        for (int i = 0; i < courses.size(); i++) {
            rates.add(60 + rand.nextInt(31)); // 60 -> 90
        }
        return toJsonArrayInt(rates);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");
        doGet(request, response);
    }
}

package controller.Admin;

import com.opencsv.CSVWriter;
import dal.CourseDAO;
import dal.PaymentDAO;
import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import model.CourseStat;
import model.DashboardStats;
import model.User;
import model.UserActivity;
import java.io.IOException;
import java.io.StringWriter;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.*;
import model.DailyStat;

public class AdminServlet extends HttpServlet {

    private CourseDAO courseDAO;
    private PaymentDAO paymentDAO;
    private UserDAO userDAO;

    private static final SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
    private static final SimpleDateFormat ctrSdf = new SimpleDateFormat("yyyy-MM-dd");

    @Override
    public void init() throws ServletException {
        courseDAO = new CourseDAO();
        paymentDAO = new PaymentDAO();
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        response.setContentType("text/html;charset=UTF-8");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("authen?action=login");
            return;
        }

        User user = (User) session.getAttribute("user");
        if (user.getRoleId() != 2 && user.getRoleId() != 3) {
            response.sendRedirect("authen?action=login");
            return;
        }

        String action = request.getParameter("action");
        if ("download".equals(action)) {
            handleDownload(request, response);
            return;
        }

        try {
            DashboardStats stats = new DashboardStats();
            String type = request.getParameter("type");
            if (type == null) {
                type = "day";
            }

            // Technical performance
            Map<String, Object> techMetrics = userDAO.getTechnicalPerformanceMetrics();
            stats.setPageLoadTime(getDoubleOrDefault(techMetrics.get("avg_page_load_time"), 0.0));
            stats.setServerResponseTime(getDoubleOrDefault(techMetrics.get("avg_server_response_time"), 0.0));
            stats.setErrorRate(getDoubleOrDefault(techMetrics.get("error_rate"), 0.0));

            // User behavior
            Map<String, Object> behaviorMetrics = userDAO.getUserBehaviorMetrics();
//            stats.setClickThroughRate(userDAO.getClickThroughRate());
//            stats.setBounceRate(getDoubleOrDefault(behaviorMetrics.get("bounce_rate"), 0.0));
//            stats.setAvgSessionDuration(getIntOrDefault(behaviorMetrics.get("avg_session_duration"), 0));
            stats.setPagesPerSession(getDoubleOrDefault(behaviorMetrics.get("pages_per_session"), 0.0));
            stats.setScrollDepth(getDoubleOrDefault(behaviorMetrics.get("avg_scroll_depth"), 0.0));

            // Traffic
            Map<String, Object> trafficMetrics = userDAO.getTrafficMetrics();
            stats.setNewUsers(getIntOrDefault(trafficMetrics.get("new_users"), 0));
            stats.setReturningUsers(getIntOrDefault(trafficMetrics.get("returning_users"), 0));
            Map<String, Object> rawSources = (Map<String, Object>) trafficMetrics.getOrDefault("traffic_sources", new HashMap<>());
            Map<String, Integer> trafficSources = new HashMap<>();

            for (Map.Entry<String, Object> entry : rawSources.entrySet()) {
                try {
                    trafficSources.put(entry.getKey(), ((Number) entry.getValue()).intValue());
                } catch (Exception e) {
                    trafficSources.put(entry.getKey(), 0); // fallback if parsing fails
                }
            }

            stats.setTrafficSources(trafficSources);

            // Conversion
            Map<String, Object> conversionMetrics = userDAO.getConversionMetrics();
            stats.setConversionRate(getDoubleOrDefault(conversionMetrics.get("conversion_rate"), 0.0));
            stats.setSignupConversion(getDoubleOrDefault(conversionMetrics.get("signup_conversion"), 0.0));
            stats.setPurchaseConversion(getDoubleOrDefault(conversionMetrics.get("purchase_conversion"), 0.0));

            stats.setTotalUsers(userDAO.countAllUsers());
            stats.setActiveUsers(userDAO.countActiveUsers());
            stats.setOnlineUsers(userDAO.countOnlineUsers());
            stats.setUserGrowth(userDAO.calculateUserGrowth());

            Map<String, Integer> userActivityMap = userDAO.getUserDistribution();  // ⬅️ Phải có dòng này
            UserActivity ua = new UserActivity(
                    getIntOrDefault(userActivityMap.get("regularUsers"), 0),
                    getIntOrDefault(userActivityMap.get("premiumUsers"), 0),
                    getIntOrDefault(userActivityMap.get("adminUsers"), 0),
                    getIntOrDefault(userActivityMap.get("staffUsers"), 0)
            );

            stats.setUserActivity(ua);

            stats.setMonthlyRevenue(BigDecimal.valueOf(paymentDAO.getMonthlyRevenue()));
            stats.setTotalRevenue(BigDecimal.valueOf(paymentDAO.getTotalRevenue()));

            // Most Viewed Courses
            List<Map<String, Object>> viewedRaw = courseDAO.getMostViewedCourses(5);
            int maxViews = viewedRaw.stream().mapToInt(v -> getIntOrDefault(v.get("views"), 1)).max().orElse(1);
            List<CourseStat> mostViewed = new ArrayList<>();
            for (Map<String, Object> row : viewedRaw) {
                String title = (String) row.getOrDefault("title", "Unknown");
                int views = getIntOrDefault(row.get("views"), 0);
                int avg = getIntOrDefault(row.get("avgViewDuration"), 0);
                double growth = views * 100.0 / maxViews;
                CourseStat c = new CourseStat(title, views, avg);
                c.setGrowthRate(growth);
                mostViewed.add(c);
            }
            stats.setMostViewedCourses(mostViewed);

            // Highest Rated Courses
            List<Map<String, Object>> ratedRaw = courseDAO.getHighestRatedCourses(5);
            List<CourseStat> highestRated = new ArrayList<>();
            for (Map<String, Object> row : ratedRaw) {
                highestRated.add(new CourseStat(
                        (String) row.getOrDefault("title", "Unknown"),
                        getDoubleOrDefault(row.get("rating"), 0.0),
                        getIntOrDefault(row.get("enrollments"), 0)
                ));
            }
            stats.setHighestRatedCourses(highestRated);

            // Daily/Weekly/Monthly stats
            List<Map<String, Object>> statsRaw = userDAO.getDailyStats(30);
            List<DailyStat> dailyStatsList = new ArrayList<>();
            for (Map<String, Object> row : statsRaw) {
                DailyStat d = new DailyStat();
                d.setDate((Date) row.get("date"));
                d.setVisits(getIntOrDefault(row.get("visits"), 0));
                d.setUniqueVisitors(getIntOrDefault(row.get("uniqueVisitors"), 0));
                d.setNewUsers(getIntOrDefault(row.get("newUsers"), 0));
                d.setAvgDuration(getIntOrDefault(row.get("avgDuration"), 0));
                d.setPageViews(getIntOrDefault(row.get("pageViews"), 0));
                d.setBounceRate(getDoubleOrDefault(row.get("bounceRate"), 0.0));
                dailyStatsList.add(d);
            }
            stats.setDailyStats(dailyStatsList);

            switch (type) {
                case "month":
                    statsRaw = userDAO.getMonthlyStats(12);
                    break;
                case "week":
                    statsRaw = userDAO.getWeeklyStats(8);
                    break;
                default:
                    statsRaw = userDAO.getDailyStats(30);
                    break;
            }
            List<String> dailyLabels = new ArrayList<>();
            List<Integer> dailyVisits = new ArrayList<>();
            List<Integer> dailyUsers = new ArrayList<>();
            for (Map<String, Object> row : statsRaw) {
                dailyLabels.add(sdf.format((Date) row.getOrDefault("date", new Date())));
                dailyVisits.add(getIntOrDefault(row.get("visits"), 0));
                dailyUsers.add(getIntOrDefault(row.get("uniqueVisitors"), 0));
            }

            // CTR
            List<Map<String, Object>> dailyCTR = userDAO.getCTRStats(type, 30);
            List<String> ctrLabels = new ArrayList<>();
            List<Double> ctrValues = new ArrayList<>();
            for (Map<String, Object> row : dailyCTR) {
                ctrLabels.add(ctrSdf.format((Date) row.getOrDefault("date", new Date())));
                ctrValues.add(getDoubleOrDefault(row.get("ctr"), 0.0));
            }

            // Learning Time
            List<Map<String, Object>> learningTimeData = courseDAO.getAverageLearningTime(10);
            List<String> courseTitles = new ArrayList<>();
            List<Integer> avgTimes = new ArrayList<>();
            for (Map<String, Object> row : learningTimeData) {
                courseTitles.add((String) row.getOrDefault("title", "Unknown"));
                avgTimes.add(getIntOrDefault(row.get("avg_time"), 0));
            }

            // Completion Rate
            int limit = 20; // ví dụ
            List<Map<String, Object>> completionRates = courseDAO.getCourseCompletionRates(limit);
            List<String> completionCourseTitles = new ArrayList<>();
            List<Double> completionRatesList = new ArrayList<>();
            for (Map<String, Object> row : completionRates) {
                completionCourseTitles.add((String) row.getOrDefault("title", "Unknown"));
                completionRatesList.add(getDoubleOrDefault(row.get("completion_rate"), 0.0));
            }
            Map<String, Object> userActivityJsonMap = new HashMap<>();
            for (Map.Entry<String, Integer> entry : userActivityMap.entrySet()) {
                userActivityJsonMap.put(entry.getKey(), entry.getValue());
            }

            Map<String, Object> trafficSourcesJsonMap = new HashMap<>();
            for (Map.Entry<String, Integer> entry : stats.getTrafficSources().entrySet()) {
                trafficSourcesJsonMap.put(entry.getKey(), entry.getValue());
            }

            request.setAttribute("dailyLabels", toJsonArray(dailyLabels));
            request.setAttribute("dailyVisits", toJsonArrayInt(dailyVisits));
            request.setAttribute("dailyUsers", toJsonArrayInt(dailyUsers));
            request.setAttribute("ctrLabels", toJsonArray(ctrLabels));
            request.setAttribute("ctrValues", toJsonArrayDouble(ctrValues));
            request.setAttribute("courseTitles", toJsonArray(courseTitles));
            request.setAttribute("avgTimes", toJsonArrayInt(avgTimes));
            request.setAttribute("completionCourseTitles", toJsonArray(completionCourseTitles));
            request.setAttribute("completionRates", toJsonArrayDouble(completionRatesList));
            request.setAttribute("userDistribution", ua);
            request.setAttribute("stats", stats);
            request.setAttribute("userDistributionJson", toJsonMap(userActivityJsonMap));
            request.setAttribute("trafficSourcesJson", toJsonMap(trafficSourcesJsonMap));
            request.getRequestDispatcher("/Admin.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi tải dữ liệu: " + e.getMessage());
            request.getRequestDispatcher("/Admin.jsp").forward(request, response);
        }
    }

    private void handleDownload(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String type = request.getParameter("dataType");
        response.setContentType("text/csv;charset=UTF-8");
        response.setHeader("Content-Disposition", "attachment; filename=" + type + "_data.csv");

        HttpSession session = request.getSession(false);
        if (session == null) {
            return;
        }

        try (StringWriter sw = new StringWriter(); CSVWriter csvWriter = new CSVWriter(sw)) {
            switch (type) {
                case "dailyStats":
                    List<String> dailyLabels = (List<String>) session.getAttribute("dailyLabels");
                    List<Integer> dailyVisits = (List<Integer>) session.getAttribute("dailyVisits");
                    List<Integer> dailyUsers = (List<Integer>) session.getAttribute("dailyUsers");
                    csvWriter.writeNext(new String[]{"Date", "Visits", "Unique Visitors"});
                    for (int i = 0; i < dailyLabels.size(); i++) {
                        csvWriter.writeNext(new String[]{
                            dailyLabels.get(i),
                            dailyVisits.get(i).toString(),
                            dailyUsers.get(i).toString()
                        });
                    }
                    break;
                case "mostViewedCourses":
                    List<CourseStat> mostViewed = ((DashboardStats) session.getAttribute("stats")).getMostViewedCourses();
                    csvWriter.writeNext(new String[]{"Title", "Views", "Avg View Duration", "Growth Rate"});
                    for (CourseStat c : mostViewed) {
                        csvWriter.writeNext(new String[]{
                            c.getTitle(),
                            String.valueOf(c.getViews()),
                            String.valueOf(c.getAvgViewDuration()),
                            String.format("%.2f", c.getGrowthRate())
                        });
                    }
                    break;
                case "highestRatedCourses":
                    List<CourseStat> highestRated = ((DashboardStats) session.getAttribute("stats")).getHighestRatedCourses();
                    csvWriter.writeNext(new String[]{"Title", "Rating", "Enrollments"});
                    for (CourseStat c : highestRated) {
                        csvWriter.writeNext(new String[]{
                            c.getTitle(),
                            String.format("%.2f", c.getRating()),
                            String.valueOf(c.getEnrollments())
                        });
                    }
                    break;
                case "conversionRates":
                    DashboardStats stats = (DashboardStats) session.getAttribute("stats");
                    csvWriter.writeNext(new String[]{"Loại", "Tỉ lệ (%)"});
                    csvWriter.writeNext(new String[]{"Tổng", String.format("%.2f", stats.getConversionRate() * 100)});
                    csvWriter.writeNext(new String[]{"Đăng ký", String.format("%.2f", stats.getSignupConversion() * 100)});
                    csvWriter.writeNext(new String[]{"Mua hàng", String.format("%.2f", stats.getPurchaseConversion() * 100)});
                    break;

            }
            response.getWriter().write(sw.toString());
        }
    }

    private double getDoubleOrDefault(Object value, double defaultValue) {
        if (value == null) {
            return defaultValue;
        }
        try {
            return ((Number) value).doubleValue();
        } catch (Exception e) {
            return defaultValue;
        }
    }

    private int getIntOrDefault(Object value, int defaultValue) {
        if (value == null) {
            return defaultValue;
        }
        try {
            return ((Number) value).intValue();
        } catch (Exception e) {
            return defaultValue;
        }
    }

    private String toJsonMap(Map<String, Object> map) {
        StringBuilder sb = new StringBuilder("{");
        int i = 0;
        for (Map.Entry<String, Object> entry : map.entrySet()) {
            sb.append("\"").append(entry.getKey()).append("\":");
            Object value = entry.getValue();
            if (value instanceof String) {
                sb.append("\"").append(value.toString().replace("\"", "\\\"")).append("\"");
            } else {
                sb.append(value);
            }
            if (i < map.size() - 1) {
                sb.append(",");
            }
            i++;
        }
        sb.append("}");
        return sb.toString();
    }

    private String toJsonArray(List<String> values) {
        StringBuilder sb = new StringBuilder("[");
        for (int i = 0; i < values.size(); i++) {
            sb.append("\"").append(values.get(i).replace("\"", "\\\"")).append("\"");
            if (i < values.size() - 1) {
                sb.append(",");
            }
        }
        sb.append("]");
        return sb.toString();
    }

    private String toJsonArrayInt(List<Integer> values) {
        return "[" + String.join(",", values.stream().map(String::valueOf).toArray(String[]::new)) + "]";
    }

    private String toJsonArrayDouble(List<Double> values) {
        return "[" + String.join(",", values.stream().map(v -> String.format("%.2f", v)).toArray(String[]::new)) + "]";
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

/**
 *
 * @author FPT
 */
public class DashboardStats {

    private int onlineUsers;
    private int totalUsers;
    private int activeUsers;
    private double userGrowth;
    private int totalCourses;
    private int activeCourses;
    private BigDecimal monthlyRevenue;
    private BigDecimal totalRevenue;

    private List<DailyStat> dailyStats;
    private UserActivity userActivity;
    private List<CourseStat> mostViewedCourses;
    private List<CourseStat> highestRatedCourses;

    private Map<String, Object> dailyTraffic;
    private Map<String, Object> weeklyTraffic;
    private Map<String, Object> monthlyTraffic;
    private Map<String, Object> yearlyTraffic;
    private Map<String, Object> userDistribution;
    private Map<String, Object> learningTimeStats;
    private Map<String, Object> completionRateStats;
    private Map<String, Object> currentDayStats;
    private Map<String, Object> currentWeekStats;
    private Map<String, Object> currentMonthStats;

    // Chỉ số hiệu suất kỹ thuật
    private double pageLoadTime; // giây
    private double serverResponseTime; // ms
    private double errorRate; // tỉ lệ

// Chỉ số tương tác người dùng
    private double bounceRate; // tỉ lệ
    private int avgSessionDuration; // giây
    private double pagesPerSession;
    private double scrollDepth; // tỉ lệ

// Chỉ số lưu lượng truy cập
    private int newUsers;
    private int returningUsers;
    private Map<String, Integer> trafficSources;

// Chỉ số chuyển đổi
    private double conversionRate;
    private double signupConversion;
    private double purchaseConversion;

    private double clickThroughRate;

    public DashboardStats() {
    }

    public DashboardStats(int onlineUsers, int totalUsers, int activeUsers, double userGrowth, int totalCourses, int activeCourses, BigDecimal monthlyRevenue, BigDecimal totalRevenue, List<DailyStat> dailyStats, UserActivity userActivity, List<CourseStat> mostViewedCourses, List<CourseStat> highestRatedCourses, Map<String, Object> dailyTraffic, Map<String, Object> weeklyTraffic, Map<String, Object> monthlyTraffic, Map<String, Object> yearlyTraffic, Map<String, Object> userDistribution, Map<String, Object> learningTimeStats, Map<String, Object> completionRateStats, Map<String, Object> currentDayStats, Map<String, Object> currentWeekStats, Map<String, Object> currentMonthStats, double pageLoadTime, double serverResponseTime, double errorRate, double bounceRate, int avgSessionDuration, double pagesPerSession, double scrollDepth, int newUsers, int returningUsers, Map<String, Integer> trafficSources, double conversionRate, double signupConversion, double purchaseConversion, double clickThroughRate) {
        this.onlineUsers = onlineUsers;
        this.totalUsers = totalUsers;
        this.activeUsers = activeUsers;
        this.userGrowth = userGrowth;
        this.totalCourses = totalCourses;
        this.activeCourses = activeCourses;
        this.monthlyRevenue = monthlyRevenue;
        this.totalRevenue = totalRevenue;
        this.dailyStats = dailyStats;
        this.userActivity = userActivity;
        this.mostViewedCourses = mostViewedCourses;
        this.highestRatedCourses = highestRatedCourses;
        this.dailyTraffic = dailyTraffic;
        this.weeklyTraffic = weeklyTraffic;
        this.monthlyTraffic = monthlyTraffic;
        this.yearlyTraffic = yearlyTraffic;
        this.userDistribution = userDistribution;
        this.learningTimeStats = learningTimeStats;
        this.completionRateStats = completionRateStats;
        this.currentDayStats = currentDayStats;
        this.currentWeekStats = currentWeekStats;
        this.currentMonthStats = currentMonthStats;
        this.pageLoadTime = pageLoadTime;
        this.serverResponseTime = serverResponseTime;
        this.errorRate = errorRate;
        this.bounceRate = bounceRate;
        this.avgSessionDuration = avgSessionDuration;
        this.pagesPerSession = pagesPerSession;
        this.scrollDepth = scrollDepth;
        this.newUsers = newUsers;
        this.returningUsers = returningUsers;
        this.trafficSources = trafficSources;
        this.conversionRate = conversionRate;
        this.signupConversion = signupConversion;
        this.purchaseConversion = purchaseConversion;
        this.clickThroughRate = clickThroughRate;
    }

    public int getOnlineUsers() {
        return onlineUsers;
    }

    public void setOnlineUsers(int onlineUsers) {
        this.onlineUsers = onlineUsers;
    }

    public int getTotalUsers() {
        return totalUsers;
    }

    public void setTotalUsers(int totalUsers) {
        this.totalUsers = totalUsers;
    }

    public int getActiveUsers() {
        return activeUsers;
    }

    public void setActiveUsers(int activeUsers) {
        this.activeUsers = activeUsers;
    }

    public double getUserGrowth() {
        return userGrowth;
    }

    public void setUserGrowth(double userGrowth) {
        this.userGrowth = userGrowth;
    }

    public int getTotalCourses() {
        return totalCourses;
    }

    public void setTotalCourses(int totalCourses) {
        this.totalCourses = totalCourses;
    }

    public int getActiveCourses() {
        return activeCourses;
    }

    public void setActiveCourses(int activeCourses) {
        this.activeCourses = activeCourses;
    }

    public BigDecimal getMonthlyRevenue() {
        return monthlyRevenue;
    }

    public void setMonthlyRevenue(BigDecimal monthlyRevenue) {
        this.monthlyRevenue = monthlyRevenue;
    }

    public BigDecimal getTotalRevenue() {
        return totalRevenue;
    }

    public void setTotalRevenue(BigDecimal totalRevenue) {
        this.totalRevenue = totalRevenue;
    }

    public List<DailyStat> getDailyStats() {
        return dailyStats;
    }

    public void setDailyStats(List<DailyStat> dailyStats) {
        this.dailyStats = dailyStats;
    }

    public UserActivity getUserActivity() {
        return userActivity;
    }

    public void setUserActivity(UserActivity userActivity) {
        this.userActivity = userActivity;
    }

    public List<CourseStat> getMostViewedCourses() {
        return mostViewedCourses;
    }

    public void setMostViewedCourses(List<CourseStat> mostViewedCourses) {
        this.mostViewedCourses = mostViewedCourses;
    }

    public List<CourseStat> getHighestRatedCourses() {
        return highestRatedCourses;
    }

    public void setHighestRatedCourses(List<CourseStat> highestRatedCourses) {
        this.highestRatedCourses = highestRatedCourses;
    }

    public Map<String, Object> getDailyTraffic() {
        return dailyTraffic;
    }

    public void setDailyTraffic(Map<String, Object> dailyTraffic) {
        this.dailyTraffic = dailyTraffic;
    }

    public Map<String, Object> getWeeklyTraffic() {
        return weeklyTraffic;
    }

    public void setWeeklyTraffic(Map<String, Object> weeklyTraffic) {
        this.weeklyTraffic = weeklyTraffic;
    }

    public Map<String, Object> getMonthlyTraffic() {
        return monthlyTraffic;
    }

    public void setMonthlyTraffic(Map<String, Object> monthlyTraffic) {
        this.monthlyTraffic = monthlyTraffic;
    }

    public Map<String, Object> getYearlyTraffic() {
        return yearlyTraffic;
    }

    public void setYearlyTraffic(Map<String, Object> yearlyTraffic) {
        this.yearlyTraffic = yearlyTraffic;
    }

    public Map<String, Object> getUserDistribution() {
        return userDistribution;
    }

    public void setUserDistribution(Map<String, Object> userDistribution) {
        this.userDistribution = userDistribution;
    }

    public Map<String, Object> getLearningTimeStats() {
        return learningTimeStats;
    }

    public void setLearningTimeStats(Map<String, Object> learningTimeStats) {
        this.learningTimeStats = learningTimeStats;
    }

    public Map<String, Object> getCompletionRateStats() {
        return completionRateStats;
    }

    public void setCompletionRateStats(Map<String, Object> completionRateStats) {
        this.completionRateStats = completionRateStats;
    }

    public Map<String, Object> getCurrentDayStats() {
        return currentDayStats;
    }

    public void setCurrentDayStats(Map<String, Object> currentDayStats) {
        this.currentDayStats = currentDayStats;
    }

    public Map<String, Object> getCurrentWeekStats() {
        return currentWeekStats;
    }

    public void setCurrentWeekStats(Map<String, Object> currentWeekStats) {
        this.currentWeekStats = currentWeekStats;
    }

    public Map<String, Object> getCurrentMonthStats() {
        return currentMonthStats;
    }

    public void setCurrentMonthStats(Map<String, Object> currentMonthStats) {
        this.currentMonthStats = currentMonthStats;
    }

    public double getPageLoadTime() {
        return pageLoadTime;
    }

    public void setPageLoadTime(double pageLoadTime) {
        this.pageLoadTime = pageLoadTime;
    }

    public double getServerResponseTime() {
        return serverResponseTime;
    }

    public void setServerResponseTime(double serverResponseTime) {
        this.serverResponseTime = serverResponseTime;
    }

    public double getErrorRate() {
        return errorRate;
    }

    public void setErrorRate(double errorRate) {
        this.errorRate = errorRate;
    }

    public double getBounceRate() {
        return bounceRate;
    }

    public void setBounceRate(double bounceRate) {
        this.bounceRate = bounceRate;
    }

    public int getAvgSessionDuration() {
        return avgSessionDuration;
    }

    public void setAvgSessionDuration(int avgSessionDuration) {
        this.avgSessionDuration = avgSessionDuration;
    }

    public double getPagesPerSession() {
        return pagesPerSession;
    }

    public void setPagesPerSession(double pagesPerSession) {
        this.pagesPerSession = pagesPerSession;
    }

    public double getScrollDepth() {
        return scrollDepth;
    }

    public void setScrollDepth(double scrollDepth) {
        this.scrollDepth = scrollDepth;
    }

    public int getNewUsers() {
        return newUsers;
    }

    public void setNewUsers(int newUsers) {
        this.newUsers = newUsers;
    }

    public int getReturningUsers() {
        return returningUsers;
    }

    public void setReturningUsers(int returningUsers) {
        this.returningUsers = returningUsers;
    }

    public Map<String, Integer> getTrafficSources() {
        return trafficSources;
    }

    public void setTrafficSources(Map<String, Integer> trafficSources) {
        this.trafficSources = trafficSources;
    }

    public double getConversionRate() {
        return conversionRate;
    }

    public void setConversionRate(double conversionRate) {
        this.conversionRate = conversionRate;
    }

    public double getSignupConversion() {
        return signupConversion;
    }

    public void setSignupConversion(double signupConversion) {
        this.signupConversion = signupConversion;
    }

    public double getPurchaseConversion() {
        return purchaseConversion;
    }

    public void setPurchaseConversion(double purchaseConversion) {
        this.purchaseConversion = purchaseConversion;
    }

    public double getClickThroughRate() {
        return clickThroughRate;
    }

    public void setClickThroughRate(double clickThroughRate) {
        this.clickThroughRate = clickThroughRate;
    }

}

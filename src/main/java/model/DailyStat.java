/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.Date;

/**
 *
 * @author FPT
 */
public class DailyStat {

    private Date date;
    private int visits;
    private int uniqueVisitors;
    private int newUsers;
    private int avgDuration; // in seconds
    private int pageViews;
    private double bounceRate;

    public DailyStat(Date date, int visits, int uniqueVisitors, int newUsers, int avgDuration, int pageViews, double bounceRate) {
        this.date = date;
        this.visits = visits;
        this.uniqueVisitors = uniqueVisitors;
        this.newUsers = newUsers;
        this.avgDuration = avgDuration;
        this.pageViews = pageViews;
        this.bounceRate = bounceRate;
    }

    public DailyStat() {
    }

    // Getters and setters
    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public int getVisits() {
        return visits;
    }

    public void setVisits(int visits) {
        this.visits = visits;
    }

    public int getUniqueVisitors() {
        return uniqueVisitors;
    }

    public void setUniqueVisitors(int uniqueVisitors) {
        this.uniqueVisitors = uniqueVisitors;
    }

    public int getNewUsers() {
        return newUsers;
    }

    public void setNewUsers(int newUsers) {
        this.newUsers = newUsers;
    }

    public int getAvgDuration() {
        return avgDuration;
    }

    public void setAvgDuration(int avgDuration) {
        this.avgDuration = avgDuration;
    }

    public int getPageViews() {
        return pageViews;
    }

    public void setPageViews(int pageViews) {
        this.pageViews = pageViews;
    }

    public double getBounceRate() {
        return bounceRate;
    }

    public void setBounceRate(double bounceRate) {
        this.bounceRate = bounceRate;
    }
}

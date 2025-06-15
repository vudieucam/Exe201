/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author FPT
 */
public class CourseStat {

    private String title;
    private int views;
    private int avgViewDuration;
    private double rating;
    private int enrollments;

    public CourseStat() {
    }

    public CourseStat(String title, int views, int avgViewDuration) {
        this.title = title;
        this.views = views;
        this.avgViewDuration = avgViewDuration;
    }

    public CourseStat(String title, double rating, int enrollments) {
        this.title = title;
        this.rating = rating;
        this.enrollments = enrollments;
    }

    public CourseStat(String title, int views, int avgViewDuration, double rating, int enrollments) {
        this.title = title;
        this.views = views;
        this.avgViewDuration = avgViewDuration;
        this.rating = rating;
        this.enrollments = enrollments;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public int getViews() {
        return views;
    }

    public void setViews(int views) {
        this.views = views;
    }

    public int getAvgViewDuration() {
        return avgViewDuration;
    }

    public void setAvgViewDuration(int avgViewDuration) {
        this.avgViewDuration = avgViewDuration;
    }

    public double getRating() {
        return rating;
    }

    public void setRating(double rating) {
        this.rating = rating;
    }

    public int getEnrollments() {
        return enrollments;
    }

    public void setEnrollments(int enrollments) {
        this.enrollments = enrollments;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("CourseStat{");
        sb.append("title=").append(title);
        sb.append(", views=").append(views);
        sb.append(", avgViewDuration=").append(avgViewDuration);
        sb.append(", rating=").append(rating);
        sb.append(", enrollments=").append(enrollments);
        sb.append('}');
        return sb.toString();
    }

}

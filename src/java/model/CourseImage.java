package model;

import java.util.Date;

public class CourseImage {
    private int id;
    private int courseId;
    private String imageUrl;
    private boolean isPrimary;
    private Date createdAt;
    
    // Constructors
    public CourseImage() {
    }

    public CourseImage(int id, int courseId, String imageUrl, boolean isPrimary, Date createdAt) {
        this.id = id;
        this.courseId = courseId;
        this.imageUrl = imageUrl;
        this.isPrimary = isPrimary;
        this.createdAt = createdAt;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getCourseId() {
        return courseId;
    }

    public void setCourseId(int courseId) {
        this.courseId = courseId;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public boolean isPrimary() {
        return isPrimary;
    }

    public void setPrimary(boolean isPrimary) {
        this.isPrimary = isPrimary;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }
}
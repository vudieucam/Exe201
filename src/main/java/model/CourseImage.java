package model;

import java.util.Date;

public class CourseImage {

    private int id;
    private int courseId;
    private String imageUrl;
    private boolean isPrimary;
    private Date createdAt;
    private boolean status; // true: active, false: inactive

    public CourseImage() {
    }

    public CourseImage(int id, int courseId, String imageUrl, boolean isPrimary, Date createdAt, boolean status) {
        this.id = id;
        this.courseId = courseId;
        this.imageUrl = imageUrl;
        this.isPrimary = isPrimary;
        this.createdAt = createdAt;
        this.status = status;
    }

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

    public boolean isIsPrimary() {
        return isPrimary;
    }

    public void setIsPrimary(boolean isPrimary) {
        this.isPrimary = isPrimary;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("CourseImage{");
        sb.append("id=").append(id);
        sb.append(", courseId=").append(courseId);
        sb.append(", imageUrl=").append(imageUrl);
        sb.append(", isPrimary=").append(isPrimary);
        sb.append(", createdAt=").append(createdAt);
        sb.append(", status=").append(status);
        sb.append('}');
        return sb.toString();
    }

    
    
}

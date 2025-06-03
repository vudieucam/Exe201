package model;

import java.util.Date;
import java.util.List;

public class CourseModule {

    private int id;
    private int courseId;
    private String title;
    private String description;
    private int orderIndex;
    private Date createdAt;
    private Date updatedAt;
    private boolean status; // true: active, false: inactive
    private List<CourseLesson> lessons;

    public CourseModule() {
    }

    public CourseModule(int id, int courseId, String title, String description, int orderIndex, Date createdAt, Date updatedAt, boolean status, List<CourseLesson> lessons) {
        this.id = id;
        this.courseId = courseId;
        this.title = title;
        this.description = description;
        this.orderIndex = orderIndex;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.status = status;
        this.lessons = lessons;
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

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public int getOrderIndex() {
        return orderIndex;
    }

    public void setOrderIndex(int orderIndex) {
        this.orderIndex = orderIndex;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    public List<CourseLesson> getLessons() {
        return lessons;
    }

    public void setLessons(List<CourseLesson> lessons) {
        this.lessons = lessons;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("CourseModule{");
        sb.append("id=").append(id);
        sb.append(", courseId=").append(courseId);
        sb.append(", title=").append(title);
        sb.append(", description=").append(description);
        sb.append(", orderIndex=").append(orderIndex);
        sb.append(", createdAt=").append(createdAt);
        sb.append(", updatedAt=").append(updatedAt);
        sb.append(", status=").append(status);
        sb.append(", lessons=").append(lessons);
        sb.append('}');
        return sb.toString();
    }

}

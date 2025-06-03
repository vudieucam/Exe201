package model;

import java.util.Date;

public class UserProgress {

    private int id;
    private int userId;
    private int lessonId;
    private boolean completed;
    private Date completedAt;
    private boolean status; // true: active, false: inactive

    public UserProgress() {
    }

    public UserProgress(int id, int userId, int lessonId, boolean completed, Date completedAt, boolean status) {
        this.id = id;
        this.userId = userId;
        this.lessonId = lessonId;
        this.completed = completed;
        this.completedAt = completedAt;
        this.status = status;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public int getLessonId() {
        return lessonId;
    }

    public void setLessonId(int lessonId) {
        this.lessonId = lessonId;
    }

    public boolean isCompleted() {
        return completed;
    }

    public void setCompleted(boolean completed) {
        this.completed = completed;
    }

    public Date getCompletedAt() {
        return completedAt;
    }

    public void setCompletedAt(Date completedAt) {
        this.completedAt = completedAt;
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
        sb.append("UserProgress{");
        sb.append("id=").append(id);
        sb.append(", userId=").append(userId);
        sb.append(", lessonId=").append(lessonId);
        sb.append(", completed=").append(completed);
        sb.append(", completedAt=").append(completedAt);
        sb.append(", status=").append(status);
        sb.append('}');
        return sb.toString();
    }

    
}

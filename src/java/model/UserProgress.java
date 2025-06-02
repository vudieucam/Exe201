package model;

import java.util.Date;

public class UserProgress {
    private int id;
    private int userId;
    private int lessonId;
    private boolean completed;
    private Date completedAt;
    
    // Constructors
    public UserProgress() {
    }

    public UserProgress(int id, int userId, int lessonId, boolean completed, Date completedAt) {
        this.id = id;
        this.userId = userId;
        this.lessonId = lessonId;
        this.completed = completed;
        this.completedAt = completedAt;
    }

    // Getters and Setters
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
}
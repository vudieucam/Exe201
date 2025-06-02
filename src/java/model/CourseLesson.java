package model;

import java.util.Date;
import java.util.List;

public class CourseLesson {
    private int id;
    private int moduleId;
    private String title;
    private String content;
    private String videoUrl;
    private int duration;
    private int orderIndex;
    private Date createdAt;
    private Date updatedAt;
    private List<LessonAttachment> attachments;
    
    // Constructors
    public CourseLesson() {
    }

    public CourseLesson(int id, int moduleId, String title, String content, 
                       String videoUrl, int duration, int orderIndex, 
                       Date createdAt, Date updatedAt) {
        this.id = id;
        this.moduleId = moduleId;
        this.title = title;
        this.content = content;
        this.videoUrl = videoUrl;
        this.duration = duration;
        this.orderIndex = orderIndex;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getModuleId() {
        return moduleId;
    }

    public void setModuleId(int moduleId) {
        this.moduleId = moduleId;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getVideoUrl() {
        return videoUrl;
    }

    public void setVideoUrl(String videoUrl) {
        this.videoUrl = videoUrl;
    }

    public int getDuration() {
        return duration;
    }

    public void setDuration(int duration) {
        this.duration = duration;
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

    public List<LessonAttachment> getAttachments() {
        return attachments;
    }

    public void setAttachments(List<LessonAttachment> attachments) {
        this.attachments = attachments;
    }
}
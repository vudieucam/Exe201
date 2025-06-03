package model;

import java.util.Date;
import java.util.List;

public class CourseLesson {

    private int id;
    private int moduleId;
    private String title;
    private String content;
    private String videoUrl;
    private int duration; // minutes
    private int orderIndex;
    private Date createdAt;
    private Date updatedAt;
    private boolean status; // true: active, false: inactive
    private List<LessonAttachment> attachments;

    public CourseLesson() {
    }

    public CourseLesson(int id, int moduleId, String title, String content, String videoUrl, int duration, int orderIndex, Date createdAt, Date updatedAt, boolean status, List<LessonAttachment> attachments) {
        this.id = id;
        this.moduleId = moduleId;
        this.title = title;
        this.content = content;
        this.videoUrl = videoUrl;
        this.duration = duration;
        this.orderIndex = orderIndex;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
        this.status = status;
        this.attachments = attachments;
    }

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

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    public List<LessonAttachment> getAttachments() {
        return attachments;
    }

    public void setAttachments(List<LessonAttachment> attachments) {
        this.attachments = attachments;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("CourseLesson{");
        sb.append("id=").append(id);
        sb.append(", moduleId=").append(moduleId);
        sb.append(", title=").append(title);
        sb.append(", content=").append(content);
        sb.append(", videoUrl=").append(videoUrl);
        sb.append(", duration=").append(duration);
        sb.append(", orderIndex=").append(orderIndex);
        sb.append(", createdAt=").append(createdAt);
        sb.append(", updatedAt=").append(updatedAt);
        sb.append(", status=").append(status);
        sb.append(", attachments=").append(attachments);
        sb.append('}');
        return sb.toString();
    }

}

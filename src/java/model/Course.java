package model;

import java.util.Date;
import java.util.List;

public class Course {
    private int id;
    private String title;
    private String content;
    private Date postDate;
    private String researcher;
    private String videoUrl;
    private int status;
    private String duration;
    private String thumbnailUrl;
    private Date createdAt;
    private Date updatedAt;
    private List<CourseCategory> categories;
    private List<CourseImage> images;
    private List<CourseModule> modules;
    private List<CourseReview> reviews;
    
    // Constructors
    public Course() {
    }

    public Course(int id, String title, String content, Date postDate, String researcher, String videoUrl, 
                 int status, String duration, String thumbnailUrl, Date createdAt, Date updatedAt) {
        this.id = id;
        this.title = title;
        this.content = content;
        this.postDate = postDate;
        this.researcher = researcher;
        this.videoUrl = videoUrl;
        this.status = status;
        this.duration = duration;
        this.thumbnailUrl = thumbnailUrl;
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

    public Date getPostDate() {
        return postDate;
    }

    public void setPostDate(Date postDate) {
        this.postDate = postDate;
    }

    public String getResearcher() {
        return researcher;
    }

    public void setResearcher(String researcher) {
        this.researcher = researcher;
    }

    public String getVideoUrl() {
        return videoUrl;
    }

    public void setVideoUrl(String videoUrl) {
        this.videoUrl = videoUrl;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public String getDuration() {
        return duration;
    }

    public void setDuration(String duration) {
        this.duration = duration;
    }

    public String getThumbnailUrl() {
        return thumbnailUrl;
    }

    public void setThumbnailUrl(String thumbnailUrl) {
        this.thumbnailUrl = thumbnailUrl;
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

    public List<CourseCategory> getCategories() {
        return categories;
    }

    public void setCategories(List<CourseCategory> categories) {
        this.categories = categories;
    }

    public List<CourseImage> getImages() {
        return images;
    }

    public void setImages(List<CourseImage> images) {
        this.images = images;
    }

    public List<CourseModule> getModules() {
        return modules;
    }

    public void setModules(List<CourseModule> modules) {
        this.modules = modules;
    }

    public List<CourseReview> getReviews() {
        return reviews;
    }

    public void setReviews(List<CourseReview> reviews) {
        this.reviews = reviews;
    }
}
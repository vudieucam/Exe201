/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author FPT
 */


public class Course {
    private int id;
    private String title;
    private String content;
    private String postDate;
    private String researcher;
    private String imageUrl;
    private String time;
    private int status;
    private String categories; // Thêm trường categories
    private int categoryId;

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }

    public Course(int categoryId) {
        this.categoryId = categoryId;
    }

    public Course() {
    }

    public Course(int id, String title, String content, String postDate, String researcher, String imageUrl, String time, int status, String categories) {
        this.id = id;
        this.title = title;
        this.content = content;
        this.postDate = postDate;
        this.researcher = researcher;
        this.imageUrl = imageUrl;
        this.time = time;
        this.status = status;
        this.categories = categories;
    }

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

    public String getPostDate() {
        return postDate;
    }

    public void setPostDate(String postDate) {
        this.postDate = postDate;
    }

    public String getResearcher() {
        return researcher;
    }

    public void setResearcher(String researcher) {
        this.researcher = researcher;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getTime() {
        return time;
    }

    public void setTime(String time) {
        this.time = time;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public String getCategories() {
        return categories;
    }

    public void setCategories(String categories) {
        this.categories = categories;
    }

    @Override
    public String toString() {
        return "Course{" + "id=" + id + ", title=" + title + ", content=" + content + ", postDate=" + postDate + ", researcher=" + researcher + ", imageUrl=" + imageUrl + ", time=" + time + ", status=" + status + ", categories=" + categories + '}';
    }


}
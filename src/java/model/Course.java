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

    // Constructor mặc định
    public Course() {
    }

    // Constructor đầy đủ tham số
    public Course(int id, String title, String content, String postDate,
                String researcher, String imageUrl, String time) {
        this.id = id;
        this.title = title;
        this.content = content;
        this.postDate = postDate;
        this.researcher = researcher;
        this.imageUrl = imageUrl;
        this.time = time;
    }

    // Getter và Setter
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
        this.title = title != null ? title : "";
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content != null ? content : "";
    }

    public String getPostDate() {
        return postDate;
    }

    public void setPostDate(String postDate) {
        this.postDate = postDate != null ? postDate : "";
    }

    public String getResearcher() {
        return researcher;
    }

    public void setResearcher(String researcher) {
        this.researcher = researcher != null ? researcher : "";
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl != null ? imageUrl : "";
    }

    public String getTime() {
        return time;
    }

    public void setTime(String time) {
        this.time = time != null ? time : "";
    }

    @Override
    public String toString() {
        return "Course{" +
                "id=" + id +
                ", title='" + title + '\'' +
                ", content.length=" + (content != null ? content.length() : 0) +
                ", postDate='" + postDate + '\'' +
                ", researcher='" + researcher + '\'' +
                ", imageUrl='" + imageUrl + '\'' +
                ", time='" + time + '\'' +
                '}';
    }
}
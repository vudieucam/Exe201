package model;

public class CourseCategoryMapping {
    private int courseId;
    private int categoryId;
    
    // Constructors
    public CourseCategoryMapping() {
    }

    public CourseCategoryMapping(int courseId, int categoryId) {
        this.courseId = courseId;
        this.categoryId = categoryId;
    }

    // Getters and Setters
    public int getCourseId() {
        return courseId;
    }

    public void setCourseId(int courseId) {
        this.courseId = courseId;
    }

    public int getCategoryId() {
        return categoryId;
    }

    public void setCategoryId(int categoryId) {
        this.categoryId = categoryId;
    }
}
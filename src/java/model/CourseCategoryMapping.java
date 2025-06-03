package model;

public class CourseCategoryMapping {

    private int courseId;
    private int categoryId;
    private boolean status; // true: active, false: inactive

    public CourseCategoryMapping() {
    }

    public CourseCategoryMapping(int courseId, int categoryId, boolean status) {
        this.courseId = courseId;
        this.categoryId = categoryId;
        this.status = status;
    }

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

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("CourseCategoryMapping{");
        sb.append("courseId=").append(courseId);
        sb.append(", categoryId=").append(categoryId);
        sb.append(", status=").append(status);
        sb.append('}');
        return sb.toString();
    }

    
}

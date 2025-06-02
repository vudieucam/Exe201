package model;

public class CourseAccess {
    private int courseId;
    private int servicePackageId;
    
    // Constructors
    public CourseAccess() {
    }

    public CourseAccess(int courseId, int servicePackageId) {
        this.courseId = courseId;
        this.servicePackageId = servicePackageId;
    }

    // Getters and Setters
    public int getCourseId() {
        return courseId;
    }

    public void setCourseId(int courseId) {
        this.courseId = courseId;
    }

    public int getServicePackageId() {
        return servicePackageId;
    }

    public void setServicePackageId(int servicePackageId) {
        this.servicePackageId = servicePackageId;
    }
}
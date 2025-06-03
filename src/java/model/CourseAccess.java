package model;

public class CourseAccess {

    private int courseId;
    private int servicePackageId;
    private boolean status; // true: active, false: inactive

    public CourseAccess() {
    }

    public CourseAccess(int courseId, int servicePackageId, boolean status) {
        this.courseId = courseId;
        this.servicePackageId = servicePackageId;
        this.status = status;
    }

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

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("CourseAccess{");
        sb.append("courseId=").append(courseId);
        sb.append(", servicePackageId=").append(servicePackageId);
        sb.append(", status=").append(status);
        sb.append('}');
        return sb.toString();
    }
    
    
    
}

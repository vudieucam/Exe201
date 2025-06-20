package model;

public class LessonAttachment {

    private int id;
    private int lessonId;
    private String fileName;
    private String fileUrl;
    private int fileSize;
    private boolean status; // true: active, false: inactive

    public LessonAttachment() {
    }

    public LessonAttachment(int id, int lessonId, String fileName, String fileUrl, int fileSize, boolean status) {
        this.id = id;
        this.lessonId = lessonId;
        this.fileName = fileName;
        this.fileUrl = fileUrl;
        this.fileSize = fileSize;
        this.status = status;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getLessonId() {
        return lessonId;
    }

    public void setLessonId(int lessonId) {
        this.lessonId = lessonId;
    }

    public String getFileName() {
        return fileName;
    }

    public void setFileName(String fileName) {
        this.fileName = fileName;
    }

    public String getFileUrl() {
        return fileUrl;
    }

    public void setFileUrl(String fileUrl) {
        this.fileUrl = fileUrl;
    }

    public int getFileSize() {
        return fileSize;
    }

    public void setFileSize(int fileSize) {
        this.fileSize = fileSize;
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
        sb.append("LessonAttachment{");
        sb.append("id=").append(id);
        sb.append(", lessonId=").append(lessonId);
        sb.append(", fileName=").append(fileName);
        sb.append(", fileUrl=").append(fileUrl);
        sb.append(", fileSize=").append(fileSize);
        sb.append(", status=").append(status);
        sb.append('}');
        return sb.toString();
    }

}

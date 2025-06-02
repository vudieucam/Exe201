package model;

public class LessonAttachment {
    private int id;
    private int lessonId;
    private String fileName;
    private String fileUrl;
    private int fileSize;
    
    // Constructors
    public LessonAttachment() {
    }

    public LessonAttachment(int id, int lessonId, String fileName, String fileUrl, int fileSize) {
        this.id = id;
        this.lessonId = lessonId;
        this.fileName = fileName;
        this.fileUrl = fileUrl;
        this.fileSize = fileSize;
    }

    // Getters and Setters
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
}
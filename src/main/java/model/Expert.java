/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Timestamp;

public class Expert {

    private int id;
    private String fullName;
    private String position;
    private String bio;
    private String imageUrl;
    private String twitterUrl;
    private String facebookUrl;
    private String googleUrl;
    private String instagramUrl;
    private boolean status;

    private Timestamp createdAt;
    private Partner partner; // lớp mới hoặc đã có

    public Expert() {
    }

    public Expert(int id, String fullName, String position, String bio, String imageUrl, String twitterUrl, String facebookUrl, String googleUrl, String instagramUrl, boolean status, Timestamp createdAt, Partner partner) {
        this.id = id;
        this.fullName = fullName;
        this.position = position;
        this.bio = bio;
        this.imageUrl = imageUrl;
        this.twitterUrl = twitterUrl;
        this.facebookUrl = facebookUrl;
        this.googleUrl = googleUrl;
        this.instagramUrl = instagramUrl;
        this.status = status;
        this.createdAt = createdAt;
        this.partner = partner;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
        this.position = position;
    }

    public String getBio() {
        return bio;
    }

    public void setBio(String bio) {
        this.bio = bio;
    }

    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    public String getTwitterUrl() {
        return twitterUrl;
    }

    public void setTwitterUrl(String twitterUrl) {
        this.twitterUrl = twitterUrl;
    }

    public String getFacebookUrl() {
        return facebookUrl;
    }

    public void setFacebookUrl(String facebookUrl) {
        this.facebookUrl = facebookUrl;
    }

    public String getGoogleUrl() {
        return googleUrl;
    }

    public void setGoogleUrl(String googleUrl) {
        this.googleUrl = googleUrl;
    }

    public String getInstagramUrl() {
        return instagramUrl;
    }

    public void setInstagramUrl(String instagramUrl) {
        this.instagramUrl = instagramUrl;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Partner getPartner() {
        return partner;
    }

    public void setPartner(Partner partner) {
        this.partner = partner;
    }

}

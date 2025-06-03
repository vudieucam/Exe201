/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.sql.Timestamp;
import java.util.Date;

/**
 *
 * @author FPT
 */
public class User {

    private int id;
    private String email;
    private String password;
    private String fullname;
    private String phone;
    private String address;
    private int roleId; // 1: user, 2: staff, 3: admin
    private boolean status; // true: active, false: inactive
    private Date createdAt;
    private String verificationToken;
    private int servicePackageId;
    private boolean isActive;
    private String activationToken;
    private Date tokenExpiry;

    public User() {
    }

    public User(int id, String email, String password, String fullname, String phone, String address, int roleId, boolean status, Date createdAt, String verificationToken, int servicePackageId, boolean isActive, String activationToken, Date tokenExpiry) {
        this.id = id;
        this.email = email;
        this.password = password;
        this.fullname = fullname;
        this.phone = phone;
        this.address = address;
        this.roleId = roleId;
        this.status = status;
        this.createdAt = createdAt;
        this.verificationToken = verificationToken;
        this.servicePackageId = servicePackageId;
        this.isActive = isActive;
        this.activationToken = activationToken;
        this.tokenExpiry = tokenExpiry;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getFullname() {
        return fullname;
    }

    public void setFullname(String fullname) {
        this.fullname = fullname;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public int getRoleId() {
        return roleId;
    }

    public void setRoleId(int roleId) {
        this.roleId = roleId;
    }

    public boolean isStatus() {
        return status;
    }

    public void setStatus(boolean status) {
        this.status = status;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public String getVerificationToken() {
        return verificationToken;
    }

    public void setVerificationToken(String verificationToken) {
        this.verificationToken = verificationToken;
    }

    public int getServicePackageId() {
        return servicePackageId;
    }

    public void setServicePackageId(int servicePackageId) {
        this.servicePackageId = servicePackageId;
    }

    public boolean isIsActive() {
        return isActive;
    }

    public void setIsActive(boolean isActive) {
        this.isActive = isActive;
    }

    public String getActivationToken() {
        return activationToken;
    }

    public void setActivationToken(String activationToken) {
        this.activationToken = activationToken;
    }

    public Date getTokenExpiry() {
        return tokenExpiry;
    }

    public void setTokenExpiry(Date tokenExpiry) {
        this.tokenExpiry = tokenExpiry;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("User{");
        sb.append("id=").append(id);
        sb.append(", email=").append(email);
        sb.append(", password=").append(password);
        sb.append(", fullname=").append(fullname);
        sb.append(", phone=").append(phone);
        sb.append(", address=").append(address);
        sb.append(", roleId=").append(roleId);
        sb.append(", status=").append(status);
        sb.append(", createdAt=").append(createdAt);
        sb.append(", verificationToken=").append(verificationToken);
        sb.append(", servicePackageId=").append(servicePackageId);
        sb.append(", isActive=").append(isActive);
        sb.append(", activationToken=").append(activationToken);
        sb.append(", tokenExpiry=").append(tokenExpiry);
        sb.append('}');
        return sb.toString();
    }

    
}

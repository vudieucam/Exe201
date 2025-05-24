/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.security.Timestamp;

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
    private int roleId;
    private boolean status;
    private String verificationToken;
    private Timestamp createdAt; // thêm nếu muốn theo dõi ngày tạo
    private Integer servicePackageId;

    public User() {
    }

    public User(int id, String email, String password, String fullname, String phone, String address, int roleId, boolean status, String verificationToken, Timestamp createdAt, Integer servicePackageId) {
        this.id = id;
        this.email = email;
        this.password = password;
        this.fullname = fullname;
        this.phone = phone;
        this.address = address;
        this.roleId = roleId;
        this.status = status;
        this.verificationToken = verificationToken;
        this.createdAt = createdAt;
        this.servicePackageId = servicePackageId;
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

    public String getVerificationToken() {
        return verificationToken;
    }

    public void setVerificationToken(String verificationToken) {
        this.verificationToken = verificationToken;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }

    public Integer getServicePackageId() {
        return servicePackageId;
    }

    public void setServicePackageId(Integer servicePackageId) {
        this.servicePackageId = servicePackageId;
    }

}

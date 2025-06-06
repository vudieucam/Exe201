/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author FPT
 */
public class UserActivity {
    private int regularUsers;
    private int premiumUsers;
    private int adminUsers;
    private int staffUsers;

    public UserActivity() {
    }

    public UserActivity(int regularUsers, int premiumUsers, int adminUsers, int staffUsers) {
        this.regularUsers = regularUsers;
        this.premiumUsers = premiumUsers;
        this.adminUsers = adminUsers;
        this.staffUsers = staffUsers;
    }

    public int getRegularUsers() {
        return regularUsers;
    }

    public void setRegularUsers(int regularUsers) {
        this.regularUsers = regularUsers;
    }

    public int getPremiumUsers() {
        return premiumUsers;
    }

    public void setPremiumUsers(int premiumUsers) {
        this.premiumUsers = premiumUsers;
    }

    public int getAdminUsers() {
        return adminUsers;
    }

    public void setAdminUsers(int adminUsers) {
        this.adminUsers = adminUsers;
    }

    public int getStaffUsers() {
        return staffUsers;
    }

    public void setStaffUsers(int staffUsers) {
        this.staffUsers = staffUsers;
    }

    @Override
    public String toString() {
        StringBuilder sb = new StringBuilder();
        sb.append("UserActivity{");
        sb.append("regularUsers=").append(regularUsers);
        sb.append(", premiumUsers=").append(premiumUsers);
        sb.append(", adminUsers=").append(adminUsers);
        sb.append(", staffUsers=").append(staffUsers);
        sb.append('}');
        return sb.toString();
    }
    
    
}

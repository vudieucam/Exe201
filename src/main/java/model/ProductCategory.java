/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author FPT
 */
public class ProductCategory {

    private int id;
    private String name;
    private boolean status; // true: active, false: inactive

    public ProductCategory() {
    }

    public ProductCategory(int id, String name, boolean status) {
        this.id = id;
        this.name = name;
        this.status = status;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
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
        sb.append("ProductCategory{");
        sb.append("id=").append(id);
        sb.append(", name=").append(name);
        sb.append(", status=").append(status);
        sb.append('}');
        return sb.toString();
    }
    
    
}

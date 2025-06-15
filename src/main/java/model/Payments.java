/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.math.BigDecimal;
import java.sql.Timestamp;


/**
 *
 * @author FPT
 */
public class Payments {
    private int id;
    private int userId;
    private Integer servicePackageId;
    private Integer orderId;
    private String paymentMethod;
    private BigDecimal amount;
    private Timestamp paymentDate;
    private String status;
    private String transactionId;
    private String qrCodeUrl;
    private String bankAccountNumber;
    private String bankName;
    private String notes;
    private boolean isConfirmed;
    private String confirmationCode;
    private Timestamp confirmationExpiry;

    public Payments() {
    }

    public Payments(int id, int userId, Integer servicePackageId, Integer orderId, String paymentMethod, BigDecimal amount, Timestamp paymentDate, String status, String transactionId, String qrCodeUrl, String bankAccountNumber, String bankName, String notes, boolean isConfirmed, String confirmationCode, Timestamp confirmationExpiry) {
        this.id = id;
        this.userId = userId;
        this.servicePackageId = servicePackageId;
        this.orderId = orderId;
        this.paymentMethod = paymentMethod;
        this.amount = amount;
        this.paymentDate = paymentDate;
        this.status = status;
        this.transactionId = transactionId;
        this.qrCodeUrl = qrCodeUrl;
        this.bankAccountNumber = bankAccountNumber;
        this.bankName = bankName;
        this.notes = notes;
        this.isConfirmed = isConfirmed;
        this.confirmationCode = confirmationCode;
        this.confirmationExpiry = confirmationExpiry;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public Integer getServicePackageId() {
        return servicePackageId;
    }

    public void setServicePackageId(Integer servicePackageId) {
        this.servicePackageId = servicePackageId;
    }

    public Integer getOrderId() {
        return orderId;
    }

    public void setOrderId(Integer orderId) {
        this.orderId = orderId;
    }

    public String getPaymentMethod() {
        return paymentMethod;
    }

    public void setPaymentMethod(String paymentMethod) {
        this.paymentMethod = paymentMethod;
    }

    public BigDecimal getAmount() {
        return amount;
    }

    public void setAmount(BigDecimal amount) {
        this.amount = amount;
    }

    public Timestamp getPaymentDate() {
        return paymentDate;
    }

    public void setPaymentDate(Timestamp paymentDate) {
        this.paymentDate = paymentDate;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getTransactionId() {
        return transactionId;
    }

    public void setTransactionId(String transactionId) {
        this.transactionId = transactionId;
    }

    public String getQrCodeUrl() {
        return qrCodeUrl;
    }

    public void setQrCodeUrl(String qrCodeUrl) {
        this.qrCodeUrl = qrCodeUrl;
    }

    public String getBankAccountNumber() {
        return bankAccountNumber;
    }

    public void setBankAccountNumber(String bankAccountNumber) {
        this.bankAccountNumber = bankAccountNumber;
    }

    public String getBankName() {
        return bankName;
    }

    public void setBankName(String bankName) {
        this.bankName = bankName;
    }

    public String getNotes() {
        return notes;
    }

    public void setNotes(String notes) {
        this.notes = notes;
    }

    public boolean isIsConfirmed() {
        return isConfirmed;
    }

    public void setIsConfirmed(boolean isConfirmed) {
        this.isConfirmed = isConfirmed;
    }

    public String getConfirmationCode() {
        return confirmationCode;
    }

    public void setConfirmationCode(String confirmationCode) {
        this.confirmationCode = confirmationCode;
    }

    public Timestamp getConfirmationExpiry() {
        return confirmationExpiry;
    }

    public void setConfirmationExpiry(Timestamp confirmationExpiry) {
        this.confirmationExpiry = confirmationExpiry;
    }
    
}

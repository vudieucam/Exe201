/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Expert;
import model.Partner;

/**
 *
 * @author FPT
 */
public class ExpertDAO extends DBConnect {

    public List<Expert> getAllExperts() throws Exception {
        List<Expert> list = new ArrayList<>();
        String sql = """
        SELECT e.*, 
               p.id AS pid, p.name, p.email, p.phone, p.address, p.description,
               p.partner_type, p.country, p.partnership_date, p.project_count,
               p.logo_url, p.website, p.status AS pstatus, p.created_at AS pcreated
        FROM experts e
        LEFT JOIN partners p ON e.partner_id = p.id
        WHERE e.status = 1
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Expert e = new Expert();
                e.setId(rs.getInt("id"));
                e.setFullName(rs.getString("full_name"));
                e.setPosition(rs.getString("position"));
                e.setBio(rs.getString("bio"));
                e.setImageUrl(rs.getString("image_url"));
                e.setFacebookUrl(rs.getString("facebook_url"));
                e.setInstagramUrl(rs.getString("instagram_url"));
                e.setTwitterUrl(rs.getString("twitter_url"));
                e.setGoogleUrl(rs.getString("google_url"));
                e.setStatus(rs.getBoolean("status"));
                e.setCreatedAt(rs.getTimestamp("created_at"));

                // Gán đối tác nếu có
                int partnerId = rs.getInt("partner_id");
                if (partnerId > 0) {
                    Partner p = new Partner();
                    p.setId(rs.getInt("pid"));
                    p.setName(rs.getString("name"));
                    p.setEmail(rs.getString("email"));
                    p.setPhone(rs.getString("phone"));
                    p.setAddress(rs.getString("address"));
                    p.setDescription(rs.getString("description"));
                    p.setPartnerType(rs.getString("partner_type"));
                    p.setCountry(rs.getString("country"));
                    p.setPartnershipDate(rs.getDate("partnership_date"));
                    p.setProjectCount(rs.getInt("project_count"));
                    p.setLogoUrl(rs.getString("logo_url"));
                    p.setWebsite(rs.getString("website"));
                    p.setStatus(rs.getBoolean("pstatus"));
                    p.setCreatedAt(rs.getTimestamp("pcreated"));

                    e.setPartner(p);
                }

                list.add(e);
            }
        }
        return list;
    }

    public List<Expert> getAllExpertsAdmin() throws Exception {
        List<Expert> list = new ArrayList<>();
        String sql = """
        SELECT e.*, 
               p.id AS pid, p.name, p.email, p.phone, p.address, p.description,
               p.partner_type, p.country, p.partnership_date, p.project_count,
               p.logo_url, p.website, p.status AS pstatus, p.created_at AS pcreated
        FROM experts e
        LEFT JOIN partners p ON e.partner_id = p.id
        
    """;

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Expert e = new Expert();
                e.setId(rs.getInt("id"));
                e.setFullName(rs.getString("full_name"));
                e.setPosition(rs.getString("position"));
                e.setBio(rs.getString("bio"));
                e.setImageUrl(rs.getString("image_url"));
                e.setFacebookUrl(rs.getString("facebook_url"));
                e.setInstagramUrl(rs.getString("instagram_url"));
                e.setTwitterUrl(rs.getString("twitter_url"));
                e.setGoogleUrl(rs.getString("google_url"));
                e.setStatus(rs.getBoolean("status"));
                e.setCreatedAt(rs.getTimestamp("created_at"));

                // Gán đối tác nếu có
                int partnerId = rs.getInt("partner_id");
                if (partnerId > 0) {
                    Partner p = new Partner();
                    p.setId(rs.getInt("pid"));
                    p.setName(rs.getString("name"));
                    p.setEmail(rs.getString("email"));
                    p.setPhone(rs.getString("phone"));
                    p.setAddress(rs.getString("address"));
                    p.setDescription(rs.getString("description"));
                    p.setPartnerType(rs.getString("partner_type"));
                    p.setCountry(rs.getString("country"));
                    p.setPartnershipDate(rs.getDate("partnership_date"));
                    p.setProjectCount(rs.getInt("project_count"));
                    p.setLogoUrl(rs.getString("logo_url"));
                    p.setWebsite(rs.getString("website"));
                    p.setStatus(rs.getBoolean("pstatus"));
                    p.setCreatedAt(rs.getTimestamp("pcreated"));

                    e.setPartner(p);
                }

                list.add(e);
            }
        }
        return list;
    }

    public void insert(Expert e) throws Exception {
        String sql = """
        INSERT INTO experts (full_name, position, bio, image_url, twitter_url,
                             facebook_url, google_url, instagram_url, status, partner_id, created_at)
        VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, GETDATE())
    """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, e.getFullName());
            ps.setString(2, e.getPosition());
            ps.setString(3, e.getBio());
            ps.setString(4, e.getImageUrl());
            ps.setString(5, e.getTwitterUrl());
            ps.setString(6, e.getFacebookUrl());
            ps.setString(7, e.getGoogleUrl());
            ps.setString(8, e.getInstagramUrl());
            ps.setBoolean(9, e.isStatus());
            ps.setInt(10, e.getPartner().getId());
            ps.executeUpdate();
        }
    }

    public void update(Expert e) throws Exception {
        String sql = """
        UPDATE experts SET
            full_name = ?, position = ?, bio = ?, image_url = ?, twitter_url = ?,
            facebook_url = ?, google_url = ?, instagram_url = ?, status = ?, partner_id = ?
        WHERE id = ?
    """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, e.getFullName());
            ps.setString(2, e.getPosition());
            ps.setString(3, e.getBio());
            ps.setString(4, e.getImageUrl());
            ps.setString(5, e.getTwitterUrl());
            ps.setString(6, e.getFacebookUrl());
            ps.setString(7, e.getGoogleUrl());
            ps.setString(8, e.getInstagramUrl());
            ps.setBoolean(9, e.isStatus());
            ps.setInt(10, e.getPartner().getId());
            ps.setInt(11, e.getId());
            ps.executeUpdate();
        }
    }

    public void delete(int id) throws Exception {
        String sql = "DELETE FROM experts WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    public void toggleStatus(int id, boolean newStatus) throws Exception {
        String sql = "UPDATE experts SET status = ? WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setBoolean(1, newStatus);
            ps.setInt(2, id);
            ps.executeUpdate();
        }
    }

}

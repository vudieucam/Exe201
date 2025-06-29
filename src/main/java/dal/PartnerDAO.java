package dal;

import java.sql.*;
import java.util.*;
import model.Partner;

public class PartnerDAO extends DBConnect {

    public List<Partner> getAll() throws Exception {
        List<Partner> list = new ArrayList<>();
        String sql = "SELECT * FROM partners";

        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                list.add(map(rs));
            }
        }
        return list;
    }

    public Partner getById(int id) throws Exception {
        String sql = "SELECT * FROM partners WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return map(rs);
            }
        }
        return null;
    }

    public void insert(Partner p) throws Exception {
        String sql = """
            INSERT INTO partners 
            (name, email, phone, address, description, partner_type, country, 
             partnership_date, project_count, logo_url, website, status) 
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, p.getName());
            ps.setString(2, p.getEmail());
            ps.setString(3, p.getPhone());
            ps.setString(4, p.getAddress());
            ps.setString(5, p.getDescription());
            ps.setString(6, p.getPartnerType());
            ps.setString(7, p.getCountry());
            ps.setDate(8, p.getPartnershipDate());
            ps.setInt(9, p.getProjectCount());
            ps.setString(10, p.getLogoUrl());
            ps.setString(11, p.getWebsite());
            ps.setBoolean(12, p.isStatus());
            ps.executeUpdate();
        }
    }

    public void update(Partner p) throws Exception {
        String sql = """
            UPDATE partners SET 
                name=?, email=?, phone=?, address=?, description=?, 
                partner_type=?, country=?, partnership_date=?, 
                project_count=?, logo_url=?, website=?, status=? 
            WHERE id=?
        """;
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, p.getName());
            ps.setString(2, p.getEmail());
            ps.setString(3, p.getPhone());
            ps.setString(4, p.getAddress());
            ps.setString(5, p.getDescription());
            ps.setString(6, p.getPartnerType());
            ps.setString(7, p.getCountry());
            ps.setDate(8, p.getPartnershipDate());
            ps.setInt(9, p.getProjectCount());
            ps.setString(10, p.getLogoUrl());
            ps.setString(11, p.getWebsite());
            ps.setBoolean(12, p.isStatus());
            ps.setInt(13, p.getId());
            ps.executeUpdate();
        }
    }

    public void delete(int id) throws Exception {
        String sql = "DELETE FROM partners WHERE id=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    public void toggleStatus(int id, boolean newStatus) throws Exception {
        String sql = "UPDATE partners SET status=? WHERE id=?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setBoolean(1, newStatus);
            ps.setInt(2, id);
            ps.executeUpdate();
        }
    }

    public List<String> getDistinctPartnerTypes() throws Exception {
        List<String> types = new ArrayList<>();
        String sql = "SELECT DISTINCT partner_type FROM partners ORDER BY partner_type";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                types.add(rs.getString("partner_type"));
            }
        }
        return types;
    }

    public List<String> getDistinctCountries() throws Exception {
        List<String> countries = new ArrayList<>();
        String sql = "SELECT DISTINCT country FROM partners WHERE country IS NOT NULL ORDER BY country";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                countries.add(rs.getString("country"));
            }
        }
        return countries;
    }

    /* ========== Helper & Mapping ========== */
    private Partner map(ResultSet rs) throws SQLException {
        Partner p = new Partner();
        p.setId(rs.getInt("id"));
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
        p.setStatus(rs.getBoolean("status"));
        p.setCreatedAt(rs.getTimestamp("created_at"));
        return p;
    }

    private int getCount(String sql) throws Exception {
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            rs.next();
            return rs.getInt(1);
        }
    }

    /* ========== Pagination ========== */
    public List<Partner> getPage(int page, int size) throws Exception {
        String sql = """
            SELECT * FROM partners ORDER BY id
            OFFSET ? ROWS FETCH NEXT ? ROWS ONLY
        """;
        List<Partner> list = new ArrayList<>();
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, (page - 1) * size);
            ps.setInt(2, size);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(map(rs));
            }
        }
        return list;
    }

    public int countAll() throws Exception {
        return getCount("SELECT COUNT(*) FROM partners");
    }

    public int countByStatus(boolean status) throws Exception {
        return getCount("SELECT COUNT(*) FROM partners WHERE status=" + (status ? 1 : 0));
    }
}

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Pet;

/**
 *
 * @author FPT
 */
public class PetDAO extends DBConnect {

    public List<Pet> getAllActivePets() throws SQLException {
        String sql = "SELECT p.id, p.name, p.gender, p.age, p.color, p.weight, "
                + "p.breed, p.description, c.name AS category_name, i.image_url "
                + "FROM pets p "
                + "JOIN pet_categories c ON p.category_id = c.id "
                + "LEFT JOIN pet_images i ON p.id = i.pet_id AND i.is_primary = 1 "
                + "WHERE p.status = 1";

        List<Pet> list = new ArrayList<>();
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Pet p = new Pet();
                p.setId(rs.getInt("id"));
                p.setName(rs.getString("name"));
                p.setGender(rs.getString("gender"));
                p.setAge(rs.getInt("age"));
                p.setColor(rs.getString("color"));
                p.setWeight(rs.getDouble("weight"));
                p.setBreed(rs.getString("breed"));
                p.setDescription(rs.getString("description"));
                p.setCategoryName(rs.getString("category_name"));
                p.setPrimaryImage(rs.getString("image_url"));
                list.add(p);
            }
        }
        return list;
    }

    public List<Pet> getAllActivePetsAdmin() throws SQLException {
        String sql = "SELECT p.id, p.name, p.gender, p.age, p.color, p.weight, "
                + "p.breed, p.description, c.name AS category_name, i.image_url "
                + "FROM pets p "
                + "JOIN pet_categories c ON p.category_id = c.id "
                + "LEFT JOIN pet_images i ON p.id = i.pet_id AND i.is_primary = 1 ";

        List<Pet> list = new ArrayList<>();
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Pet p = new Pet();
                p.setId(rs.getInt("id"));
                p.setName(rs.getString("name"));
                p.setGender(rs.getString("gender"));
                p.setAge(rs.getInt("age"));
                p.setColor(rs.getString("color"));
                p.setWeight(rs.getDouble("weight"));
                p.setBreed(rs.getString("breed"));
                p.setDescription(rs.getString("description"));
                p.setCategoryName(rs.getString("category_name"));
                p.setPrimaryImage(rs.getString("image_url"));
                list.add(p);
            }
        }
        return list;
    }

    public void insert(Pet p) {
        String sql = "INSERT INTO pets(name, gender, age, color, weight, breed, description, category_id, primary_image, created_at, status) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setString(1, p.getName());
            ps.setString(2, p.getGender());
            ps.setInt(3, p.getAge());
            ps.setString(4, p.getColor());
            ps.setDouble(5, p.getWeight());
            ps.setString(6, p.getBreed());
            ps.setString(7, p.getDescription());
            ps.setInt(8, p.getCategoryId());
            ps.setString(9, p.getPrimaryImage());
            ps.setTimestamp(10, p.getCreatedAt());
            ps.setBoolean(11, p.isStatus());
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public List<Pet> getPetsByPage(int pageIndex, int pageSize) throws SQLException {
        String sql = "SELECT p.id, p.name, p.gender, p.age, p.color, c.name AS category_name, i.image_url "
                + "FROM pets p "
                + "JOIN pet_categories c ON p.category_id = c.id "
                + "LEFT JOIN pet_images i ON p.id = i.pet_id AND i.is_primary = 1 "
                + "WHERE p.status = 1 "
                + "ORDER BY p.id OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        List<Pet> list = new ArrayList<>();
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, (pageIndex - 1) * pageSize);
            ps.setInt(2, pageSize);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Pet p = new Pet();
                p.setId(rs.getInt("id"));
                p.setName(rs.getString("name"));
                p.setGender(rs.getString("gender"));
                p.setAge(rs.getInt("age"));
                p.setColor(rs.getString("color"));
                p.setCategoryName(rs.getString("category_name"));
                p.setPrimaryImage(rs.getString("image_url"));
                list.add(p);
            }
        }
        return list;
    }

    public int countAllPets() throws SQLException {
        String sql = "SELECT COUNT(*) FROM pets WHERE status = 1";
        try (PreparedStatement ps = connection.prepareStatement(sql); ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return 0;
    }

    // Xoá thú cưng theo ID
    public void delete(int id) {
        String sql = "DELETE FROM pets WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

// Đổi trạng thái hiển thị (ẩn/hiện)
    public void toggleStatus(int id) {
        String sql = "UPDATE pets SET status = 1 - status WHERE id = ?";
        try (PreparedStatement ps = connection.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

}

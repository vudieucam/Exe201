/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;


import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 *
 * @author FPT
 */
public class ProductDAO extends DBConnect{
    public List<Map<String, Object>> getTopSellingProducts(int limit) throws SQLException {
    String sql = "SELECT TOP (?) p.id, p.name, p.price, SUM(oi.quantity) as total_sold "
               + "FROM products p "
               + "JOIN order_items oi ON p.id = oi.product_id "
               + "GROUP BY p.id, p.name, p.price "
               + "ORDER BY total_sold DESC";
    
    List<Map<String, Object>> result = new ArrayList<>();
    try (PreparedStatement stmt = connection.prepareStatement(sql)) {
        stmt.setInt(1, limit);
        try (ResultSet rs = stmt.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> product = new HashMap<>();
                product.put("id", rs.getInt("id"));
                product.put("name", rs.getString("name"));
                product.put("price", rs.getBigDecimal("price"));
                product.put("total_sold", rs.getInt("total_sold"));
                result.add(product);
            }
        }
    }
    return result;
}
}

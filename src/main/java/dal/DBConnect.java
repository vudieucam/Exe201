package dal;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnect {
    protected Connection connection;

    public DBConnect() {
        try {
            // ✅ Đây là chuỗi đúng (KHÔNG có dấu cách dư, có thêm encrypt + trust)
            String url = "jdbc:sqlserver://localhost:1433;databaseName=PetTech;encrypt=true;trustServerCertificate=true";
            String username = "sa";
            String password = "123";
            Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
            connection = DriverManager.getConnection(url, username, password);
        } catch (ClassNotFoundException | SQLException ex) {
            System.out.println("❌ Lỗi kết nối:");
            ex.printStackTrace();
        }
    }

    public static void main(String[] args) {
        DBConnect d = new DBConnect();
        Connection connection = d.connection;

        if (connection != null) {
            System.out.println("✅ Kết nối cơ sở dữ liệu thành công.");
        } else {
            System.out.println("❌ Không thể kết nối đến cơ sở dữ liệu.");
        }
    }
}

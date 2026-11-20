package dao;

import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.sql.*;
import java.util.Properties;

/** JDBC base class from section C. Each request closes its own DAO connection. */
public class DAO3 implements AutoCloseable {
    protected final Connection con;

    public DAO3() throws SQLException {
        Properties settings = new Properties();
        try (InputStream input = DAO3.class.getResourceAsStream("/db.properties")) {
            settings.load(input);
            String localConfig = System.getProperty("restman.config");
            if (localConfig != null) {
                try (InputStream local = Files.newInputStream(Path.of(localConfig))) {
                    settings.load(local);
                }
            }
            String password = System.getenv("DB_PASSWORD");
            if (password != null) settings.setProperty("db.password", password);
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (Exception e) {
            throw new SQLException("Không đọc được cấu hình kết nối CSDL.", e);
        }
        con = DriverManager.getConnection(settings.getProperty("db.url"),
                settings.getProperty("db.user"), settings.getProperty("db.password"));
    }

    protected int generatedId(PreparedStatement statement) throws SQLException {
        try (ResultSet keys = statement.getGeneratedKeys()) {
            if (!keys.next()) throw new SQLException("Không lấy được mã vừa lưu.");
            return keys.getInt(1);
        }
    }

    protected String contains(String name) {
        return "%" + name.replace("!", "!!").replace("%", "!%").replace("_", "!_") + "%";
    }

    @Override
    public void close() throws SQLException {
        con.close();
    }
}

package dao;

import java.sql.*;
import java.util.ArrayList;
import model.Supplier3;

public class SupplierDAO3 extends DAO3 {
    public SupplierDAO3() throws SQLException { super(); }

    public Supplier3[] getNCCTheoTen(String ten) throws SQLException {
        ArrayList<Supplier3> suppliers = new ArrayList<>();
        try (PreparedStatement ps = con.prepareStatement("SELECT * FROM tblSupplier WHERE name LIKE ? ESCAPE '!' ORDER BY id")) {
            ps.setString(1, contains(ten));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) suppliers.add(readSupplier(rs));
            }
        }
        return suppliers.toArray(Supplier3[]::new);
    }

    public Supplier3 getNCC(int id) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement("SELECT * FROM tblSupplier WHERE id=?")) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? readSupplier(rs) : null;
            }
        }
    }

    public boolean themNCC(Supplier3 ncc) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement("INSERT INTO tblSupplier(name,phone) VALUES (?,?)", Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, ncc.getName());
            ps.setString(2, ncc.getPhone());
            ps.executeUpdate();
            ncc.setId(generatedId(ps));
            return true;
        }
    }

    private Supplier3 readSupplier(ResultSet rs) throws SQLException {
        Supplier3 supplier = new Supplier3();
        supplier.setId(rs.getInt("id"));
        supplier.setName(rs.getString("name"));
        supplier.setPhone(rs.getString("phone"));
        return supplier;
    }
}

package dao;

import java.sql.*;
import model.*;

public class HoaDonDAO3 extends DAO3 {
    public HoaDonDAO3() throws SQLException { super(); }

    public boolean luuHoaDon(ImportReceipt3 hoaDon) throws SQLException {
        String sql = """
                INSERT INTO tblImportReceipt(tblImportIngredientId,name,date,totalPrice)
                SELECT p.id, ?, p.date, SUM(d.quantity*d.unitCost)
                FROM tblImportIngredient p JOIN tblImportDetail d ON d.importIngredientId=p.id
                WHERE p.id=? GROUP BY p.id,p.date
                ON DUPLICATE KEY UPDATE id=LAST_INSERT_ID(tblImportReceipt.id)
                """;
        try (PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, hoaDon.getName());
            ps.setInt(2, hoaDon.getImportIngredient().getId());
            ps.executeUpdate();
            hoaDon.setId(generatedId(ps));
            return true;
        }
    }

    public ImportReceipt3 getHoaDon(int id) throws SQLException {
        String sql = """
                SELECT r.*, p.date AS importDate, p.description, p.warehouseStaffId,
                       s.id AS supplierId, s.name AS supplierName, s.phone,
                       m.fullName, st.staffCode, st.role
                FROM tblImportReceipt r
                JOIN tblImportIngredient p ON p.id=r.tblImportIngredientId
                JOIN tblSupplier s ON s.id=p.tblSupplierid
                JOIN tblMember m ON m.id=p.warehouseStaffId
                JOIN tblStaff st ON st.id=m.id WHERE r.id=?
                """;
        ImportReceipt3 receipt;
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;
                receipt = new ImportReceipt3();
                receipt.setId(rs.getInt("id"));
                receipt.setName(rs.getString("name"));
                receipt.setDate(rs.getDate("date").toLocalDate());
                receipt.setTotalPrice(rs.getBigDecimal("totalPrice"));
                ImportIngredient3 phieu = new ImportIngredient3();
                phieu.setId(rs.getInt("tblImportIngredientId"));
                phieu.setDate(rs.getDate("importDate").toLocalDate());
                phieu.setDescription(rs.getString("description"));
                Supplier3 supplier = new Supplier3();
                supplier.setId(rs.getInt("supplierId"));
                supplier.setName(rs.getString("supplierName"));
                supplier.setPhone(rs.getString("phone"));
                WarehouseStaff3 staff = new WarehouseStaff3();
                staff.setId(rs.getInt("warehouseStaffId"));
                staff.setFullName(rs.getString("fullName"));
                staff.setStaffCode(rs.getString("staffCode"));
                staff.setRole(rs.getString("role"));
                phieu.setSupplier(supplier);
                phieu.setWarehouseStaff(staff);
                receipt.setImportIngredient(phieu);
            }
        }
        try (PreparedStatement ps = con.prepareStatement("SELECT d.*, i.name, i.unit FROM tblImportDetail d JOIN tblIngredient i ON i.id=d.ingredientId WHERE d.importIngredientId=? ORDER BY d.id")) {
            ps.setInt(1, receipt.getImportIngredient().getId());
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Ingredient3 ingredient = new Ingredient3();
                    ingredient.setId(rs.getInt("ingredientId"));
                    ingredient.setName(rs.getString("name"));
                    ingredient.setUnit(rs.getString("unit"));
                    ingredient.setUnitCost(rs.getBigDecimal("unitCost"));
                    ImportDetail detail = new ImportDetail();
                    detail.setId(rs.getInt("id"));
                    detail.setIngredient(ingredient);
                    detail.setQuantity(rs.getInt("quantity"));
                    detail.setUnitCost(rs.getBigDecimal("unitCost"));
                    receipt.getImportIngredient().getImportDetail().add(detail);
                }
            }
        }
        return receipt;
    }
}

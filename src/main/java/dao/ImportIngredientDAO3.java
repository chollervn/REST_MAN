package dao;

import java.sql.*;
import model.*;

public class ImportIngredientDAO3 extends DAO3 {
    public ImportIngredientDAO3() throws SQLException { super(); }

    public boolean luuPhieuNhap(ImportIngredient3 phieu, WarehouseStaff3 nv, Supplier3 ncc) throws SQLException {
        if (phieu.getId() > 0) return true;
        if (phieu.getImportDetail().isEmpty()) throw new IllegalArgumentException("Phiếu nhập chưa có nguyên liệu.");
        con.setAutoCommit(false);
        try {
            int id;
            try (PreparedStatement ps = con.prepareStatement("INSERT INTO tblImportIngredient(date,description,warehouseStaffId,tblSupplierid) VALUES (?,?,?,?)", Statement.RETURN_GENERATED_KEYS)) {
                ps.setDate(1, Date.valueOf(phieu.getDate()));
                ps.setString(2, phieu.getDescription());
                ps.setInt(3, nv.getId());
                ps.setInt(4, ncc.getId());
                ps.executeUpdate();
                id = generatedId(ps);
            }
            try (PreparedStatement ps = con.prepareStatement("INSERT INTO tblImportDetail(importIngredientId,ingredientId,quantity,unitCost) VALUES (?,?,?,?)")) {
                for (ImportDetail detail : phieu.getImportDetail()) {
                    ps.setInt(1, id);
                    ps.setInt(2, detail.getIngredient().getId());
                    ps.setInt(3, detail.getQuantity());
                    ps.setBigDecimal(4, detail.getUnitCost());
                    ps.addBatch();
                }
                ps.executeBatch();
            }
            con.commit();
            phieu.setId(id);
            phieu.setWarehouseStaff(nv);
            phieu.setSupplier(ncc);
            return true;
        } catch (SQLException e) {
            con.rollback();
            throw e;
        } finally {
            con.setAutoCommit(true);
        }
    }
}

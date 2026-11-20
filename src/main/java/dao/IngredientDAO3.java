package dao;

import java.sql.*;
import java.util.ArrayList;
import model.*;

public class IngredientDAO3 extends DAO3 {
    public IngredientDAO3() throws SQLException { super(); }

    public Ingredient3[] getNLTheoTen(String ten, Supplier3 ncc) throws SQLException {
        ArrayList<Ingredient3> ingredients = new ArrayList<>();
        try (PreparedStatement ps = con.prepareStatement("SELECT i.*, p.id AS linkId, p.unitPrice FROM tblIngredient i JOIN tblIngredientSupplier p ON p.ingredientId=i.id WHERE p.supplierId=? AND i.name LIKE ? ESCAPE '!' ORDER BY i.id")) {
            ps.setInt(1, ncc.getId());
            ps.setString(2, contains(ten));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) ingredients.add(readIngredient(rs, ncc));
            }
        }
        return ingredients.toArray(Ingredient3[]::new);
    }

    public Ingredient3 getNL(int id, Supplier3 ncc) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement("SELECT i.*, p.id AS linkId, p.unitPrice FROM tblIngredient i JOIN tblIngredientSupplier p ON p.ingredientId=i.id WHERE p.supplierId=? AND i.id=?")) {
            ps.setInt(1, ncc.getId());
            ps.setInt(2, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? readIngredient(rs, ncc) : null;
            }
        }
    }

    public boolean themNL(Ingredient3 nl, Supplier3 ncc) throws SQLException {
        int price = nl.getUnitCost().intValueExact();
        if (price < 0) throw new IllegalArgumentException("Đơn giá phải từ 0 trở lên.");
        con.setAutoCommit(false);
        try {
            int id;
            // Reuse the same name/unit even when two requests add it concurrently.
            try (PreparedStatement ps = con.prepareStatement("INSERT INTO tblIngredient(name,unit) VALUES (?,?) ON DUPLICATE KEY UPDATE id=LAST_INSERT_ID(id)", Statement.RETURN_GENERATED_KEYS)) {
                ps.setString(1, nl.getName());
                ps.setString(2, nl.getUnit());
                ps.executeUpdate();
                id = generatedId(ps);
            }
            try (PreparedStatement ps = con.prepareStatement("INSERT INTO tblIngredientSupplier(ingredientId,supplierId,unitPrice) VALUES (?,?,?) ON DUPLICATE KEY UPDATE id=LAST_INSERT_ID(id)")) {
                ps.setInt(1, id);
                ps.setInt(2, ncc.getId());
                ps.setInt(3, price);
                ps.executeUpdate();
            }
            con.commit();
            nl.setId(id);
            return true;
        } catch (SQLException e) {
            con.rollback();
            throw e;
        } finally {
            con.setAutoCommit(true);
        }
    }

    private Ingredient3 readIngredient(ResultSet rs, Supplier3 ncc) throws SQLException {
        Ingredient3 ingredient = new Ingredient3();
        ingredient.setId(rs.getInt("id"));
        ingredient.setName(rs.getString("name"));
        ingredient.setUnit(rs.getString("unit"));
        ingredient.setUnitCost(rs.getBigDecimal("unitPrice"));
        IngredientSupplier3 link = new IngredientSupplier3();
        link.setId(rs.getInt("linkId"));
        link.setSupplier(ncc);
        link.setUnitPrice(ingredient.getUnitCost());
        ingredient.setIngredientSupplier(new IngredientSupplier3[]{link});
        return ingredient;
    }
}

package dao;

import java.sql.*;
import java.util.ArrayList;
import model.Dish3;

public class DishDAO3 extends DAO3 {
    public DishDAO3() throws SQLException { super(); }

    public Dish3[] getDsMonAnTheoTen(String name) throws SQLException {
        ArrayList<Dish3> dishes = new ArrayList<>();
        try (PreparedStatement ps = con.prepareStatement("SELECT i.* FROM tblDish d JOIN tblSellableItem i ON i.id=d.id WHERE i.name LIKE ? ESCAPE '!' ORDER BY i.id")) {
            ps.setString(1, contains(name));
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) dishes.add(readDish(rs));
            }
        }
        return dishes.toArray(Dish3[]::new);
    }

    public Dish3 getMonAn(int id) throws SQLException {
        try (PreparedStatement ps = con.prepareStatement("SELECT i.* FROM tblDish d JOIN tblSellableItem i ON i.id=d.id WHERE d.id=?")) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? readDish(rs) : null;
            }
        }
    }

    private Dish3 readDish(ResultSet rs) throws SQLException {
        Dish3 dish = new Dish3();
        dish.setId(rs.getInt("id"));
        dish.setName(rs.getString("name"));
        dish.setPrice(rs.getBigDecimal("price"));
        dish.setDescription(rs.getString("description"));
        return dish;
    }
}

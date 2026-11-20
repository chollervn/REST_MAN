package dao;

import java.sql.*;
import model.*;

public class MemberDAO3 extends DAO3 {
    public MemberDAO3() throws SQLException { super(); }

    public Member3 dangNhap(String username, String password) throws SQLException {
        String sql = """
                SELECT m.*, c.id AS customerId, w.id AS warehouseId, s.role, s.staffCode
                FROM tblMember m
                LEFT JOIN tblCustomer c ON c.id=m.id
                LEFT JOIN tblStaff s ON s.id=m.id
                LEFT JOIN tblWarehouseStaff w ON w.id=s.id
                WHERE m.username=? AND m.password=?
                """;
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, username);
            ps.setString(2, password);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;
                Member3 member;
                if (rs.getObject("warehouseId") != null) {
                    WarehouseStaff3 staff = new WarehouseStaff3();
                    staff.setRole(rs.getString("role"));
                    staff.setStaffCode(rs.getString("staffCode"));
                    member = staff;
                } else if (rs.getObject("customerId") != null) {
                    member = new Customer3();
                } else {
                    return null;
                }
                member.setId(rs.getInt("id"));
                member.setUsername(rs.getString("username"));
                member.setFullName(rs.getString("fullName"));
                member.setPhone(rs.getString("phone"));
                member.setEmail(rs.getString("email"));
                return member;
            }
        }
    }
}

package model;

import java.io.Serializable;

public class Staff3 extends Member3 implements Serializable {
    private String role;
    private String staffCode;

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getStaffCode() {
        return staffCode;
    }

    public void setStaffCode(String staffCode) {
        this.staffCode = staffCode;
    }
}

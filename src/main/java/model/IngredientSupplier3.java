package model;

import java.io.Serializable;
import java.math.BigDecimal;

public class IngredientSupplier3 implements Serializable {
    private int id;
    private Supplier3 supplier;
    private BigDecimal unitPrice = BigDecimal.ZERO;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Supplier3 getSupplier() {
        return supplier;
    }

    public void setSupplier(Supplier3 supplier) {
        this.supplier = supplier;
    }

    public BigDecimal getUnitPrice() {
        return unitPrice;
    }

    public void setUnitPrice(BigDecimal unitPrice) {
        this.unitPrice = unitPrice;
    }
}

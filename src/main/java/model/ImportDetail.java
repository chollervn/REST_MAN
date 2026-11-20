package model;

import java.io.Serializable;
import java.math.BigDecimal;

public class ImportDetail implements Serializable {
    private int id;
    private Ingredient3 ingredient;
    private int quantity;
    private BigDecimal unitCost = BigDecimal.ZERO;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public Ingredient3 getIngredient() {
        return ingredient;
    }

    public void setIngredient(Ingredient3 ingredient) {
        this.ingredient = ingredient;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getUnitCost() {
        return unitCost;
    }

    public void setUnitCost(BigDecimal unitCost) {
        this.unitCost = unitCost;
    }

    public BigDecimal getThanhTien() {
        return unitCost.multiply(BigDecimal.valueOf(quantity));
    }
}

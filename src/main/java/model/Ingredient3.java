package model;

import java.io.Serializable;
import java.math.BigDecimal;

public class Ingredient3 implements Serializable {
    private int id;
    private String name;
    private String unit;
    private BigDecimal unitCost = BigDecimal.ZERO;
    private IngredientSupplier3[] ingredientSupplier;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getUnit() {
        return unit;
    }

    public void setUnit(String unit) {
        this.unit = unit;
    }

    public BigDecimal getUnitCost() {
        return unitCost;
    }

    public void setUnitCost(BigDecimal unitCost) {
        this.unitCost = unitCost;
    }

    public IngredientSupplier3[] getIngredientSupplier() {
        return ingredientSupplier;
    }

    public void setIngredientSupplier(IngredientSupplier3[] ingredientSupplier) {
        this.ingredientSupplier = ingredientSupplier;
    }
}

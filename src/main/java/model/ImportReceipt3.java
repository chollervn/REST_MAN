package model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDate;

public class ImportReceipt3 implements Serializable {
    private int id;
    private String name;
    private LocalDate date = LocalDate.now();
    private BigDecimal totalPrice = BigDecimal.ZERO;
    private ImportIngredient3 importIngredient;

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

    public LocalDate getDate() {
        return date;
    }

    public void setDate(LocalDate date) {
        this.date = date;
    }

    public BigDecimal getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(BigDecimal totalPrice) {
        this.totalPrice = totalPrice;
    }

    public ImportIngredient3 getImportIngredient() {
        return importIngredient;
    }

    public void setImportIngredient(ImportIngredient3 importIngredient) {
        this.importIngredient = importIngredient;
    }

    public String getCode() {
        return String.format("HD%03d", id);
    }
}

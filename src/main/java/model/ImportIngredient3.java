package model;

import java.io.Serializable;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

public class ImportIngredient3 implements Serializable {
    private int id;
    private LocalDate date = LocalDate.now();
    private String description;
    private WarehouseStaff3 warehouseStaff;
    private Supplier3 supplier;
    private List<ImportDetail> importDetail = new ArrayList<>();
    private ImportReceipt3 importReceipt;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public LocalDate getDate() {
        return date;
    }

    public void setDate(LocalDate date) {
        this.date = date;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public WarehouseStaff3 getWarehouseStaff() {
        return warehouseStaff;
    }

    public void setWarehouseStaff(WarehouseStaff3 warehouseStaff) {
        this.warehouseStaff = warehouseStaff;
    }

    public Supplier3 getSupplier() {
        return supplier;
    }

    public void setSupplier(Supplier3 supplier) {
        this.supplier = supplier;
    }

    public List<ImportDetail> getImportDetail() {
        return importDetail;
    }

    public void setImportDetail(List<ImportDetail> importDetail) {
        this.importDetail = importDetail;
    }

    public ImportReceipt3 getImportReceipt() {
        return importReceipt;
    }

    public void setImportReceipt(ImportReceipt3 importReceipt) {
        this.importReceipt = importReceipt;
    }

    public BigDecimal getTotalPrice() {
        BigDecimal total = BigDecimal.ZERO;
        for (ImportDetail detail : importDetail) {
            total = total.add(detail.getThanhTien());
        }
        return total;
    }
}

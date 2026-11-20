-- RestMan: customer dish search and warehouse ingredient import.
-- Target: MySQL 8.0.16+ (enforced CHECK constraints).
-- Run in an empty restman schema. Stop on errors when importing this file.
-- JDBC URL: jdbc:mysql://localhost:3306/restman
-- Supply the MySQL username and password separately in Java.
-- Application passwords are stored directly as requested for this exercise.

CREATE DATABASE IF NOT EXISTS restman
    CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;

USE restman;
SET NAMES utf8mb4;

CREATE TABLE tblMember (
    id INT NOT NULL AUTO_INCREMENT,
    username VARCHAR(100) COLLATE utf8mb4_0900_as_cs NOT NULL,
    password VARCHAR(100) COLLATE utf8mb4_0900_as_cs NOT NULL,
    fullName VARCHAR(150) NOT NULL,
    phone VARCHAR(30) NULL,
    email VARCHAR(255) NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_member_username (username)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Subtype IDs are also foreign keys. Insert the parent first and reuse its ID.
CREATE TABLE tblCustomer (
    id INT NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_customer_member FOREIGN KEY (id) REFERENCES tblMember (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE tblStaff (
    id INT NOT NULL,
    role VARCHAR(50) NOT NULL,
    staffCode VARCHAR(30) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_staff_code (staffCode),
    CONSTRAINT fk_staff_member FOREIGN KEY (id) REFERENCES tblMember (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE tblWarehouseStaff (
    id INT NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_warehouse_staff FOREIGN KEY (id) REFERENCES tblStaff (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE tblMenu (
    id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(150) NOT NULL,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE tblSellableItem (
    id INT NOT NULL AUTO_INCREMENT,
    menuId INT NOT NULL,
    name VARCHAR(150) NOT NULL,
    price DECIMAL(12,2) NOT NULL,
    description VARCHAR(500) NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_sellable_item_menu FOREIGN KEY (menuId) REFERENCES tblMenu (id),
    CONSTRAINT ck_sellable_item_price CHECK (price >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE tblDish (
    id INT NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_dish_sellable_item FOREIGN KEY (id) REFERENCES tblSellableItem (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE tblSupplier (
    id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(150) NOT NULL,
    phone VARCHAR(30) NULL,
    PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE tblIngredient (
    id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(150) COLLATE utf8mb4_0900_as_ci NOT NULL,
    unit VARCHAR(30) COLLATE utf8mb4_0900_as_ci NOT NULL,
    PRIMARY KEY (id),
    -- Reuse an existing ingredient with the same name and unit for another supplier.
    UNIQUE KEY uq_ingredient_name_unit (name, unit)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE tblIngredientSupplier (
    id INT NOT NULL AUTO_INCREMENT,
    ingredientId INT NOT NULL,
    supplierId INT NOT NULL,
    unitPrice INT NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_ingredient_supplier (ingredientId, supplierId),
    CONSTRAINT fk_ingredient_supplier_ingredient FOREIGN KEY (ingredientId)
        REFERENCES tblIngredient (id),
    CONSTRAINT fk_ingredient_supplier_supplier FOREIGN KEY (supplierId)
        REFERENCES tblSupplier (id),
    CONSTRAINT ck_ingredient_supplier_price CHECK (unitPrice >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE tblImportIngredient (
    id INT NOT NULL AUTO_INCREMENT,
    date DATE NOT NULL,
    description VARCHAR(500) NULL,
    warehouseStaffId INT NOT NULL,
    tblSupplierid INT NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_import_warehouse_staff FOREIGN KEY (warehouseStaffId)
        REFERENCES tblWarehouseStaff (id),
    CONSTRAINT fk_import_supplier FOREIGN KEY (tblSupplierid) REFERENCES tblSupplier (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Servlet/DAO saves the header and all detail rows in one JDBC transaction.
-- Copy the selected supplier price into unitCost when building the draft line.
CREATE TABLE tblImportDetail (
    id INT NOT NULL AUTO_INCREMENT,
    importIngredientId INT NOT NULL,
    ingredientId INT NOT NULL,
    quantity INT NOT NULL,
    unitCost DECIMAL(12,2) NOT NULL,
    PRIMARY KEY (id),
    CONSTRAINT fk_import_detail_import FOREIGN KEY (importIngredientId)
        REFERENCES tblImportIngredient (id),
    CONSTRAINT fk_import_detail_ingredient FOREIGN KEY (ingredientId)
        REFERENCES tblIngredient (id),
    CONSTRAINT ck_import_detail_quantity CHECK (quantity > 0),
    CONSTRAINT ck_import_detail_cost CHECK (unitCost >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- DAO derives totalPrice from the saved quantity * unitCost detail rows.
-- On reopening an import, read its existing receipt using tblImportIngredientId.
CREATE TABLE tblImportReceipt (
    id INT NOT NULL AUTO_INCREMENT,
    tblImportIngredientId INT NOT NULL,
    name VARCHAR(150) NOT NULL,
    date DATE NOT NULL,
    totalPrice DECIMAL(12,2) NOT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY uq_import_receipt_import (tblImportIngredientId),
    CONSTRAINT fk_import_receipt_import FOREIGN KEY (tblImportIngredientId)
        REFERENCES tblImportIngredient (id),
    CONSTRAINT ck_import_receipt_total CHECK (totalPrice >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

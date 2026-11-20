-- Demo accounts: khachhang / 123456 and kho / 123456.
-- Existing accounts and supplier prices are preserved on reruns.
USE restman;
SET NAMES utf8mb4;
START TRANSACTION;
INSERT INTO tblMember(username,password,fullName,phone,email)
VALUES ('khachhang','123456','Trần Minh Anh','0901234567','khach@example.com'),
       ('kho','123456','Nguyễn Văn A','0902345678','kho@example.com')
ON DUPLICATE KEY UPDATE id=LAST_INSERT_ID(id);
INSERT IGNORE INTO tblCustomer(id) SELECT id FROM tblMember WHERE username='khachhang';
INSERT IGNORE INTO tblStaff(id,role,staffCode) SELECT id,'WAREHOUSE','KHO001' FROM tblMember WHERE username='kho';
INSERT IGNORE INTO tblWarehouseStaff(id) SELECT id FROM tblStaff WHERE id=(SELECT id FROM tblMember WHERE username='kho');

INSERT INTO tblMenu(name) SELECT 'Thực đơn chính' WHERE NOT EXISTS (SELECT 1 FROM tblMenu WHERE name='Thực đơn chính');
SET @menu=(SELECT id FROM tblMenu WHERE name='Thực đơn chính' ORDER BY id LIMIT 1);
INSERT INTO tblSellableItem(menuId,name,price,description)
SELECT @menu,'Phở bò',50000,'Phở bò với nước dùng ninh xương, bánh phở và rau thơm.'
WHERE NOT EXISTS (SELECT 1 FROM tblSellableItem WHERE menuId=@menu AND name='Phở bò');
INSERT INTO tblSellableItem(menuId,name,price,description)
SELECT @menu,'Phở gà',45000,'Phở gà ta, bánh phở mềm, hành lá và nước dùng thanh.'
WHERE NOT EXISTS (SELECT 1 FROM tblSellableItem WHERE menuId=@menu AND name='Phở gà');
INSERT INTO tblSellableItem(menuId,name,price,description)
SELECT @menu,'Cơm rang hải sản',65000,'Cơm rang cùng tôm, mực, trứng và rau củ.'
WHERE NOT EXISTS (SELECT 1 FROM tblSellableItem WHERE menuId=@menu AND name='Cơm rang hải sản');
INSERT IGNORE INTO tblDish(id) SELECT id FROM tblSellableItem
WHERE menuId=@menu AND name IN ('Phở bò','Phở gà','Cơm rang hải sản');

INSERT INTO tblSupplier(name,phone) SELECT 'An Phú','0901234567' WHERE NOT EXISTS (SELECT 1 FROM tblSupplier WHERE name='An Phú');
INSERT INTO tblSupplier(name,phone) SELECT 'Bình Minh','0902345678' WHERE NOT EXISTS (SELECT 1 FROM tblSupplier WHERE name='Bình Minh');
SET @anphu=(SELECT id FROM tblSupplier WHERE name='An Phú' ORDER BY id LIMIT 1);
SET @binhminh=(SELECT id FROM tblSupplier WHERE name='Bình Minh' ORDER BY id LIMIT 1);
INSERT IGNORE INTO tblIngredient(name,unit) VALUES ('Gạo','kg'),('Thịt bò','kg'),('Thịt gà','kg');
INSERT INTO tblIngredientSupplier(ingredientId,supplierId,unitPrice)
SELECT id,@anphu,20000 FROM tblIngredient WHERE name='Gạo' AND unit='kg'
ON DUPLICATE KEY UPDATE id=LAST_INSERT_ID(tblIngredientSupplier.id);
INSERT INTO tblIngredientSupplier(ingredientId,supplierId,unitPrice)
SELECT id,@binhminh,25000 FROM tblIngredient WHERE name='Gạo' AND unit='kg'
ON DUPLICATE KEY UPDATE id=LAST_INSERT_ID(tblIngredientSupplier.id);
INSERT INTO tblIngredientSupplier(ingredientId,supplierId,unitPrice)
SELECT id,@anphu,200000 FROM tblIngredient WHERE name='Thịt bò' AND unit='kg'
ON DUPLICATE KEY UPDATE id=LAST_INSERT_ID(tblIngredientSupplier.id);
INSERT INTO tblIngredientSupplier(ingredientId,supplierId,unitPrice)
SELECT id,@anphu,90000 FROM tblIngredient WHERE name='Thịt gà' AND unit='kg'
ON DUPLICATE KEY UPDATE id=LAST_INSERT_ID(tblIngredientSupplier.id);
COMMIT;

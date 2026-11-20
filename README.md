# RestMan PTTK

Hai module tìm kiếm món ăn và nhập nguyên liệu theo phần C của tài liệu `21B23DCCN683-final - finalllllll.docx`.

Ứng dụng dùng Java 21, Jakarta Servlet 6, JSP/JSTL, JDBC và MySQL 8. Đóng gói WAR để chạy trên Tomcat 10.1.

## Cài đặt sau khi clone

1. Cài JDK 21, MySQL 8 và IntelliJ IDEA có hỗ trợ Maven.
2. Clone repo: `git clone https://github.com/chollervn/REST_MAN.git`, rồi mở `pom.xml` dưới dạng Maven project.
3. Trong MySQL, chạy `database/restman.sql` để tạo CSDL và bảng, sau đó chạy `database/seed.sql` để thêm dữ liệu mẫu.
4. Sao chép `local.properties.example` thành `local.properties` tại thư mục gốc project, thay `YOUR_MYSQL_PASSWORD` bằng mật khẩu MySQL của máy bạn. File này không được đưa lên Git.
5. Reload Maven, mở `src/main/java/Main.java` và chạy `main()`. Truy cập http://localhost:8085/PTTK/. Không cần cài Tomcat riêng khi chạy bằng `Main`.

Các đường dẫn `D:\PTTK` và đường dẫn công cụ trong hướng dẫn bên dưới thuộc máy phát triển ban đầu; trên máy khác dùng thư mục clone của bạn. Các script `run.ps1`/`stop.ps1` là lựa chọn chạy bằng Tomcat riêng.

## Chạy trên máy hiện tại

### Bấm Run hàm main trong IntelliJ

1. Mở project `D:\PTTK`, chọn SDK 21. Nếu IDE chưa nhận Maven, nhấn chuột phải `pom.xml` → **Add as Maven Project**. Nếu đã nhận, chọn **Reload All Maven Projects** để tải thư viện Tomcat nhúng vừa thêm.
2. Nếu đang chạy bằng `run.ps1`, chạy `./stop.ps1` trước để giải phóng cổng 8085.
3. Mở `src/main/java/Main.java`, bấm nút tam giác cạnh `main()` → **Run 'Main.main()'**. Hoặc chọn cấu hình **PTTK - Main** rồi bấm Run/Debug.
4. Khi console hiện địa chỉ `http://localhost:8085/PTTK/`, mở địa chỉ đó. Bấm **Stop** trong IntelliJ để dừng; sau khi sửa Java, chạy lại để nạp code mới.

`Main` khởi động Tomcat nhúng, nạp các Servlet/Filter qua annotation, JSP/JSTL và đọc `local.properties` tại thư mục project. Không cần chạy `run.ps1` hay khởi động Tomcat riêng khi dùng cách này. MySQL vẫn cần đang chạy. Để đổi cổng, đặt VM options `-Drestman.port=8086` trong Run Configuration. Working directory là thư mục project.

Lớp `Main` chỉ phụ trách khởi động server; luồng JSP → Servlet → DAO theo phần C giữ nguyên. Cấu hình tài nguyên dựa trên [API Tomcat nhúng](https://tomcat.apache.org/tomcat-10.1-doc/api/org/apache/catalina/startup/Tomcat.html).

### Chạy bằng Tomcat riêng như trước

Mở terminal PowerShell 7 trong `D:\PTTK` và chạy `./run.ps1`. Truy cập http://localhost:8085/PTTK/.

Chạy `./stop.ps1` để dừng. Sau khi sửa code, dừng rồi chạy lại `./run.ps1` để build và nạp bản mới. Tham số `-Port`, `-JavaHome`, `-TomcatHome`, `-Maven` cho phép chọn lại môi trường khi cần.

Trong IntelliJ, mở `pom.xml` dưới dạng Maven project và chọn Project SDK 21. Source Java nằm trong `src/main/java`, JSP nằm trong `src/main/webapp/WEB-INF/views`. Bản đóng gói là `target/PTTK.war`.

| Vai trò | Tên đăng nhập | Mật khẩu mẫu |
|---|---|---|
| Khách hàng | `khachhang` | `123456` |
| Nhân viên kho | `kho` | `123456` |

CSDL `restman` trên máy đã có cấu trúc và dữ liệu mẫu. `database/restman.sql` tạo cấu trúc cho một schema trống. `database/seed.sql` thêm dữ liệu mẫu và có thể chạy lại. Dữ liệu mẫu gồm ba món ăn, hai nhà cung cấp và ba nguyên liệu. Gạo của An Phú có giá 20.000 đồng/kg, của Bình Minh là 25.000 đồng/kg.

`src/main/resources/db.properties` chứa URL và user MySQL. Mật khẩu MySQL nằm trong `local.properties` tại thư mục project, được loại khỏi Git và WAR. `run.ps1` truyền đường dẫn này bằng `-Drestman.config`. Có thể dùng biến môi trường `DB_PASSWORD` thay thế. Mật khẩu đăng nhập mẫu của ứng dụng được lưu trực tiếp trong `tblMember.password` theo yêu cầu bài thực hành.

## Đối chiếu phần C khi vấn đáp

Tên JSP, model và các hàm DAO nghiệp vụ được giữ theo thiết kế. Do sử dụng Java Servlet, form JSP gửi yêu cầu tới Servlet, Servlet gọi DAO rồi chuyển dữ liệu cho JSP bằng request attributes. Đây là bước hiện thực xử lý yêu cầu HTTP giữa giao diện và DAO mô tả trong tài liệu.

| Giao diện trong phần C | Servlet và URL | Hàm DAO chính |
|---|---|---|
| `GDChinhKH3.jsp` | `DishServlet` — `/customer` | Trang chủ khách hàng |
| `GDTimMonAn3.jsp` | `DishServlet` — `/dishes` | `DishDAO3.getDsMonAnTheoTen(name)` |
| `GDChiTietMonAn3.jsp` | `DishServlet` — `/dish` | `DishDAO3.getMonAn(id)` |
| `GDChinhNVKho3.jsp` | `SupplierServlet` — `/warehouse` | Trang chủ nhân viên kho |
| `GDTimNCC3.jsp` | `SupplierServlet` — `/suppliers` | `SupplierDAO3.getNCCTheoTen(ten)` |
| `GDThemNCC3.jsp` | `SupplierServlet` — `/supplier/new` | `SupplierDAO3.themNCC(ncc)` |
| `GDNhapNguyenLieu3.jsp` | `ImportServlet` — `/imports` | `IngredientDAO3.getNLTheoTen(ten, ncc)` |
| `GDThemNguyenLieu3.jsp` | `ImportServlet` — `/ingredients/new` | `IngredientDAO3.themNL(nl, ncc)` |
| `GDXacNhanNhap3.jsp` | `ImportServlet` — `/imports/confirm` | `ImportIngredientDAO3.luuPhieuNhap(phieu, nv, ncc)` |
| `GDHoaDonNhap3.jsp` | `HoaDonServlet` — `/receipt` | `HoaDonDAO3.luuHoaDon(hoaDon)` rồi `getHoaDon(id)` |

Trang `GDDangNhap3.jsp`, `LoginServlet` và `MemberDAO3.dangNhap` cung cấp bước đăng nhập trước hai module. Các hàm `getNCC(id)` và `getNL(id, ncc)` hỗ trợ lấy đối tượng được chọn từ mã trên form.

## Luồng dữ liệu cần giải thích

- `Customer3` kế thừa `Member3`. `WarehouseStaff3` kế thừa `Staff3`, rồi `Member3`. `Dish3` kế thừa `SellableItem3`. DAO đọc các bảng cha và bảng con theo cùng mã.
- `HttpSession.member` giữ người đăng nhập. `HttpSession.phieu` giữ `ImportIngredient3`, nhà cung cấp và danh sách `ImportDetail` trong lúc lập phiếu. Chọn lại cùng nhà cung cấp giữ phiếu đang lập. Chọn nhà cung cấp khác bắt đầu phiếu mới.
- `Ingredient3.unitCost` là giá lấy theo nhà cung cấp đang chọn. Khi thêm dòng nhập, giá được chép vào `ImportDetail.unitCost`. Tiền dùng `BigDecimal`, ngày dùng `LocalDate`, danh sách chi tiết dùng `List<ImportDetail>` để thêm và xóa dòng.
- Nút **Xác nhận** chỉ mở trang kiểm tra. Nút **Xác nhận nhập** gọi `luuPhieuNhap`, lưu phiếu và tất cả dòng trong một transaction, sau đó cập nhật `phieu.id`.
- Theo bước 73 của sequence, `ImportServlet` chuyển tiếp phiếu đã lưu sang `HoaDonServlet` bằng `RequestDispatcher.forward`. `HoaDonServlet.post` tạo `ImportReceipt3` và gọi `luuHoaDon`. Sau đó chuyển sang GET `/receipt?id=...`, nơi `HoaDonServlet.get` gọi `getHoaDon(id)` một lần để hiển thị `GDHoaDonNhap3.jsp`. DAO tính tổng từ các dòng đã lưu. Nút **Xuất hóa đơn** mở hộp thoại in của trình duyệt. Nhân viên thanh toán cho nhà cung cấp sau khi in theo kịch bản C.
- Nếu lưu hóa đơn lỗi sau khi phiếu đã lưu, session giữ mã phiếu để thử lại. Ràng buộc mỗi phiếu có một hóa đơn cùng xử lý tuần tự trong session giúp tránh tạo trùng khi bấm xác nhận lặp.

## Thử nghiệp vụ

Đăng nhập `khachhang`, tìm `Phở`, mở chi tiết một món rồi quay lại kết quả. Đăng nhập `kho`, chọn An Phú, tìm Gạo, thêm 10 kg. Phiếu và hóa đơn phải có tổng 200.000 đồng. Thử thêm nguyên liệu mới, quay lại từ trang xác nhận, xóa dòng, nhập số lượng không hợp lệ và tải lại hóa đơn để đối chiếu các nhánh xử lý.

Thông tin nền tảng tham khảo từ [Tomcat 10.1](https://tomcat.apache.org/tomcat-10.1-doc/appdev/deployment.html) và [MySQL Connector/J](https://dev.mysql.com/doc/connector-j/en/connector-j-usagenotes-connect-drivermanager.html).

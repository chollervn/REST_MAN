import java.nio.file.Files;
import java.nio.file.Path;
import org.apache.catalina.Context;
import org.apache.catalina.startup.Tomcat;
import org.apache.catalina.webresources.DirResourceSet;
import org.apache.catalina.webresources.StandardRoot;

/** Điểm khởi động web trong IntelliJ: mở lớp này và chạy main(). */
public class Main {
    public static void main(String[] args) throws Exception {
        Path classes = Path.of(Main.class.getProtectionDomain()
                .getCodeSource().getLocation().toURI());
        Path project = findProject(classes);


        Path config = project.resolve("local.properties");
        if (System.getProperty("restman.config") == null && Files.isRegularFile(config)) {
            System.setProperty("restman.config", config.toString());
        }
        if (System.getProperty("restman.config") == null && System.getenv("DB_PASSWORD") == null) {
            throw new IllegalStateException("Cần local.properties hoặc biến môi trường DB_PASSWORD.");
        }

        // Có thể đổi cổng bằng VM option: -Drestman.port=8086
        int port = Integer.parseInt(System.getProperty("restman.port", "8085"));
        if (port < 1 || port > 65535) {
            throw new IllegalArgumentException("Cổng phải từ 1 đến 65535.");
        }
        Path runtime = Files.createDirectories(project.resolve(".run/embedded"));
        Tomcat tomcat = new Tomcat();
        tomcat.setBaseDir(runtime.toString());
        tomcat.setPort(port);
        tomcat.getConnector().setProperty("address", "127.0.0.1");
        tomcat.getConnector().setURIEncoding("UTF-8");
        tomcat.getConnector().setThrowOnFailure(true);

        // Nạp JSP, CSS và web.xml trực tiếp từ thư mục web của project.
        Context context = tomcat.addWebapp("/PTTK",
                project.resolve("src/main/webapp").toString());
        context.setParentClassLoader(Main.class.getClassLoader());

        // Nạp các lớp model và DAO đã biên dịch để các trang JSP sử dụng.
        // Các thư viện JDBC, JSP/JSTL được lấy từ classpath Maven của Main.
        StandardRoot resources = new StandardRoot(context);
        resources.addPreResources(new DirResourceSet(resources, "/WEB-INF/classes",
                classes.toString(), "/"));
        context.setResources(resources);

        try {
            tomcat.start();
            if (!context.getState().isAvailable()) {
                throw new IllegalStateException("Không nạp được ứng dụng PTTK. Xem log phía trên.");
            }
        } catch (Exception e) {
            shutdown(tomcat);
            throw e;
        }

        Runtime.getRuntime().addShutdownHook(new Thread(() -> shutdown(tomcat), "pttk-shutdown"));
        System.out.println("PTTK đang chạy: http://localhost:" + port + "/PTTK/");
        System.out.println("Bấm Stop trong IntelliJ để dừng chương trình.");
        tomcat.getServer().await();
    }

    private static Path findProject(Path classes) {
        // Ưu tiên working directory; cũng hỗ trợ Run từ thư mục cha trong IntelliJ.
        for (Path start : new Path[]{Path.of("").toAbsolutePath(), classes}) {
            for (Path dir = start; dir != null; dir = dir.getParent()) {
                if (Files.isRegularFile(dir.resolve("pom.xml"))
                        && Files.isDirectory(dir.resolve("src/main/webapp"))) {
                    return dir;
                }
            }
        }
        throw new IllegalStateException("Không tìm thấy project. Đặt Working directory về thư mục PTTK.");
    }

    private static void shutdown(Tomcat tomcat) {
        try {
            tomcat.stop();
            tomcat.destroy();
        } catch (Exception e) {
            System.err.println("Lỗi khi dừng Tomcat: " + e.getMessage());
        }
    }
}

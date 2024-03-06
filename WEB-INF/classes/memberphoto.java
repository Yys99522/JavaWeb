

import java.io.IOException;
import java.io.InputStream;
import java.io.PrintWriter;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.http.Part;

/**
 * Servlet implementation class memberphoto
 */
@MultipartConfig(
	    fileSizeThreshold = 1024 * 1024, // 1 MB
	    maxFileSize = 1024 * 1024 * 5,    // 5 MB
	    maxRequestSize = 1024 * 1024 * 10 // 10 MB
)
@WebServlet("/photo")
public class memberphoto extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public memberphoto() {
        super();
        // TODO Auto-generated constructor stub
    }

    private String getFileExtension(String fileName) {
        int lastDotIndex = fileName.lastIndexOf(".");
        if (lastDotIndex > 0) {
            return fileName.substring(lastDotIndex);
        }
        return ""; // 没有副檔名
    }
	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
        //JDBC 取得資料庫圖片路徑

		request.setCharacterEncoding("utf-8");		
		response.setContentType("text/html;charset=utf-8");
	    PrintWriter out=response.getWriter();
	    HttpSession session=request.getSession();
		String uid=(String)session.getAttribute("uid");
		
		//取得上傳的文件
		Part filePart = request.getPart("file");
		// 获取文件的 MIME 类型
		String contentType = filePart.getContentType();
		
		// 检查是否是 JPG 文件
		if ("image/jpeg".equals(contentType)) {
			// 確保文件不為空
	        if (filePart != null) {

	        	//取得文件名
	            String fileName = filePart.getSubmittedFileName();
	            String fileExtension=getFileExtension(fileName);
                
	            // 可以在這裡處理文件，例如保存到伺服器上的指定位置
	            String uploadDir = getServletContext().getRealPath("/img/member/");
	            String savename=uploadDir+uid+fileExtension;
	            String path="/img/member/"+uid+fileExtension;
	            session.setAttribute("path", path);
	            // 例如，你可以使用File IO操作來保存文件
	            
	            try (InputStream input = filePart.getInputStream()) {
	                Files.copy(input, Paths.get(savename), StandardCopyOption.REPLACE_EXISTING);
	            }catch (Exception e) {
	                e.printStackTrace();	               
	            }      
	        }
        } else {
            // 不是 JPG 文件，进行相应的处理
            response.getWriter().println("上傳檔案格式不符");
        }

		Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        //參數
        String sDriver = "com.mysql.cj.jdbc.Driver";
      
        String url="jdbc:mysql://localhost/gym";
        String acc="user";
        String pwd="1234";
        String sql = "update memberinfo set img=\"/img/member/"+uid+".jpg\" where memberid = '"+uid+"'";
       
        System.out.println("連線資料庫\n");
       
        try   //載入JDBC driver 
        {     
            Class.forName(sDriver);
        }
        catch(Exception e)
        {
            System.out.println("無法載入驅動程式");
            return;
        }
        
       
        try   
        {
            conn = DriverManager.getConnection(url,acc,pwd);
            stmt = conn.createStatement();
        }
        catch(SQLException e){
       
            System.out.println(e.getMessage());
            return;
        }
       
        try{  
			stmt.execute(sql);
       }
       catch(SQLException e){ 
    	   System.out.println(e.getMessage());
    	   return;
    	   }
       
       try{
        
           stmt.close(); 
           conn.close(); 
       }
       catch( SQLException e ){ 
    	   System.out.println(e.getMessage());
    	   return;
    	   }
        

        // 重定向或返回響應給用戶
        response.sendRedirect("/gym/memberwindow.jsp");
    }
}

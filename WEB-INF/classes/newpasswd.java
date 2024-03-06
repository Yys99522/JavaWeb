

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
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

import org.json.JSONException;
import org.json.JSONObject;

/**
 * Servlet implementation class newpasswd
 */
@WebServlet("/newpasswd")
public class newpasswd extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public newpasswd() {
        super();
        // TODO Auto-generated constructor stub
    }

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
        //用JDBC 取得資料庫資料

		request.setCharacterEncoding("utf-8");		
		response.setContentType("text/html;charset=utf-8");
	    PrintWriter out=response.getWriter();
	    HttpSession session=request.getSession();
	    
		String passwd="";
        String uid="";
        uid=(String)session.getAttribute("uid");
		
		BufferedReader reader=request.getReader();
		StringBuffer sb=new StringBuffer();
		String line;
		while((line=reader.readLine())!=null) {
			sb.append(line);
		}
		
		try {
			JSONObject obj=new JSONObject(sb.toString());
			passwd=obj.getString("passwd");
			
		}catch(JSONException e) {
			System.out.println(e.getMessage());
		};
        
        
        
		//連線資料庫
		Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;
        //參數
        String sDriver = "com.mysql.cj.jdbc.Driver";
      
        String url="jdbc:mysql://localhost/gym";
        String acc="user";
        String pwd="1234";
        String sql = "update account  set userpasswd='"+passwd+"' where uid='"+uid+"'";
       
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
	}

}



import java.sql.Statement;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class Info
 */
@WebServlet("/register")
public class registerServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public registerServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		//用JDBC 將資料寫入資料庫

		request.setCharacterEncoding("utf-8");
		String memberid="";
		String membername= request.getParameter("membername");
		String username= request.getParameter("username");
		String userpasswd= request.getParameter("userpasswd");
		String phone= request.getParameter("phone");
		String birthdate= request.getParameter("birthdate");
		String sex= request.getParameter("sex");
		String email= request.getParameter("email");
		String county= request.getParameter("county");
		String district= request.getParameter("district");
		String address= request.getParameter("address");
		String img="/img/member/0.svg";

	    response.setContentType("text/html;charset=utf-8");
	       
	    
	    Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;

        //參數
        String sDriver = "com.mysql.cj.jdbc.Driver";
        String url="jdbc:mysql://localhost/gym";
        String acc="user";
        String pwd="1234";
        String sql = "insert into memberinfo values(0,'"+membername+"','"+email+"','"+phone+"','"+birthdate+"','"+sex+"','"+
        		county+"','"+district+"','"+address+"','"+img+"',0)";
       
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
        	rs=stmt.executeQuery("select username from account where username=\""+username +"\"");
        	if(rs.next()) {
        		String error="帳號已存在";
        		request.setAttribute("error", error);
        		RequestDispatcher register =request.getRequestDispatcher("/register.jsp");
        		register.forward(request, response);

        	}
			else {	
        		stmt.execute(sql);
                rs=stmt.executeQuery("select * from memberinfo order by memberid desc limit 1");
                if(rs.next()) {
                	memberid=rs.getString("memberid");
                }
                stmt.execute("insert into account values('"+username+"','"+userpasswd+"','"+memberid+"','m')");
        		response.sendRedirect("/gym/login.html");
        	}
        
        	
        	           
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

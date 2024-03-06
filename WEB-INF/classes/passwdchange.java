

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

/**
 * Servlet implementation class passwdchange
 */
@WebServlet("/passwdchange")
public class passwdchange extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public passwdchange() {
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
	    
	    String userpasswd=""; 
	    String newpasswd="";
        String uid="";
        uid=(String)session.getAttribute("uid");
        userpasswd=request.getParameter("userpasswd");
        newpasswd=request.getParameter("newpasswd");
        
        //連線資料庫
        Connection conn = null;
        Statement stmt = null;
        ResultSet rs = null;

        //參數
        String sDriver = "com.mysql.cj.jdbc.Driver";
        String url="jdbc:mysql://localhost/gym";
        String acc="user";
        String pwd="1234";
        String sql = "update account  set userpasswd='"+newpasswd+"' where uid='"+uid+"'";
        
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
            rs=stmt.executeQuery("select * from account where uid='"+uid+"'");
            if(rs.next()) {
                if(!userpasswd.equals(rs.getString("userpasswd"))) {
                request.setAttribute("error","密碼錯誤");
                RequestDispatcher chpasswd =request.getRequestDispatcher("/changepasswd.jsp");
                chpasswd.forward(request, response);
                }else {
                stmt.execute(sql);
                //response.sendRedirect("/gym/memberinfo.html");
                session.setAttribute("success","密碼修改成功!!");
                response.sendRedirect("/gym/changepasswd.jsp");
                }
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

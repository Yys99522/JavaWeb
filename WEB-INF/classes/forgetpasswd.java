

import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.naming.*;
import javax.sql.DataSource;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONException;
import org.json.JSONObject;

/**
 * Servlet implementation class forgetpasswd
 */
@WebServlet("/forget")
public class forgetpasswd extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public forgetpasswd() {
        super();
        // TODO Auto-generated constructor stub
    }

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		//JNDI 取得資料庫資料

		request.setCharacterEncoding("utf-8");
		response.setContentType("text/html;charset=utf-8");
		HttpSession session=request.getSession();
	    PrintWriter out=response.getWriter();
		
        String sqlname="";
        String sqlmail="";
        String sqlphone="";
        String uid="";
        String username="";
		String email="";
        String rand="";
        
        BufferedReader reader=request.getReader();
		StringBuffer sb=new StringBuffer();
		String line;
		while((line=reader.readLine())!=null) {
			sb.append(line);
		}
		
		try {
			JSONObject obj=new JSONObject(sb.toString());
			username=obj.getString("username");
			email=obj.getString("email");
			rand=obj.getString("rand");
			
		}catch(JSONException e) {
			System.out.println(e.getMessage());
		};

        String sql = "call forget('"+username+"')";
       
        if(rand.equals(session.getAttribute("rnd"))) {  
	        try{  

				InitialContext initContext =new InitialContext();
				Context context =(Context)initContext.lookup("java:comp/env");
				DataSource ds = (DataSource)context.lookup("jdbc/mysql");
				Connection connection=ds.getConnection();
				Statement statement=connection.createStatement();
				ResultSet rs= statement.executeQuery(sql);
				
	            if(rs.next()) {	
		        	sqlname=rs.getString("username");
		        	sqlmail=rs.getNString("email");
		        	sqlphone=rs.getNString("phone");
		        	if(!(sqlmail.equals(email))&&!(sqlphone.equals(email))) {
		        		out.print("手機或信箱錯誤");
		        	}else {
		        		uid=rs.getString("uid");
		        		session.setAttribute("uid",uid);
		        	}
	            }
	            else {
	            	out.print("帳號不存在");
	            }  

				statement.close();
           		connection.close();
	       	}
	     	catch(SQLException e){ 
	    	   System.out.println(e.getMessage());
	    	   return;
	    	   }
			catch(NamingException e){
            System.out.println(e.getMessage());
        }
        }else {
        	out.print("驗證碼輸入錯誤");
        }

	}

}



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
 * Servlet implementation class loginServlet
 */
@WebServlet("/login")
public class loginServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public loginServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub

        //JNDI 取得資料庫資料
        
		request.setCharacterEncoding("utf-8");		
		response.setContentType("text/html;charset=utf-8");
	    PrintWriter out=response.getWriter();
	    
	    String username="";
		String userpasswd="";
        String sqlname="";
        String sqlpasswd="";
        String uid="";
		String imgpath="";
        String membername="";

		BufferedReader reader=request.getReader();
		StringBuffer sb=new StringBuffer();
		String line;
		while((line=reader.readLine())!=null) {
			sb.append(line);
		}
		
		try {
			JSONObject obj=new JSONObject(sb.toString());
			username=obj.getString("username");
			userpasswd=obj.getString("userpasswd");
			
		}catch(JSONException e) {
			System.out.println(e.getMessage());
		};
        
        String sql = "call  login('"+username+"');";
       
        try{  
            InitialContext initContext =new InitialContext();
            Context context =(Context)initContext.lookup("java:comp/env");
            DataSource ds = (DataSource)context.lookup("jdbc/mysql");
            Connection connection=ds.getConnection();
            Statement statement=connection.createStatement();
            ResultSet rs= statement.executeQuery(sql);

            if(rs.next()) {	
	        	sqlname=rs.getString("username");
	        	sqlpasswd=rs.getString("userpasswd");
	        	
	        	if(!(sqlname.equals(username)&&sqlpasswd.equals(userpasswd))) {
	        		out.print("<h1>帳號或密碼錯誤</h1>");
	        	}else {
	        		uid=rs.getString("uid");
	        		HttpSession session=request.getSession();
	        		session.setAttribute("uid",uid);
                    rs= statement.executeQuery("select img,membername from memberinfo where memberid='"+uid+"'");
                    if(rs.next()){
                        membername=rs.getString("membername");
                        session.setAttribute("name",membername);
                        imgpath=rs.getString("img");
                        session.setAttribute("imgpath",imgpath);
                    }
	        	}
            }
            else {
            	out.print("<h1>帳號或密碼錯誤</h1>");
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
       
	}

}

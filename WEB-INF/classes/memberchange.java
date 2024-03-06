

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
 * Servlet implementation class memberchange
 */
@WebServlet("/savechange")
public class memberchange extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public memberchange() {
        super();
        // TODO Auto-generated constructor stub
    }

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		//JNDI修改資料庫資料
		
		String uid="";
		String membername="";
		String email="";
		String phone="";
		String birthdate="";
		String sex="";
		String county="";
		String district="";
		String address="";
		String json="";
		
		request.setCharacterEncoding("utf-8");
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out=response.getWriter();
		
		BufferedReader reader=request.getReader();
		StringBuffer sb=new StringBuffer();
		String line;
		while((line=reader.readLine())!=null) {
			sb.append(line);
		}
		
		try {
			JSONObject obj=new JSONObject(sb.toString());
			// membername=obj.getString("membername");
			phone=obj.getString("phone");
			birthdate=obj.getString("birthdate");
			sex=obj.getString("sex");
			county=obj.getString("county");
			district=obj.getString("district");
			address=obj.getString("address");
			email=obj.getString("email");
		}catch(JSONException e) {
			System.out.println(e.getMessage());
		};
		HttpSession session=request.getSession();
		uid=(String)session.getAttribute("uid");
		membername=(String)session.getAttribute("name");
       
	   	String sql="call updatemember('"+membername+"','"+email+"','"+phone+"','"+birthdate+"','"+sex+"','"+county+"','"+district+"','"+address+"','"+uid+"');";
       
        try{ 

			InitialContext initContext =new InitialContext();
            Context context =(Context)initContext.lookup("java:comp/env");
            DataSource ds = (DataSource)context.lookup("jdbc/mysql");
            Connection connection=ds.getConnection();
            Statement statement=connection.createStatement();
            ResultSet rs= statement.executeQuery(sql);

        	System.out.println("修改資料庫");
			rs=statement.executeQuery(sql);
           
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

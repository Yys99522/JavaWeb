

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

/**
 * Servlet implementation class memberServlet
 */
@WebServlet("/member")
public class memberServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public memberServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
        //用JNDI 取得資料庫資料

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

		HttpSession session=request.getSession();
		String loginuid =(String)session.getAttribute("uid");
	
		String sql="call member("+loginuid+");";
       
        System.out.println("連線資料庫\n");

        try{ 
			
			InitialContext initContext =new InitialContext();
			Context context =(Context)initContext.lookup("java:comp/env");
			DataSource ds = (DataSource)context.lookup("jdbc/mysql");
			Connection connection=ds.getConnection();
			Statement statement=connection.createStatement();
			ResultSet rs= statement.executeQuery(sql);

        	rs=statement.executeQuery(sql);

            if(rs.next()) {
			
				membername=rs.getString("membername");
				email=rs.getString("email");
				phone=rs.getString("phone");
				birthdate=rs.getString("birthdate");
				sex=rs.getString("sex");
				county=rs.getString("county");
				district=rs.getString("district");
				address=rs.getString("address");
	        	
            }
            json="{\"membername\":\""+membername+"\",\"email\":\""+email+"\",\"phone\":\""+phone
            		+"\",\"birthdate\":\""+birthdate+"\",\"sex\":\""+sex+"\",\"county\":\""+county+"\",\"district\":\""
            		+district+"\",\"address\":\""+address+"\"}";
            out.print(json);


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

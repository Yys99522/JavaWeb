

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

@WebServlet("/CreateMenuServlet")
public class CreateMenuServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//設定接的數據類型是utf8
		request.setCharacterEncoding("UTF-8");
		//設定囘傳的數據格式是json
	    response.setContentType("text/html;charset=utf-8");
	    PrintWriter out = response.getWriter();
	    //這個servlet完全就是抓資料的,不需要request到東西
	    
	    //開始建立連綫
	    Connection conn = null;
	    //建立請求query的物件
        Statement stmt = null;
        //建立解析query的物件
        ResultSet rs = null;
        //參數
        String sDriver = "com.mysql.cj.jdbc.Driver";
      
        String url="jdbc:mysql://localhost:3306/gym";
        String acc="user";
        String pwd="1234";
        
        try   //載入JDBC driver 
        {     
            Class.forName(sDriver);
        }
        catch(Exception e)
        {
           System.out.println("cm無法載入驅動程式");
           return;
        }
        
        try   //建立資料連結和Statement物件
        {
            conn = DriverManager.getConnection(url,acc,pwd);
            if(conn != null)
            {
                System.out.println("cm建立Connection物件成功!");
                
                stmt = conn.createStatement();
                if(stmt != null)
                    System.out.println("cm建立Statement物件成功!");
            }
        }     
        catch(SQLException e)
        {
            System.out.println("cm與資料來源連結錯誤: " );
            System.out.println(e.getMessage());
        }
        
        //建立連接成功後,使用query語法,操控資料庫
        //
        String query = "SELECT * FROM gym.products;";
        try {
        	//stmt發出query請求後,接受到的資訊由result處理(產生了result物件)
			rs = stmt.executeQuery(query);
			//建立一個buffer存字串拼接
			StringBuffer strbuf = new StringBuffer();
			//資料已經儲存成文字流,接下來做行指向,跟欄位指向即可
			while(rs.next()) {//原始指針在負,確認有下一個
				//使用欄位標簽取當前列的欄位值
				//確認課程販售中才導入
				boolean bol = rs.getString("isavailable").equals("0");
				if(bol) {
					//查來的數據,要拼起來傳給前端解讀
					//使用StringBuffer的append功能
					strbuf.append(rs.getString("productid")+"=");
					strbuf.append(rs.getString("image")+"=");
					strbuf.append(rs.getString("productname")+"=");
					strbuf.append(rs.getString("descript")+"=");
					strbuf.append(rs.getString("price")+"=");				
				}
			}
			//讀完后丟給前端
			out.write(strbuf.toString());
		} catch (SQLException e1) {
			System.out.println("cm寫入異常");
		}
        
        try 
        { 
            stmt.close();
            conn.close();
            
        }
        catch( SQLException e ) {e.printStackTrace();}
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		doGet(request, response);
	}

}

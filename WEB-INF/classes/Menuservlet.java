import java.io.BufferedReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

/**
 * Servlet implementation class Menuservlet
 */
@WebServlet("/Menuservlet")
public class Menuservlet extends HttpServlet {
	private static final long serialVersionUID = 1L;


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
        //用JDBC取得資料庫資料

		//思路
		//建立讀取器讀取post過來的json格式
		//寫成字串(附上key好取值)
		//建立一個json物件來接json字串,變成物件之後可以解包值

		BufferedReader bfReader = request.getReader();
		String str = bfReader.readLine();
		JSONArray jsonArray = new JSONArray();

		//設定接的數據類型是utf8
		request.setCharacterEncoding("UTF-8");

		//設定囘傳的數據格式是json
	    response.setContentType("application/json;charset=utf-8");

	    PrintWriter out = response.getWriter();

	    //設定session值,讓下一個頁面可以抓到(session本來就存在,只是有request抓出來)
        HttpSession session = request.getSession();

	    //資料取用
	    try {
	    	//已知資料是陣列,直接用json陣列接
			jsonArray = new JSONArray(str);
            JSONObject obj = jsonArray.getJSONObject(0);
			//輸出測試
			//out.write(obj.getJSONObject("value").getString("cartPCost").toString());

			
		} catch (JSONException e) {
			e.printStackTrace();
		}

	    //--------------------建立連綫,連接資料庫----------------------------
        //?代表參數引入
        String uid=(String)session.getAttribute("uid");
	    String query1 = "INSERT INTO gym.ordermain (orderdate,memberid) VALUES(?,'"+uid+"')";
	    String query2 = "SELECT orderid FROM ORDERMAIN WHERE ORDERDATE=?";
	    String query3 = "INSERT INTO gym.orderdetal VALUES(?,?,?,1,null,'false')";
        
	    Connection conn = null;
        //事件預處理(建立物件就先引入query)
        PreparedStatement prepstmt1 = null;
        PreparedStatement prepstmt2 = null;
        PreparedStatement prepstmt3 = null;

        //result物件
        ResultSet res = null;

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
           System.out.println("ms無法載入驅動程式");
           return;
        }
        
        try   //建立資料連結和Statement物件
        {
            conn = DriverManager.getConnection(url,acc,pwd);
            if(conn != null)
            {
                System.out.println("ms建立Connection物件成功!");
              //事件預處理(建立物件就先引入query)
                prepstmt1 = conn.prepareStatement(query1);
                prepstmt2 = conn.prepareStatement(query2);
                prepstmt3 = conn.prepareStatement(query3);

                
                if(prepstmt1 != null && prepstmt2 != null && prepstmt3 !=null)
                    System.out.println("ms建立Prepared/Statement物件成功!");
            }
        }     
        catch(SQLException e)
        {
            System.out.println("ms與資料來源連結錯誤: " );
            System.out.println(e.getMessage());
            
        }
        
        //要存入orderdetal的資料
        String[] sproductid = new String[jsonArray.length()];
        String[] sprice = new String[jsonArray.length()];
        
    	// 取得當前日期
        Date currentDate = new Date();

        // 定義日期格式
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

        // 使用格式化日期
        String formattedDate = dateFormat.format(currentDate);

        try{
        	for(int i=0;i<jsonArray.length();i++) {
        		
        		//囘圈拆出數據
                JSONObject obj = jsonArray.getJSONObject(i);
                //囘圈存值
                sproductid[i] = obj.getString("key");
                sprice[i] = obj.getJSONObject("value").getString("cartPCost").replace("$", "");
        		
        	}
        }
        catch(JSONException je){
            System.out.println("json解讀異常");
            je.printStackTrace();
        }
        //變數建立在外面讓session好抓
        int curID=0;
        //建立連接成功後,使用query語法,操控資料庫s
        try {
        	prepstmt1.setString(1, formattedDate);
        	prepstmt1.execute();
        	//儲存完ordermain后,要取得他的orderid
        	prepstmt2.setString(1, formattedDate);
        	res = prepstmt2.executeQuery();
        	
        	
        	if(res.next()) {
        		curID=res.getInt("orderid");
        	}
        	      
        	//設定剛才預留的參數位
        	for(int i=0;i<jsonArray.length();i++) {
        		prepstmt3.setString(1, ""+curID);
            	prepstmt3.setString(2,sproductid[i]);
            	prepstmt3.setString(3,sprice[i]);
            	
            	//執行
    			prepstmt3.execute();
        	}
        	
		} catch (SQLException e1) {
			// TODO Auto-generated catch block
			System.out.println("ms寫入異常");
			e1.printStackTrace();
		}
        
        try 
        { 
            prepstmt1.close();
            prepstmt3.close();
            conn.close();
            
        }
        catch( SQLException e ) {e.printStackTrace();}
        //設定丟到session的值
        session.setAttribute("curID",curID);
        
        //測試回傳給到menu.js-OK
        //out.print((int)session.getAttribute("curID"));
        
	}

}



<%@ page language="java" import="java.util.*" import="java.sql.*" pageEncoding="UTF-8"%>
<%
		//获取数据库连接 
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/S2013150090?useUnicode=true&characterEncoding=utf-8","S2013150090","150090");

	//获取URL传值
	String id_string=null;
	String click_account = null;
	int account_id=0;
	String notice_account=null;//消息通知的账户
	id_string = request.getParameter("value1");
	click_account = request.getParameter("value2");
	int anounce_id=Integer.parseInt(id_string);
	boolean click_flag=false;


	try{
		
		//获得点赞用户的ID	
		String user_sql = "SELECT User_ID FROM User WHERE User_Account=?";
		PreparedStatement user_ps = conn.prepareStatement(user_sql);
		user_ps.setString(1,click_account);					
		ResultSet user_rs=user_ps.executeQuery();
		if(user_rs.next())
		{
			account_id = user_rs.getInt("User_ID");		
		}

		//将点赞用户的ID和被点赞的内容ID存入数据库表Click
		String click_sql = "INSERT INTO Click(Anounce_ID,Account_ID,Click_Account) VALUES(?,?,?)";
		PreparedStatement click_ps = conn.prepareStatement(click_sql);
		click_ps.setInt(1,anounce_id);
		click_ps.setInt(2,account_id);
		click_ps.setString(3,click_account);
		click_ps.executeUpdate();
		//关闭数据库连接
		click_ps.close();
		click_flag=true;
		
	}
	catch(Exception e) 
	{
		out.print(e);
	}	
	if(click_flag)
	{ 	
%>
		<img src="img/like_click.jpg"/><%=click_account %>
<% 
	}		
%>


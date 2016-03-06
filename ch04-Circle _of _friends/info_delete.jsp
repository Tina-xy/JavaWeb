<%@ page language="java" import="java.util.*" import="java.sql.*" pageEncoding="UTF-8"%>
<%
	//获取数据库连接 
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/S2013150090?useUnicode=true&characterEncoding=utf-8","S2013150090","150090");
	String user_account = (String)session.getAttribute("name");  //永远标记当前登录的账号

	//获取URL传值
	String id_string = request.getParameter("value");
	int friend_id=0;//获得好友id
	try{
		
		friend_id=Integer.parseInt(id_string);

 		//查询数据库表Friend,删除好友
		String check_sql = "DELETE FROM Friend WHERE Friende_ID=?";
		PreparedStatement check_ps = conn.prepareStatement(check_sql);
		check_ps.setInt(1,friend_id);					
		check_ps.executeUpdate();	

		String msg = "该好友已删除！";
		out.println(msg);

	}
	catch(Exception e) 
	{
		out.print(e);
	}
	conn.close();	

%>


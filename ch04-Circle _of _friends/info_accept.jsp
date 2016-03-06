<%@ page language="java" import="java.util.*" import="java.sql.*" pageEncoding="UTF-8"%>
<%
		//获取数据库连接 
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/S2013150090?useUnicode=true&characterEncoding=utf-8","S2013150090","150090");

	//获取URL传值
	String id_string = request.getParameter("value");
	boolean accept_flag=false;

	try{

	int apply_id=Integer.parseInt(id_string);
	
	//Friend表里面更新相关信息
	String accept_sql = "UPDATE Friend SET status=1,new_flag=0 WHERE Friende_ID=?";
	PreparedStatement accept_ps = conn.prepareStatement(accept_sql);
	accept_ps.setInt(1,apply_id);
	accept_ps.executeUpdate();				
	accept_flag=true;

	}
	catch(Exception e) 
	{
		out.print(e);
	}

	if(accept_flag)
	{ 	
%>
		<font color='#C0C0C0'>已接受</font>
<% 
	}		
%>



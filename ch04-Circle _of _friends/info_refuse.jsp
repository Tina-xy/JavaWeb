<%@ page language="java" import="java.util.*" import="java.sql.*" pageEncoding="UTF-8"%>
<%
		//获取数据库连接 
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/S2013150090?useUnicode=true&characterEncoding=utf-8","S2013150090","150090");

	//获取URL传值
	String id_string = request.getParameter("value");
	int apply_id=Integer.parseInt(id_string);
	boolean refuse_flag=false;

	try{
		//Friend表里面更新相关信息
		
		Statement refuse_st = conn.createStatement();
		String refuse_sql = "UPDATE Friend SET status=2,new_flag=0 WHERE Friende_ID=?";
		refuse_st.setInt(1,apply_id);					
		refuse_st.executeUpdate();
		refuse_flag=true;
	}
	catch(Exception e) 
	{
		out.print(e);
	}

	if(refuse_flag)
	{ 	
%>
		<font color='#C0C0C0'>已拒绝</font>
<% 
	}		
%>



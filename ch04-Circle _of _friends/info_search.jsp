<%@ page language="java" import="java.util.*" import="java.sql.*" pageEncoding="UTF-8"%>
<%	
	//获取数据库连接
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/S2013150090?useUnicode=true&characterEncoding=utf-8","S2013150090","150090");
	
		String search_account = null;
		boolean search_flag=false;
		search_account = request.getParameter("value");
		if(search_account!=null && search_account!="")
		{	
			try{
				
				String search_sql = "SELECT User_Name FROM User WHERE User_Account=?";
				PreparedStatement search_ps = conn.prepareStatement(search_sql);
				search_ps.setString(1,search_account);
				ResultSet search_rs = search_ps.executeQuery();

				while(search_rs.next()){
					search_flag=true;
				}
			}
			catch(Exception e) 
			{
				out.print(e);
			}	
			
		}

		if(search_flag)
		{
		out.print("1");
		}
		else{
		out.print("0");
		}			
%>


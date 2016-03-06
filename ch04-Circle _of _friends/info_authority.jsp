<%@ page language="java" import="java.util.*" import="java.sql.*" pageEncoding="UTF-8"%>
<%	
	//获取数据库连接
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/S2013150090?useUnicode=true&characterEncoding=utf-8","S2013150090","150090");
	String user_account = (String)session.getAttribute("name");  //永远标记当前登录的账号

	String id_string = request.getParameter("value");
	int selected_id = 0; //复选框没有选中的id(即需要屏蔽的人)
	int shield_type=0;
	if(id_string!=null && id_string!="")
	{	
		selected_id = Integer.parseInt(id_string);
		try{
			
			//查询数据库表Friend,确认屏蔽类型
			String check_sql = "SELECT * FROM Friend WHERE Friende_ID=? order by Apply_Time asc";
			PreparedStatement check_ps = conn.prepareStatement(check_sql);
			check_ps.setInt(1,selected_id);					
			ResultSet check_rs=check_ps.executeQuery();
			if(check_rs.next()){
					String apply_account = check_rs.getString("Apply_Account");
					String applied_account = check_rs.getString("Applied_Account");
					if(user_account.equals(apply_account))
					{
					    shield_type=1;
					}
					if(user_account.equals(applied_account))
					{
						shield_type=2;
					}
			}

			//更改数据库表Friend
			if(shield_type==1){
			//Friend表里面更新相关信息
			String selected_sql = "UPDATE Friend SET A_shield_B=1 WHERE Friende_ID=?";
			PreparedStatement selected_ps = conn.prepareStatement(selected_sql);
			selected_ps.setInt(1,selected_id);
			selected_ps.executeUpdate();
			}
			else if(shield_type==2){
			//Friend表里面更新相关信息
			String selected_sql = "UPDATE Friend SET B_shield_A=1 WHERE Friende_ID=?";
			PreparedStatement selected_ps = conn.prepareStatement(selected_sql);
			selected_ps.setInt(1,selected_id);
			selected_ps.executeUpdate();
			}

		}
		catch(Exception e) 
		{
			out.print(e);
		}
	}	
				
%>


<%@ page language="java" import="java.util.*" import="java.sql.*" pageEncoding="UTF-8"%>
<%	
	//获取数据库连接
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/S2013150090?useUnicode=true&characterEncoding=utf-8","S2013150090","150090");
	String user_account = (String)session.getAttribute("name");  //永远标记当前登录的账号

	String id_string = request.getParameter("value");
	int selected_id = 0; //复选框选中的id(即@的人)

	if(id_string!=null && id_string!="")
	{	
		selected_id = Integer.parseInt(id_string);
		String apply_at = null;
		String applied_at = null;

		try{

			//查询数据库表Friend,获得发生@关系的人
			String check_sql = "SELECT * FROM Friend WHERE Friende_ID=? order by Apply_Time asc";
			PreparedStatement check_ps = conn.prepareStatement(check_sql);
			check_ps.setInt(1,selected_id);					
			ResultSet check_rs=check_ps.executeQuery();
			if(check_rs.next()){
				apply_at = check_rs.getString("Apply_Account");
				applied_at = check_rs.getString("Applied_Account");
			}

			//写入数据库表AT,记录@关系
			String at_sql = "INSERT INTO AT(Apply_At,Applied_At) VALUES(?,?)";
			PreparedStatement at_ps = conn.prepareStatement(at_sql);
			if(user_account.equals(apply_at)){
				at_ps.setString(1,user_account);
				at_ps.setString(2,applied_at);
				at_ps.executeUpdate();
				//关闭数据库连接
				at_ps.close();	

			}
			else if(user_account.equals(applied_at)){
				at_ps.setString(1,user_account);
				at_ps.setString(2,apply_at);
				at_ps.executeUpdate();
				//关闭数据库连接
				at_ps.close();	
			}
			
			
		}
		catch(Exception e) 
		{
			out.print(e);
		}
	}	
				
%>


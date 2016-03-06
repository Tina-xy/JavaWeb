<%@ page language="java" import="java.sql.*" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>

<%
			//获取数据
			request.setCharacterEncoding("UTF-8");
			String user_account = request.getParameter("user_account");
			String user_name= request.getParameter("user_name");
			String password = request.getParameter("password");
			String password_validate = request.getParameter("password_validate");

%>

<html>
	<head>
		
		<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no"/> 
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />

		<!-- jquery mobile -->
		<link rel="stylesheet" href="./css/default/jquery.mobile-1.4.5.min.css" />
		<link rel="stylesheet" type="text/css" href="./css/common.css">
		<script src="js/jquery.min.js"></script>
		<script src="js/jquery.mobile-1.4.5.min.js"></script>		
	</head>

	<body>	
		<div data-role="page" style="background:url('img/picture.jpg') 50% 0 no-repeat; background-size:cover;" data-theme="a">
		    
			<div class="container" data-role="content" style="margin-top:50px;">
				<table width="400">
					<tr>
				      <td>
				      <a width="30" href="login.jsp" data-role="button" data-icon="Back" data-iconpos="notext"></a>
				      </td>
				      <td width="300" align="center"><h2>欢迎注册</h2></td>		        
				    </tr>
		    	</table>
				<form method="post" style="margin-top:80px" name="Register_Account">
					
					<label for="reg_user_id" style="display:inline-block" >账号：</label><label id="check_id" style="display:inline-block"></label>
					<input id="reg_user_id" name="user_account"  type="text" maxlength="20" placeholder="邮箱/手机号">

					<label for="user_name" >昵称：</label>
					<input id="user_name" name="user_name"  type="text" maxlength="20" placeholder="非特殊字符">

					<label for="reg_password" >密码：</label>
					<input id="reg_password" name="password" type="password" maxlength="32" placeholder="请输入8~20位数字和字母组成的密码">

					<label for="password_validate" style="display:inline-block" >确认密码：</label><label id="check_password" style="display:inline-block"></label>
					<input id="password_validate" name="password_validate" type="password" maxlength="32" placeholder="再次输入密码">
					<%

					if(user_account==null||user_name==null||password==null||password_validate==null)//不存在参数
					{  }
					else if(user_account.equals("")||user_name.equals("")||password.equals("")||password_validate.equals(""))//空
					{
						out.print("<script>alert('输入信息不完整，请输入完整信息')</script>");
					}
					else if(password_validate.equals(password)==false)
					{
						out.print("<font color=\"#FF0000\">"+"两次密码输入不一致"+"</font>");		
						//如何实现在提示的时候信息不被清空
					}

					%>

					<table  style="margin-top:50px" width="502">
					<tr>							
	                   <td aligh="left" width="251"><input type="button" value="注册" onclick="validate();" ></td>
	                   <td aligh="right" width="251"><input type="reset"  value="重置" ></td>
	                </tr>	
	                </table>
				</form>
			</div>

			<%
			
		    //获取数据库连接
			Class.forName("com.mysql.jdbc.Driver");
			Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/S2013150090?useUnicode=true&characterEncoding=utf-8","S2013150090","150090");			
			if(user_account==null||user_name==null||password==null||password_validate==null)//不存在参数
			{  }
			else if(user_account.equals("")||user_name.equals("")||password.equals("")||password_validate.equals(""))//空
			{
				out.print("<script>alert('输入信息不完整，请输入完整信息')</script>");
			}
			else if(password_validate.equals(password))					
			{		
				try{
					//数据添加   （注意MYSQL里面password（）函数的用法）
					String sql = "INSERT INTO Account(User_Account,User_Name,Password) VALUES(?,?,password(?))";
					PreparedStatement ps = conn.prepareStatement(sql);
					ps.setString(1,user_account);
					ps.setString(2,user_name);
					ps.setString(3,password);				
					ps.executeUpdate();
					//关闭数据库连接
					ps.close();	

					/*
					response.senndRedirect("login.jsp");   错误
					因为 out.print()只是将代码写到html中，完了还要再次刷新 执行,但response.senndRedirect()是java代码，执行到这里时，跳转就放生了。out.print()里面的<script>alert();</script>这个就不再执行
					*/

					//以下语句可以实现先弹框提示再页面跳转			
					out.write("<script language='javascript'>alert('注册成功,请登录');document.cookie='cookie_user=';window.location='login.jsp';</script>");
					}
				catch(Exception e){
						    out.print(e);
						}		
					
				}
			%>
			
			
			
			<script type="text/javascript">
				function validate(){
					user_account=document.Register_Account.user_account.value;
					user_name=document.Register_Account.user_name.value;
					password=document.Register_Account.password.value;
					password_validate=document.Register_Account.password_validate.value;
					if(user_account==""){
						window.alert("请输入账号");
						document.user_account.focus();
						return;
					}
					if(user_name==""){
						window.alert("请输入昵称");
						document.user_name.focus();
						return;
					}
					if(password==""){
						window.alert("请输入密码");
						document.password.focus();
						return;
					}
					if(password_validate==""){
						window.alert("请再次确认密码");
						document.password_validate.focus();
						return;
					}
				Register_Account.submit();
			}
			</script>
		</div>
	</body>
</html>
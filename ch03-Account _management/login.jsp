<%@ page language="java" import="java.sql.*" import="java.io.*" import="javax.servlet.*" 
	contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"
%>
<%          
            String user_account = null;
            String user_password = null;
            String cookie_record=null; //记录此次登录是否设置cookie值         
            String mach_error=null;   //记录是否提醒错误
            String code_error=null;  //记录是否验证码错误
            String code=null;
            String cookie_flag="0"; //记录是否自动登录（自动登录无"验证码匹配"）
            boolean login_flag=false;   //记录是否已经可以登录
       
            try{ 
            	Cookie[] cookies=request.getCookies(); 
                //首先判断cookie是否为空,不为空,则从cookie获值
                if(cookies!=null)
                { 
                for(int i=0;i<cookies.length;i++){ 
                    if(cookies[i].getName().equals("cookie_user"))
                    { 
                        String cookie_user_account =  cookies[i].getValue();
                        if(cookie_user_account !=null && !cookie_user_account.equals(""))
                            user_account=cookies[i].getValue().split("-")[0]; 
                        if(cookies[i].getValue().split("-")[1] !=null && !cookies[i].getValue().split("-")[1].equals(""))
                            user_password=cookies[i].getValue().split("-")[1]; 
                                  
                    }
                }
                cookie_flag="1";//表示不需要匹配验证码
                }
				//若cookie为空,则从表单中提取
                if(user_account==null||user_account==""||user_password==null||user_password=="")
				{
					user_account = request.getParameter("user_name");
             		user_password = request.getParameter("password");
             		code=request.getParameter("captcha");
             		cookie_flag="0";//表示需要匹配验证码
					//获取此次是否设置cookie值标志
					cookie_record=request.getParameter("flag");
				}
            }
            catch(Exception e){ 
                e.printStackTrace(); 
            } 

            //获取数据库连接
			Class.forName("com.mysql.jdbc.Driver");
			Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/S2013150090?useUnicode=true&characterEncoding=utf-8","S2013150090","150090");
			if(user_account!=null&&user_account!=""&&user_password!=null&&user_password!="")
			{	
				try{
						if(cookie_flag=="0")
						{
							
							String randStr=(String)session.getAttribute("randStr");						
							if(!code.equals(randStr)){
								code_error="验证码输入错误，请重新输入";
							}	                          		
	                    }

						Statement stat = conn.createStatement();	
						String sql="SELECT * FROM Account WHERE User_Account=? and Password=password(?)";

						ResultSet rs=null;	
						PreparedStatement ps = conn.prepareStatement(sql);
						ps.setString(1,user_account);
						ps.setString(2,user_password);
						rs=ps.executeQuery();
						if(rs.next())
						{
	                        login_flag=true;   //标志此时已经可以登录 
							session.setAttribute("name","user_account");

	                    }
					    //关闭数据库连接
					    rs.close();
						stat.close();
						conn.close();

						if(code_error==null)//如果验证码错误，则提示“验证码错误”，不提示“用户名或者密码错误”
						{
		   					if(login_flag)
		   					{
		   						if(cookie_record!="" && cookie_record!=null)
	                            {
	                                    Cookie cookie = new Cookie("cookie_user",user_account+"-"+user_password);       
	                                    cookie.setMaxAge(60*60*24*30); 
	                                    response.addCookie(cookie);
	                            }
			                    response.sendRedirect("GuestBook.jsp");
		                    }
		                    else{
		                    	mach_error="输入的用户名或者密码错误，请重新输入";
		                    }
	                    }         					
				}
				catch(Exception e) 
				{
					out.print(e);
				}
			}		
						
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
			<link rel="stylesheet" type="text/css" href="./css/login.css">

			<div class="container" data-role="content" style="margin-top:80px;">			    
				<form method="post" style="margin-top:100px" name="Login_Account">
					<div>				
						<input id="user_id" name="user_name" type="text" maxlength="20" placeholder="用户名">
					</div>
					
				    <div style="margin-top:40px">
						<input id="password" name="password" type="password" maxlength="32" placeholder="登录密码" >
					</div>
					
					<% 
						if(mach_error!= null && !mach_error.equals("")) 
						{						
						out.print("<font color=\"#FF0000\">"+mach_error+"</font>");
						} 
					%>
					<div style="height:80px;width:300px;margin-top:50px;margin-left:auto;margin-right:auto">
						<div style="width:150px;float:left;text-align:center">
							<img src="Validate.jsp" name="validatecode" style="cursor:pointer;" onclick="refresh()" ><br>
							<a style="cursor:pointer;font-size:10spx"  onclick="refresh()" >看不清?换一张</a>					
						</div>
						<div style="width:120px;float:left;margin-left:10px;">
							<input id="captcha" name="captcha" type="text" maxlength="6" placeholder="4位验证码" >
						</div>
					</div>
					<div style="margin-left:10px;">	
						<% 
						if(code_error!= null && !code_error.equals("")) 
						{						
						out.print("<font color=\"#FF0000\">"+code_error+"</font>");
						} 
						%>	
					</div>			
					
					<table style="margin-top:20px;" width="250">
					  <tr>
						<td aligh="left" width="30"><input type="checkbox" name="flag" id="flag"></td>
						<td aligh="left" width="150">记住密码,下次自动登录</td>
					  </tr>       				
					</table>
       				<a id="login-btn" href="#" data-role="button" style="margin-top:20px" onclick="validate()">登录</a>
					<div style="margin-top:20px">	
						<a href="user-register.jsp"  style="float:right">注册账号</a>
					</div>

				</form>
			</div>
						
		</div>

			<script type="text/javascript">

			function validate(){
				name=document.Login_Account.user_name.value;
				password=document.Login_Account.password.value;
				code=document.Login_Account.captcha.value;
				if(name==""){
					window.alert("请输入账号");
					document.user_name.focus();
					return;
				}
				if(password==""){
					window.alert("请输入密码");
					document.password.focus();
					return;
				}
				if(code==""){
					window.alert("请输入验证码");
					document.captcha.focus();
					return;
				}
				Login_Account.submit();
			}

			function refresh(){
				Login_Account.validatecode.src="Validate.jsp?"+Math.random();
			}

			</script>
		
	</body>
</html>
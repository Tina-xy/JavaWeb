	<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>

	<% 
	String accountone= request.getParameter("account");
	String passwordone = request.getParameter("password");
	String str=null;
	boolean flag=true;
	try{
	if(accountone.equals("123456") && passwordone.equals("654321")){	
	response.sendRedirect("http://www.szu.edu.cn/szu.asp");	
	}	
	else{
	    flag=false;
		if(accountone.equals("123456"))
		    str="accountone_right";
		else if(passwordone.equals("654321"))
		    str="passwordone_right";
	  }
	}catch(Exception e) {}
	%>	
	
    <html>
		<head>
			<title>深圳大学统一身份认证</title>
			<style>
			div.background{
			
			background: url('authbg.jpg') no-repeat;
			border: 1px solid black;
			 }
			 div.transbox{
			position:absolute;
			top:0;
			left:50%;
			margin-left:-400px;
			margin-top:160px;
			padding: 15px 5px 10px 20px;
			width: 300px;
			background-color: #ffffff;
			border: 2px #666666 dashed;
			filter:alpha(opacity=70);
			opacity:0.7;
			}
			div.transbox p{
			 margin: 40px 40px;
			}
			div.warning{
			color:#F00;
			}
			</style>
			</head>
			<body>
			<div class="background">
				<div class="transbox">
					<div class="warning" style="margin-top:10px;margin-left:40px">
					
					<%	
					if(flag==false){		
						if(str.equals("accountone_right"))
							out.println("登录失败！校园卡密码输入错误");
						else if(str.equals("passwordone_right"))
							out.println("登录失败！校园卡号输入错误");
						else 	
					        out.println("登录失败！校园卡号输入错误");}  
					if(flag==true) {}			 		
					 %>
					 
					</div>
			<p>
			<td colspan="2" align="center"><b><font size=4>深圳大学统一身份认证</font></b></td><br>
			<form name="login" method="post">
			<table>
			<tr height="30">
			<td align="right">校园卡号：</td>
			<td><input name="account" type="text"></td>
			</tr>
			<tr height="50">
			<td align="right">密　码：</td>
			<td><input name="password"type="password"></td>
			</tr>
			<tr>
			<td colspan="2" align="center"><input type="button"  value="登录" onclick="validate();" >
			<input type="reset" value="重置"></td>
			</tr>
			<td colspan="2" align="center" style="FONT-SIZE:12px;color:#a0a0a0">
			<a href="http://www.szu.edu.cn/nc/view.asp?id=167">登录失败？请查看《常见问题解答》</a><BR>
			<BR>—— 信息中心 Tel:26537109 ——</td>
			</table>
			</form>
			</p>
			</div>
			</div>	
			<script type="text/javascript">
			function validate(){
			account=document.login.account.value;
			password=document.login.password.value;
			if(account==""){
			window.alert("请输入你的校园卡号");
			document.account.focus();
			return;
			}
			if(password==""){
			window.alert("请输入校园卡查询密码");
			document.password.focus();
			return;
			}
			login.submit();
			}
			</script>

		</body>
	</html>
<%@ page language="java" import="java.sql.*" pageEncoding="UTF-8"%>
<%	
	//获取数据库连接 
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/S2013150090?useUnicode=true&characterEncoding=utf-8","S2013150090","150090");
	
	String user_account = (String)session.getAttribute("name");  //永远标记当前登录的账号
	String user_name=null;
	try{
				
		String name_sql = "SELECT User_Name FROM User WHERE User_Account=?";
		PreparedStatement name_ps = conn.prepareStatement(name_sql);
		name_ps.setString(1,user_account);					
		ResultSet name_rs=name_ps.executeQuery();
		
		if(name_rs.next())
		{
			user_name = name_rs.getString("User_Name");		
		}
		
    }
	catch(Exception e) 
	{
		out.print(e);
	}

	//获取表单值
	request.setCharacterEncoding("UTF-8");
	String picture_name = request.getParameter("hidden_filename");
	String name = request.getParameter("name");
	String sex = request.getParameter("sex");
	String sign = request.getParameter("sign");

	//Friend表里面更新相关信息
	if(name==null&&sex==null&&sign==null&&picture_name==null)
	{ }
	else{
		try{
			String change_sql = "UPDATE User SET User_Name=?,User_sex=?,User_sign=?,Head_picture=? WHERE User_Account=?";
			PreparedStatement change_ps = conn.prepareStatement(change_sql);
			change_ps.setString(1,name);
			change_ps.setString(2,sex);
			change_ps.setString(3,sign);
			change_ps.setString(4,picture_name);
			change_ps.setString(5,user_account);
			change_ps.executeUpdate();

			out.write("<script language='javascript'>alert('个人信息已更改成功！');window.location='Friend_index.jsp';</script>");
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
		<style>
		div .personCenter_HeaderPanel{
				position:absolute;
				margin-left:210px;
				margin-top:0px;
				padding: 4px 5px 0px 10px;
				width: 900px;
				height:40px;
				}
		div .personCenter_personInformation{
				position:absolute;
				top:0;
				left:50%;
				margin-left:-350px;
				margin-top:100px;
				padding: 10px 5px 0px 10px;
				width: 700px;
				height:550px;
				background-color: #ffffff;
				border: 2px #666666 dashed;
				filter:alpha(opacity=80);
				opacity:0.7;
		textarea.ui-input-text{
				min-height:90px;
		}
							
				}
		</style>
	</head>
	<body>
	<div data-role="page" class="background" style="background:url('img/picture.jpg') 50% 0 no-repeat; background-size:cover;" data-theme="a">			
		<div class="personCenter_HeaderPanel">
			<div class="ui-grid-a ui-responsive">
			  	<div class="ui-block-a">
			  		<div class="ui-body ui-body-d" style="margin-left:85px;margin-top:20px;height:80px">
			 			<a width="30"  href="Friend_index.jsp" data-role="button" data-ajax="false" data-icon="Back" data-iconpos="notext"></a>	
		 	  		</div>
		 	  	</div>
				<div class="ui-block-b">
					<div class="ui-body ui-body-d" style="height:80px">
			 			<h1>个人中心</h1>
		 	 		</div>
		 	 	</div>
			</div>
		</div>
		<div class="personCenter_personInformation">
		    
			
			<form style="margin_top:5px;" name="file_upload" id="file_upload" enctype="multipart/form-data" method="post">
				<div  id="img">
					<table>
					<tr>
						<td align="center">头像：</td>
						<td><img  src='head_sculpture/weixin_picture_6.jpg'/></td>
					</tr>
					</table>
				</div>
				<table weight="600">
				 <tr>
					<td aligh="left" width="230">
						<label for="file"></label>
						<input type="file" name="myfile" id="file">
					</td>
				 	<td aligh="left" width="150"><input type="button" data-role="none" value="上传" onclick="Upload();">
				 	</td>
				</tr>
				</table>
			</form>

			<form name="personCenter"  method="post">
				<ul data-role="listview" data-inset="true"> 
					<li class="ui-field-contain">
					    <input type="hidden" name="hidden_filename" id="hidden_filename" value="">
						<label for="account">账号:</label>
						<input name="account" id="account" disabled="disabled" data-clear-btn="true" placeholder="<%=user_account%>" type="text">
					</li>
					
					<li class="ui-field-contain">
						<label for="name">昵称:</label>
						<input name="name" id="name" data-clear-btn="true"  placeholder="<%=user_name%>" type="text">
					</li>
					
					<li class="ui-field-contain">
						<label for="sex">性别:</label>
						<table width="250"><tr>
						<td aligh="left" width="60"><input type="radio" value="男" name="sex"></td><td aligh="left" width="60">男</td>
						<td aligh="left" width="60"><input type="radio" value="女" name="sex"></td><td aligh="left" width="60">女</td>
						</tr></table>
					</li>
					
					<li class="ui-field-contain">
						<label for="sign">个性签名:</label>
						<input name="sign" id="sign" data-clear-btn="true"  placeholder="随便写写......" type="text">
					</li>

					<li style="margin_top:5px">
						<fieldset class="ui-grid-a">
							<div class="ui-block-a"><button onclick="Cancle()" class="ui-btn ui-corner-all ui-btn-a">取消</button></div>
							<div class="ui-block-b"><button onclick="Validate()" class="ui-btn ui-corner-all ui-btn-a">保存</button></div>
						</fieldset>
					</li>
					
					<li style="margin_top:5px;margin_left:150px;">
						<button onclick="exit()">注销账户</button>
					</li>
				</ul>
			</form>
			
			
		</div>
		
	</div>
	
	<script>
		function Upload(){
			var file_name=null;
			var formData = new FormData($( "#file_upload" )[0]);
			$.ajax({
				url: 'info_upload.jsp',
			    type: 'POST',
			    data: formData,
			    async: false,
			    cache: false,
			    contentType: false,
			    processData: false,
			    success: function (returndata) {
					var obj = JSON.parse(returndata);
					$("#hidden_filename").val(obj.filename);
					
			    } 
		  	});
		}

		function Validate(){
			personCenter.submit();
			
		}

		function Cancle(){
			alert("确定取消此次更改？");
		}

		function exit(){
				document.cookie="cookie_user=";
				location.href="../Friend_login.jsp"; 
			}
	</script>
	
	</body>
</html>

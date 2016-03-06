<%@ page language="java" import="java.util.Date" import="java.text.SimpleDateFormat" import="java.sql.*" pageEncoding="UTF-8"%>
<%	
	//获取数据库连接
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/S2013150090?useUnicode=true&characterEncoding=utf-8","S2013150090","150090");

	//URL传值
	String user_account = (String)session.getAttribute("name");
	String add_account = null;
	add_account = request.getParameter("add_account");

	//从数据库获得
	String  information_Account=null;
	String  information_Name=null;

	//表单传值
	String  information_Account_get = request.getParameter("information_Account");

	//获取当前时间
	Date nowTime = new Date();
	SimpleDateFormat matter = new SimpleDateFormat("yyyy-MM-dd HH:mm");
	String add_time = matter.format(nowTime);

	if(information_Account_get != null)
	{
		try{

			//Friend表里面数据添加
			String sql = "INSERT INTO Friend(Apply_Account,Applied_Account,Apply_Time,status,new_flag,A_shield_B,B_shield_A) VALUES(?,?,?,?,?,?,?)";
			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1,user_account);
			ps.setString(2,information_Account_get);
			ps.setString(3,add_time);
			ps.setInt(4,0);
			ps.setInt(5,1);
			ps.setInt(6,0);
			ps.setInt(7,0);				
			ps.executeUpdate();
			//关闭数据库连接
			ps.close();

			out.write("<script language='javascript'>alert('已添加,等待对方回复');window.location='Friend_friendSearch.jsp';</script>");
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
		 
		div .friendAdd_HeaderPanel{
				position:absolute;
				margin-left:170px;
				margin-top:10px;
				padding: 4px 5px 0px 10px;
				width: 700px;
				height:40px;
				}
		div .friendAdd_searchPanel{
				position:absolute;
				top:0;
				left:50%;
				margin-left:-400px;
				margin-top:100px;
				padding: 10px 5px 0px 10px;
				width: 700px;
				height:400px;				
				background-color: #ffffff;
				border: 2px #666666 dashed;
				filter:alpha(opacity=80);
				opacity:0.7;
				}	
		</style>
	</head>
	<body>
		<div data-role="page" style="background:url('img/picture.jpg') 50% 0 no-repeat; background-size:cover;" data-theme="c">
			<div class="friendAdd_HeaderPanel">
				<div class="ui-grid-a ui-responsive">
				  	<div class="ui-block-a">
				  		<div class="ui-body ui-body-d" style="margin-left:85px;margin-top:30px;height:80px">
				 			<a width="30"  href="Friend_index.jsp" data-role="button" data-ajax="false" data-icon="Back" data-iconpos="notext"></a>	
			 	  		</div>
			 	  	</div>
					<div class="ui-block-b">
						<div class="ui-body ui-body-d" style="height:80px">
				 			<h1>添加朋友</h1>
			 	 		</div>
			 	 	</div>
				</div>
			</div>	
			<div class="friendAdd_searchPanel">
				<div style="margin-top:30px;margin-left:190px">
				<form name="friend_Add"> 
					<table weight="400">
				    	<tr height="240">
							<td align="center" height="250">
								<%
									out.println("<img src=\"head_sculpture/weixin_picture_2.jpg\"/>");					
								%>
							</td>
							<td>
								<div style="margin-left:50px"> 
									<%
										if(add_account!=null && add_account!="")
										{	
											try{
												
												String add_sql = "SELECT * FROM User WHERE User_Account=?";
												PreparedStatement add_ps = conn.prepareStatement(add_sql);
												add_ps.setString(1,add_account);
												ResultSet add_rs=add_ps.executeQuery();

												

												if(add_rs.next())
												{
													information_Account = add_rs.getString("User_Account");
													information_Name= add_rs.getString("User_Name");				
												}
												out.println("<b>"+ "<font color=\"#330000\">"+"微信号: "+ information_Account + "<BR>" + "<BR>"+ "<BR>" +"昵称："+ information_Name + "</font>" +"</b>");

											}
											catch(Exception e) 
											{
												out.print(e);
											}
												
											
										}	
									%>
									<input type="hidden" name="information_Account" value="<%= information_Account %>" >		
								</div>
							</td>
						</tr>
						<tr>
							<td colspan="2" style="weight:200px">

								<input style="margin-left:50px;height:40px;weight:100px" type="button" value="添加为好友" onclick="friendAdd()">
							
							</td>
						</tr>
					</table>
				</form>
				</div>
			</div>
		</div>


		<script type="text/javascript">

		function friendAdd(){					
					friend_Add.submit();
		}
		</script>	
	</body>	
</html>
<%@ page language="java" import="java.util.Date" import="java.text.SimpleDateFormat" import="java.sql.*" pageEncoding="UTF-8"%>
<%	
				//获取数据库连接
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/S2013150090?useUnicode=true&characterEncoding=utf-8","S2013150090","150090");
	String user_account = (String)session.getAttribute("name");  //永远标记当前登录的账号
%>
<html  xmlns="http://www.w3.org/1999/xhtml">
	<head>
		<meta name="viewport" content="width=device-width, initial-scale=1.0, minimum-scale=1.0, maximum-scale=1.0, user-scalable=no"/> 
		<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
		
		<!-- jquery mobile -->
		<link rel="stylesheet" href="./css/default/jquery.mobile-1.4.5.min.css" />
		<link rel="stylesheet" type="text/css" href="./css/common.css">
		<link rel="stylesheet" href="./css/listnav.css" type="text/css" media="screen" charset="utf-8" />

		<script src="js/jquery.min.js"></script>		
		<script src="js/jquery.mobile-1.4.5.min.js"></script>
	
		<style>
		div .friendList_HeaderPanel{
				position:absolute;
				margin-left:170px;
				margin-top:0px;
				padding: 4px 5px 0px 10px;
				width: 900px;
				height:40px;
				}
		div .friendList_listPanel{
				position:absolute;
				top:0;
				left:50%;
				margin-left:-400px;
				margin-top:80px;
				padding: 10px 5px 0px 10px;
				width: 800px;
				}
		</style>
	</head>

	<body>
		<div data-role="page" style="background:url('img/picture.jpg') 50% 0 no-repeat; background-size:cover;" data-theme="a">
			<div class="friendList_HeaderPanel">

				<div class="ui-grid-a ui-responsive">
				  	<div class="ui-block-a"><div class="ui-body ui-body-d" style="margin-left:90px;margin-top:20px;height:80px">
				 		<a width="30"  href="Friend_index.jsp" data-role="button" data-ajax="false" data-icon="Back" data-iconpos="notext"></a></div>
				 	</div>
					<div class="ui-block-b"><div class="ui-body ui-body-d" style="height:80px"><h1>好友信息</h1></div></div>
				</div>

			</div>	
			<div class="friendList_listPanel" id="myList-nav">
			<%
				try{
					
					String friend_sql = "SELECT * FROM Friend WHERE status=1 order by Apply_Time asc";
					PreparedStatement friend_ps = conn.prepareStatement(friend_sql);					
					ResultSet friend_rs=friend_ps.executeQuery();
			%>			
			<ul id="myList" data-role="listview" data-autodividers="true" data-filter="true" data-filter-placeholder="Search..."	data-inset="true" data-icon="false">
			<%
				while(friend_rs.next()){
					String apply_account = friend_rs.getString("Apply_Account");
					String applied_account = friend_rs.getString("Applied_Account");
					int friend_id = friend_rs.getInt("Friende_ID");
					if(user_account.equals(apply_account))
					{
						out.print("<li>"+"<img style='margin-top:20px;margin-left:20px' src='head_sculpture/weixin_picture_6.jpg'/>"+ "<b>" + applied_account + "</b>"+"<div style='margin-left:400px;'>"+"<table width='250'>"+"<tr>"+"<td aligh='left' width='120'>"+"<input type='button' value='进入' onclick='Come("+friend_id+");'>"+"</td>"+"<td aligh='left' width='140'>"+"<input type='button' value='删除' onclick='Delete("+friend_id+");'>"+"</td>"+"</tr>"+"</table>"+"</div>" + "</li>");
					}
					if(user_account.equals(applied_account))
					{
						out.print("<li>"+"<img style='margin-top:20px;margin-left:20px' src='head_sculpture/weixin_picture_6.jpg'/>"+ "<b>" + apply_account + "</b>"+"<div style='margin-left:400px;'>"+"<table width='250'>"+"<tr>"+"<td aligh='left' width='120'>"+"<input type='button' value='进入' onclick='Come("+friend_id+");'>"+"</td>"+"<td aligh='left' width='140'>"+"<input type='button' value='删除' onclick='Delete("+friend_id+");'>"+"</td>"+"</tr>"+"</table>"+"</div>" + "</li>");
					}
				}	
			%>
			</ul>
			<%
					friend_rs.close();				
				}
				catch(Exception e) 
				{
					out.print(e);
				}
				conn.close();	
			%> 
				
			</div>
		</div>
		<script type="text/javascript">
		



		function Come(id){
			var friend_id=id;
			location.href="Friend_friendPage.jsp?value="+friend_id;
		}

		function Delete(id){
			//注意：JS里面的类型只有var,不要自己乱定义
			var friend_id=id;       
			$(document).ready(function(){
				$.ajax({
				    type: "post",
				    url: "info_delete.jsp",         //请求程序页面
				    data: {"value":friend_id},//请求需要发送的处理数据
				    success: function(msg){
				        	alert(msg);
	            			window.location.href = "Friend_friendList.jsp?";
	    			}
	    		});
			});
		}

		</script>
	</body>
</html>
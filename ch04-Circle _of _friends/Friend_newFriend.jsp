<%@ page language="java" import="java.util.Date" import="java.text.SimpleDateFormat" import="java.sql.*" pageEncoding="UTF-8"%>
<%	
	//获取数据库连接
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/S2013150090?useUnicode=true&characterEncoding=utf-8","S2013150090","150090");
	String user_account = (String)session.getAttribute("name");  //永远标记当前登录的账号
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
		 
		div .newFriend_HeaderPanel{
				position:absolute;
				margin-left:180px;
				margin-top:10px;
				padding: 4px 5px 0px 10px;
				width: 800px;
				height:40px;
				}
		div .newFriend_listPanel{
				position:absolute;
				top:0;
				left:50%;
				margin-left:-400px;
				margin-top:150px;
				padding: 10px 5px 0px 10px;
				width: 800px;						
				background-color: #ffffff;
				border: 2px #666666 dashed;
				filter:alpha(opacity=80);
				opacity:0.7;
				}	
		</style>
	</head>
	<body>
		<div data-role="page" style="background:url('img/picture.jpg') 50% 0 no-repeat; background-size:cover;" data-theme="a">
			<div class="newFriend_HeaderPanel">
				<div class="ui-grid-a ui-responsive">
				  	<div class="ui-block-a">
				  		<div class="ui-body ui-body-d" style="margin-left:85px;margin-top:30px;height:80px">
				 			<a width="30"  href="Friend_index.jsp" data-role="button" data-ajax="false" data-icon="Back" data-iconpos="notext"></a>	
			 	  		</div>
			 	  	</div>
					<div class="ui-block-b">
						<div class="ui-body ui-body-d" style="height:80px">
				 			<h1>新的朋友</h1>
			 	 		</div>
			 	 	</div>
				</div>
			</div>	
			<div class="newFriend_listPanel">

			<%
				try{
					
					String newfriend_sql = "SELECT * FROM Friend WHERE Applied_Account=? order by Apply_Time desc";
					PreparedStatement newfriend_ps = conn.prepareStatement(newfriend_sql);
					newfriend_ps.setString(1,user_account);					
					ResultSet newfriend_rs=newfriend_ps.executeQuery();
			%>		
			<ul data-role="listview">
			<%
				while(newfriend_rs.next()){
					String apply_account = newfriend_rs.getString("Apply_Account");
					int status = newfriend_rs.getInt("status");
					int apply_flag = newfriend_rs.getInt("new_flag");
					int apply_id = newfriend_rs.getInt("Friende_ID");
					if(apply_flag==1)
					{
						out.print("<li>"+"<img style='margin-top:20px;margin-left:20px' src='head_sculpture/weixin_picture_6.jpg'/>"+ "<b>" + apply_account + "</b>"+"<div style='margin-left:400px;' id='result"+apply_id+"'>"+"<table width='250'>"+"<tr>"+"<td aligh='left' width='120'>"+"<input type='button' value='接受' onclick='Accept("+apply_id+");'>"+"</td>"+"<td aligh='left' width='140'>"+"<input type='button' value='拒绝' onclick='Refuse("+apply_id+");'>"+"</td>"+"</tr>"+"</table>"+"</div>" + "</li>");
					}
					else if(status==1)
					{
						out.print("<li>"+"<img style='margin-top:20px;margin-left:20px' src='head_sculpture/weixin_picture_6.jpg'/>"+ "<b>" + apply_account + "</b>"+"<div style='margin-left:400px;'>"+"<font color='#C0C0C0'>"+"已接受"+"</font>"+"</div>" + "</li>");
					}
					else if(status==2)
					{
						out.print("<li>"+"<img style='margin-top:20px;margin-left:20px' src='head_sculpture/weixin_picture_6.jpg'/>"+ "<b>" + apply_account + "</b>"+"<div style='margin-left:400px;'>"+"<font color='#C0C0C0'>"+"已拒绝"+"</font>"+"</div>" + "</li>");
					}

				}
				//未关数据库			
			%>
			</ul>		   
			<%
								
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

		function Accept(id){
			//注意：JS里面的类型只有var,不要自己乱定义
			var apply_id=id;       
			//不刷新页面显示结果
	    	var xmlHttp=new XMLHttpRequest();
			xmlHttp.open("GET","info_accept.jsp?value="+apply_id,true);
			xmlHttp.onreadystatechange=function(){
				if(xmlHttp.readyState==4){
					document.getElementById("result"+apply_id).innerHTML=xmlHttp.responseText;

				}
			}
			xmlHttp.send();
		}

		function Refuse(id){
			//注意：JS里面的类型只有var,不要自己乱定义
			var apply_id=id;       
			//不刷新页面显示结果
	    	var xmlHttp=new XMLHttpRequest();
			xmlHttp.open("GET","info_refuse.jsp?value="+apply_id,true);
			xmlHttp.onreadystatechange=function(){
				if(xmlHttp.readyState==4){
					document.getElementById("result"+apply_id).innerHTML=xmlHttp.responseText;

				}
			}
			xmlHttp.send();
		}
		</script>
			
	</body>
</html>
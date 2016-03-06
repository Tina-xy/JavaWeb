<%@ page language="java" import="java.util.*" import="java.sql.*" import="java.text.SimpleDateFormat" contentType="text/html;charset=utf-8" %>

<%	
	//获取数据库连接 
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/S2013150090?useUnicode=true&characterEncoding=utf-8","S2013150090","150090");
	String user_account = (String)session.getAttribute("name");  //永远标记当前登录的账号
	String user_name=null;
	String user_sign=null;
	String user_head_picture=null;
	int user_ID=0;
	String friend_headpicture=null;

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
		div .index_HeaderPanel{
				position:absolute;
				margin-left:200px;
				margin-top:0px;
				padding: 4px 5px 0px 10px;
				width: 900px;
				height:40px;
				}
		div .index_PersonPanel{
				position:absolute;
				top:0;
				left:50%;
				margin-left:-450px;
				margin-top:120px;
				padding: 10px 5px 0px 10px;
				width: 700px;
				height:250px;				
				}	
		div .index_SettingPanel{
				position:absolute;
				margin-left:1100px;
				margin-top:150px;
				padding: 10px 5px 0px 10px;								
				}
		div .head_Panel{
				position:absolute;
				margin-left:-80px;							
				}
		div .index_contentPanel{
				position:absolute;
				top:0;
				left:50%;
				margin-left:-450px;
				margin-top:400px;
				padding: 10px 5px 0px 10px;
				width: 700px;
				}
		div .index_commentPanel{
			background-color: #ffffff;
			border: 2px #666666 dashed;
			filter:alpha(opacity=80);
			opacity:0.8;
		}
				
		</style>
	</head>
	<body>
	<div data-role="page" class="background" style="background:url('img/picture.jpg') 50% 0 no-repeat; background-size:cover;" data-theme="c">			
		<div class="index_HeaderPanel">
			<h1  align="center">朋友圈</h1>

		</div>
		<div class="index_SettingPanel" id="SettingPanel">
			<!--  问题：按钮里面的字体大小 -->
			
			<a href="Friend_punish.jsp" data-ajax="false" class="ui-btn ui-corner-all ui-shadow">我要发布</a><br><br><br>
			<a href="Friend_friendSearch.jsp" data-ajax="false" class="ui-btn ui-corner-all ui-shadow">添加好友</a><br><br><br>
			<a href="Friend_friendList.jsp" data-ajax="false" class="ui-btn ui-corner-all ui-shadow">好友信息</a><br><br><br>
			<a href="Friend_newFriend.jsp" data-ajax="false" class="ui-btn ui-corner-all ui-shadow">新的朋友</a><br><br><br>
			<a href="Friend_personPage.jsp" data-ajax="false" class="ui-btn ui-corner-all ui-shadow">我的足迹</a><br><br><br>
			<a href="Friend_personCenter.jsp" data-ajax="false" class="ui-btn ui-corner-all ui-shadow">个人中心</a>
		</div>
		<div class="index_PersonPanel"> 
		    <table>
		    	<tr height="240">
					<td align="center"  height="250">
						<%
							out.println("<img src='head_sculpture/weixin_picture_2.jpg'/>");
						%>
					</td>
					<td>
						<div style="margin-left:50px"> 
						<%  
						    try{
								
								String name_sql = "SELECT * FROM User WHERE User_Account=?";
								PreparedStatement name_ps = conn.prepareStatement(name_sql);
								name_ps.setString(1,user_account);					
								ResultSet name_rs=name_ps.executeQuery();
								
								if(name_rs.next())
								{
									user_ID = name_rs.getInt("User_ID");
									user_name = name_rs.getString("User_Name");
									user_sign = name_rs.getString("User_sign");
									user_head_picture = name_rs.getString("Head_picture"); 

								}
								
								out.println("<font size='8'>"+ "<font color='#330000'>"+user_name+ "</font>" +"</font>" + "<BR>"+ "<BR>" +"<b>"+ "<font color='#330000'>"+user_sign+ "</font>" +"</b>");
							}
							catch(Exception e) 
							{
								out.print(e);
							}								
						%>
						</div>
					</td>
				</tr>
			</table>
		</div>
		<!-- 朋友圈内容栏 -->
		<div class="index_contentPanel">
		<%			
			try{
				
				//搜索数据库的Anouncement表
				int number=1;					
				int page1 ;
				if(request.getParameter("page") == null){
					page1 = 1;
				}
				else{
					page1 = Integer.parseInt(request.getParameter("page"));
				}
				String sql = "SELECT * FROM Anouncement order by Anounce_ID desc limit " + (page1-1)*10 + "," + 10;
				Statement stat = conn.createStatement();
				ResultSet rs = stat.executeQuery(sql);
				while(rs.next()){
					int    punish_ID = rs.getInt("Anounce_ID");
					String punish_name = rs.getString("Anounce_User");				    
					String punish_content = rs.getString("Anounce_Content");
					String punish_time = rs.getString("Anounce_Time");
					String punish_picturename = rs.getString("Picture_name");

					String friend_sql = "SELECT Head_picture FROM User WHERE User_Account=?";
					PreparedStatement friend_ps = conn.prepareStatement(friend_sql);
					friend_ps.setString(1,punish_name);					
					ResultSet friend_rs=friend_ps.executeQuery();
					while(friend_rs.next()){
						friend_headpicture = friend_rs.getString("Head_picture");
					}


		%>

			<div style="margin-top:20px;" class="head_Panel" id="head_Panel<%=punish_ID%>"> 				
			<%  //头像栏
				out.println("<img src='Upload/"+friend_headpicture+"'/>");

			%>
			</div>

		<%		
				if(punish_picturename==null || punish_picturename.equals("")){	
				
					out.println("<div  style='margin-top:9px;'>"+ "<b>"+ "<font color='##C0C0C0'>"+
						punish_name+ "</font>" +"</b>" + "<BR>" + 
						punish_content + "<BR>"+ "<font color='##C0C0C0'>"+ 
						punish_time + "</font>"+ "</div>");		
				}
				else{		
			   		
					out.println("<div  style='margin-top:9px;'>"+ "<b>"+ "<font color='##C0C0C0'>"+
						punish_name+ "</font>" +"</b>" + "<BR>" + 
						punish_content + "<BR>"+ "<font color='##C0C0C0'>"+
						"<img src='Upload/"+punish_picturename +"'/>"+ "<BR>" +
						punish_time + "</font>"+ "</div>");
				}

				out.println("<div  style='margin-left:550px;'>"+"<form>"+
							"<input style='weight:20px;height:30px;' data-role='none' type='button' value='点赞' clickid='"+punish_ID+"' onclick=\"Click("+punish_ID+",'"+user_account+"');\">"+
							"<input style='weight:20px;height:30px;' data-role='none'  type='button' id='comment"+punish_ID+"' value='评论' >"+"</form>"+ "</div>");
							
		%>


			<div class="index_commentPanel" id="index_commentPanel<%=punish_ID%>">

			<div style="margin_top:5px;" class="click_Panel" id="click_Panel<%=punish_ID%>">
			<%  
				//点赞栏:搜索数据库的Click表
				String click_sql = "SELECT * FROM Click WHERE Anounce_ID=?";
				PreparedStatement click_ps = conn.prepareStatement(click_sql);
				click_ps.setInt(1,punish_ID);					
				ResultSet click_rs=click_ps.executeQuery();
				while(click_rs.next())
				{
					String click_account= click_rs.getString("Click_Account");
					out.println("<img src='img/like_click.jpg'/>"+click_account);	
				}

			%>
			</div>

			<form method="post" style="display:none" id="form<%=punish_ID%>" type="com" name="form_content">
				<table width="700">
				  <tr>							
                   <td aligh="left" width="550">
                   		<input style="weight:550px;height:40px" class="comment_content" id="comment_content<%=punish_ID%>" name="comment_content" type="text">
                   </td>
                   <td aligh="center" width="60">
                   		<input class="comment_submit" formid="<%=punish_ID%>" style="weight:60px;height:30px" onclick="Comment('<%=punish_ID%>','<%=user_ID%>',$('#form<%=punish_ID%>').attr('type'));" type="button" data-role='none' value="发送">
                   </td>
				   <td aligh="right" width="60">
                   		<input style="weight:60px;height:30px" id="cancle<%=punish_ID%>" type="button" onclick="***" data-role='none' value="取消">
                   </td>
	              </tr>	
	            </table>	
			</form>

			
			<script>

			var mycomment_id=0;

			$("#comment<%=punish_ID%>").click(function(){
				$("#form<%=punish_ID%>").show();
			});
			
			$("#cancle<%=punish_ID%>").click(function(){
			$("#form<%=punish_ID%>").hide();
			});

			</script>

			<% 	
				//评论栏:搜索数据库的Comment表
				String comment_sql = "SELECT * FROM Comment WHERE Anounce_ID=?";
				PreparedStatement comment_ps = conn.prepareStatement(comment_sql);
				comment_ps.setInt(1,punish_ID);					
				ResultSet comment_rs=comment_ps.executeQuery();
				while(comment_rs.next())
				{
					String commented_account = comment_rs.getString("User_Account");//被评论或被回复
					String comment_account = comment_rs.getString("Com_Account");//评论或回复
					String comment_content = comment_rs.getString("Comment_Content");//评论或回复的内容
					int comment_id = comment_rs.getInt("Comment_ID");
					int replayed_id = comment_rs.getInt("Replayed_ID");
					if(replayed_id == 0){
						out.println("<div  style='margin-top:5px;'>"+ "<b>"+ "<font color='##C0C0C0'>"+
									comment_account + "</font>" +"</b>" + "评论:"+ "<BR>" + 
									comment_content +"<input style='margin_left:20px;weight:20px;height:30px;' data-role='none' type='button' class='rep"+punish_ID+"' value='回复'>" + "</div>" +"<br>");

					}
					else{
						out.println("<div  style='margin-top:4px;'>"+ "<b>"+ "<font color='##C0C0C0'>"+
									comment_account + "</font>" +"</b>" + "回复"+ "<b>"+ "<font color='##C0C0C0'>"+ commented_account + "</font>" +"</b>" +":"+ "<BR>" + comment_content +"<input style='margin_left:20px;weight:20px;height:30px;' data-role='none' type='button' class='rep"+punish_ID+"' value='回复'>" + "</div>" +"<br>");

					}
							
			%>
				<script>				
				$(".rep<%=punish_ID%>").click(function(){
					mycomment_id="<%=comment_id%>";
                    $("#form<%=punish_ID%>").attr("type","rep");
                    $("#form<%=punish_ID%>").show();
                });

				</script>
			<%
				}
			%>
			</div>

		<%
				}	
				sql = "select count(Anounce_ID) numberOfMessage from Anouncement";//从数据库获得页数
				stat = conn.createStatement();
				ResultSet resultOfMessageNumber = stat.executeQuery(sql);
				resultOfMessageNumber.next();		
				
				int pages = Integer.parseInt(resultOfMessageNumber.getString("numberOfMessage"))/10+1;//每10条则分页
				out.println("<br>"+"<hr>");
				for(int i = 0; i<pages; i++){
					out.println("<a href='Friend_index.jsp?page="+(i+1)+"'>"+(i+1)+"</a>");
				}
			   //关闭数据库连接
				stat.close();				
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
		setInterval(Notice,1000);
		function Notice(time)
		{
			Messenger.options = { 
				extraClasses: 'messenger-fixed messenger-on-bottom messenger-on-right', 
				theme: 'air' 
			}
			for(var i=time-1;i>=0;i--)
			{
				Messenger().post({message:"<a href='info_message.jsp'>你的新消息来啦！</a>",showCloseButto:true});
			}
		} 

		//点赞时如何获取内容ID：把内容的id做为点赞按钮的id，然后点赞调用函数时把this.id传过去
		function Click(id,account){
			//注意：JS里面的类型只有var,不要自己乱定义
			var clicked_id=id;       
			var user_account=account;
 			
 			//不刷新页面显示点赞
	    	var xmlHttp=new XMLHttpRequest();
			xmlHttp.open("GET","info_click.jsp?value1="+clicked_id+"&value2="+user_account,true);
			xmlHttp.onreadystatechange=function(){
				if(xmlHttp.readyState==4){
					document.getElementById("click_Panel"+clicked_id).innerHTML=document.getElementById("click_Panel"+clicked_id).innerHTML+xmlHttp.responseText;

				}
			}
			xmlHttp.send();
		}

		function Comment(id1,id2,type){
		    
			var comment_type=type;
			var commenter_id=id2;
			var anounce_id=0; 
			if(comment_type=="com"){
				anounce_id=id1;
			}
			else if(comment_type=="rep"){
				anounce_id=mycomment_id;
			}       			
			var comment_content = $("#comment_content"+id1).val();
			if(comment_content=="" || comment_content==null){
					window.alert("请填写内容");
					document.form_content.comment_content.focus();
					return;
			}

    		//不刷新页面显示评论或回复
	    	var xmlHttp=new XMLHttpRequest();
			xmlHttp.open("GET","info_comment.jsp?value1="+type+"&value2="+anounce_id+"&value3="+commenter_id+"&value4="+comment_content,true);
			xmlHttp.onreadystatechange=function(){
				if(xmlHttp.readyState==4){
					document.getElementById("index_commentPanel"+id1).innerHTML=document.getElementById("index_commentPanel"+id1).innerHTML+xmlHttp.responseText;

				}
			}
			xmlHttp.send();

		}


		</script>
	</body>
</html>

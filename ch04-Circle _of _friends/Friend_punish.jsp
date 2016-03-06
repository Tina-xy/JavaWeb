<%@ page language="java" import="com.jspsmart.upload.*" import="java.text.SimpleDateFormat" import="java.util.Date" import="java.sql.*" pageEncoding="UTF-8"%>
<%   
	//获取数据库连接
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/S2013150090?useUnicode=true&characterEncoding=utf-8","S2013150090","150090");	

	String user_account = (String)session.getAttribute("name");
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
		div .punish_HeaderPanel{
				position:absolute;
				margin-left:200px;
				margin-top:10px;
				padding: 4px 5px 0px 10px;
				width: 800px;
				height:40px;
				}
		div .punish_punishPanel{
				position:absolute;
				top:0;
				left:50%;
				margin-left:-400px;
				margin-top:120px;
				padding: 10px 5px 0px 10px;
				width: 800px;				
				background-color: #ffffff;
				border: 2px #666666 dashed;
				filter:alpha(opacity=80);
				opacity:0.7;
				}	
		div .punish_button{
				width:120px;
				height:40px;				
				}
		textarea.ui-input-text{
				min-height:200px;
		}
		
		</style>
	</head>
	<body>
		<div data-role="page" class="background" style="background:url('img/picture.jpg') 50% 0 no-repeat; background-size:cover;" data-theme="a">
			<div class="punish_HeaderPanel">
				<div class="ui-grid-a ui-responsive">
				  	<div class="ui-block-a">
				  		<div class="ui-body ui-body-d" style="margin-left:85px;margin-top:20px;height:80px">
				 			<a width="30"  href="Friend_index.jsp" data-role="button" data-ajax="false" data-icon="Back" data-iconpos="notext"></a>	
			 	  		</div>
			 	  	</div>
					<div class="ui-block-b">
						<div class="ui-body ui-body-d" style="height:80px">
				 			<h1>我要发布</h1>
			 	 		</div>
			 	 	</div>
				</div>	
			</div>	
			<div class="punish_punishPanel"> 
				<form name="punish_punishment"  method="post">				
					<textarea name="content" rows="100" cols="96" placeholder="这一刻的想法......"></textarea>
					<table  style="margin-top:20px;margin-left:340px;" width="450">
						<tr>
							<td><input type="hidden" name="hidden_filename" id="hidden_filename" value=""></td>
							<td aligh="left" width="140">
					        	<input type="button" value="@" class="at_button" onclick="At();"></td>
					        <td aligh="left" width="160">
					        	<input type="button" value="部分好友查看" class="authority_button" onclick="Authority();"></td>			
					        <td aligh="left" width="140">
					        	<input type="button" value="发布" class="punish_button" onclick="Punish();"></td>
				        </tr>
				    </table>					               				
				</form>	

				<form name="file_upload" id="file_upload" enctype="multipart/form-data" method="post">
					<table width="350">
						<tr>
							<td aligh="left" width="350">上传文件或图片：</td>
						</tr>
						<tr>
							<td aligh="left" width="130"><label for="file"></label><input type="file" name="myfile" id="file"></td>
							<td aligh="left" width="150"><input type="button" data-role="none" value="上传" onclick="Upload();"></td>
						</tr>
					</table>
				</form>			
			</div>
			
			<%
		    
			//获取数据
			request.setCharacterEncoding("UTF-8");
			String punish_content = request.getParameter("content");
			String file_name = request.getParameter("hidden_filename");
			String content=null;
			if(punish_content==null)
			{  }
			else if(punish_content.equals(""))
			{
				out.print("<script>alert('发帖信息不完整，请重新填写')</script>"); //在Java中利用标签达到JS的效果
			}
			else{
					StringBuffer content_copy=new StringBuffer(punish_content.length());
					char ch;			
					for( int i=0;i<punish_content.length();i++)
					{
					   ch=punish_content.charAt(i);
					   if(ch==' ')
					   {
							content_copy.append("&nbsp;");
							continue;
					   }
					   if(ch=='\n')
					   {
							content_copy.append("<br>");
							continue;
					   }
					   if(ch=='<')
					   {
							content_copy.append("&lt;");
							continue;
					   }
					   if(ch=='>')
					   {
							content_copy.append("&gt;");
							continue;
					   }
					   if(ch=='&')
					   {
							content_copy.append("&amp;");
							continue;
					   }
					   else
					   {
							content_copy.append(ch);
							continue;
					   }
					}
					content=content_copy.toString();
					
					//获取当前时间
					Date nowTime = new Date();
					SimpleDateFormat matter = new SimpleDateFormat("yyyy-MM-dd HH:mm");
					String punish_time = matter.format(nowTime);
					
					try{
						//数据添加
						String sql = "INSERT INTO Anouncement(Anounce_Content,Anounce_Time,Anounce_User,Picture_name) VALUES(?,?,?,?)";
						PreparedStatement ps = conn.prepareStatement(sql);
						ps.setString(1,content);
						ps.setString(2,punish_time);
						ps.setString(3,user_account);
						if(file_name==null || file_name.equals(""))
						{
							ps.setString(4,null);
						}
						else{
							ps.setString(4,file_name);
						}
						ps.executeUpdate();
						//关闭数据库连接
						ps.close();

						out.write("<script language='javascript'>alert('发布成功！');window.location='Friend_index.jsp';</script>");
					}
					catch(Exception e)
					{
						out.print(e);
					}						
				}
			%>
		</div>
		
		<script type="text/javascript">
			
			function At(){
				location.href="Authority_select.jsp?value="+"at";
			}

			function Authority(){
				location.href="Authority_select.jsp?value="+"authority";
			}

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

			function Punish(){
			content=document.punish_punishment.content.value;
			if(content==""){
				window.alert("你还没有填写需要发表的内容");
				return;
				}
				punish_punishment.submit();
			}

		</script>
	</body>	
</html>
<%@ page language="java" import="java.util.Date"  import="java.sql.*" pageEncoding="UTF-8"%>
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
		 
		div .friendSearch_HeaderPanel{
				position:absolute;
				margin-left:170px;
				margin-top:10px;
				padding: 4px 5px 0px 10px;
				width: 800px;
				height:40px;
				}
		div .friendSearch_searchPanel{
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
			<div class="friendSearch_HeaderPanel">
				<div class="ui-grid-a ui-responsive">
				  	<div class="ui-block-a">
				  		<div class="ui-body ui-body-d" style="margin-left:85px;margin-top:30px;height:80px">
				 			<a width="30"  href="Friend_index.jsp" data-role="button" data-ajax="false" data-icon="Back" data-iconpos="notext"></a>	
			 	  		</div>
			 	  	</div>
					<div class="ui-block-b">
						<div class="ui-body ui-body-d" style="height:80px">
				 			<h1>搜索信息</h1>
			 	 		</div>
			 	 	</div>
				</div>
			</div>	
			<div class="friendSearch_searchPanel">
				<div style="margin-top:150px;margin-left:40px">
					<form  method="get" name="friendSearch_account">
						<table width="600">
							<tr>							
			                   <td aligh="left" width="450">
			                   		<input style="weight:600px;height:40px" name="user_account" type="text" placeholder="微信号/手机号/QQ号">
			                   </td>
			                   <td aligh="right" width="150">
			                   		<input style="weight:100px;height:40px"  type="button" value="搜索" onclick="Send_requist()">
			                   </td>
			                </tr>	
		                </table>					
	 				</form>
	 				<div style="margin-top:50px;margin-left:200px">
					<%  
						  
								String user_account = (String)session.getAttribute("name");													
								out.println("<b>"+ "<font color=\"#330000\">"+"我的微信号："+user_account+"</font>" +"</b>");
			
					%>	 			
	 				</div>
					<div style="margin-top:50px;margin-left:200px" id="friendSearch_inforDiv"></div>
 				</div>
			</div>
 		</div>	
		<script type="text/javascript">

		function Send_requist(){
			account=document.friendSearch_account.user_account.value;
			if(account==""){
					window.alert("请输入搜索账号");
					document.user_account.focus();
					return;
			}
			$(document).ready(function(){
				$.ajax({
				    type: "post",
				    url: "info_search.jsp",         //请求程序页面
				    data: {"value":account},//请求需要发送的处理数据
				    success: function(msg){
				        if(msg==1) //根据返回值进行跳转
				        {
	            			window.location.href = "Friend_friendAdd.jsp?add_account="+account;
	        			}
	        			else
	        			{
	        				friendSearch_inforDiv.innerHTML="<font color='red'>该用户不存在</font>";

	        			}
	    			}
	    		});
			});
		}

		</script>
	
	</body>	
</html>
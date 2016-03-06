<%@ page language="java" import="java.util.Date" import="java.text.SimpleDateFormat" import="java.sql.*" pageEncoding="UTF-8"%>
<%	
				//获取数据库连接
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/S2013150090?useUnicode=true&characterEncoding=utf-8","S2013150090","150090");
	String user_account = (String)session.getAttribute("name");  //永远标记当前登录的账号

	String value_type = request.getParameter("value");//判断是@还是设置权限
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
		div .Authority_select_HeaderPanel{
				position:absolute;
				margin-left:540px;
				margin-top:0px;
				padding: 4px 5px 0px 10px;
				width: 900px;
				height:40px;
				}
		div .Authority_select_listPanel{
				position:absolute;
				top:0;
				left:50%;
				margin-left:-400px;
				margin-top:100px;
				padding: 10px 5px 0px 10px;
				width: 800px;
				}
		</style>
	</head>

	<body>
		<div data-role="page" style="background:url('img/picture.jpg') 50% 0 no-repeat; background-size:cover;" data-theme="a">
			<div class="Authority_select_HeaderPanel">

				<div class="ui-grid-a ui-responsive">
				  	<div class="ui-block-a"><div class="ui-body ui-body-d" style="margin-left:90px;margin-top:20px;height:80px">
				 		<a width="30"  href="Friend_punish.jsp" data-role="button" data-ajax="false" data-icon="Back" data-iconpos="notext"></a></div>
				 	</div>
					<div class="ui-block-b"><div class="ui-body ui-body-d" style="height:80px;margin-top:35px">选择相关好友</div></div>
				</div>

			</div>	
			<div class="Authority_select_listPanel" id="myList-nav">
			<form>
			<ul data-role="listview">
			<%

				boolean select_flag=false;//判断是否有好友可选择

				try{
					
					String select_sql = "SELECT * FROM Friend WHERE status=1 order by Apply_Time asc";
					PreparedStatement select_ps = conn.prepareStatement(select_sql);					
					ResultSet select_rs=select_ps.executeQuery();
					while(select_rs.next()){
						String apply_account = select_rs.getString("Apply_Account");
						String applied_account = select_rs.getString("Applied_Account");
						int friend_id = select_rs.getInt("Friende_ID");
						if(user_account.equals(apply_account)) 
						{
							out.print("<li>"+"<fieldset data-role='controlgroup' data-iconpos='right'>"+"<input type='checkbox' name='checkbox' value='"+friend_id+"' id='checkbox"+friend_id+"'>"+"<label for='checkbox"+friend_id+"'>"+"<img src='head_sculpture/weixin_picture_6.jpg'/>"+applied_account+"</label>"+"</fieldset>"+ "</li>");

							select_flag=true;
						}
						else if(user_account.equals(applied_account))
						{
							out.print("<li>"+"<fieldset data-role='controlgroup' data-iconpos='right'>"+"<input type='checkbox' name='checkbox' value='"+friend_id+"' id='checkbox"+friend_id+"'>"+"<label for='checkbox"+friend_id+"'>"+"<img src='head_sculpture/weixin_picture_6.jpg'/>"+apply_account+"</label>"+"</fieldset>"+"</li>");

							select_flag=true;
						}
					}

					if(select_flag){
						out.print("<li>"+"<table style='margin-left:400px;' width='300'>"+"<tr>"+"<td aligh='left' width='140'>"+"<input type='reset' value='取消'>"+"</td>"+"<td aligh='left' width='140'>"+"<input type='button' value='确定' onclick='Selected(\""+value_type+"\");'>"+"</td>"+"</tr>"+"</table>"+"</li>");
					}
					else{
						out.print("你暂时没有好友，请添加......");
					}			
				}
				catch(Exception e) 
				{
					out.print(e);
				}
					
			%> 
			</ul>
			</form>
			</div>
		</div>

		<script type="text/javascript">

		function Selected(type){
			var selected_flag=false;//判断是否有复选框被选中
			var value_type=type;    //判断是@还是设置权限
            var checkbox_array=document.getElementsByName("checkbox");
            var checkbox_value=null;

            if(value_type=="authority"){
	            for(var i=0;i<checkbox_array.length;i++)
	            {
	                if(checkbox_array[i].checked==true)
	                { 
	                	selected_flag=true;
	                }
	           	    else//未被选中的好友会被屏蔽
	           	    {	
						checkbox_value=checkbox_array[i].value;
	           	    	$(document).ready(function(){
							$.ajax({
							    type: "post",
							    url: "info_authority.jsp",         //请求程序页面
							    data: {"value":checkbox_value},//请求需要发送的处理数据
							});
						});
	           	    }
	            }
	            if(!selected_flag)
	           	{
	       	    	alert("请最少选择一项!");
	       	    }
	       	    else{
           	    	alert("已确定只允许查看的好友！");
           	    	location.href="Friend_punish.jsp";
           	    }
        	}
            else if(value_type=="at"){
	            for(var i=0;i<checkbox_array.length;i++)
	            {
	                if(checkbox_array[i].checked==true)//被选中的好友会被@
	                { 
	                	checkbox_value=checkbox_array[i].value;
	           	    	$(document).ready(function(){
							$.ajax({
							    type: "post",
							    url: "info_at.jsp",         //请求程序页面
							    data: {"value":checkbox_value},//请求需要发送的处理数据
							});
						});

	                	selected_flag=true;
	                }   
	            }
	            if(!selected_flag)
           	    {
           	    	alert("请最少选择一项!");
           	    }
           	    else{
           	    	alert("已确定@的好友！");
           	    	location.href="Friend_punish.jsp";
           	    }
            }
		}

		</script>
	</body>
</html>
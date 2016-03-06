<%@ page language="java" import="java.util.Date" import="java.text.SimpleDateFormat" import="java.sql.*" pageEncoding="UTF-8"%>
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
		div .personPage_HeaderPanel{
				position:absolute;
				margin-left:170px;
				margin-top:0px;
				padding: 4px 5px 0px 10px;
				width: 900px;
				height:40px;
				}
		div .personPage_PersonPanel{
				position:absolute;
				top:0;
				left:50%;
				margin-left:-400px;
				margin-top:120px;
				padding: 10px 5px 0px 10px;
				width: 700px;
				height:250px;								
				}			
		div .personPage_contentPanel{
				position:absolute;
				top:0;
				left:50%;
				margin-left:-400px;
				margin-top:400px;
				padding: 10px 5px 0px 10px;
				width: 700px;
				}
				
		</style>
	</head>
	<body>
	<div data-role="page" class="background" style="background:url('img/picture.jpg') 50% 0 no-repeat; background-size:cover;" data-theme="c">			
		<div class="personPage_HeaderPanel">
		 	<div class="ui-grid-a ui-responsive">
		  	<div class="ui-block-a">
		  		<div class="ui-body ui-body-d" style="margin-left:85px;margin-top:20px;height:80px">
		 			<a width="30"  href="Friend_index.jsp" data-role="button" data-ajax="false" data-icon="Back" data-iconpos="notext"></a>	
	 	  		</div>
	 	  	</div>
			<div class="ui-block-b">
				<div class="ui-body ui-body-d" style="height:80px">
		 			<h1><%=user_name%>的朋友圈</h1>
	 	 		</div>
	 	 	</div>
			</div>		
		</div>	
		<div class="personPage_PersonPanel"> 
		<table>
		    	<tr height="240">
					<td align="center"height="250">
						<%
							out.println("<img src=\"head_sculpture/weixin_picture_2.jpg\"/>");					
						%>
					</td>
					<td>
						<div style="margin-left:50px"> 
						<%
							out.println("<b>"+ "<font color=\"#330000\">"+"相思本是无凭语，莫向花牋费泪行。"+ "</font>" +"</b>");					
						%>
						</div>
					</td>
				</tr>
			</table>
		</div>
		<div class="personPage_contentPanel">
			<%	
			
				try{					
					int page1 ;
					if(request.getParameter("page") == null){
						page1 = 1;
					}
					else{
						page1 = Integer.parseInt(request.getParameter("page"));
					}

					String user_sql= "SELECT Anounce_Content,Anounce_Time FROM Anouncement WHERE Anounce_User=? order by Anounce_ID desc limit " + (page1-1)*20 + "," + 20 ;
					PreparedStatement user_ps = conn.prepareStatement(user_sql);
					user_ps.setString(1,user_account);					
					ResultSet user_rs=user_ps.executeQuery();
					while(user_rs.next()){									    
						String the_content = user_rs.getString("Anounce_Content");
						String the_time = user_rs.getString("Anounce_Time");
						out.println("<font size='6'>"+the_time+"</font>" + "<BR>"+ "<BR>" + the_content + "<BR>" +"<HR>");
					}

					user_sql = "select count(Anounce_ID) numberOfMessage from Anouncement";//从数据库获得页数
					Statement stat = conn.createStatement();
					ResultSet resultOfMessageNumber = stat.executeQuery(user_sql);
					resultOfMessageNumber.next();		
					
					int pages = Integer.parseInt(resultOfMessageNumber.getString("numberOfMessage"))/20+1;//每20条则分页
					for(int i = 0; i<pages; i++){
						out.println("<a href='Friend_personPage.jsp?page="+(i+1)+"'>"+(i+1)+"</a>");
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
	</body>
</html>

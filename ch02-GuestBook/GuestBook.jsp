<%@ page language="java" import="java.util.Date" import="java.text.SimpleDateFormat" import="java.sql.*" pageEncoding="UTF-8"%>
<html>
	<head>
		<style>
		
		div .publishPanel{
				position:absolute;
				top:0;
				left:50%;
				margin-left:-400px;
				margin-top:60px;
				padding: 10px 5px 0px 10px;
				width: 800px;				
				background-color: #ffffff;
				border: 2px #666666 dashed;
				filter:alpha(opacity=80);
				opacity:0.8;
				}
		div .publish{
				width:120px;
				height:30px;
				margin-left:670px;
				}
		div .contentPanel{
				position:absolute;
				top:0;
				left:50%;
				margin-left:-400px;
				margin-top:330px;
				padding: 10px 5px 0px 10px;
				width: 800px;
				}
				
		</style>
	</head>
	<body background="back_picture.jpg" style="width:100%;height:100%;no-repeat ">

	<%
  		response.setHeader("Pragma","No-cache"); //表示在客户端缓存中不保存页面的副本（不缓存）
  	%>

    <div class="background">
	    <div class="publishPanel">
			<form name="Guestbook" method="post">
				发帖人：<input type="text" name="name" size="50"><br><br>
				<textarea name="content" rows="6" cols="95"></textarea><br><br>
				<input type="button"  value="发布" class="publish" onclick="validate();" >		
			</form>		
		</div>

		<%
		    //获取数据库连接
			Class.forName("com.mysql.jdbc.Driver");
			Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/S2013150090?useUnicode=true&characterEncoding=utf-8","S2013150090","150090");			

			//获取数据
			request.setCharacterEncoding("UTF-8");
			String name = request.getParameter("name");	
			String input_content = request.getParameter("content");
			String content=null;
			
			if(name==null || input_content==null)   //没有存在name,input_content参数
			{  }
			else if(name.equals("") ||input_content.equals("")) //空字符（没有输入内容）
			{
				out.print("<script>alert('输入信息为空，请输入完整信息')</script>"); //在Java中利用标签达到JS的效果
			}
			else{
					//String不可以用append()函数切String不可更改，StringBuffer可以用append()函数切StringBuffer可更改，
					StringBuffer content_copy=new StringBuffer(input_content.length());
					StringBuffer name_copy = new StringBuffer(name.length());
					char ch;			
					for( int i=0;i<input_content.length();i++)
					{
					   ch=input_content.charAt(i);
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

					for( int i=0;i<name.length();i++)
					{
					   ch=name.charAt(i);
					   if(ch==' ')
					   {
							name_copy.append("&nbsp;");
							continue;
					   }
					   if(ch=='\n')
					   {
							name_copy.append("<br>");
							continue;
					   }
					   if(ch=='<')
					   {
							name_copy.append("&lt;");
							continue;
					   }
					   if(ch=='>')
					   {
							name_copy.append("&gt;");
							continue;
					   }
					   if(ch=='&')
					   {
							name_copy.append("&amp;");
							continue;
					   }
					   else
					   {
							name_copy.append(ch);
							continue;
					   }
					}
					name=name_copy.toString();

					//获取当前时间
					Date nowTime = new Date();
					SimpleDateFormat matter = new SimpleDateFormat("yyyy-MM-dd HH:mm");
					String time = matter.format(nowTime);
					
					try{
						//数据添加
						String sql = "INSERT INTO GuestBook(NAME,CONTENT,TIME) VALUES(?,?,?)";
						PreparedStatement ps = conn.prepareStatement(sql);
						ps.setString(1,name);
						ps.setString(2,content);
						ps.setString(3,time);
						ps.executeUpdate();
						//关闭数据库连接
						ps.close();
					}
					catch(Exception e)
					{
						out.print(e);
					}						
				}
			%>

			<div class="contentPanel">
			<%	
				try{
					

					int page1 ;
					if(request.getParameter("page") == null){  //得到URL值上面的page值
						page1 = 1;
					}
					else{
						page1 = Integer.parseInt(request.getParameter("page"));
					}
					String sql = "SELECT * FROM GuestBook order by ID desc limit " + (page1-1)*10 + "," + 10;
					//每个页面显示十条信息：(page1-1)*10 + "," + 10 规律

					Statement stat = conn.createStatement();
					ResultSet rs = stat.executeQuery(sql);
					while(rs.next()){
						String the_name = rs.getString("NAME");				    
						String the_content = rs.getString("CONTENT");
						String the_time = rs.getString("TIME");
						out.println("<b>"+the_name+"</b>" + "<BR>" + the_content + "<BR>" + "<font color=\"#00ccff\">"+the_time+"</font>" + "<BR>" + "<HR>");    //标签里面的特殊字符转义

					}

					//每次获得一次count，然后返回，next()由null指向下一个存当前count的地址		
					sql = "select count(ID) numberOfMessage from GuestBook"; //从数据库获得数量
					stat = conn.createStatement();
					ResultSet resultOfMessageNumber = stat.executeQuery(sql);
					resultOfMessageNumber.next();	

					
					int pages = Integer.parseInt(resultOfMessageNumber.getString("numberOfMessage"))/10+1;    //计算当前一共会显示多少页
					for(int i = 0; i<pages; i++){
						out.println("<a href='GuestBook.jsp?page="+(i+1)+"'>"+(i+1)+"</a>");
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
			function validate(){
			name=document.Guestbook.name.value;
			content=document.Guestbook.content.value;
			if(name==""){
			window.alert("请输入发帖人信息");
			document.name.focus();
			return;
			}
			if(content==""){
			window.alert("你还没有填写留言板上的内容");
			document.content.focus();
			return;
			}

			//判断全是空内容

			Guestbook.submit();
			}
	</script>
	</body>
</html>

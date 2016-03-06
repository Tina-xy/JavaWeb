<%@ page language="java" import="java.util.*" import="java.sql.*" contentType="text/html;charset=UTF-8"%>
<%
		//获取数据库连接 
	Class.forName("com.mysql.jdbc.Driver");
	Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/S2013150090?useUnicode=true&characterEncoding=utf-8","S2013150090","150090");
	String user_account = (String)session.getAttribute("name");

	//获取URL传值
	request.setCharacterEncoding("UTF-8");
	String comment_type = request.getParameter("value1"); //类型（评论/回复）
	String id_string1 = request.getParameter("value2");
	String id_string2 = request.getParameter("value3");	
	String content = request.getParameter("value4");
	String comment_content=null;

	if(content==null || content.equals(""))
	{  }
	else
	{
		StringBuffer content_copy=new StringBuffer(content.length());
		char ch;			
		for( int i=0;i<content.length();i++)
		{
		   ch=content.charAt(i);
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
		comment_content=content_copy.toString();
	}

    try{
		//评论
		if(comment_type.equals("com")){

			int anounce_id=Integer.parseInt(id_string1);	//朋友圈的id
			int commenter_id=Integer.parseInt(id_string2);	//评论人的id
			String commenter_account=null;//评论人账户
			String commented_account=null;//被评论人账户
			int commented_id=0;//被评论id

			//获得评论人的账号	
			String commenter_sql = "SELECT User_Account FROM User WHERE User_ID=?";
			PreparedStatement commenter_ps = conn.prepareStatement(commenter_sql);
			commenter_ps.setInt(1,commenter_id);					
			ResultSet commenter_rs=commenter_ps.executeQuery();
			if(commenter_rs.next())
			{
				commenter_account = commenter_rs.getString("User_Account");
			}

			//获得被评论人的账户
			String commented1_sql = "SELECT Anounce_User FROM Anouncement WHERE Anounce_ID=?";
			PreparedStatement commented1_ps = conn.prepareStatement(commented1_sql);
			commented1_ps.setInt(1,anounce_id);					
			ResultSet commented1_rs=commented1_ps.executeQuery();
			if(commented1_rs.next())
			{
				commented_account = commented1_rs.getString("Anounce_User");
			}

			//获得评论人的id	
			String commented2_sql = "SELECT User_ID FROM User WHERE User_Account=?";
			PreparedStatement commented2_ps = conn.prepareStatement(commented2_sql);
			commented2_ps.setString(1,commented_account);					
			ResultSet commented2_rs=commented2_ps.executeQuery();
			if(commented2_rs.next())
			{
				commented_id = commented2_rs.getInt("User_ID");
			}

			//将评论写进数据库
			String comment_sql = "INSERT INTO Comment(Anounce_ID,Replayed_ID,User_ID,User_Account,Com_ID,Com_Account,Comment_Content) VALUES(?,?,?,?,?,?,?)";
			PreparedStatement comment_ps = conn.prepareStatement(comment_sql);
			comment_ps.setInt(1,anounce_id);
			comment_ps.setInt(2,0);
			comment_ps.setInt(3,commented_id);
			comment_ps.setString(4,commented_account);
			comment_ps.setInt(5,commenter_id);
			comment_ps.setString(6,commenter_account);
			comment_ps.setString(7,comment_content);		
			comment_ps.executeUpdate();
			//关闭数据库连接
			comment_ps.close();

			%>
                  <div  style='margin-top:5px;'>
                        <b><font color='##C0C0C0'><%=commenter_account%></font></b>评论:
                        <BR>
                        <%=comment_content%>
                        <input style="margin_left:20px;weight:20px;height:30px;" data-role="none" type="button" class="rep<%=anounce_id%>" value="回复">
                  </div><br>

			<%

		}
		//回复
		else if(comment_type.equals("rep")){

			int replayed_id=Integer.parseInt(id_string1);	//被回复的评论的id
			int replayer_id=Integer.parseInt(id_string2);	//回复人的id
			String replayer_account=null;//回复人账户
			int anounce_id=0;//朋友圈id
			String replayed_account=null;//被回复的人的账户
			int replayed_account_id=0;//被回复的人的id

			//获得回复人的账号	
			String replayer_sql = "SELECT User_Account FROM User WHERE User_ID=?";
			PreparedStatement replayer_ps = conn.prepareStatement(replayer_sql);
			replayer_ps.setInt(1,replayer_id);					
			ResultSet replayer_rs=replayer_ps.executeQuery();
			if(replayer_rs.next())
			{
				replayer_account = replayer_rs.getString("User_Account");
			}

			//获得朋友圈id	
			String anounce_sql = "SELECT Anounce_ID FROM Comment WHERE Comment_ID=?";
			PreparedStatement anounce_ps = conn.prepareStatement(anounce_sql);
			anounce_ps.setInt(1,replayed_id);					
			ResultSet anounce_rs=anounce_ps.executeQuery();
			if(anounce_rs.next())
			{
				anounce_id = anounce_rs.getInt("Anounce_ID");
			}

			//被回复的人的账户 和 id
			String replayed_sql = "SELECT Com_Account,Com_ID FROM Comment WHERE Comment_ID=?";
			PreparedStatement replayed_ps = conn.prepareStatement(replayed_sql);
			replayed_ps.setInt(1,replayed_id);					
			ResultSet replayed_rs=replayed_ps.executeQuery();
			if(replayed_rs.next())
			{
				replayed_account = replayed_rs.getString("Com_Account");
				replayed_account_id = replayed_rs.getInt("Com_ID");
			}


			//将回复存入数据库表Comment
			//out.print(replayed_account+","+replayed_account_id);
			String comment_sql = "INSERT INTO Comment(Anounce_ID,Replayed_ID,User_ID,User_Account,Com_ID,Com_Account,Comment_Content) VALUES(?,?,?,?,?,?,?)";
			PreparedStatement comment_ps = conn.prepareStatement(comment_sql);
			comment_ps.setInt(1,anounce_id);
			comment_ps.setInt(2,replayed_id);
			comment_ps.setInt(3,replayed_account_id);
			comment_ps.setString(4,replayed_account);
			comment_ps.setInt(5,replayer_id);
			comment_ps.setString(6,replayer_account);
			comment_ps.setString(7,comment_content);		
			comment_ps.executeUpdate();
			//关闭数据库连接
			comment_ps.close();
			%>
              <div  style='margin-top:5px;'>
                    <b><font color='##C0C0C0'><%=replayer_account%></font></b>回复
                    <b><font color='##C0C0C0'><%=replayed_account%></font></b>：
                    <BR>
                    <%=comment_content%>
                    <input style="margin_left:20px;weight:20px;height:30px;" data-role="none" type="button" class="rep<%=anounce_id%>" value="回复">
              </div><br>
			<%

		}
	}
	catch(Exception e) 
	{
		out.print(e);
	}
%>		



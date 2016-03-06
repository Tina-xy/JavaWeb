<%@ page language="java" import="com.jspsmart.upload.*" pageEncoding="UTF-8"%>
<%
		SmartUpload smartUpload = new SmartUpload();
		//初始化	
		smartUpload.initialize(config, request, response); 	
		try {
			//上传文件
			smartUpload.upload(); 
			//得到上传的文件对象
			File smartFile = smartUpload.getFiles().getFile(0);
			//保存文件
			smartFile.saveAs("/Friend_Index/Upload/" + smartFile.getFileName(),
					smartUpload.SAVE_VIRTUAL);// 保存文件

			//如无异常
			String name=smartFile.getFileName();
		
			out.println("{ \"success\":true, \"filename\":\""+ name +"\"}");

		} catch (SmartUploadException e) {
			e.printStackTrace();
		}

%>
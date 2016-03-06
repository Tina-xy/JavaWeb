package  javamedo;

import javax.swing.*;
import javax.swing.event.*;
import javax.swing.undo.*;

import java.awt.BorderLayout;
import java.awt.Font;
import java.awt.event.*;
import java.awt.*;
import java.io.*;
import java.util.Date;
import java.text.SimpleDateFormat;

public class Notepad
{

	private static void createAndShowGUI()
	{
		new FirstWindow("Tina田");//FirstWindow的构造方法
	}

	public static void main(String[] args)
	{
		//为事件调度线程安排一个任务
		//创建并显示这个程序的图形用户界面
		javax.swing.SwingUtilities.invokeLater(new Runnable()
		{
			public void run()
			{
				createAndShowGUI();
			}
		});
	}
}     //?
class FirstWindow extends JFrame implements ActionListener, DocumentListener
{
 
	//创建菜单栏及菜单项的对象
	JMenuBar  Menubar;
	JMenu     MenuFile, MenuEdit, MenuLookup, MenuForm, MenuCheck, MenuHelp;
	JMenuItem itemOpen, itemSave, itemExit, itemNew, itemSaveAs;
	JMenuItem itemCancle, itemCut, itemCopy, itemPaste, itemDelete, itemSelectAll, itemDate;
	JMenuItem itemFind, itemFindNext, itemReplace, itemGoto;
	JCheckBoxMenuItem itemWrap;
	JMenuItem itemFont;
	JMenuItem itemStatusBar;
	JMenuItem itemHelpTopics,itemAbout;
	JTextArea textArea;
	JLabel    statusBar;
	
	//工具栏及工具栏对象
	JPanel  Toolbar;
	JButton ButtonNew,ButtonOpen,ButtonSave,ButtonCut, ButtonCopy, ButtonPaste,ButtonLargen,ButtonDiminish ;
	
	//创建右键的菜单栏及菜单项对象
	JPopupMenu  Menu;
	JMenuItem   RitemCancle,RitemCut,RitemCopy,RitemPaste,RitemDelete,RitemSelectAll;
	//创建一个撤销对象
	UndoManager undoCancle;
	
	//创建替换与查找内部的对象
	JLabel       LabelFindwhat,LabelReplacement;
	JTextField   txtFindwhat,txtReplacement;
	JPanel       PanelDirection;
	ButtonGroup  PanelDirection1;
	JRadioButton button1,button2;
	JButton buttonFindNext,buttonReplace,buttonReplaceAll,button_quxiao;
	JCheckBox    ckbox;
	JFrame       check_or_swap;
	
	//字体
	String fontname1;
	int fontsize1,fontstyle1;
	Font f;

	//FirstWindow的构造方法
	FirstWindow(String s)
	{
		setTitle(s);
		setSize(500,400);
		setLocation(250, 250);
		setVisible(true);
		setResizable(true);

		//创建状态栏
		statusBar = new JLabel();
		//创建菜单栏
		Menubar = new JMenuBar();
		//创建菜单
		MenuFile = new JMenu("文件(F)"); //文件菜单
		MenuEdit = new JMenu("编辑(E)"); //编辑菜单
		MenuLookup = new JMenu("搜索(S)");//搜索菜单
		MenuForm = new JMenu("格式(O)");//格式菜单
		MenuCheck = new JMenu("查看(V)");//查看菜单
		MenuHelp = new JMenu("帮助(H)"); //帮助菜单

		//创建菜单项
		itemOpen = new JMenuItem("打开(O)");
		itemSave = new JMenuItem("保存(S)");
		itemNew = new JMenuItem("新建(N)");
		itemSaveAs = new JMenuItem("另存为(A)...");
		itemExit = new JMenuItem("退出(X)");
		itemCancle = new JMenuItem("撤销(U)");
		itemCut = new JMenuItem("剪切(T)");
		itemCopy = new JMenuItem("复制(C)");
		itemPaste = new JMenuItem("粘帖(P)");
		itemDelete = new JMenuItem("删除(L)");
		itemSelectAll = new JMenuItem("全选(A)");
		itemDate = new JMenuItem("时间/日期(D)");
		itemFind = new JMenuItem("查找(F)");
		itemFindNext = new JMenuItem("查找下一个(N)");
		itemReplace = new JMenuItem("替换(R)...");
		itemGoto = new JMenuItem("转到(G)...");
		itemWrap = new JCheckBoxMenuItem("自动换行");
		itemFont = new JMenuItem("字体(F)...");
		itemStatusBar = new JMenuItem("状态栏(S)");
		itemHelpTopics = new JMenuItem("帮助主题(H)");
		itemAbout = new JMenuItem("关于记事本(A)");
		//禁用保存菜单项
		itemSave.setEnabled(false);
	
		//设置快捷键
		itemOpen.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_O, InputEvent.CTRL_MASK));
		itemSave.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_S, InputEvent.CTRL_MASK));
		itemNew.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_N, InputEvent.CTRL_MASK));
		itemExit.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_X, InputEvent.CTRL_MASK));
		itemCancle.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_Z, InputEvent.CTRL_MASK));
		itemCut.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_X, InputEvent.CTRL_MASK));
		itemCopy.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_C, InputEvent.CTRL_MASK));
		itemPaste.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_V, InputEvent.CTRL_MASK));
		itemDelete.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_DELETE,0));               //0字符用于填充
		itemFind.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_F, InputEvent.CTRL_MASK));
		itemFindNext.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_F3,0));   
		itemReplace.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_H, InputEvent.CTRL_MASK));
		itemGoto.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_G, InputEvent.CTRL_MASK));
		itemSelectAll.setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_A, InputEvent.CTRL_MASK));
		itemDate .setAccelerator(KeyStroke.getKeyStroke(KeyEvent.VK_F5,0));    
		//设置快捷键下划线
		MenuFile.setMnemonic(KeyEvent.VK_F);
		MenuEdit.setMnemonic(KeyEvent.VK_E);
		MenuLookup.setMnemonic(KeyEvent.VK_S);
		MenuForm.setMnemonic(KeyEvent.VK_O);
		MenuCheck.setMnemonic(KeyEvent.VK_V);
		MenuHelp.setMnemonic(KeyEvent.VK_H);
		itemSaveAs.setMnemonic(KeyEvent.VK_A);
		itemStatusBar.setMnemonic(KeyEvent.VK_S);

		//为菜单项增加事件响应
		//使用该类创建的对象可使用组件的 addActionListener 方法向该组件注册。在发生操作事件时，调用该对象的 actionPerformed 方法。 
		itemOpen.addActionListener(this);
		itemSave.addActionListener(this);
		itemExit.addActionListener(this);
		itemNew.addActionListener(this);
		itemSaveAs.addActionListener(this);
		itemCancle.addActionListener(this);
		itemCut.addActionListener(this);
		itemCopy.addActionListener(this);
		itemPaste.addActionListener(this);
		itemDelete.addActionListener(this);
		itemSelectAll.addActionListener(this);
		itemDate.addActionListener(this);
		itemFind.addActionListener(this);
		itemFindNext.addActionListener(this);
		itemReplace.addActionListener(this);
		itemGoto.addActionListener(this);
		itemWrap.addActionListener(this);
		itemFont.addActionListener(this);
		itemStatusBar.addActionListener(this);
		itemAbout.addActionListener(this);
		itemHelpTopics.addActionListener(this);
		itemStatusBar.addActionListener(this);
    	
		
		//为文件菜单增加菜单项
		MenuFile.add(itemNew);
		MenuFile.add(itemOpen);
		MenuFile.add(itemSave);
		MenuFile.add(itemSaveAs);
		//添加分割线
		MenuFile.addSeparator();
		MenuFile.add(itemExit);
		//为编辑菜单增加菜单项
		MenuEdit.add(itemCancle);
		MenuEdit.addSeparator();   
		MenuEdit.add(itemCut);
		MenuEdit.add(itemCopy);
		MenuEdit.add(itemPaste);
		MenuEdit.add(itemDelete);
		MenuEdit.addSeparator();
		MenuEdit.add(itemSelectAll);
		MenuEdit.add(itemDate);
		//为搜索菜单栏添加菜单项
		MenuLookup.add(itemFind);
		MenuLookup.add(itemFindNext);
		MenuLookup.add(itemReplace);
		MenuLookup.add(itemGoto);
		//为格式菜单栏添加菜单项
		MenuForm.add(itemFont);
		MenuForm.add(itemWrap);
		//为查看菜单栏添加菜单项
		MenuCheck.add(itemStatusBar);
		//为帮助菜单增加菜单项
		MenuHelp.add(itemAbout);
		MenuHelp.add(itemHelpTopics);

		//将菜单增加到菜单栏中
		Menubar.add(MenuFile);
		Menubar.add(MenuEdit);
		Menubar.add(MenuLookup);
		Menubar.add(MenuForm);
		Menubar.add(MenuCheck);
		Menubar.add(MenuHelp);

		//为窗口设置菜单栏
		this.setJMenuBar(Menubar);
		
		//创建文本区域
		textArea = new JTextArea();
		//添加文本区域到窗口中，并增加滚动条（BorderLayout布局） 
		this.add(new JScrollPane(textArea), BorderLayout.CENTER);
		
		//添加状态条，以JLabel作为状态条(BorderLayout布局)
		this.add(statusBar, BorderLayout.SOUTH);

		(textArea.getDocument()).addDocumentListener(this);
		
	    //设置字体
		fontname1="宋体";
		fontstyle1=Font.BOLD;
	   	fontsize1=26;
	    f = new Font(fontname1,fontstyle1,fontsize1);
		textArea.setFont(f);
		validate();
		setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
		
		//"右键"功能相关
	    //创建右键菜单栏项目
		Menu=new JPopupMenu();
		
		RitemCancle = new JMenuItem("撤销(U)");
		RitemCut = new JMenuItem("剪切(T)");
		RitemCopy = new JMenuItem("复制(C)");
		RitemPaste = new JMenuItem("粘帖(P)");
		RitemDelete = new JMenuItem("删除(D)");
		RitemSelectAll = new JMenuItem("全选(A)");
		//创建右键菜单栏
		Menu.add(RitemCancle);
		Menu.addSeparator();   
		Menu.add(RitemCut);
		Menu.add(RitemCopy);
		Menu.add(RitemPaste);
		Menu.add(RitemDelete);
		Menu.addSeparator();
		Menu.add(RitemSelectAll);
	    //为右键菜单栏增加事件响应
		textArea.addMouseListener(new MouseAdapter(){
		                            public void mousePressed(MouseEvent e){
									   if(e.getModifiers()==InputEvent.BUTTON3_MASK)
									       Menu.show(textArea,e.getX(),e.getY());
								    }
								});//???????????
		RitemCancle.addActionListener(this);
		RitemCut.addActionListener(this);
		RitemCopy.addActionListener(this);
		RitemPaste.addActionListener(this);
		RitemDelete.addActionListener(this);
		RitemSelectAll.addActionListener(this);
		
	     //"撤销"相关
		  
		 //创建一个撤销对象
		undoCancle=new UndoManager();
		//为撤销添加事件响应
		textArea.getDocument().addUndoableEditListener(new UndoableEditListener() {
			   public void undoableEditHappened(UndoableEditEvent e) {
				   undoCancle.addEdit(e.getEdit());
			       }
			  		  });   //????

       //"工具栏"相关
        //创建工具栏
        Toolbar=new JPanel();
        Toolbar.setLayout(new FlowLayout(FlowLayout.LEFT));//构造一个新的 FlowLayout，它具有指定的对齐方式
		
	    //创建工具栏菜单项
		ButtonNew=new JButton(new ImageIcon(Notepad.class.getResource("tab_new.png")));
		ButtonOpen=new JButton(new ImageIcon(Notepad.class.getResource("folder.png")));
		ButtonSave=new JButton(new ImageIcon(Notepad.class.getResource("filesave.png")));
		ButtonCut=new JButton(new ImageIcon(Notepad.class.getResource("editcut.png")));
		ButtonCopy=new JButton(new ImageIcon(Notepad.class.getResource("editcopy.png")));
		ButtonPaste=new JButton(new ImageIcon(Notepad.class.getResource("editpaste.png")));
		ButtonLargen=new JButton(new ImageIcon(Notepad.class.getResource("zoomin.png")));
		ButtonDiminish =new JButton(new ImageIcon(Notepad.class.getResource("zoomout.png")));
		
		//设置工具栏按钮大小
		ButtonNew.setPreferredSize(new Dimension(25,25));
		ButtonOpen.setPreferredSize(new Dimension(25,25));
		ButtonSave.setPreferredSize(new Dimension(25,25));
		ButtonCut.setPreferredSize(new Dimension(25,25));
		ButtonCopy.setPreferredSize(new Dimension(25,25));
		ButtonPaste.setPreferredSize(new Dimension(25,25));
		ButtonLargen.setPreferredSize(new Dimension(25,25));
		ButtonDiminish .setPreferredSize(new Dimension(25,25));
		//工具栏按钮添加响应
		ButtonNew.addActionListener(this);
		ButtonOpen.addActionListener(this);
		ButtonSave.addActionListener(this);
		ButtonCut.addActionListener(this);
		ButtonCopy.addActionListener(this);
		ButtonPaste.addActionListener(this);
		ButtonLargen.addActionListener(this);
		ButtonDiminish .addActionListener(this);
		//为按钮设置提示文本
		ButtonNew.setToolTipText("新建");
		ButtonOpen.setToolTipText("打开");
		ButtonSave.setToolTipText("保存");
		ButtonCut.setToolTipText("剪切");
		ButtonCopy.setToolTipText("复制");
		ButtonPaste.setToolTipText("粘贴");
		ButtonLargen.setToolTipText("放大");
		ButtonDiminish .setToolTipText("缩小");
		//将按钮添加进工具栏
		Toolbar.add(ButtonNew);
		Toolbar.add(ButtonOpen);
		Toolbar.add(ButtonSave);
        Toolbar.add(ButtonCut);
		Toolbar.add(ButtonCopy);
		Toolbar.add(ButtonPaste);
		Toolbar.add(ButtonLargen);		
		Toolbar.add(ButtonDiminish );
		this.add(Toolbar,BorderLayout.NORTH);	
			  	
	}	

	public void actionPerformed(ActionEvent e)
	{
		Object src = e.getSource();//获取激发事件的对象

		//如果是菜单<新建>被按下
		if (src == itemNew || src==ButtonNew)
		{
			int n = JOptionPane.showConfirmDialog(this,
									"是否将更改保存到 无标题？",
									"Tina",
									JOptionPane.YES_NO_CANCEL_OPTION);
			if (n == JOptionPane.YES_OPTION)
			{
				String fileName = new String();
				JFileChooser c = new JFileChooser();
				//显示保存对话框
				int rVal = c.showSaveDialog(this);
				if (rVal == JFileChooser.APPROVE_OPTION)
				{
					//获取文件名
					fileName = c.getSelectedFile().getAbsolutePath();

					try
					{

						FileWriter fw = new FileWriter(fileName);
						fw.write(textArea.getText());
						fw.close();

						setTitle(fileName);

					}
					catch (IOException ep)
					{
						JOptionPane.showConfirmDialog(this, ep.toString(), "保存文件出错", JOptionPane.YES_NO_OPTION);
					}
				}
				textArea.selectAll();
				textArea.replaceRange("",textArea.getSelectionStart (),textArea.getSelectionEnd());
			}
			if (n == JOptionPane.NO_OPTION)
			{
				textArea.selectAll();
				textArea.replaceRange("",textArea.getSelectionStart (),textArea.getSelectionEnd());
			}
			if (n == JOptionPane.CANCEL_OPTION) ;
		}
		
		//如果是菜单<打开>被按下
		if (src == itemOpen || src == ButtonOpen)
		{
			String fileName;
			JFileChooser c = new JFileChooser();
			int rVal = c.showOpenDialog(this);
			if (rVal == JFileChooser.APPROVE_OPTION)
			{
				fileName = c.getSelectedFile().getAbsolutePath();
				try
				{
					File file = new File(fileName);

					FileInputStream fis = new FileInputStream(file);

					byte b[] = new byte[(int)file.length()];
					fis.read(b);
					fis.close();

					textArea.setText(new String(b));

					itemSave.setEnabled(false);
					statusBar.setText("文本字符数：" + textArea.getText().length());
					setTitle(fileName);
				}
				catch (IOException ep)
				{
					JOptionPane.showConfirmDialog(this, ep.toString(), "打开文件出错", JOptionPane.YES_NO_OPTION);
				}

			}
		}
		
		//如果是菜单<保存>被按下
		else if (src == itemSave || src == ButtonSave)
		{
			String fileName = new String();
			JFileChooser c = new JFileChooser();
			//显示保存对话框
			int rVal = c.showSaveDialog(this);  
			if (rVal == JFileChooser.APPROVE_OPTION)
			{
				//获取文件名
				fileName = c.getSelectedFile().getAbsolutePath();
				try
				{

					FileWriter fw = new FileWriter(fileName);
					fw.write(textArea.getText());
					fw.close();
					setTitle(fileName);
				}
				catch (IOException ep)
				{
					JOptionPane.showConfirmDialog(this, ep.toString(), "保存文件出错", JOptionPane.YES_NO_OPTION);
				}
			}
		}
		
		//如果是菜单<另保存>被按下
		else if (src == itemSaveAs)
		{
			String fileName = new String();
			JFileChooser c = new JFileChooser();
			//显示保存对话框
			int rVal = c.showSaveDialog(this);
			if (rVal == JFileChooser.APPROVE_OPTION)
			{
				//获取文件名
				fileName = c.getSelectedFile().getAbsolutePath();
				try
				{

					FileWriter fw = new FileWriter(fileName);
					fw.write(textArea.getText());
					fw.close();
					setTitle(fileName);

				}
				catch (IOException ep)
				{
					JOptionPane.showConfirmDialog(this, ep.toString(), "保存文件出错", JOptionPane.YES_NO_OPTION);
				}
			}
		}
		
		//如果是菜单<退出>被按下
		else if (src == itemExit)
		{
			if(textArea.getText().equals(""))
			//注意如果是字符串比较不能用“==”（“==”用于比较地址）而是应该用s1.equals(s2)(此用于比较内容)
			//也不能用"textArea.getText()==null",因为Null表示的是该文件不存在，而不是内容为空
			   this.dispose();
			else
			{
			int n = JOptionPane.showConfirmDialog(this,
									"是否将更改保存到 无标题？",
									"Tina",
									JOptionPane.YES_NO_CANCEL_OPTION);
			if (n == JOptionPane.YES_OPTION)
			{
				String fileName = new String();
				JFileChooser c = new JFileChooser();
				//显示保存对话框
				int rVal = c.showSaveDialog(this);
				if (rVal == JFileChooser.APPROVE_OPTION)
				{
					//获取文件名
					fileName = c.getSelectedFile().getAbsolutePath();
					try
					{

						FileWriter fw = new FileWriter(fileName);
						fw.write(textArea.getText());
						fw.close();
						setTitle(fileName);

					}
					catch (IOException ep)
					{
						JOptionPane.showConfirmDialog(this, ep.toString(), "保存文件出错", JOptionPane.YES_NO_OPTION);
					}
				}
				this.dispose();
			}
			if (n == JOptionPane.NO_OPTION)
			{
				this.dispose();
			}
			if (n == JOptionPane.CANCEL_OPTION) ;
		    }
		}
		
		//如果是菜单<撤销>被按下                   
		else if (src == itemCancle || src == RitemCancle)
		{
			textArea.requestFocus();
			if (undoCancle.canUndo()) {
			try {
			undoCancle.undo();
			} 
			catch (CannotUndoException ex) 
			{
			System.out.println("Unable to undo: " + ex);
			ex.printStackTrace();
			}

			if (!undoCancle.canUndo()) {
				itemCancle.setEnabled(false);
				RitemCancle.setEnabled(false);
			}
			}
		}
		
		//如果是菜单<复制>被按下
		else if (src == itemCopy || src == RitemCopy || src == ButtonCopy)
			textArea.copy();
		
		//如果是菜单<剪切>被按下
		else if (src == itemCut || src == RitemCut || src == ButtonCut)
			textArea.cut();
		//如果是菜单<粘贴>被按下
		
		else if (src == itemPaste || src == RitemPaste || src == ButtonPaste)
			textArea.paste();
		
		//如果是菜单<删除>被按下
		else if (src == itemDelete || src == RitemDelete)
		{
			textArea.replaceRange("",textArea.getSelectionStart (),textArea.getSelectionEnd());
			 //将原有文本中start到end之间的内容替换为新文本(作为第一个参数[空字符串]传入)
		}
		
		//如果是菜单<全选>被按下
		else if (src == itemSelectAll || src == RitemSelectAll)
		{
			textArea.selectAll();
		}
		
		//如果是图标<放大>被按下
	    else if (src == ButtonLargen)
	    {
	    	if(fontsize1>=14 && fontsize1<=54)
	    		fontsize1+=5;
	    	f=new Font(fontname1,fontstyle1,fontsize1);
	    	textArea.setFont(f);
	    }
	    		
		//如果是图标<缩小>被按下
	    else if (src == ButtonDiminish )
	    {
	    	if(fontsize1>=14 && fontsize1<=54)
	    		fontsize1-=5;
	    	f=new Font(fontname1,fontstyle1,fontsize1);
	    	textArea.setFont(f);
	    }
	    	
        //如果是菜单<日期/时间>被按下
	    else if (src == itemDate)
		{
            String riqi;
            mySimpleDateFormat myriqi=new mySimpleDateFormat();
            riqi=myriqi.myDate();
            textArea.replaceSelection(riqi);
        }
		
		//如果是菜单<查找>被按下
        else if (src == itemFind)
		{
			Find();
		}
		
		//如果是菜单<查找下一个>被按下
		else if (src == itemFindNext)
		{
			Find();
		}
		
		//如果是菜单<替换>被按下
		else if (src == itemReplace)
        {
			
			Replace();
		}
		
		//查找与替换的内部实现
		//按钮“查找下一个”被按下
		else if(src ==  buttonFindNext)
		{
			String textAll = textArea.getText();
			String findWord = txtFindwhat.getText();
			
			if (ckbox.isSelected()) {
				textAll = textAll.toLowerCase();
				findWord = findWord.toLowerCase();
			}
			
			int startPos = textArea.getCaretPosition();
			int findPos = -1;

			if (button1.isSelected()) {
				findPos = textAll.lastIndexOf(findWord,startPos - 1);
			} 
			else if (button2.isSelected()) {
				findPos = textAll.indexOf(findWord,startPos + 1);
			}
			if (findPos == -1){
				JFrame jfmessage=new JFrame();
				JOptionPane.showMessageDialog(jfmessage, "查找不到输入内容", "记事本",JOptionPane.WARNING_MESSAGE);
				jfmessage.dispose();
			}
			else {
				textArea.setSelectionStart(findPos);
				textArea.setSelectionEnd(findPos + findWord.length());
			}
		}
		
		//按钮“替换”被按下
		else if(src ==  buttonReplace)
		{
			int start=0;
			JFrame  jfmessage=new JFrame();
	        String czvalue=textArea.getText();
			String temp=txtFindwhat.getText();
			int s=czvalue.indexOf(temp,start); 
			if(czvalue.indexOf(temp,start)!=-1)  
			{
				textArea.setSelectionStart(s);
				textArea.setSelectionEnd(s+temp.length());
				textArea.setSelectedTextColor(Color.GREEN);
				start=s+1;
				textArea.replaceSelection(txtReplacement.getText());//用给定字符串所表示的新内容替换当前选定的内容。如果没有选择的内容，则该操作插入给定的文本。如果没有替换文本，则该操作移除当前选择的内容。 
			}
			else
			{
				JOptionPane.showMessageDialog(jfmessage, "查找不到输入内容", "记事本",JOptionPane.WARNING_MESSAGE);
				jfmessage.dispose();
			}
		}
		
		//按钮“全部替换”被按下
		else if(src == buttonReplaceAll)
		{
			int start=0;
			JFrame jfmessage=new JFrame();
	        String czvalue=textArea.getText();
			String temp=txtFindwhat.getText();
			int count = 0;
			int s;
			while ((s = czvalue.indexOf(temp,start))!=-1) //用while循环实现全部替换
			{
				textArea.setSelectionStart(s);
				textArea.setSelectionEnd(s + temp.length());
				textArea.setSelectedTextColor(Color.GREEN);
				textArea.replaceSelection(txtReplacement.getText());
				//replaceSelection() 用给定字符串所表示的新内容替换当前选定的内容。如果没有选择的内容，则该操作插入给定的文本。如果没有替换文本，则该操作移除当前选择的内容。 
				start = s + temp.length();
				count++;
			}
			
			jfmessage.dispose();
		}
		
		//按钮“取消”被按下
		else if(src == button_quxiao)
		{
			check_or_swap.dispose();	
		}
	
		//如果是菜单<转到>被按下
		else if(src==itemGoto)
		{ }
		
       //如果是菜单<字体>被按下
		else if(src==itemFont)
		{
		    new fontdialog(this,200,300);
		}	
		
	    //如果是菜单<自动换行>被按下
		else if (src == itemWrap)
		{
			textArea.setLineWrap(!textArea.getLineWrap());
		}
		
        //如果是菜单<状态栏>被按下 
		else if (src == itemStatusBar)
		{
			statusBar.setText("Lines: "+textArea.getLineCount()+"单行"); 

		}
		
		//如果是菜单<帮助主题>被按下
        else if(src==itemHelpTopics)
		{
        	JOptionPane.showMessageDialog(this,
        			 "作者邮箱：1093000545qq.com\nQQ号：1093000545\n"); 
                    
		}
		
		//如果是菜单<关于记事本>被按下
		else if (src == itemAbout)
		{
			JOptionPane.showMessageDialog(this,"本软件由Tina(田)制作！\n如需要源代码，随时欢迎联系作者！\n"
			+ "联系方式见帮助主题\n本程序基本上实现了Microsoft记事本的功能\n" 
            +"并新增了“工具栏”“字数统计”等功能"
            + "希望您喜欢！\n"
			+ "如有任何疑问及改善意见，随时欢迎指出，\n我们将尽最大的努力满足您的需求！\n"
			+ "最后谢谢您的使用！\n版权所有，请勿侵权！","关于记事本...",
			JOptionPane.INFORMATION_MESSAGE);
		}
	}

	//文本区更新
	public void changedUpdate(DocumentEvent e)
	{
		statusBar.setText("文本字符数：" + textArea.getText().length());
		//如文本区进行了更改，则运行保存
		itemSave.setEnabled(true);
	}
	
	//文本区删除字符
	public void removeUpdate(DocumentEvent e)
	{
		changedUpdate(e);
	}
	
	//文本区增加字符
	public void insertUpdate(DocumentEvent e)
	{
		changedUpdate(e);
	}
	
	public void Find()
    {		
		    check_or_swap=new JFrame("查找");
		    LabelFindwhat=new JLabel("查找内容(N):");
		    txtFindwhat=new JTextField(15);
			buttonFindNext=new JButton("查找下一个(F)");
			ckbox=new JCheckBox("区分大小写(C)");
			button_quxiao=new JButton("取消");
			PanelDirection=new JPanel();
			PanelDirection.setBorder(BorderFactory.createTitledBorder("方向"));
			PanelDirection.setBounds(10,20,8,12);
			button1 =new JRadioButton("向上");
			button2 =new JRadioButton("向下");
			ButtonGroup PanelDirection1=new ButtonGroup();//利用ButtonGroup()创建一个对象把若干个单选按钮归组
			//将button1,button2加入一个组（ButtonGroup）里面
			PanelDirection1.add(button1);
			PanelDirection1.add(button2);
			//将button1,button2加入到组件里面
			PanelDirection.add(button1);
			PanelDirection.add(button2);
			
			//查找对话框的布局
			Box baseBox,boxV1,boxV2,boxV3;
			boxV1=Box.createVerticalBox();
			boxV1.add(LabelFindwhat);
			boxV1.add(Box.createVerticalStrut(30));
			boxV1.add(ckbox);
			boxV2=Box.createVerticalBox();
			boxV2.add(txtFindwhat);
			boxV2.add(Box.createVerticalStrut(6));
			boxV2.add(PanelDirection);
			boxV3=Box.createVerticalBox();
			boxV3.add(buttonFindNext);
			boxV3.add(Box.createVerticalStrut(30));
			boxV3.add(button_quxiao);
			baseBox=Box.createHorizontalBox();
			baseBox.add(boxV1);
			baseBox.add(Box.createHorizontalStrut(15));
			baseBox.add(boxV2);
			baseBox.add(Box.createHorizontalStrut(15));
			baseBox.add(boxV3);
			check_or_swap.setLayout(new FlowLayout());
			check_or_swap.add(baseBox);
			
			check_or_swap.setBounds(120,125,450,130);
			check_or_swap.setVisible(true);
			check_or_swap.setResizable(false);
			check_or_swap.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
			
			//为查找对话框里面的按钮添加事件
			buttonFindNext.addActionListener(this);
		    button_quxiao.addActionListener(this);
			}
		
	public void Replace()
    {
		    JFrame check_or_swap=new JFrame("替换");
            LabelFindwhat=new JLabel("查找内容(N):");
			LabelReplacement=new JLabel("替换为(P):");
			ckbox=new JCheckBox("区分大小写(C)");
			txtFindwhat=new JTextField(20);
			txtReplacement=new JTextField(20);
			buttonFindNext=new JButton("查找下一个(F)");
			buttonReplace=new JButton("替换(R)");
			buttonReplaceAll=new JButton("全部替换(A)");
			button_quxiao=new JButton("取消");
			
			//替换对话框的布局
			Box baseBox,boxV1,boxV2,boxV3,boxV4;
			boxV1=Box.createHorizontalBox();
			boxV1.add(LabelFindwhat);
			boxV1.add(Box.createHorizontalStrut(10));
			boxV1.add(txtFindwhat);
			boxV2=Box.createHorizontalBox();
			boxV2.add(LabelReplacement);
			boxV2.add(Box.createHorizontalStrut(10));
			boxV2.add(txtReplacement);
			boxV3=Box.createHorizontalBox();
			boxV3.add(buttonFindNext);
			boxV3.add(Box.createHorizontalStrut(8));
			boxV3.add(buttonReplace);
			boxV3.add(Box.createHorizontalStrut(8));
			boxV3.add(buttonReplaceAll);
			boxV3.add(Box.createHorizontalStrut(8));
			boxV3.add(button_quxiao);
			boxV4=Box.createHorizontalBox();
			boxV4.add(ckbox);
			baseBox=Box.createVerticalBox();
			baseBox.add(boxV1);
			baseBox.add(Box.createVerticalStrut(10));
			baseBox.add(boxV2);
			baseBox.add(Box.createVerticalStrut(10));
			baseBox.add(boxV3);
			baseBox.add(Box.createVerticalStrut(10));
			baseBox.add(boxV4);
			check_or_swap.setLayout(new FlowLayout());
			check_or_swap.add(baseBox);
			
			check_or_swap.setBounds(120,125,450,200);
			check_or_swap.setVisible(true);
			check_or_swap.setResizable(false);
			check_or_swap.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
			
			//为替换对话框里面的按钮添加事件
			buttonFindNext.addActionListener(this);
		    buttonReplace.addActionListener(this);
		    buttonReplaceAll.addActionListener(this);
		    button_quxiao.addActionListener(this);
	}  
	
	//重载setTitle函数
	public void setTitle(String s)
	{
		if (s == "")
			super.setTitle("记事本");
		else
			super.setTitle(s + " - 记事本");
	}
	
	//创建一个时间、日期的内部类
	class mySimpleDateFormat   
    {
        public String  myDate()
            {
                Date nowTime=new Date();
                SimpleDateFormat matter=new SimpleDateFormat("HH:mm  yyyy/MM/dd");
                String formatTime=matter.format(nowTime);
                return	formatTime;				 
            }   
	}
	
}   //创建一个字体外部类
     class fontdialog implements ActionListener,ItemListener
		{
    	  
    	 	FirstWindow F;     //创建一个FirstWindow
		    List  fontname,fontshape,fontsize;      //list对象：显示对象列表并且允许用户选择一个或多个项的组件
			JPanel PanelName,PanelShape,PanelSize,PanelModel;      //JPanel称做面板，面板上添加组件，而面板可以放在Jframe容器或Applet上
			JTextField txtname,txtshape,txtsize;   //JTextField 它允许编辑"单行"文本 ，是一个轻量级组件 
			JTextArea txtmodel;                    //JTextArea 是一个显示纯文本的多行区域
			JDialog dialog; 					   //创建对话框窗口的主要类
			JButton btnok,btncancle;
			public Font modelfont;                 //Font 类表示字体，可以使用它以可见方式呈现文本
			@SuppressWarnings("deprecation")
			public fontdialog(FirstWindow f,int x,int y)
		    {
				F=f;
			    GraphicsEnvironment g=GraphicsEnvironment.getLocalGraphicsEnvironment();
				 /*
				GraphicsEnvironment 类描述了 Java(tm) 应用程序在特定平台上可用的 GraphicsDevice 对象和 Font 对象的集合。
				此 GraphicsEnvironment 中的资源可以是本地资源，也可以位于远程机器上。
				getLocalGraphicsEnvironment()   返回本地 GraphicsEnvironment。
				 */
				String name[]=g.getAvailableFontFamilyNames();//getAvailableFontFamilyNames() 返回一个包含此 GraphicsEnvironment 中所有字体系列名称的数组，它针对默认语言环境进行了本地化，由 Locale.getDefault() 返回。
				String shape[]={"常规","斜体","粗体  倾斜","粗体"};
				
				//字体对话框
				dialog=new JDialog(f,"字体",true);  //JDialog(Dialog owner, String title, boolean modal) 创建一个具有指定标题、模式和指定所有者 Dialog 的对话框。
				dialog.setLayout(null);             //void setLayout(LayoutManager mgr) 设置此容器的布局管理器。  参数：mgr - 指定的布局管理器  （此处为自定义布局）
				dialog.setResizable(false);
	
            	//各个面版
				PanelName=new JPanel(); //"字体"的面版      (创建具有双缓冲和流布局的新 JPanel)
				PanelShape=new JPanel();//"字形"的面版
				PanelSize=new JPanel(); //"大小"的面版
				PanelModel=new JPanel();//"示例"的面版
				
				//三个选项列表
	     		fontname=new List();
				fontshape=new List();
				fontsize=new List();
				for(int i=0;i<name.length;i++)
				    fontname.add(name[i]);//本地得到的所有字体系列名称
				for(int i=0;i<shape.length;i++)
				    fontshape.add(shape[i]);//上面创建的shape数组
				for(int i=0;i<50;i++)
				    fontsize.add(Integer.toString(i+10));//toString方法会返回一个“以文本方式表示”此对象的字符串
			    fontname.select(175);
				fontshape.select(1);   
				fontsize.select(22);
				
				//选项列表上面的“显示栏”
				txtname=new JTextField(12); //构造一个具有指定列数的新的空 TextField
				txtshape=new JTextField(12);
				txtsize=new JTextField(20);
			
				//”示例“部分
				txtmodel=new JTextArea(); 
				txtmodel.setText("Java记事本");
				
				//对话框下方的按钮
				btnok=new JButton("确定");
				btncancle=new JButton("取消");
				
				//添加监听器
				fontname.addItemListener(this);
				fontshape.addItemListener(this);
				fontsize.addItemListener(this);
				btnok.addActionListener(this);
				btncancle.addActionListener(this);
				
				//为各组件设置边框
				PanelName.setBorder(BorderFactory.createTitledBorder("字体"));
				PanelShape.setBorder(BorderFactory.createTitledBorder("字形"));
				PanelSize.setBorder(BorderFactory.createTitledBorder("大小"));
				PanelModel.setBorder(BorderFactory.createTitledBorder("示例"));
				PanelName.setBounds(10,10,190,170);
				PanelShape.setBounds(210,10,160,170);
				PanelSize.setBounds(380,10,80,170);
				PanelModel.setBounds(150,200,300,120);
				txtname.setBounds(30,30,160,22);
				txtshape.setBounds(220,30,140,22);
				txtsize.setBounds(390,30,60,22);
				txtmodel.setBounds(175,220,250,85);
				fontname.setBounds(30,65,160,100);
				fontshape.setBounds(220,65,140,100);
				fontsize.setBounds(390,65,60,100);
				btnok.setBounds(140,340,65,30);
				btncancle.setBounds(250,340,65,30);
				
				//为对话框添加    
				dialog.add(txtname);
				dialog.add(txtshape);
				dialog.add(txtsize);
				dialog.add(fontname);
				dialog.add(fontshape);
				dialog.add(fontsize);
				dialog.add(PanelName);
				dialog.add(PanelShape);
				dialog.add(PanelSize);
				dialog.add(txtmodel);
				dialog.add(PanelModel);
				dialog.add(btnok);
				dialog.add(btncancle);
				dialog.setSize(480,440);
				dialog.setDefaultCloseOperation(JFrame.DISPOSE_ON_CLOSE);
				dialog.show();
			}
          
			public void actionPerformed(ActionEvent e)
			{ 
				Object src = e.getSource();
				if(src == btncancle){
					dialog.dispose();
				}
				else if(src == btnok){
					F.textArea.setFont(getfont());
					dialog.dispose();
				}
			}
			public void itemStateChanged(ItemEvent e)
			{
			    try{
					if(fontshape.getSelectedItem()=="粗体")
					   {
					        modelfont=new Font(fontname.getSelectedItem(),Font.BOLD,Integer.parseInt(fontsize.getSelectedItem()));
							txtmodel.setFont(modelfont);  //void setFont(Font f)设置当前字体  参数：f - 要使用的当前字体

							}
					if(fontshape.getSelectedItem()=="粗体 倾斜")
					   {
					        modelfont=new Font(fontname.getSelectedItem(),Font.BOLD+Font.ITALIC,Integer.parseInt(fontsize.getSelectedItem()));
							txtmodel.setFont(modelfont);
							}
					if(fontshape.getSelectedItem()=="倾斜")
					   {
					        modelfont=new Font(fontname.getSelectedItem(),Font.ITALIC,Integer.parseInt(fontsize.getSelectedItem()));
							txtmodel.setFont(modelfont);
							}
					if(fontshape.getSelectedItem()=="常规")
					   {
					        modelfont=new Font(fontname.getSelectedItem(),Font.PLAIN,Integer.parseInt(fontsize.getSelectedItem()));
							txtmodel.setFont(modelfont);
							}
					txtname.setText(fontname.getSelectedItem());
					txtshape.setText(fontshape.getSelectedItem());
					txtsize.setText(fontsize.getSelectedItem());
					
				}
				catch(Exception ex)
				{}
			
	    }
     	public  Font getfont()
			{
			   return modelfont; 
			}

			public void guanbi()
			{
				dialog.dispose();
			}
			
}
     
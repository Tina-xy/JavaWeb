import javax.swing.*;

import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.WindowEvent;
import java.awt.event.WindowListener;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.UnknownHostException;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

public class Frame {

	private static void createAndShowGUI() {
		new FileTransmissionFrame("Java");// FileTransmissionFrame的构造方法
	}

	public static void main(String[] args) {
		// 为事件调度线程安排一个任务
		// 创建并显示这个程序的图形用户界面
		javax.swing.SwingUtilities.invokeLater(new Runnable() {
			public void run() {
				createAndShowGUI();
			}
		});
	}
}

class FileTransmissionFrame extends JFrame implements ActionListener {
	JPanel panelDialogeFrame, panelIcon;
	JPanel panelTextAreaDialog,panelTextArea;
	JTextArea textAreaDialog;
	JTextArea textArea;
	JButton buttonCancle, buttonSent, buttonConnect, buttonFileSent,
			buttonClear, buttonCutConnect;
	JScrollPane dialogPane;
	JScrollPane textPane;
	JTextField jTextField;
	
	String myIp;// 本机IP
	String inputIp;// 输入IP (作为客户端时)
	boolean available;// 用于判断是否“发送”可行
	
	//创建内部类对象
	Server myServerSocket;
	Client myClientSocket;
	FileServer myFileServerSocket;
	FileClient myFileClientSocket;

	// TODO 主类构造函数
	FileTransmissionFrame(String s) {

		Font f = new Font("宋体", Font.BOLD, 20);
		
		// 创建文本区域textAreaDialog,显示对话内容
		textAreaDialog = new JTextArea();
		textAreaDialog.setFont(f);
		textAreaDialog.setEditable(false);
		textAreaDialog.setLineWrap(true);
		textAreaDialog.setBorder(BorderFactory.createLineBorder(Color.BLACK));

		// 创建文本区域textArea，显示输入内容
		textArea = new JTextArea();
		textArea.setFont(f);
		textArea.setBorder(BorderFactory.createLineBorder(Color.BLACK));
		textArea.setLineWrap(true);

		// 文本域面板
		dialogPane = new JScrollPane(textAreaDialog);
		textPane = new JScrollPane(textArea);
		dialogPane.setBounds(15, 25, 455, 245);
		textPane.setBounds(15, 275, 455, 145);
		
		// 创建各个按钮（包括图标按钮）
		buttonCancle = new JButton("取消");
		buttonSent = new JButton("发送");
		// 图标按钮
		buttonConnect = new JButton(new ImageIcon("icon/Connect.png"));
		buttonFileSent = new JButton(new ImageIcon("icon/FileSent.jpg"));
		buttonClear = new JButton(new ImageIcon("icon/Clear.jpg"));
		buttonCutConnect = new JButton(new ImageIcon("icon/CutConnect.png"));
		// 设置图标按钮大小
		buttonConnect.setPreferredSize(new Dimension(128, 100));
		buttonFileSent.setPreferredSize(new Dimension(128, 100));
		buttonClear.setPreferredSize(new Dimension(128, 100));
		buttonCutConnect.setPreferredSize(new Dimension(128, 100));
		// 为图标按钮设置提示文本
		buttonConnect.setToolTipText("建立连接");
		buttonFileSent.setToolTipText("发送文件");
		buttonClear.setToolTipText("清屏");
		buttonCutConnect.setToolTipText("断开连接");

		// 创建各个面板
		panelDialogeFrame = new JPanel();
		panelIcon = new JPanel();
		panelTextAreaDialog = new JPanel();
		panelTextArea = new JPanel();

		// 获得本机的IP
		myIp = null;
		inputIp = null;
		try {
			InetAddress address = InetAddress.getLocalHost();
			myIp = address.getHostAddress().toString();// 获得本机IP
		} catch (UnknownHostException e) {
			e.printStackTrace();
		}

		available = false;

		// 功能面板的布局
		Box baseBox;
		baseBox = Box.createVerticalBox();
		baseBox.add(Box.createVerticalStrut(30));
		baseBox.add(buttonConnect);
		baseBox.add(Box.createVerticalStrut(30));
		baseBox.add(buttonFileSent);
		baseBox.add(Box.createVerticalStrut(30));
		baseBox.add(buttonClear);
		baseBox.add(Box.createVerticalStrut(30));
		baseBox.add(buttonCutConnect);
		panelIcon.add(baseBox);

		// 整个窗体的布局
		panelDialogeFrame.setBorder(BorderFactory.createTitledBorder("Dialog"));
		panelDialogeFrame.setBounds(1, 1, 480, 490);
		panelIcon.setBounds(500, 1, 200, 490);
		buttonCancle.setBounds(250, 440, 100, 30);
		buttonSent.setBounds(360, 440, 100, 30);
		this.setLayout(null);
		this.add(buttonCancle);
		this.add(buttonSent);
		this.add(dialogPane);
		this.add(textPane);
		this.add(panelDialogeFrame);
		this.add(panelIcon);
		this.setDefaultCloseOperation(EXIT_ON_CLOSE);

		// 为组件添加事件响应
		buttonCancle.addActionListener(this);
		buttonSent.addActionListener(this);
		buttonFileSent.addActionListener(this);
		buttonClear.addActionListener(this);
		buttonConnect.addActionListener(this);
		buttonCutConnect.addActionListener(this);

		// 与进度条相关的
		jTextField = new JTextField();
		jTextField.setText("0");
		jTextField.setVisible(false);
		
		setVisible(true);
		setTitle(s);
		setSize(700, 520); // 700,520
		setLocation(250, 250);
		setBackground(Color.lightGray);

		// 创建一个监听接收消息的线程
		myClientSocket = null;
		myServerSocket = new Server();
		myServerSocket.start();

		// 创建一个监听接收文件的线程
		myFileClientSocket = null;
		myFileServerSocket = new FileServer(this);
		myFileServerSocket.start();

	}
	
	// TODO BUTTON CLICK(事件响应)
	public void actionPerformed(ActionEvent e) {
		
		Object src = e.getSource();// 获取激发事件的对象

		// 如果按钮“建立连接”被按下
		if (src == buttonConnect) {
			inputIp = JOptionPane.showInputDialog(null, "请输入对方IP:",
					"Connecting", JOptionPane.INFORMATION_MESSAGE);
			if (inputIp == null)
				return;
			else if (inputIp != null) {

				myClientSocket = new Client(inputIp);
				myClientSocket.start();

				myFileClientSocket = new FileClient(inputIp, this);
				myFileClientSocket.start();
				available = true;
			}
		}
		
		// 如果按钮“发送文件”被按下
		if (src == buttonFileSent) {
			if (available == true || myFileClientSocket != null) {

				myFileClientSocket.SendFile();
				myFileClientSocket.interrupt();
			} else {
				JOptionPane.showMessageDialog(this, "未连接，请先建立连接！",
						"Sending......", JOptionPane.PLAIN_MESSAGE);
			}
		}
		
		// 如果按钮“清屏”被按下
		if (src == buttonClear) {
			textAreaDialog.setText("");
		}
		
		// 如果按钮“断开连接”被按下
		if (src == buttonCutConnect) {
			int n = JOptionPane.showConfirmDialog(this, "确定“断开连接”？",
					"ConfirmDialog......", JOptionPane.YES_NO_OPTION);
			if (n == JOptionPane.YES_OPTION) {
				textAreaDialog.setText("");
				try {
					myServerSocket.close();
					myClientSocket.close();
					myFileClientSocket.close();
					myFileServerSocket.close();			
				} catch (IOException e1) {
					e1.printStackTrace();
				}
				
			} else { }
		}
		// 如果是按钮<发送>被按下
		if (src == buttonSent) {
			if (available == true || myClientSocket != null) {
				if (textArea.getText().equals("")) {
					JOptionPane.showMessageDialog(this, "内容不能为空！");
					textAreaDialog.append("");
				} else {
					myClientSocket.SendMessage();
					myClientSocket.interrupt();
					myServerSocket.ReceivedMessage();
					myServerSocket.interrupt();
				}
			} else {
				JOptionPane.showMessageDialog(this, "未连接，请先建立连接！",
						"Sending......", JOptionPane.PLAIN_MESSAGE);
			}
		}
		// 如果是按钮<取消>被按下
		if (src == buttonCancle) {
			textArea.setText("");
		}
	}

	// 重载setTitle函数
	public void setTitle(String s) {
		if (s == "")
			super.setTitle("文件传输");
		else
			super.setTitle(s + " - 文件传输");
	}

	// 内部类
	
	// TODO Server  （用来处理作为服务器时的接收消息） 
	class Server extends Thread {
		ServerSocket serverSocket;
		Socket socket;
		String receivedMessage;
		DataInputStream in = null;
		InetAddress ip;
		
		public void run() {
			if (serverSocket == null) {
				try {
					serverSocket = new ServerSocket(8112);
					try {
						if (socket == null)
							socket = serverSocket.accept();
					} catch (Exception e) {
						e.printStackTrace();
					}
				} catch (IOException e1) {
					e1.printStackTrace();
				}
			}// if
		}

		boolean isConnected1() {
			if (socket.isConnected())
				return true;
			else
				return false;
		}

		void ReceivedMessage() {
			try {
				if (isConnected1()) {
					ip = socket.getInetAddress();
					in = new DataInputStream(socket.getInputStream());
					receivedMessage = in.readUTF();
					textAreaDialog.append(ip
							+ " "
							+ new SimpleDateFormat("yyyy/MM/dd HH:mm:ss")
									.format(new Date()) + " \n"
							+ receivedMessage + "\n");
				}
			} catch (Exception e) {
				e.printStackTrace();
			}// catch
		}
		
		void close() throws IOException {
			serverSocket.close();
			socket.close();
		}
	}

	// TODO Client  （用来处理作为客户端时的发送消息）
	class Client extends Thread {
		public Socket mysocket;
		String sendMessage;
		String receivedMessage;
		String inputIp;
		DataOutputStream out = null;
		
		public Client(String ip1) {
			inputIp = ip1;
			mysocket = null; // 创建客户端Socket对象
		}

		public void run() {
			try {
				mysocket = new Socket();
				InetAddress address = InetAddress.getByName(inputIp); // InetAddress类的静态方法getByName(strings):将一个域名或IP地址传递给该方法的参数s，获得一个InetAddress对象
				InetSocketAddress socketAddress = new InetSocketAddress(
						address, 8112);
				mysocket.connect(socketAddress);// public void connect(SocketAddress endpoint)将此套接字连接到服务器
			} catch (Exception e) {
				System.out.println("服务器已断开" + e);
			}
		}

		void SendMessage() {
			sendMessage = textArea.getText();
			try {
				out = new DataOutputStream(mysocket.getOutputStream());
				out.writeUTF(sendMessage);
				textAreaDialog.append(myIp
						+ " "
						+ new SimpleDateFormat("yyyy/MM/dd HH:mm:ss")
								.format(new Date()) + "\n" + sendMessage
						+ "\n\n");
				textArea.setText("");

			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		void close() throws IOException {
			mysocket.close();
		}

	}

	// TODO FILE SERVER    （用来处理作为服务器时的接收并保存文件） 
	class FileServer extends Thread {

		FileClient fc;
		ServerSocket fileServerSocket;
		Socket fileClientSocket;
		DataInputStream dataIn = null;
		FileOutputStream fileOut = null;
		String fileName;
		InetAddress ip;

		long allLength;
		long fileLength;
		FileTransmissionFrame frame;

		FileServer(FileTransmissionFrame frame1) {
			frame = frame1;
			allLength = 0;
			fc = null;
		}

		@Override
		public void run() {
			if (fileServerSocket == null) {
				try {
					fileServerSocket = new ServerSocket(8823);
					try {
						if (fileClientSocket == null)
							fileClientSocket = fileServerSocket.accept();
					} catch (Exception e) {
						e.printStackTrace();
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
				if (fileClientSocket.isConnected()) {
					ReceivedFile();
				}
			}// if
		}// run

		void ReceivedFile() {
			try {
				// p2.start();
				if (fileClientSocket.isConnected()) {
					ip = fileClientSocket.getInetAddress();
				}
				while (true) {
					dataIn = new DataInputStream(
							fileClientSocket.getInputStream());
					fileName = dataIn.readUTF();
					fileLength = dataIn.readLong();

					DecimalFormat df = new DecimalFormat("0.000");
					textAreaDialog.append(ip
							+"  "
							+ new SimpleDateFormat("yyyy/MM/dd HH:mm:ss")
									.format(new Date()) + "\n" + "正在接收文件:"
							+ fileName + "  大小："
							+ df.format((fileLength) / (1024.0*1024.0)) + " MB\n"
							+ "\n");
					
				    //启动进度条线程
					ProgressBar1  fw1=new ProgressBar1(this,fc, fileName, "" + fileLength);
					Thread ProgressBarThread = new Thread(fw1);
					ProgressBarThread.start();
					
					fileOut = new FileOutputStream(new File("C:/FileReceived/"
							+ fileName));
					allLength = 0;// 记录已经传输(写入)的总计大小
					byte[] writeBytes = new byte[512];// 分块将收到的文件写入硬盘
					while (true) {
						int readlength = 0;// 记录每次读到的大小
						readlength = dataIn.read(writeBytes);
						if (readlength == -1)
							break;
						allLength += readlength;
						jTextField.setText(Long.toString(100 * allLength/ fileLength));
						fileOut.write(writeBytes, 0, readlength);// 将指定writeBytes数组中从偏移量0开始的length个字节写入此文件输出流。
						fileOut.flush();
					}
					try {
						DecimalFormat df1 = new DecimalFormat("0.000");
						textAreaDialog.append(ip
								+"  "
								+ new SimpleDateFormat("yyyy/MM/dd HH:mm:ss")
										.format(new Date()) + "\n" + "文件:"
								+ fileName + "  大小："
								+ df1.format((fileLength) / (1024.0*1024.0))
								+ " MB 接收成功\n" + "\n");
						fileClientSocket.close();
					} catch (Exception e) {
						e.printStackTrace();
					}
				}// while
			} catch (Exception e) {
				e.printStackTrace();
			}

		}

		void close() throws IOException {
			dataIn.close();
			fileOut.close();
			fileClientSocket.close();
			fileServerSocket.close();
		}

		long getFileLength() {
			return fileLength;
		}

		long getNowLength() {
			return allLength;
		}
	}// class

	// TODO FILE Client   （用来处理作为客户端时的读取和发送文件）
	class FileClient extends Thread {
		Socket fileClientSocket;
		DataOutputStream dataOut;
		FileInputStream fileIn;
		String inputIp;
		String fileName;
		FileTransmissionFrame frame;

		long allLength;
		long fileLength;

		public FileClient(String ip1, FileTransmissionFrame frame1) {
			inputIp = ip1;
			fileClientSocket = null; // 创建客户端文件Socket对象
			frame = frame1;
			allLength = 0;
			fileLength = 0;

		}

		public void run() {

			try {
				fileClientSocket = new Socket(inputIp, 8823);// 建立文件传输的连接连接
				if (fileClientSocket.isConnected()) {
				}
			} catch (Exception e) {
				e.printStackTrace();
			}// catch
		}// run

		void SendFile() {
			try {
			    JFileChooser readfile = new JFileChooser();
				int rVal = readfile.showOpenDialog(null); // 弹出一个 "Open File"
				// 文件选择器对话框
				if (rVal == JFileChooser.APPROVE_OPTION) {
					fileName = readfile.getSelectedFile().getName();// 返回选中的文件的文件名
					File file = readfile.getSelectedFile();
					fileIn = new FileInputStream(file);
					fileLength = readfile.getSelectedFile().length();// 返回选中的文件的长度

					dataOut = new DataOutputStream(fileClientSocket.getOutputStream());
					dataOut.writeUTF(fileName);
					dataOut.flush();
					dataOut.writeLong(fileLength);
					dataOut.flush();

					//启动进度条线程
					ProgressBar  fw=new ProgressBar(this, fileName, "" + fileLength);
					Thread ProgressBarThread = new Thread(fw);
					ProgressBarThread.start();

					DecimalFormat df = new DecimalFormat("0.000");
					textAreaDialog.append(myIp
							+ " "
							+ new SimpleDateFormat("yyyy/MM/dd HH:mm:ss")
									.format(new Date()) + "\n" + "对方正在接收文件:"
							+ fileName + "  大小："
							+ df.format((fileLength) / (1024.0*1024.0)) + " MB\n"
							+ "\n");
					byte[] sendBytes = new byte[512];// 分块将读取的文件写到输出流
					allLength = 0;// 累积文件已经读入的大小
					int readlength;
					while ((readlength = fileIn.read(sendBytes)) > 0) {
						allLength += readlength;
						dataOut.write(sendBytes, 0, readlength);
						dataOut.flush();
					}// while
				}// if
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		void close() throws IOException {
			dataOut.close();
			fileIn.close();
			fileClientSocket.close();
		}

		long getFileLength() {
			return fileLength;
		}

		long getNowLength() {

			return allLength;
		}
	}// class

	class ProgressBar1 extends ProgressBar {

		FileServer fs;

		ProgressBar1(FileServer fs1, FileClient fc1, String fileName,String fileSize) {
			super(fc1, fileName, fileSize);
			fs = fs1;
		}

		@Override
		public void run() {
			value = 0;
			while (value <= 100) {
				long tempSize = fs.getNowLength();
				try {
					Thread.sleep(1000);
				} catch (InterruptedException e) {
					e.printStackTrace();
				}
				value = (int) (((double) fs.getFileLength() / (double) FileSize) * 100.0);
				setProgress(value);
				System.out.println(value);
				System.out.println("BABAABABABABAAB");
				DecimalFormat df = new DecimalFormat("0.00");
				JfileSpeed.setText(""
						+ df.format(((fs.getFileLength() - tempSize) / 1024.0) * 2.0)
						+ "KB/s");
				System.out.println("progressBar");
				if (value == 100) {
					this.dispose();
					System.out.println("FC.Closed");
					if (value < 100) {
						JOptionPane.showMessageDialog(null, "文件传输被取消", "提示",
								JOptionPane.INFORMATION_MESSAGE);
						textAreaDialog.append(fs.ip+"\n"+"取消文件:"+fs.fileName+" 传输");
					}
					return;
				}
			}
		}

		private void closeWindow() {
			int option = JOptionPane.showConfirmDialog(null, "取消文件发送？", "取消？",
					JOptionPane.YES_NO_OPTION, JOptionPane.QUESTION_MESSAGE);
			if (option == JOptionPane.YES_OPTION) {
				try {
					fs.close();
				} catch (IOException e1) {
					e1.printStackTrace();
				}
				this.dispose();
			}
		}
	}

	class ProgressBar extends JFrame implements Runnable, WindowListener {
		JButton cancelButton;
		JLabel JfileName,JfileSize, JfileSpeed;
		JProgressBar progressBar;
		long FileSize;
		
		int value;// 进度条的值
		FileClient fc;

		ProgressBar(FileClient fc1, String fileName, String fileSize) {
			fc = fc1;
			this.setTitle("File  Send....");
			this.setSize(335, 200);
			this.setLayout(null);
			this.setLocationRelativeTo(null);//设置窗口相对于指定组件的位置
			
			// 标签
			JfileSpeed = new JLabel();
			JfileSpeed.setBounds(10, 100, 300, 20);
			JfileName = new JLabel("文件名：" + fileName);
			JfileName.setBounds(10, 10, 300, 20);
			DecimalFormat df = new DecimalFormat("0.00");
			FileSize = Long.parseLong(fileSize);
			JfileSize = new JLabel("文件大小：" + df.format(FileSize / (1024.0*1024.0))+ " MB");
			JfileSize.setBounds(10, 30, 300, 20);			
			// /进度条
			progressBar = new JProgressBar();
			progressBar.setValue(0);//将进度条的当前值设置为 n
			progressBar.setStringPainted(true);//设置 stringPainted 属性的值，该属性确定进度条是否应该呈现进度字符串。
			progressBar.setBounds(10, 70, 300 , 30);
			progressBar.setBounds(10, 70, 300, 30);
			progressBar.setBorderPainted(true);
			   // 取消按钮
			cancelButton = new JButton("取消");
			cancelButton.setBounds(130, 110, 60, 30);
			
			// 添加组件
			this.add(JfileSpeed);
			this.add(JfileSize);
			this.add(JfileName);
			this.add(cancelButton);
			this.add(progressBar);
			this.setVisible(true);
			this.addWindowListener(this);
			this.setDefaultCloseOperation(DO_NOTHING_ON_CLOSE);
			
			// 添加事件监听
			cancelButton.addActionListener(new ActionListener() {
				public void actionPerformed(ActionEvent e) {
					closeWindow();
				}
			});

		}

		void setProgress(int value) {
			if (progressBar != null) {
				progressBar.setValue(value);
			}
		}

		public void run() {
			value = 0;
			while (value <= 100) {
				try {
					Thread.sleep(500); //防止文件太小，为了看清进度条，这里有意延缓0.5秒
				} catch (InterruptedException e) {
					e.printStackTrace();
				}
				progressBar.setValue(value);
				try {
					value = Integer.parseInt(jTextField.getText());
					
					System.out.println("进度条的值");
					System.out.println(value);
					
				} catch (Exception e) {
					value = 0;
				}
				long tempSize = fc.getNowLength();//得到文件总长度
				
				DecimalFormat df = new DecimalFormat("0.00");
				JfileSpeed.setText(""+ df.format(((fc.getFileLength() - tempSize) / 1024.0) * 2.0)+ "KB/s"); //传输速度
				if (value == 100) {
					this.dispose();//value == 100 表示文件传输完毕
					if (value < 100) {
						JOptionPane.showMessageDialog(null, "文件传输被取消", "提示",
								JOptionPane.INFORMATION_MESSAGE);
						textAreaDialog.append(myIp+"\n"+"文件:"+fc.fileName+" 传输被取消");
					}
					return;
				}//if
			}
		}

		private void closeWindow() {
			int option = JOptionPane.showConfirmDialog(null, "取消文件发送？", "取消？",
					JOptionPane.YES_NO_OPTION, JOptionPane.QUESTION_MESSAGE);
			if (option == JOptionPane.YES_OPTION) {
				try {
					fc.close();
				} catch (IOException e1) {
					e1.printStackTrace();
				}
				this.dispose();
			}
		}

		@Override
		public void windowActivated(WindowEvent e)  { }

		@Override
		public void windowClosed(WindowEvent e) { }

		@Override
		public void windowClosing(WindowEvent e) { }

		@Override
		public void windowDeactivated(WindowEvent e) { }

		@Override
		public void windowDeiconified(WindowEvent e) { }

		@Override
		public void windowIconified(WindowEvent e) { }

		@Override
		public void windowOpened(WindowEvent e) { }
	}
	
}

import socket
import threading
import keyboard
import TcpRecvDataManager
from KeyboardListener import KeyboardListener


class TcpServer:

    def __init__(self):
        # 创建套接字
        self.tcpServerSocket = None

    def start_tcpserver(self):
        self.tcpServerSocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        # 设置地址可复用
        self.tcpServerSocket.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, True)
        # 绑定TCP端口
        self.tcpServerSocket.bind((self.get_host_ip(), 8888))
        # 设置待办事件排队等待connect的最大数目
        self.tcpServerSocket.listen(5)

        # self.tcpServerSocket.ioctl(socket.SIO_KEEPALIVE_VALS, (1, 60 * 1000, 30 * 1000))

        while True:
            new_client_socket, ip_port = self.tcpServerSocket.accept()

            # 删除之前所有的键盘监听hook
            keyboard.unhook_all()

            print("新连接: ", ip_port)
            new_thread = threading.Thread(target=self.connected_listener, args=(new_client_socket, ip_port))

            # 设置守护线程：在主线程关闭的时候 子线程也会关闭
            new_thread.setDaemon(True)
            new_thread.start()

    #  监听从客户端发送的数据
    def connected_listener(self, new_client_socket, ip_port):
        """
        接收消息 的函数
        :param new_client_socket: socket
        :param ip_port: ip地址元祖
        :return:
        """
        keyboardListener = KeyboardListener(new_client_socket)
        keyboardListener.listen_keyboard()

        while True:
            recv_data = new_client_socket.recv(1024)

            # 判断是否有消息返回
            if recv_data:
                recv_text = recv_data.decode("utf8")
                print("来自[%s]的消息:%s" % (str(ip_port), recv_text))

                # 处理客户端发送的数据
                TcpRecvDataManager.data_manager(new_client_socket, recv_text)

            else:
                # 如果断开连接会执行这行代码，此时关闭socket的连接
                new_client_socket.close()
                print("已经断开[%s]的连接" % (str(ip_port)))
                break

    #  获取本机的IP地址
    def get_host_ip(self) -> str:

        # 利用了UDP协议, 通过把自身ip放入该协议头中, 再通过读取UDP包获取ip.
        try:
            s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
            s.connect(("8.8.8.8", 80))
            ip = s.getsockname()[0]
            s.close()
            print("当前服务端ip地址:%s" % ip)
            return ip
        finally:
            print()

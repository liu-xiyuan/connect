import os
import time
from ctypes import windll
import pyperclip
from pykeyboard import PyKeyboard
import subprocess
from winotify import Notification, audio

user32 = windll.LoadLibrary('user32.dll')
k = PyKeyboard()


def other_manager(client_socket, dataList: list):
    action = dataList[1]
    data = dataList[2]
    if action == "OtherAction.lockScreen":
        _lock_computer()
    elif action == "OtherAction.checkLockScreen":
        _check_lock_screen(client_socket)
    elif action == "OtherAction.copyText":
        _copy_text(client_socket)
    elif action == 'OtherAction.openApplication':
        _open_application(data)
    elif action == 'OtherAction.timedShutdown':
        _timed_shutdown(data, client_socket)
    elif action == 'OtherAction.copyTranslator':
        _copy_translator(data)


# 锁定电脑
def _lock_computer():
    user32.LockWorkStation()


# 检查电脑是否锁屏
def _check_lock_screen(client_socket):
    result = user32.GetForegroundWindow()
    if result == 0:
        client_socket.send('Locked screen'.encode("utf8"))
    else:
        client_socket.send('No lock screen'.encode('utf8'))


# 复制文本至手机端
def _copy_text(client_socket):
    k.press_keys([k.control_key, 'c'])
    time.sleep(.3)
    text = pyperclip.waitForPaste()
    client_socket.send(('copyText:' + text).encode('utf8'))


# 打开指定路径的应用
def _open_application(data: str):
    try:
        subprocess.Popen(data)
    except():
        print('_open_application: 应用路径不存在!')


# 将翻译目标文本写入剪贴板
def _copy_translator(data: str):
    pyperclip.copy(data)
    toast = Notification(
        app_id="Connect",
        title="Connect Translator",
        msg="📌 翻译文本已复制至剪切板",
        icon=r"D:\DeveloperTools\code\Flutter\connect\connectServer\assets\icon.png"
    )
    toast.set_audio(audio.Mail, loop=False)
    toast.add_actions(label="确认", launch="")
    toast.show()


# 定时关机
def _timed_shutdown(data: str, client_socket):
    timerList = data.split(',')
    seconds = int(timerList[0]) * 60 * 60 + int(timerList[1]) * 60

    if seconds > 0:
        try:
            os.system('shutdown -s -t %d' % seconds)
            client_socket.send('shutdown,start,T'.encode("utf8"))

            toast = Notification(
                app_id="Connect",
                title="Connect 定时关机",
                msg="Windows 将在 {hour} 小时 {minute} 分钟后关机💤".format(hour=timerList[0], minute=timerList[1]),
                icon=r"D:\DeveloperTools\code\Flutter\connect\connectServer\assets\icon.png"
            )
            toast.set_audio(audio.Mail, loop=False)
            toast.add_actions(label="确认", launch="")
            toast.show()

        except():
            client_socket.send('shutdown,start,F'.encode("utf8"))
    else:
        try:
            os.system('shutdown -a')  # 清除定时关机任务
            client_socket.send('shutdown,clear,T'.encode("utf8"))

            toast = Notification(
                app_id="Connect",
                title="Connect 定时关机",
                msg="已取消计时!",
                icon=r"D:\DeveloperTools\code\Flutter\connect\connectServer\assets\icon.png"
            )
            toast.set_audio(audio.Mail, loop=False)
            toast.add_actions(label="确认", launch="")
            toast.show()

        except():
            client_socket.send('shutdown,clear,F'.encode("utf8"))

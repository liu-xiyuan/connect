import time
from ctypes import windll
import pyperclip
from pykeyboard import PyKeyboard
import subprocess


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
    elif action == 'OtherAction.loveSong':
        _love_song()
    elif action == 'OtherAction.openLyrics':
        _open_lyrics()
    elif action == 'OtherAction.miniMode':
        _mini_mode()
    elif action == 'OtherAction.openApplication':
        _open_application(data)


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
    subprocess.Popen(data)


# 喜欢歌曲(网易云快捷键)
def _love_song():
    k.press_keys([k.control_key, k.alt_key, 'l'])


# 打开歌词(网易云快捷键)
def _open_lyrics():
    k.press_keys([k.control_key, k.alt_key, 'd'])


# mini模式(网易云快捷键)
def _mini_mode():
    k.press_keys([k.control_key, k.shift_key, 'm'])


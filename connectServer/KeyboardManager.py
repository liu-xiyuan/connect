import time

import win32api
import win32con
import win32gui
from pykeyboard import PyKeyboard

k = PyKeyboard()


def keyboard_manager(dataList: list):
    action = dataList[1]
    data = dataList[2]
    if action == "KeyboardAction.tapArrowKey":
        _tap_arrow_key(data)
    elif action == "KeyboardAction.tapEnter":
        _tap_enter_key()
    elif action == "KeyboardAction.showProgramWindow":
        _show_program_window()
    elif action == "KeyboardAction.switchDesktop":
        _switch_desktop(data)
    elif action == "KeyboardAction.webpageZoom":
        _webpage_zoom(data)


def _tap_arrow_key(data: str):

    #  禁用NUMLOCK
    if win32api.GetKeyState(win32con.VK_NUMLOCK) == 1:
        k.tap_key(k.num_lock_key)

    if data == "left":
        k.tap_key(k.left_key)
    elif data == "right":
        k.tap_key(k.right_key)
    elif data == "up":
        k.tap_key(k.up_key)
    elif data == "down":
        k.tap_key(k.down_key)


# 按下Enter键
def _tap_enter_key():
    k.tap_key(k.enter_key)


# 显示桌面窗口
def _show_program_window():
    k.press_keys([k.windows_l_key, k.tab_key])


# 切换桌面
def _switch_desktop(data: str):
    if data == "left":
        k.press_keys([k.windows_l_key, k.control_l_key, k.left_key])
    elif data == "right":
        k.press_keys([k.windows_l_key, k.control_l_key, k.right_key])



# 浏览器页面缩放
def _webpage_zoom(data: str):
    hwnd = win32gui.FindWindow("MozillaWindowClass", None)  # 查找窗口, 返回值为0表表示未找到窗口

    # if hwnd != 0:
    #     win32gui.SetForegroundWindow(hwnd)  # 置顶窗口
    #     win32gui.ShowWindow(hwnd, win32con.SW_SHOWMAXIMIZED)  # 激活并最大化窗口
    #
    #     if data == 'zoom_in':
    #         k.press_keys([k.control_l_key, "-"])
    #     elif data == "zoom_out":
    #         k.press_keys([k.control_l_key, "="])



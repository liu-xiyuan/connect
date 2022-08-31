import win32api
import win32con
import win32gui
from pykeyboard import PyKeyboard

k = PyKeyboard()
keyValues = {
    'tab': k.tab_key,
    'shift': k.shift_key,
    'ctrl': k.control_key,
    'win': k.windows_l_key,
    'alt': k.alt_key,
    'space': k.space_key,
    'backSpace': k.backspace_key,
    'enter': k.enter_key,
    'arrow_up': k.up_key,
    'arrow_down': k.down_key,
    'arrow_left': k.left_key,
    'arrow_right': k.right_key,
    'ins': k.insert_key,
    'home': k.home_key,
    'pgup': k.page_up_key,
    'del': k.delete_key,
    'end': k.end_key,
    'pgdn': k.page_down_key,
}


def keyboard_manager(dataList: list):
    action = dataList[1]
    data = dataList[2]
    if action == "KeyboardAction.tapArrowKey":
        _tap_arrow_key(data)
    elif action == "KeyboardAction.webpageZoom":
        _webpage_zoom(data)
    elif action == "KeyboardAction.pressKeys":
        _press_keys(data)


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


#  禁用NUMLOCK
def _disable_numlock():
    if win32api.GetKeyState(win32con.VK_NUMLOCK) == 1:
        k.tap_key(k.num_lock_key)


# 按下组合键
# data = "ctrl, shift, a"
def _press_keys(data: str):
    dataList = data.replace(' ', '').split(',')
    keysList = []

    for key in dataList:
        if key in keyValues:
            if key.startswith('arrow_'):
                _disable_numlock()
            keysList.append(keyValues.get(key))
        elif len(key) == 1:
            keysList.append(key)

    k.press_keys(keysList)


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

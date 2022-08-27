import pyperclip
from pykeyboard import PyKeyboard

k = PyKeyboard()


def speech_manager(client_socket, dataList: list):
    action = dataList[1]
    data = dataList[2]
    if action == "SpeechAction.inputText":
        _input_text(data)


# 输入字符串
def _input_text(data: str):
    # 因为pyKeyboard无法输入中文
    # 所以先将文本复制到剪切板中, 再执行 ctrl+v
    pyperclip.copy(data)
    k.press_keys([k.control_key, 'v'])  # 使用组合键

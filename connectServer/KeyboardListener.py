import time
import keyboard
import pyperclip
from winotify import Notification, audio


class KeyboardListener:
    def __init__(self, client_socket):
        self.client_socket = client_socket
        self.callback = None
        self.t = 0
        self.c = 0
        self.key_state_map = {}
        self.screen_capture = None

    def listen_keyboard(self):
        keyboard.hook(self.on_ctrl_cc_event)

    def _isCtrlHolding(self):
        return ('ctrl' in self.key_state_map and self.key_state_map['ctrl'] == 'down') \
               or ('left ctrl' in self.key_state_map and self.key_state_map['left ctrl'] == 'down') \
               or ('right ctrl' in self.key_state_map and self.key_state_map['right ctrl'] == 'down')

    # 判断是否按下 CTRL + C C 组合键
    def on_ctrl_cc_event(self, key):
        self.key_state_map[key.name.lower()] = key.event_type

        # Ctrl + c c ?
        if key.event_type == "down" \
                and key.name.lower() == "c" \
                and self._isCtrlHolding():

            if self.t == 0:
                self.t = time.time()
                self.c += 1
                return

            if time.time() - self.t < 0.5:
                self.t = time.time()
                self.c += 1
                if self.c >= 2:
                    self.c = 0
                    self.t = 0
                    self._send_source_text()

            else:
                self.c = 0
                self.t = 0

    # 将翻译源文本发送至手机
    def _send_source_text(self):
        text = pyperclip.waitForPaste().strip()

        if len(text) > 50:
            toast = Notification(
                app_id="Connect",
                title="Connect Translator",
                msg="文本长度不能超过50字符 !",
                icon=r"D:\DeveloperTools\code\Flutter\connect\connectServer\assets\icon.png"
            )
            toast.set_audio(audio.Mail, loop=False)
            toast.add_actions(label="确认", launch="")
            toast.show()

        else:
            try:
                self.client_socket.send(('Translate:' + text).encode("utf8"))
            except():
                print("发送失败")

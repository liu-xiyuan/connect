from KeyboardManager import keyboard_manager
from OtherManager import other_manager
from SpeechManager import speech_manager


def data_manager(client_socket, data: str):
    dataList = data.split(",", 2)
    command = dataList[0]

    if command == "TcpCommands.keyboardAction":
        keyboard_manager(dataList)

    elif command == "TcpCommands.otherAction":
        other_manager(client_socket, dataList)

    elif command == "TcpCommands.speechAction":
        speech_manager(client_socket, dataList)

    elif command == "TcpCommands.heartbeatAction":
        client_socket.send('Heartbeat'.encode("utf8"))




object Waiterkey: TWaiterkey
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 390
  Width = 553
  object ZylSerialPort: TZylSerialPort
    OnReceive = ZylSerialPortReceive
    OnSend = ZylSerialPortSend
    OnLineStatusChange = ZylSerialPortLineStatusChange
    OnConnect = ZylSerialPortConnect
    OnDisconnect = ZylSerialPortDisconnect
    Left = 48
    Top = 24
  end
  object TimerASSI: TTimer
    Enabled = False
    OnTimer = TimerASSITimer
    Left = 49
    Top = 88
  end
end

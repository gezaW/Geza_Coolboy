unit OrdermanCommunication.Constants;

// Projekt: OrdermanServer
// Workfile: OrdermanCommunication.Constants.pas
// Created: 24.06.2010 (Christoph Hazott)
// Log: - Created Folder Structure and Namespace Structure
//          24.06.2010 (Christoph Hazott)
// Description:
//      This File contains all Constants which are Valid for the
//      Hermes- and Classic- Line

interface

uses
  OleCtrls;

{$REGION 'INSTRUCTIONS'}

  type
    TINSTRUCTION_CODES = TOleEnum;
    const
      CHERMES_DATA_INSTR          = $8;                                           // Orderman Hermes Data Instruction
      CASCII_SCREEN_INSTR         = $10;                                          // Data output and keyboard control
      CKEYB_INSTR                 = $20;                                          // Returns single keystrokes to the host
      CKEYB_STRING_INSTR          = $21;                                          // Returns data to the host that has been entered on the keyboard or the touch screen
      CTAG_DATA_INSTR             = $22;                                          // Returns data from Contactless Card Reader or Magnetic Card Reader
      CSCAN_DATA_INSTR            = $23;                                          // Returns data from the Barcode Scanner
      CBLUETOOTH_INSTR            = $24;                                          // Response to bluetooth commands
      CCOM_DATA_INSTR             = $28;                                          // Returns received data from a serial port of an Orderman Terminal or RF printer station
      CCOM_STATUS_INSTR           = $29;                                          // Returns the status of a serial port of an Orderman Terminal
      CCOM_READY_INSTR            = $2A;                                          // Signals that the specified serial port of an Orderman Terminal is ready again to accept data
      CCOM_TIMEOUT_INSTR          = $2B;                                          // Signals data output timeout at a serial port of an Orderman Terminal
      CMACRO_DEFINE               = $2C;                                          // Permanent storing of screen data to DON, MAX and Orderman Terminal (OMT) devices
      CPROGRAM_KEY_INSTR          = $2D;                                          // Programming the waiter lock and the corresponding clerk keys of an Orderman Terminal
      CORDERMAN_POWER_ON_INSTR    = $30;                                          // Power on message of Orderman
      CTERMINAL_POWER_ON_INSTR    = $30;                                          // Power on message of Orderman Terminal
      CRF_PRINTER_STATUS_INSTR    = $33;                                          // Power on and status message of RF printer station
      CORDERMAN_POWER_OFF_INSTR   = $34;                                          // Power off message of Orderman DON, MAX and LEO
      CACK_INSTR                  = $40;                                          // Confirmation of telegrams in both directions (to and from host)
      CNACK_INSTR                 = $41;                                          // Negative acknowledge to telegrams from host
      CHOST_LOGIN_INSTR           = $60;                                          // Start-up message of the Orderman Network
      CBOOT_REQ_INSTR             = $63;                                          // Boot Request instruction. For firmware update purposes
      CRESET_ORDERMAN_INSTR       = $65;                                          // Reset Orderman or Orderman Terminal to power on state
      CROUTER_CMD_INSTR           = $70;                                          // Several subcommands to Orderman Network devices (e.g. System-Reset, set/get radio channel...)
      CXMT_ROUTER_INSTR           = $71;                                          // Response to ROUTER_CMD_INSTR
      CFAX_DATA_INSTR             = $90;                                          // FaxData from DON or MAX to host
      COM_STATUS_INSTR            = $91;                                          // Various status information from DON or MAX to host
      CGET_VERSION_INSTR          = $F6;                                          // Request firmware version of Orderman or Orderman Terminal
      CXMT_VERSION_INSTR          = $F7;                                          // Return firmware version of Orderman or Orderman Terminal
      CXMT_MACRO_CHECKSUM_INSTR   = $FC;                                          // Return macro checksum of Orderman Terminal

{$ENDREGION}

{$REGION 'MESSAGEBOX'}

  type
    TMESSAGEBOX_MODES = TOleEnum;
    const
      COk       = 1;
      COkCancel = 2;
      CYesNo    = 3;

{$ENDREGION}

  type
    TSTRINGALIGNMENT = TOleEnum;
  const
    CLEFTTOP = 1;
    CCENTERTOP = 2;
    CRIGHTTOP = 3;
    CLEFTMIDDLE = 4;
    CCENTERMIDDLE = 5;
    CRIGHTMIDDLE = 6;
    CLEFTBOTTOM = 7;
    CCENTERBOTTOM = 8;
    CRIGHTBOTTOM = 9;

  //27.12.2010 BW: new types for lists
  type
    TLISTTYPE = TOleEnum;
  const
    CADAPTIVELIST = 1;
    CGRIDLIST = 2;
    CMULTILIST = 3;

{$REGION 'Data Types'}

  type
    TBoolArray = Array of Boolean;

  type
    TIntegerArray = Array of Integer;

  type
    TStringArray = Array of String;

  type
    TByteArray = Array of Byte;

{$ENDREGION}

implementation

end.
object DataDesign: TDataDesign
  OldCreateOrder = False
  Height = 376
  Width = 441
  object SkinDataOrange: TbsSkinData
    DlgTreeViewDrawSkin = True
    DlgTreeViewItemSkinDataName = 'listbox'
    DlgListViewDrawSkin = True
    DlgListViewItemSkinDataName = 'listbox'
    SkinnableForm = True
    AnimationForAllWindows = False
    EnableSkinEffects = True
    ShowButtonGlowFrames = True
    ShowCaptionButtonGlowFrames = True
    ShowLayeredBorders = True
    AeroBlurEnabled = True
    CompressedStoredSkin = bsCompressedStoredSkinOrange
    ResourceStrData = bsResourceStrData
    SkinIndex = 0
    ChangeSystemColors = False
    SystemColorHooks = [bsschHighLight]
    Left = 48
    Top = 8
  end
  object SkinDataBlau: TbsSkinData
    DlgTreeViewDrawSkin = True
    DlgTreeViewItemSkinDataName = 'listbox'
    DlgListViewDrawSkin = True
    DlgListViewItemSkinDataName = 'listbox'
    SkinnableForm = True
    AnimationForAllWindows = False
    EnableSkinEffects = True
    ShowButtonGlowFrames = True
    ShowCaptionButtonGlowFrames = True
    ShowLayeredBorders = True
    AeroBlurEnabled = True
    CompressedStoredSkin = bsCompressedStoredSkinBlau
    ResourceStrData = bsResourceStrData
    SkinIndex = 0
    ChangeSystemColors = False
    SystemColorHooks = [bsschHighLight]
    Left = 272
    Top = 8
  end
  object SkinDataGrau: TbsSkinData
    DlgTreeViewDrawSkin = True
    DlgTreeViewItemSkinDataName = 'listbox'
    DlgListViewDrawSkin = True
    DlgListViewItemSkinDataName = 'listbox'
    SkinnableForm = True
    AnimationForAllWindows = False
    EnableSkinEffects = True
    ShowButtonGlowFrames = True
    ShowCaptionButtonGlowFrames = True
    ShowLayeredBorders = True
    AeroBlurEnabled = True
    CompressedStoredSkin = bsCompressedStoredSkinGrau
    ResourceStrData = bsResourceStrData
    SkinIndex = 0
    ChangeSystemColors = False
    SystemColorHooks = [bsschHighLight]
    Left = 156
    Top = 8
  end
  object bsSkinMessage: TbsSkinMessage
    ShowAgainFlag = False
    ShowAgainFlagValue = False
    AlphaBlend = False
    AlphaBlendAnimation = False
    AlphaBlendValue = 200
    SkinData = SkinDataOrange
    CtrlSkinData = SkinDataBlau
    ButtonSkinDataName = 'button'
    MessageLabelSkinDataName = 'stdlabel'
    DefaultFont.Charset = DEFAULT_CHARSET
    DefaultFont.Color = clWindowText
    DefaultFont.Height = 14
    DefaultFont.Name = 'Arial'
    DefaultFont.Style = []
    DefaultButtonFont.Charset = DEFAULT_CHARSET
    DefaultButtonFont.Color = clWindowText
    DefaultButtonFont.Height = 14
    DefaultButtonFont.Name = 'Arial'
    DefaultButtonFont.Style = []
    UseSkinFont = True
    Left = 312
    Top = 88
  end
  object bsResourceStrData: TbsResourceStrData
    ResStrings.Strings = (
      'MI_MINCAPTION=Mi&nimieren'
      'MI_MAXCAPTION=Ma&ximieren'
      'MI_CLOSECAPTION=S&chliessen'
      'MI_RESTORECAPTION=&Wiederherstellen'
      'MI_MINTOTRAYCAPTION=Minimize to &Tray'
      'MI_ROLLUPCAPTION=Ro&llUp'
      'MINBUTTON_HINT=Minimieren'
      'MAXBUTTON_HINT=Maximieren'
      'CLOSEBUTTON_HINT=Close'
      'TRAYBUTTON_HINT=Minimize to Tray'
      'ROLLUPBUTTON_HINT=Roll Up'
      'MENUBUTTON_HINT=System menu'
      'EDIT_UNDO=Verwerfen'
      'EDIT_COPY=Kopieren'
      'EDIT_CUT=Ausschneiden'
      'EDIT_PASTE=Einf'#252'gen'
      'EDIT_DELETE=L'#246'schen'
      'EDIT_SELECTALL=Alles ausw'#228'hlen'
      'MSG_BTN_YES=&Ja'
      'MSG_BTN_NO=&Nein'
      'MSG_BTN_OK=OK'
      'MSG_BTN_CANCEL=Abbrechen'
      'MSG_BTN_ABORT=&Abbrechen'
      'MSG_BTN_RETRY=&Wiederholen'
      'MSG_BTN_IGNORE=&Ignorieren'
      'MSG_BTN_ALL=&Alle'
      'MSG_BTN_NOTOALL=N&oToAll'
      'MSG_BTN_YESTOALL=&YesToAll'
      'MSG_BTN_HELP=&Hilfe'
      'MSG_BTN_OPEN=&'#214'ffnen'
      'MSG_BTN_SAVE=&Speichern'
      'MSG_BTN_BACK_HINT=Go To Last Folder Visited'
      'MSG_BTN_UP_HINT=Up One Level'
      'MSG_BTN_NEWFOLDER_HINT=Create New Folder'
      'MSG_BTN_VIEWMENU_HINT=View Menu'
      'MSG_BTN_STRETCH_HINT=Stretch Picture'
      'MSG_FILENAME=Dateiname:'
      'MSG_FILETYPE=Dateityp:'
      'MSG_NEWFOLDER=New Folder'
      'MSG_LV_DETAILS=Details'
      'MSG_LV_ICON=Large icons'
      'MSG_LV_SMALLICON=Small icons'
      'MSG_LV_LIST=List'
      'MSG_PREVIEWSKIN=Preview'
      'MSG_PREVIEWBUTTON=Button'
      'MSG_CAP_WARNING=Warnung'
      'MSG_CAP_ERROR=Fehler'
      'MSG_CAP_INFORMATION=Information'
      'MSG_CAP_CONFIRM=Best'#228'tigung'
      'CALC_CAP=Calculator'
      'ERROR=Error'
      'COLORGRID_CAP=Standard Farben'
      'CUSTOMCOLORGRID_CAP=benutzerdefinierte Farben'
      'ADDCUSTOMCOLORBUTTON_CAP=zu benutzerdef. Farben hinzuf'#252'gen'
      'FONTDLG_COLOR=Color:'
      'FONTDLG_NAME=Name:'
      'FONTDLG_SIZE=Size:'
      'FONTDLG_HEIGHT=Height:'
      'FONTDLG_EXAMPLE=Example:'
      'FONTDLG_STYLE=Style:'
      'FONTDLG_SCRIPT=Script:'
      'DB_DELETE_QUESTION=Datensatz l'#246'schen?'
      'DB_MULTIPLEDELETE_QUESTION=Delete all selected records?'
      'NODISKINDRIVE=There is no disk in Drive or Drive is not ready'
      'NOVALIDDRIVEID=Not a valid Drive ID'
      'FLV_NAME=Name'
      'FLV_SIZE=Size'
      'FLV_TYPE=Type'
      'FLV_LOOKIN=Look in: '
      'FLV_MODIFIED=Modified'
      'FLV_ATTRIBUTES=Attributes'
      'FLV_DISKSIZE=Disk Size'
      'FLV_FREESPACE=Free Space')
    CharSet = DEFAULT_CHARSET
    Left = 306
    Top = 232
  end
  object bsCompressedStoredSkinOrange: TbsCompressedStoredSkin
    Left = 80
    Top = 88
    CompressedData = {}
  end
  object bsCompressedStoredSkinBlau: TbsCompressedStoredSkin
    Left = 72
    Top = 152
    CompressedData = {}
  end
  object bsCompressedStoredSkinGrau: TbsCompressedStoredSkin
    Left = 88
    Top = 232
    CompressedData = {}
  end
  object bsSkinInputDialog: TbsSkinInputDialog
    AlphaBlend = False
    AlphaBlendValue = 200
    AlphaBlendAnimation = False
    SkinData = SkinDataOrange
    CtrlSkinData = SkinDataBlau
    ButtonSkinDataName = 'button'
    LabelSkinDataName = 'stdlabel'
    EditSkinDataName = 'edit'
    DefaultLabelFont.Charset = DEFAULT_CHARSET
    DefaultLabelFont.Color = clWindowText
    DefaultLabelFont.Height = 14
    DefaultLabelFont.Name = 'Arial'
    DefaultLabelFont.Style = []
    DefaultButtonFont.Charset = DEFAULT_CHARSET
    DefaultButtonFont.Color = clWindowText
    DefaultButtonFont.Height = 14
    DefaultButtonFont.Name = 'Arial'
    DefaultButtonFont.Style = []
    DefaultEditFont.Charset = DEFAULT_CHARSET
    DefaultEditFont.Color = clWindowText
    DefaultEditFont.Height = 14
    DefaultEditFont.Name = 'Arial'
    DefaultEditFont.Style = []
    UseSkinFont = True
    Left = 312
    Top = 152
  end
end
object berichtForm: TberichtForm
  Left = 357
  Top = 410
  BorderStyle = bsDialog
  Caption = 'Bericht'
  ClientHeight = 283
  ClientWidth = 282
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object label3: TLabel
    Left = 32
    Top = 128
    Width = 39
    Height = 13
    Caption = 'Spielzeit'
  end
  object label1: TLabel
    Left = 32
    Top = 32
    Width = 42
    Height = 13
    Caption = 'Interpret:'
  end
  object label2: TLabel
    Left = 32
    Top = 80
    Width = 55
    Height = 13
    Caption = 'Stilrichtung:'
  end
  object Button1: TButton
    Left = 24
    Top = 240
    Width = 75
    Height = 25
    Caption = 'OK'
    Default = True
    ModalResult = 1
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 120
    Top = 240
    Width = 75
    Height = 25
    Cancel = True
    Caption = 'Abbruch'
    ModalResult = 2
    TabOrder = 1
  end
  object Spielzeit: TEdit
    Left = 104
    Top = 120
    Width = 121
    Height = 21
    TabOrder = 2
  end
  object interpret: TComboBox
    Left = 104
    Top = 24
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 3
  end
  object Stilrichtung: TComboBox
    Left = 104
    Top = 72
    Width = 145
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 4
  end
  object Panel1: TPanel
    Left = 32
    Top = 168
    Width = 217
    Height = 49
    TabOrder = 5
    object Live: TRadioButton
      Left = 8
      Top = 16
      Width = 41
      Height = 17
      Caption = 'Live'
      TabOrder = 0
    end
    object Studio: TRadioButton
      Left = 84
      Top = 16
      Width = 49
      Height = 17
      Caption = 'Studio'
      TabOrder = 1
    end
    object Egal: TRadioButton
      Left = 160
      Top = 16
      Width = 49
      Height = 17
      Caption = 'Egal'
      Checked = True
      TabOrder = 2
      TabStop = True
    end
  end
  object berichtTabelle: TTable
    DatabaseName = 'theCDbase'
    SessionName = 'theSessionName'
    TableName = 'Bericht.db'
    Left = 232
    Top = 240
  end
  object interpretQry: TQuery
    DatabaseName = 'theCDbase'
    SessionName = 'theSessionName'
    SQL.Strings = (
      'select distinct interpret'
      'from cd'
      'where Interpret is not null')
    UniDirectional = True
    Left = 280
    Top = 24
  end
  object stilQuery: TQuery
    DatabaseName = 'theCDbase'
    SessionName = 'theSessionName'
    SQL.Strings = (
      'select distinct stilrichtung'
      'from cd'
      'where Stilrichtung is not null')
    UniDirectional = True
    Left = 280
    Top = 80
  end
  object Interpret2Query: TQuery
    DatabaseName = 'theCDbase'
    SessionName = 'theSessionName'
    SQL.Strings = (
      'select distinct Interpret'
      'from Titel'
      'where Interpret is not null')
    UniDirectional = True
    Left = 328
    Top = 24
  end
  object stil2Query: TQuery
    DatabaseName = 'theCDbase'
    SessionName = 'theSessionName'
    SQL.Strings = (
      'select distinct Stilrichtung'
      'from Titel'
      'where Stilrichtung is not null')
    UniDirectional = True
    Left = 344
    Top = 80
  end
end

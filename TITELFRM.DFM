object MainForm: TMainForm
  Left = 852
  Top = 231
  Width = 809
  Height = 708
  Caption = 'CD-Verwaltung'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = True
  Position = poScreenCenter
  Visible = True
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 801
    Height = 295
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object titelGrid: TDBGrid
      Left = 390
      Top = 0
      Width = 411
      Height = 295
      TabStop = False
      Align = alClient
      DataSource = CDsource
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      Columns = <
        item
          Expanded = False
          FieldName = 'Interpret'
          Width = 110
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Titel'
          Width = 194
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Spieldauer'
          ReadOnly = True
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Erscheinungsdatum'
          Title.Caption = 'Datum'
          Width = 32
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Stilrichtung'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Plattenfirma'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Bestellnummer'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Verliehen_an'
          Title.Caption = 'Verliehen An'
          Visible = True
        end>
    end
    object Panel3: TPanel
      Left = 0
      Top = 0
      Width = 390
      Height = 295
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object Label1: TLabel
        Left = 16
        Top = 64
        Width = 42
        Height = 13
        Caption = 'Interpret:'
      end
      object Label2: TLabel
        Left = 16
        Top = 96
        Width = 23
        Height = 13
        Caption = 'Titel:'
      end
      object Label8: TLabel
        Left = 16
        Top = 171
        Width = 55
        Height = 13
        Caption = 'Stilrichtung:'
      end
      object Label4: TLabel
        Left = 16
        Top = 203
        Width = 62
        Height = 13
        Caption = 'Verliehen an:'
      end
      object Label5: TLabel
        Left = 16
        Top = 240
        Width = 28
        Height = 13
        Caption = 'Firma:'
      end
      object Label6: TLabel
        Left = 16
        Top = 264
        Width = 34
        Height = 13
        Caption = 'Datum:'
      end
      object DBNavigator1: TDBNavigator
        Left = 20
        Top = 16
        Width = 216
        Height = 25
        DataSource = CDsource
        VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbDelete, nbEdit, nbPost, nbCancel, nbRefresh]
        TabOrder = 0
        TabStop = True
      end
      object CD: TDBEdit
        Left = 100
        Top = 93
        Width = 277
        Height = 21
        DataField = 'Titel'
        DataSource = CDsource
        TabOrder = 2
      end
      object DBRadioGroup2: TDBRadioGroup
        Left = 100
        Top = 120
        Width = 277
        Height = 33
        Columns = 3
        DataField = 'Live_Studioaufnahme'
        DataSource = CDsource
        Items.Strings = (
          'Live'
          'Studio'
          'Unbekannt')
        TabOrder = 3
        Values.Strings = (
          'L'
          'S'
          'U')
      end
      object DBEdit1: TDBEdit
        Left = 100
        Top = 200
        Width = 277
        Height = 21
        DataField = 'Verliehen_an'
        DataSource = CDsource
        TabOrder = 5
      end
      object DBLookupComboBox1: TDBLookupComboBox
        Left = 100
        Top = 64
        Width = 277
        Height = 21
        DataField = 'Interpret'
        DataSource = CDsource
        KeyField = 'interpret'
        ListField = 'interpret'
        ListSource = InterpretSource
        TabOrder = 1
      end
      object DBLookupComboBox2: TDBLookupComboBox
        Left = 100
        Top = 168
        Width = 277
        Height = 21
        DataField = 'Stilrichtung'
        DataSource = CDsource
        KeyField = 'stilrichtung'
        ListField = 'stilrichtung'
        ListSource = StilSource
        TabOrder = 4
      end
      object DBLookupComboBox3: TDBLookupComboBox
        Left = 100
        Top = 232
        Width = 277
        Height = 21
        DataField = 'Plattenfirma'
        DataSource = CDsource
        KeyField = 'plattenfirma'
        ListField = 'plattenfirma'
        ListSource = FirmaSource
        TabOrder = 6
      end
      object DBEdit2: TDBEdit
        Left = 100
        Top = 264
        Width = 37
        Height = 21
        DataField = 'Erscheinungsdatum'
        DataSource = CDsource
        TabOrder = 7
      end
      object DBEdit3: TDBEdit
        Left = 144
        Top = 264
        Width = 57
        Height = 21
        TabStop = False
        DataField = 'Spieldauer'
        DataSource = CDsource
        ReadOnly = True
        TabOrder = 8
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 295
    Width = 801
    Height = 367
    Align = alBottom
    BevelInner = bvLowered
    TabOrder = 1
    object DBGrid2: TDBGrid
      Left = 392
      Top = 2
      Width = 407
      Height = 363
      TabStop = False
      Align = alClient
      DataSource = Titelsource
      TabOrder = 1
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'MS Sans Serif'
      TitleFont.Style = []
      Columns = <
        item
          Expanded = False
          FieldName = 'Nummer'
          ReadOnly = True
          Title.Caption = 'Nr.'
          Width = 20
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Titel'
          Width = 150
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Spieldauer'
          ReadOnly = True
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Interpret'
          Visible = True
        end
        item
          Expanded = False
          FieldName = 'Stilrichtung'
          Visible = True
        end>
    end
    object Panel4: TPanel
      Left = 2
      Top = 2
      Width = 390
      Height = 363
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object Label3: TLabel
        Left = 24
        Top = 89
        Width = 23
        Height = 13
        Caption = 'Titel:'
      end
      object Label7: TLabel
        Left = 24
        Top = 57
        Width = 42
        Height = 13
        Caption = 'Interpret:'
      end
      object CmdLabel: TLabel
        Left = 9
        Top = 0
        Width = 3
        Height = 13
        Caption = '-'
      end
      object DBRadioGroup1: TDBRadioGroup
        Left = 92
        Top = 120
        Width = 277
        Height = 33
        Columns = 3
        DataField = 'Live_Studioaufnahme'
        DataSource = Titelsource
        Items.Strings = (
          'Live'
          'Studio'
          'Unbekannt')
        TabOrder = 3
        Values.Strings = (
          'L'
          'S'
          'U')
      end
      object DBNavigator2: TDBNavigator
        Left = 20
        Top = 16
        Width = 192
        Height = 25
        DataSource = Titelsource
        VisibleButtons = [nbFirst, nbPrior, nbNext, nbLast, nbEdit, nbPost, nbCancel, nbRefresh]
        TabOrder = 0
        TabStop = True
      end
      object Titel: TDBEdit
        Left = 92
        Top = 86
        Width = 280
        Height = 21
        DataField = 'Titel'
        DataSource = Titelsource
        TabOrder = 2
      end
      object Titelinterpret: TDBEdit
        Left = 92
        Top = 54
        Width = 280
        Height = 21
        DataField = 'Interpret'
        DataSource = Titelsource
        TabOrder = 1
      end
      object GroupBox1: TGroupBox
        Left = 16
        Top = 168
        Width = 353
        Height = 185
        Caption = 'CD-Spieler'
        TabOrder = 4
        object cdPlayer: TMediaPlayer
          Left = 8
          Top = 24
          Width = 225
          Height = 33
          Hint = 'CD-Player'
          VisibleButtons = [btPlay, btPause, btStop, btNext, btPrev, btStep, btBack, btEject]
          AutoEnable = False
          AutoRewind = False
          DeviceType = dtCDAudio
          TabOrder = 0
          OnNotify = cdPlayerNotify
        end
        object cdPlayerDisplay: TEdit
          Left = 8
          Top = 97
          Width = 169
          Height = 24
          TabStop = False
          Color = clYellow
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clPurple
          Font.Height = -13
          Font.Name = 'Courier New'
          Font.Style = [fsBold]
          ParentFont = False
          ReadOnly = True
          TabOrder = 3
        end
        object cdMode: TEdit
          Left = 192
          Top = 93
          Width = 89
          Height = 21
          TabStop = False
          TabOrder = 4
        end
        object TrackCDTime: TRadioGroup
          Left = 8
          Top = 128
          Width = 73
          Height = 49
          Caption = 'Zeit'
          ItemIndex = 0
          Items.Strings = (
            'Track'
            'CD')
          TabOrder = 5
        end
        object leftTime: TRadioGroup
          Left = 88
          Top = 128
          Width = 65
          Height = 49
          Caption = 'Zeit'
          ItemIndex = 0
          Items.Strings = (
            'Bisher'
            'Rest')
          TabOrder = 6
        end
        object Button1: TButton
          Left = 8
          Top = 64
          Width = 81
          Height = 25
          Caption = 'Suchen'
          TabOrder = 1
          OnClick = Button1Click
        end
        object DirectPlay: TButton
          Left = 96
          Top = 64
          Width = 81
          Height = 25
          Caption = 'Direktanwahl'
          TabOrder = 2
          OnClick = DirectPlayClick
        end
      end
    end
  end
  object CDsource: TDataSource
    DataSet = CDtable
    Left = 712
    Top = 8
  end
  object Titelsource: TDataSource
    DataSet = Titeltable
    Left = 720
    Top = 64
  end
  object CDtable: TTable
    BeforeInsert = CDtableBeforeInsert
    BeforeDelete = CDtableBeforeDelete
    DatabaseName = 'theCDbase'
    SessionName = 'theSessionName'
    IndexName = 'interpretTitel'
    TableName = 'CD.DB'
    Left = 656
    Top = 8
  end
  object Titeltable: TTable
    BeforeInsert = TiteltableBeforeInsert
    BeforeDelete = TiteltableBeforeDelete
    DatabaseName = 'theCDbase'
    SessionName = 'theSessionName'
    IndexFieldNames = 'CD'
    MasterFields = 'ID'
    MasterSource = CDsource
    TableName = 'Titel.DB'
    Left = 656
    Top = 64
  end
  object theTimer: TTimer
    OnTimer = theTimerTimer
    Left = 192
    Top = 601
  end
  object MainMenu: TMainMenu
    Left = 320
    Top = 8
    object Datei1: TMenuItem
      Caption = '&Datei'
      object Berichte1: TMenuItem
        Caption = '&Berichte...'
        OnClick = Berichte1Click
      end
      object HitListe1: TMenuItem
        Caption = '&Hitliste'
        OnClick = HitListe1Click
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object CDSpieler1: TMenuItem
        Caption = '&CD Spieler'
        OnClick = CDSpieler1Click
      end
      object Lautstrkeregler1: TMenuItem
        Caption = '&Lautstärkeregler'
        OnClick = Lautstrkeregler1Click
      end
      object N1: TMenuItem
        Caption = '-'
      end
      object Ende1: TMenuItem
        Caption = '&Ende'
        OnClick = Ende1Click
      end
    end
    object berCDVerwaltung1: TMenuItem
      Caption = 'Über CD-Verwaltung!'
      OnClick = berCDVerwaltung1Click
    end
  end
  object System: TDdeServerConv
    OnExecuteMacro = SystemExecuteMacro
    Left = 248
    Top = 600
  end
  object InterpretSource: TDataSource
    DataSet = InterpretQuery
    Left = 720
    Top = 136
  end
  object InterpretQuery: TQuery
    DatabaseName = 'theCDbase'
    SessionName = 'theSessionName'
    SQL.Strings = (
      'select distinct interpret from cd')
    Left = 656
    Top = 136
  end
  object StilSource: TDataSource
    DataSet = StilQuery
    Left = 720
    Top = 192
  end
  object StilQuery: TQuery
    DatabaseName = 'theCDbase'
    SessionName = 'theSessionName'
    SQL.Strings = (
      'select distinct stilrichtung from cd')
    Left = 656
    Top = 192
  end
  object FirmaSource: TDataSource
    DataSet = FirmaQuery
    Left = 720
    Top = 256
  end
  object FirmaQuery: TQuery
    DatabaseName = 'theCDbase'
    SessionName = 'theSessionName'
    SQL.Strings = (
      'select distinct plattenfirma from cd')
    Left = 648
    Top = 256
  end
  object theSession: TSession
    SessionName = 'theSessionName'
    Left = 272
    Top = 8
  end
  object theDatabase: TDatabase
    AliasName = 'CD'
    DatabaseName = 'theCDbase'
    SessionName = 'theSessionName'
    Left = 224
    Top = 8
  end
end

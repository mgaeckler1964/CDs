object HitListForm: THitListForm
  Left = 397
  Top = 257
  Width = 523
  Height = 393
  Caption = 'Hit Liste'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = True
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 325
    Width = 515
    Height = 41
    Align = alBottom
    TabOrder = 0
    object cdCount: TLabel
      Left = 8
      Top = 16
      Width = 23
      Height = 13
      Caption = 'CDs:'
    end
    object titelCount: TLabel
      Left = 264
      Top = 16
      Width = 20
      Height = 13
      Caption = 'Titel'
    end
  end
  object DBGrid1: TDBGrid
    Left = 0
    Top = 0
    Width = 257
    Height = 325
    Align = alLeft
    DataSource = CDSource
    Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    TabOrder = 1
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'Anzahl'
        Width = 40
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Interpret'
        Width = 180
        Visible = True
      end>
  end
  object DBGrid2: TDBGrid
    Left = 257
    Top = 0
    Width = 258
    Height = 325
    Align = alClient
    DataSource = TitelSource
    Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit]
    TabOrder = 2
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'MS Sans Serif'
    TitleFont.Style = []
    Columns = <
      item
        Expanded = False
        FieldName = 'Anzahl'
        Width = 40
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'Interpret'
        Width = 180
        Visible = True
      end>
  end
  object CDQuery: TQuery
    DatabaseName = 'theCDbase'
    SessionName = 'theSessionName'
    SQL.Strings = (
      'select'#9'count(*) Anzahl, Interpret'
      'from'#9'cd'
      'group by interpret'
      'order by Anzahl descending, interpret')
    Left = 32
    Top = 40
  end
  object CDSource: TDataSource
    DataSet = CDQuery
    Left = 96
    Top = 40
  end
  object TitelQuery: TQuery
    DatabaseName = 'theCDbase'
    SessionName = 'theSessionName'
    SQL.Strings = (
      'select'#9'count(*) Anzahl, Interpret'
      'from'#9'cd, titel'
      'where'#9'cd.id = titel.cd'#9
      'group by interpret'
      'order by Anzahl descending, interpret')
    Left = 272
    Top = 56
  end
  object TitelSource: TDataSource
    DataSet = TitelQuery
    Left = 336
    Top = 56
  end
  object theTimer: TTimer
    Enabled = False
    OnTimer = theTimerTimer
    Left = 32
    Top = 112
  end
end

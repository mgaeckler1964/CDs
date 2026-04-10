{
		Project:		CDs
		Module:			titelfrm.pas
		Description:	Das Hauptfenster
		Author:			Martin Gäckler
		Address:		Hofmannsthalweg 14, A-4030 Linz
		Web:			https://www.gaeckler.at/

		Copyright:		(c) 1995-2026 Martin Gäckler

		This program is free software: you can redistribute it and/or modify  
		it under the terms of the GNU General Public License as published by  
		the Free Software Foundation, version 3.

		You should have received a copy of the GNU General Public License 
		along with this program. If not, see <http://www.gnu.org/licenses/>.

		THIS SOFTWARE IS PROVIDED BY Martin Gäckler, Linz, Austria ``AS IS''
		AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
		TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
		PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE AUTHOR OR
		CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
		SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
		LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF
		USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
		ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
		OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT
		OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
		SUCH DAMAGE.
}
unit titelfrm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Mask, DBCtrls, ExtCtrls, DB, DBTables, Grids, DBGrids, MPlayer,
  Menus, DdeMan;

type
  TMainForm = class(TForm)
	CDsource: TDataSource;
	Titelsource: TDataSource;
	CDtable: TTable;
	Titeltable: TTable;
	Panel1: TPanel;
	Panel2: TPanel;
    titelGrid: TDBGrid;
	DBGrid2: TDBGrid;
	theTimer: TTimer;
    MainMenu: TMainMenu;
    Datei1: TMenuItem;
    Berichte1: TMenuItem;
    Ende1: TMenuItem;
	berCDVerwaltung1: TMenuItem;
    System: TDdeServerConv;
    HitListe1: TMenuItem;
	N1: TMenuItem;
    InterpretSource: TDataSource;
    InterpretQuery: TQuery;
    StilSource: TDataSource;
	StilQuery: TQuery;
    FirmaSource: TDataSource;
    FirmaQuery: TQuery;
    CDSpieler1: TMenuItem;
    Lautstrkeregler1: TMenuItem;
    N2: TMenuItem;
    Panel3: TPanel;
    Panel4: TPanel;
    Label3: TLabel;
    Label7: TLabel;
    DBRadioGroup1: TDBRadioGroup;
    DBNavigator2: TDBNavigator;
    Titel: TDBEdit;
    Titelinterpret: TDBEdit;
    GroupBox1: TGroupBox;
    cdPlayer: TMediaPlayer;
    cdPlayerDisplay: TEdit;
    cdMode: TEdit;
    TrackCDTime: TRadioGroup;
    leftTime: TRadioGroup;
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label8: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    DBNavigator1: TDBNavigator;
    CD: TDBEdit;
    DBRadioGroup2: TDBRadioGroup;
    DBEdit1: TDBEdit;
    DBLookupComboBox1: TDBLookupComboBox;
    DBLookupComboBox2: TDBLookupComboBox;
    DBLookupComboBox3: TDBLookupComboBox;
    DBEdit2: TDBEdit;
    DBEdit3: TDBEdit;
    DirectPlay: TButton;
    CmdLabel: TLabel;
    theSession: TSession;
    theDatabase: TDatabase;
	procedure FormClose(Sender: TObject; var Action: TCloseAction);
	procedure FormShow(Sender: TObject);
	procedure theTimerTimer(Sender: TObject);
	procedure cdPlayerNotify(Sender: TObject);
	procedure FormCreate(Sender: TObject);
	procedure berCDVerwaltung1Click(Sender: TObject);
	procedure Berichte1Click(Sender: TObject);
	procedure Ende1Click(Sender: TObject);
	procedure SystemExecuteMacro(Sender: TObject; Msg: TStrings);
	procedure CDtableBeforeDelete(DataSet: TDataSet);
	procedure HitListe1Click(Sender: TObject);
    procedure CDtableBeforeInsert(DataSet: TDataSet);
    procedure TiteltableBeforeInsert(DataSet: TDataSet);
    procedure TiteltableBeforeDelete(DataSet: TDataSet);
    procedure Button1Click(Sender: TObject);
    procedure CDSpieler1Click(Sender: TObject);
    procedure Lautstrkeregler1Click(Sender: TObject);
    procedure DirectPlayClick(Sender: TObject);
  private
	autoEdit : boolean;
	lastCDFound: LongInt;
	lastTrackFound: LongInt;
	procedure checkLoadedCD;
	procedure locateCD;
	{ Private declarations }
  public
	{ Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.DFM}

uses mmsystem, about, bericht, hit;

procedure Milisec2hour( length : LongInt; var hour, min, sec : integer );
begin
	if length > 0 then
	begin
		hour := length div (1000*60*60);
		length := length - hour * 1000*60*60;

		min  := length div (1000*60);
		length := length - min*1000*60;
		sec  := length div 1000;
	end
	else
	begin
		hour := 0;
		min := 0;
		sec := 0;
	end;
end;

function Milisec2Time( length : LongInt ) : TDateTime;
var
	hour, min, sec: Integer;
begin
	Milisec2hour( length, hour, min, sec );
	Milisec2Time := EncodeTime( hour, min, sec, 0 );
end;

procedure TMainForm.locateCD;
var
	i:				Integer;

	playLength:		TDateTime;
	trackLength:	TDateTime;

	playLengthI:	integer;
	trackLengthI:	integer;

	selCD:			TQuery;
	selTitle:		TQuery;

	cdFound:		Boolean;

	newTitle:		string;
begin
	cdPlayer.TimeFormat := tfMilliseconds;

	playLengthI := cdPlayer.length;
	playLength := Milisec2Time( playLengthI );

	cdFound := false;

	selTitle := TQuery.Create( Application );
	with selTitle do
	begin
		DataBaseName := 'theCDbase';
		SessionName := 'theSessionName';
		UniDirectional := false;
		sql.add(	'select nummer, spieldauer ' +
					'from titel ' +
					'where cd = :cd ' +
					'order by nummer' );
	end;

	selCD := TQuery.Create( Application );
	with selCD do
	begin
		DataBaseName := 'theCDbase';
		SessionName := 'theSessionName';
		UniDirectional := false;
		sql.add( 'select id, interpret, Erscheinungsdatum, titel from cd ' +
					'where Spieldauer = :t_length' );
		Params[0].AsTime := playLength;

		open;
		while not cdFound and not eof do
		begin
			selTitle.Params[0].AsInteger := Fields[0].AsInteger;
			with selTitle do
			begin
				open;
				if RecordCount = cdPlayer.Tracks then
				begin
					cdFound := true;
					i := 0;
					while cdFound and not eof do
					begin
						i := i+1;
						trackLength := Milisec2Time( cdPlayer.TrackLength[i] );
						if trackLength <> Fields[1].AsDateTime then
							cdFound := false;
						next;
					end;
				end;
				close;
			end;

			if cdFound then
			begin
				with cdTable do
				begin
					if (lastCDFound <> selCD.Fields[0].AsInteger)
					and (lastCDFound <> Fields[0].AsInteger)
					and (state <> dsEdit)
					and (state <> dsInsert) then
					begin
						lastCDfound := selCD.Fields[0].AsInteger;
						SetKey;
						FieldByName( 'interpret' ).AsString := selCD.FieldByName( 'interpret' ).AsString;
						FieldByName( 'Erscheinungsdatum' ).AsInteger := selCD.FieldByName( 'Erscheinungsdatum' ).AsInteger;
						FieldByName( 'titel' ).AsString := selCD.FieldByName( 'titel' ).AsString;
						KeyFieldCount := 3;
						GotoKey;
					end;
				end;

				newTitle := '';
				if cdTable.Fields[0].AsInteger = lastCDFound then
				begin
					newTitle := cdTable.FieldByName( 'interpret' ).AsString + ': ' +
								cdTable.FieldByName( 'titel' ).AsString + ' ';
				end;
				newTitle := newTitle + '(' + cdPlayerDisplay.Text + ')';
				Application.Title := newtitle;
				MainForm.Caption := newtitle;
			end;

			next;
		end;
		close;
		free;
	end;

	selTitle.free;

	if not cdFound then
	begin
		autoEdit := true;
		with cdTable do
		begin
			insert;
			FieldByName( 'interpret' ).AsString := 'Unbekannt';
			FieldByName( 'titel' ).AsString := 'Unbekannt';
			FieldByName( 'spieldauer' ).AsDateTime := playLength;
			FieldByName( 'AutoCreate' ).AsBoolean := true;
			post;
		end;
		with titelTable do
			for i := 1 to cdPlayer.Tracks do
			begin
				trackLengthI := cdPlayer.TrackLength[i];
				playLengthI := playLengthI - trackLengthI;

				if playLengthI < -60000 then
					break	{ sometimes the CD-Player gives stupid data }
				else
				begin
					insert;
					FieldByName( 'cd' ).AsInteger := cdTable.FieldByName( 'Id' ).AsInteger;
					FieldByName( 'nummer' ).AsInteger := i;
					FieldByName( 'titel' ).AsString := 'Unbekannt';
					FieldByName( 'Spieldauer' ).AsDateTime := Milisec2Time( trackLengthI );
					post;
				end;
			end;
		autoEdit := false;
		MainForm.Caption := 'Unbekannte CD';
		Application.Title := MainForm.Caption;

		if playLengthI < -60000 then { delete stupid data }
		begin
			cdTable.delete;
			cdTable.first;
		end;
	end;
	cdPlayer.TimeFormat := tfTMSF;
end;

procedure TMainForm.checkLoadedCD;
var
	track, length, hour, min, sec:		Integer;
	newTitle:							string;
begin
	case cdPlayer.Mode of
	mpStopped, mpOpen:
		begin
			theTimer.Interval := 10000;
			cdPlayer.TimeFormat := tfMilliseconds;

			milisec2hour( cdPlayer.Length, hour, min, sec );

			if (cdPlayer.Tracks <200) and (cdPlayer.Length > 0) and ((min>0) or (hour>0) or (sec>0))then
			begin
				cdPlayerDisplay.Text := intToStr( cdPlayer.Tracks ) + ' ' +
										intToStr( hour ) + ':' +
										intToStr( min ) + ':' +
										intToStr( sec );
				locateCD;
			end
			else
			begin
				MainForm.Caption := 'Keine Audio-CD';
				Application.Title := MainForm.Caption;

				cdPlayerDisplay.Text := 'Keine Audio-CD';
				lastCDfound := -1;
				lastTrackFound := -1;
			end;
			cdPlayer.TimeFormat := tfTMSF;
		end;
	mpPlaying:
		begin
			cdPlayer.TimeFormat := tfTMSF;
			track	:= mci_TMSF_Track( cdPlayer.position );

			theTimer.Interval := 1000;
				newTitle := '';
			if TrackcdTime.itemIndex = 0 then { Track }
			begin
				min		:= mci_TMSF_Minute( cdPlayer.position );
				sec		:= mci_TMSF_Second( cdPlayer.position );

				if track < 10 then
					newTitle := '0';
				newtitle := newTitle + intToStr( track ) + ' ';

				if leftTime.itemIndex <> 0 then { bisher }
				begin
					cdPlayer.TimeFormat := tfMilliseconds;
					length := cdPlayer.TrackLength[track] - ((min*60)+sec)*1000;

					milisec2hour( length, hour, min, sec );

					newtitle := newTitle + '-';
					cdPlayer.TimeFormat := tfTMSF;
				end;
			end
			else	{ CD-Time }
			begin
				cdPlayer.TimeFormat := tfMilliseconds;
				if leftTime.itemIndex = 0 then
				begin
					length := cdPlayer.position;
					milisec2hour( length, hour, min, sec );
					cdPlayerDisplay.Text := intToStr( hour ) + ':' +
											intToStr( min ) + ':' +
											intToStr( sec );
				end
				else
				begin
					length := cdPlayer.length - cdPlayer.position;
					milisec2hour( length, hour, min, sec );

					newtitle := newTitle + '-';
				end;

				if hour < 10 then
					newTitle := newTitle + '0';
				newTitle := newTitle + intToStr( hour ) + ':';
				cdPlayer.TimeFormat := tfTMSF;
			end;

			if min < 10 then
				newtitle := newTitle + '0';
			newTitle := newTitle + intToStr( min ) + ':';

			if sec < 10 then
				newtitle := newTitle + '0';
			newtitle := newTitle + intToStr( sec );

			cdPlayerDisplay.Text := newtitle;

			if lastCDFound = -1 then
				locateCD;

			with titelTable do
			begin
				if (lastCDfound = Fields[0].AsInteger)
				and (track <> Fields[1].AsInteger)
				and ((Fields[1].AsInteger = lastTrackFound) or (lastTrackFound = -1))
				and (state <> dsEdit)
				and (state <> dsInsert) then
				begin
					SetKey;
					Fields[0].AsInteger := lastCDfound;
					Fields[1].AsInteger := track;
					KeyFieldCount := 2;
					GotoKey;
				end;
				lastTrackFound := track;
			end;

			newTitle := '';
			if cdTable.Fields[0].AsInteger = lastCDFound then
			begin
				newTitle := cdTable.FieldByName( 'interpret' ).AsString + ': ' +
							cdTable.FieldByName( 'titel' ).AsString;

				if  (titelTable.Fields[0].AsInteger = lastCDfound)
				and (titelTable.Fields[1].AsInteger = track) then
				begin
					newTitle := newTitle  + ': ' +
								titelTable.FieldByName( 'titel' ).AsString;
				end;
			end;
			if newTitle > '' then
				newTitle := newtitle + ' ';

			newTitle := newTitle + '(' + cdPlayerDisplay.Text + ')';

			Application.Title := newtitle;
			MainForm.Caption := newtitle;
		end;
	else { unknown mode }
		cdPlayerDisplay.Text := '';
		MainForm.Caption := 'CD-Verwaltung';
		Application.Title := MainForm.Caption;
	end;
	case cdPlayer.Mode of
		mpStopped:	cdMode.Text := 'Stop';
		mpOpen:		cdMode.Text := 'Open';
		mpPlaying:	cdMode.Text := 'Play';
		mpPaused:	cdMode.Text := 'Pause';
		mpNotReady:	cdMode.Text := 'not ready';
		else		cdMode.Text := 'unknown';
	end;
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
	 Application.Terminate;
end;

procedure TMainForm.FormShow(Sender: TObject);
var
	selTC: TQuery;
begin
	try
		theSession.Open;
		theDatabase.Open;

		InterpretQuery.Open;
		StilQuery.Open;
		FirmaQuery.Open;

		CDTable.Open;
		TitelTable.Open;
	except
		else
		begin
			theSession.Close;
			theDatabase.Close;

			theSession.NetFileDir := 'C:\';
			theDatabase.AliasName := 'CD_LOCAL';

			theSession.Open;
			theDatabase.Open;

			InterpretQuery.Open;
			StilQuery.Open;
			FirmaQuery.Open;

			CDTable.Open;
			TitelTable.Open;
		end;
	end;

	autoEdit := false;
	lastCdFound := -1;
	lastTrackFound := -1;
	checkLoadedCD;
	cdPlayer.notify := true;

	selTC := TQuery.create( Application );
	with selTC do
	begin
		DatabaseName := 'theCDbase';
		SessionName := 'theSessionName';
		Unidirectional := true;

		sql := interpretquery.sql;
		open;
		titelGrid.Columns[0].picklist.clear;
		while not eof do
		begin
			titelGrid.Columns[0].picklist.add( Fields[0].AsString );
			next;
		end;
		close;

		sql := stilQuery.sql;
		open;
		titelGrid.Columns[4].picklist.clear;
		while not eof do
		begin
			titelGrid.Columns[4].picklist.add( Fields[0].AsString );
			next;
		end;
		close;

		sql := firmaQuery.sql;
		open;
		titelGrid.Columns[5].picklist.clear;
		while not eof do
		begin
			titelGrid.Columns[5].picklist.add( Fields[0].AsString );
			next;
		end;
		close;

		free;
	end;
end;

procedure TMainForm.theTimerTimer(Sender: TObject);
begin
	checkLoadedCD;
end;

procedure TMainForm.cdPlayerNotify(Sender: TObject);
begin
	checkLoadedCD;
	cdPlayer.notify := true;
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
	myName		: array[0..1024] of char;
	typeName	: array[0..1024] of char;
	typeSize	: integer;
	{ key handles for CD }
	playKey,
	cmdKey,
	ddeKey,
	appKey	: HKEY;
	{ key handles for tracks }
	cdaKey,
	typeKey	: HKEY;
begin
{
	if FindWindow( 'TTitel', 'CD-Verwaltung' ) = null then
		Application.Terminate;

	TitelTable.open;
	CDTable.open;
}
	try
		cdPlayer.open;
	except
		on Exception do
		begin
			cdPlayer.enabled := false;
		end;
	end;
	GetModuleFileName( 0, myName, 1024 );
	if RegCreateKey( HKEY_CLASSES_ROOT, 'AudioCD\shell\play', playKey ) = 0 then
	begin
		if RegCreateKey( playKey, 'command', cmdKey ) = 0 then
		begin
			RegSetValue( cmdKey, '', REG_SZ, myName, StrLen( myName ) );
			RegCloseKey( cmdKey );
		end;
		if RegCreateKey( playKey, 'ddeexec', ddeKey ) = 0 then
		begin
			RegSetValue( ddeKey, '', REG_SZ, 'play %1', 7 );
			if RegCreateKey( ddeKey, 'Application', appKey ) = 0 then
			begin
				RegSetValue( appKey, '', REG_SZ, 'CD_VERW', 7 );
				RegCloseKey( appKey );
			end;
			RegCloseKey( ddeKey );
		end;
		RegCloseKey( playKey );
	end;
	if RegCreateKey( HKEY_CLASSES_ROOT, '.cda', cdaKey ) = 0 then
	begin
		typeSize := 1024;
		RegQueryValue( cdaKey, '', typeName, typeSize );
		if typeSize = 0 then
		begin
			typeName := 'cdafile';
			typeSize := StrLen( typeName );
			RegSetValue( cdaKey, '', REG_SZ, typeName, typeSize );
		end;
		if RegCreateKey( HKEY_CLASSES_ROOT, typeName, typeKey ) = 0 then
		begin
			if RegCreateKey( typeKey, 'shell\play', playKey ) = 0 then
			begin
				if RegCreateKey( playKey, 'command', cmdKey ) = 0 then
				begin
					RegSetValue( cmdKey, '', REG_SZ, myName, StrLen( myName ) );
					RegCloseKey( cmdKey );
				end;
				if RegCreateKey( playKey, 'ddeexec', ddeKey ) = 0 then
				begin
					RegSetValue( ddeKey, '', REG_SZ, 'play %1', 7 );
					if RegCreateKey( ddeKey, 'Application', appKey ) = 0 then
					begin
						RegSetValue( appKey, '', REG_SZ, 'CD_VERW', 7 );
						RegCloseKey( appKey );
					end;
					RegCloseKey( ddeKey );
				end;
				RegCloseKey( playKey );
			end;
			RegCloseKey( typeKey );
		end;
		RegCloseKey( cdaKey );
	end;
end;

procedure TMainForm.berCDVerwaltung1Click(Sender: TObject);
begin
	AboutBox.showModal;
end;

procedure TMainForm.Berichte1Click(Sender: TObject);
begin
	berichtForm.showModal;
end;

procedure TMainForm.Ende1Click(Sender: TObject);
begin
	Application.Terminate;
end;

procedure TMainForm.SystemExecuteMacro(Sender: TObject;
  Msg: TStrings);
var
	command,
	arg,
	track : string;
	newPos : Integer;
begin
	command := Copy( Msg.strings[0], 0, 5 );
	arg := Copy( Msg.strings[0], 6, Length(Msg.strings[0])) ;
	track := Copy( arg, 9, 2 );

	if Length( track ) > 0 then
		newPos := StrToInt( track )
	else
		newPos := 1;

	if( command = 'play ' ) then
	begin
		cdPlayer.stop;
		cdPlayer.TimeFormat := tfTMSF;
		cdPlayer.position := newPos;
		cdPlayer.play;
	end;

	{ CmdLabel.Caption := command + '-' + arg + '-' + track + '-'; }
end;

procedure TMainForm.CDtableBeforeDelete(DataSet: TDataSet);
begin
	autoEdit := true;
	while titelTable.RecordCount > 0 do
		titelTable.delete;
	autoEdit := false;
end;

procedure TMainForm.HitListe1Click(Sender: TObject);
begin
	HitListForm.Show;
end;

procedure TMainForm.CDtableBeforeInsert(DataSet: TDataSet);
begin
	if not autoEdit then
		abort;
end;

procedure TMainForm.TiteltableBeforeInsert(DataSet: TDataSet);
begin
	if not autoEdit then
		abort;
end;

procedure TMainForm.TiteltableBeforeDelete(DataSet: TDataSet);
begin
	if not autoEdit then
		abort;
end;

procedure TMainForm.Button1Click(Sender: TObject);
begin
	lastCDFound := -1;
	lastTrackFound := -1;
	locateCD;
end;

procedure TMainForm.CDSpieler1Click(Sender: TObject);
var
	result:	integer;
begin
	result := WinExec( 'cdplayer.exe', SW_SHOW );
	if result <= 31 then
		MessageDlg( 'Error Code ' + IntToStr( result ), mtError, [mbOK], -1 );
end;

procedure TMainForm.Lautstrkeregler1Click(Sender: TObject);
var
	result:	integer;
begin
	result := WinExec( 'sndvol32.exe', SW_SHOW );
	if result <= 31 then
		MessageDlg( 'Error Code ' + IntToStr( result ), mtError, [mbOK], -1 );
end;

procedure TMainForm.DirectPlayClick(Sender: TObject);
begin
	if cdTable.Fields[0].AsInteger = lastCDFound then
	begin
		if TitelTable.Fields[1].AsInteger <> lastTrackFound then
		begin
			cdPlayer.stop;
			cdPlayer.Position := TitelTable.Fields[1].AsInteger;
			cdPlayer.play;
		end;
	end;
end;

end.

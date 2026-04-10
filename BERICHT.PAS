{
		Project:		CDs
		Module:			bericht.pas
		Description:	das berichtsformular
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
unit bericht;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, DB, DBTables;

type
  TberichtForm = class(TForm)
    Button1: TButton;
    Button2: TButton;
    label3: TLabel;
    label2: TLabel;
    interpret: TComboBox;
    Stilrichtung: TComboBox;
    label1: TLabel;
    Spielzeit: TEdit;
    Panel1: TPanel;
    Live: TRadioButton;
    Studio: TRadioButton;
    Egal: TRadioButton;
    berichtTabelle: TTable;
    interpretQry: TQuery;
    stilQuery: TQuery;
    Interpret2Query: TQuery;
    stil2Query: TQuery;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
    procedure checkPlayTime( berichtId: Integer );
  public
    { Public declarations }
  end;

var
  berichtForm: TberichtForm;

implementation

uses layout;

{$R *.DFM}

procedure TberichtForm.checkPlayTime( berichtId: Integer );
var
	actZeit:	TDateTime;
	wunschZeit:	TDateTime;
	gesamtZeit:	TDateTime;

    selTime:	TQuery;
    delTitel:	TQuery;
begin
	wunschZeit := StrToTime( Spielzeit.Text );
	gesamtZeit := 0;

    delTitel := TQuery.Create( Application );
	with delTitel do
    begin
		DatabaseName := 'theCDbase';
		SessionName := 'theSessionName';

	    sql.add( 'delete from bericht where cd = :cd and titel = :titel and bericht = :berichtId' );
    end;

    selTime := TQuery.Create( Application );
    with selTime do
    begin
		DatabaseName := 'theCDbase';
		SessionName := 'theSessionName';
        UniDirectional := true;

        { SQL.CLEAR; }
        sql.add( 'select distinct bericht.cd, bericht.titel, titel.spieldauer' );
        sql.add( 'from   titel t, bericht b' );
        sql.add( 'where  bericht = :berichtId and' );
        sql.add( '       b.cd = t.cd and' );
        sql.add( '       b.titel = t.nummer' );

        Params[0].AsFloat := berichtId;

        open;
        { first; }
        while not eof do
        begin
        	if Fields[2].isNull then
            begin
            	delTitel.params[0].AsInteger := selTime.Fields[0].AsInteger;
                delTitel.params[1].AsInteger := selTime.Fields[1].AsInteger;
                delTitel.params[2].AsFloat   := berichtId;

                delTitel.execSql;
            end
            else
            	gesamtZeit := gesamtZeit + Fields[2].AsDateTime;

			next;
		end;
		close;

		{ wir wissen nun die gasamtzeit des berichts }
		while wunschZeit < gesamtZeit do
		begin
			open;

			{
				jetzt löschen wir so lange zufällige titel, bis die
              	gesamtzeit <= wunschzeit ist
            }
            randomize;

			MoveBy( random( RecordCount ) );

            actZeit := Fields[2].AsDateTime;
            if( actZeit < 0 ) then
            	gesamtZeit := 0
            else
				gesamtZeit := gesamtZeit - actZeit;


            delTitel.params[0].AsInteger := selTime.Fields[0].AsInteger;
            delTitel.params[1].AsInteger := selTime.Fields[1].AsInteger;
            delTitel.params[2].AsFloat   := berichtId;

			delTitel.execSql;

            close;
		end;

		free;
	end;

	delTitel.free;
end;

procedure TberichtForm.Button1Click(Sender: TObject);
var
   berichtId:	Integer;
   sqlBefehl:	TQuery;
begin
	Cursor := crHourglass;

	with berichtTabelle do
	begin
		exclusive := true;
		open;

		{ generate a unique id for the report }
{

does not work ???

		if RecordCount > 0 then
		begin
			Last;
			berichtId := fields[0].AsInteger;
			berichtId := berichtId +1;
		end
		else
			berichtId := 1;
}
		{ clear the berichts table }
		berichtId := 1;
		emptyTable;

{
	insert into bericht
	(
	   bericht, cd, titel
	)
	select 1, t.cd, t.nummer
	from cd c, titel t
	where c.id = t.cd and
	(c.live_studioaufnahme = 'L' or t.live_studioaufnahme = 'L' ) and
	(c.interpret = 'Led Zeppelin' or t.interpret = 'Led Zeppelin' )
}
		sqlBefehl := TQuery.Create( Application );
		with sqlBefehl do
		begin
			DatabaseName := 'theCDbase';
			SessionName := 'theSessionName';
			{ select all CDs matching the where clause }
			with SQL do
			begin
				clear;
				Add( 'insert into bericht ( bericht, cd, titel )' );
				Add( 'select :bericht, t.cd, t.nummer from cd c, titel t' );
				add( 'where t.cd = c.id' );
				if interpret.text > '' then
					add( 'and (t.interpret = ''' + interpret.text + ''' or c.interpret = ''' + interpret.text + ''')' );
				if stilrichtung.text > '' then
					add( 'and (t.stilrichtung = ''' + stilrichtung.text + ''' or c.stilrichtung = ''' + stilrichtung.text + ''')' );
				if live.checked then
					add( 'and (t.Live_Studioaufnahme = ''L'' or c.Live_Studioaufnahme = ''L'')' );
				if studio.checked then
					add( 'and (t.Live_Studioaufnahme = ''S'' or c.Live_Studioaufnahme = ''S'')' );
			end;

			Params[0].AsFloat := berichtId;

			execSql;

		end;

		close;
		exclusive := false;

		if spielzeit.text > '' then
			checkPlayTime( berichtId );

	end;

	Cursor := crDefault;

	with berichtLayout do
	begin

		sqlBefehl.close;
		{ sqlBefehl.params[0].AsFloat := berichtId;   --- does not work }
		sqlBefehl.open;
		QuickReport.Preview;
	end;
end;

procedure TberichtForm.FormShow(Sender: TObject);
begin
	with InterpretQry do
	begin
		open;
		Interpret.Items.Clear;
		Interpret.Items.Add( '' );
		first;
		while not EOF do
		begin
			Interpret.Items.Add( FieldByName
                        ( 'Interpret' ).AsString );
			Next;
		end;
        close;
    end;

    with Interpret2Query do
    begin
        open;
        first;
        while not EOF do
        begin
            Interpret.Items.Add( FieldByName
                    ( 'Interpret' ).AsString );
            Next;
        end;
        close;
    end;

    with stilQuery do
    begin
        open;
        Stilrichtung.Items.Clear;
        Stilrichtung.Items.Add( '' );
        first;
        while not EOF do
        begin
            Stilrichtung.Items.Add( FieldByName
                    ( 'Stilrichtung' ).AsString );
            Next;
        end;
        close;
    end;
    with stil2Query do
    begin
        open;
        first;
        while not EOF do
        begin
            Stilrichtung.Items.Add( FieldByName
                    ( 'Stilrichtung' ).AsString );
            Next;
        end;
        close;
    end;
end;

end.

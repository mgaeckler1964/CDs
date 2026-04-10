{
		Project:		CDs
		Module:			hit.pas
		Description:	Lieblingssongs
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
unit hit;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  DB, DBTables, Grids, DBGrids, ExtCtrls, StdCtrls;

type
  THitListForm = class(TForm)
	Panel1: TPanel;
	DBGrid1: TDBGrid;
	DBGrid2: TDBGrid;
	CDQuery: TQuery;
	CDSource: TDataSource;
	TitelQuery: TQuery;
	TitelSource: TDataSource;
	cdCount: TLabel;
	titelCount: TLabel;
    theTimer: TTimer;
	procedure FormShow(Sender: TObject);
	procedure FormClose(Sender: TObject; var Action: TCloseAction);
	procedure theTimerTimer(Sender: TObject);
  private
	{ Private declarations }
	interpret : string;
  public
	{ Public declarations }
  end;

var
  HitListForm: THitListForm;

implementation

{$R *.DFM}

procedure THitListForm.FormShow(Sender: TObject);
var
	countTC:	TQuery;
begin
	interpret := '';

	cdQuery.open;
	titelQuery.open;

	countTC := TQuery.Create( Application );
	with countTC do
	begin
		DatabaseName := 'theCDbase';
		SessionName := 'theSessionName';

		SQL.ADD( 'Select count(*) from cd' );

		open;
		if not eof then
			cdCount.Caption := IntToStr( Fields[0].AsInteger ) + ' CDs';
		close;

		sql.clear;
		sql.add( 'Select count(*) from titel' );

		open;
		if not eof then
			titelCount.Caption := IntToStr( Fields[0].AsInteger ) + ' Titel';
		close;

		free;
	end;

	theTimer.Enabled := true;
end;

procedure THitListForm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
	theTimer.Enabled := false;

	cdQuery.close;
	titelQuery.close;
end;

procedure THitListForm.theTimerTimer(Sender: TObject);
begin

	if interpret = '' then
		Interpret := titelQuery.Fields[1].AsString;

	with titelQuery do
	begin
		if (cdQuery.Fields[1].AsString <> Interpret)
		and (Fields[1].AsString = Interpret) then
		begin
			DisableControls;
			Interpret := cdQuery.Fields[1].AsString;

			first;
			while (not eof) and (Fields[1].AsString <> Interpret) do
				next;

			EnableControls;
		end;
	end;

	with cdQuery do
	begin
		if (titelQuery.Fields[1].AsString <> Interpret)
		and (Fields[1].AsString = Interpret) then
		begin
			DisableControls;
			Interpret := titelQuery.Fields[1].AsString;

			first;
			while (not eof) and (Fields[1].AsString <> Interpret) do
				next;

			EnableControls;
		end;
	end;
end;

end.

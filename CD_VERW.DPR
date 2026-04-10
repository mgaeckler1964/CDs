{
		Project:		CDs
		Module:			cd_verw.pas
		Description:	Das Hauptprogramm
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
program cd_verw;

uses
  Windows,
  Forms,
  SysUtils,
  titelfrm in 'titelfrm.pas' {MainForm},
  about in 'about.pas' {AboutBox},
  layout in 'layout.pas' {berichtLayout},
  bericht in 'bericht.pas' {berichtForm},
  hit in 'hit.pas' {HitListForm};

{$R *.RES}
{
var
	myFile 		: array [0..1024] of char;
	myFileStr	: string;
}
begin
{
	Why?
	GetModuleFileName( 0, myFile, 1024 );
	myFileStr := myFile;

	ChDir( ExtractFileDir( myFileStr ) );
}
	Application.Initialize;
	Application.Title := 'CD Verwaltung';
	Application.HelpFile := 'CD_VERW.HLP';
	Application.CreateForm(TMainForm, MainForm);
	Application.CreateForm(TAboutBox, AboutBox);
	Application.CreateForm(TberichtLayout, berichtLayout);
	Application.CreateForm(TberichtForm, berichtForm);
	Application.CreateForm(THitListForm, HitListForm);
	Application.Run;
end.

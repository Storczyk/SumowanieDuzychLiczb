unit Unit1;
{$mode objfpc}{$H+}
interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics,
  Dialogs, StdCtrls, ExtCtrls, Buttons, Menus, Unit2;

type
  { TForm1 }
  TForm1 = class(TForm)
    Image1: TImage;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    AktualnyCzasText: TStaticText;
    Instrukcja: TStaticText;
    Credits: TStaticText;
    Timer1: TTimer;
    ZapisDoPliku: TButton;
    CzyscListe: TButton;
    PoleZapisPlik: TEdit;
    KoniecProgramu: TButton;
    DodajLiczbe: TButton;
    DaneZPliku: TButton;
    PoleLiczba: TEdit;
    PoleOdczytPlik: TEdit;
    LabelLiczba: TLabel;
    LabelPlik: TLabel;
    PoleWynikPrzyblizony: TLabeledEdit;
    PoleWynikDokladny: TLabeledEdit;
    ListaLiczb: TListBox;
    OpenDialog1: TOpenDialog;
    procedure FormCreate(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);      //odswieza aktualny czas
    procedure ZapisDoPlikuClick(Sender: TObject);
    procedure PoleZapisPlikClick(Sender: TObject);
    procedure PoleZapisPlikEditingDone(Sender: TObject); //dodaje .txt
    procedure CzyscListeClick(Sender: TObject); //Czyść liste
    procedure DaneZPlikuClick(Sender: TObject); //odczytaj dane z pliku
    procedure PoleLiczbaClick(Sender: TObject); //czysc editboxa
    procedure PoleLiczbaKeyPress(Sender: TObject; var Key: char); //filtr znaków; miejsce wpisywania liczby
    procedure DodajLiczbeClick(Sender: TObject);//przycisk dodajliczbe-uruchamia procedure Dodaj(s);
    procedure Dodaj(s:string);
    procedure Wyrownaj();                       //wyrownywanie liczb na liscie
    procedure DodawaniePrzyblizone();
    procedure DodawanieWszystkich();
    function DodawanieDwoch(a:string; b:string):string;
    function IleZer(liczba:string):integer;
    procedure KoniecProgramuClick(Sender: TObject);
  private
  public

  end;

var
  Form1: TForm1;

implementation
{$R *.lfm}
 uses unit3;
procedure TForm1.FormCreate(Sender: TObject);
begin
  SetLength(TablicaLiczb, 0);
end;

procedure TForm1.MenuItem1Click(Sender: TObject);
begin
  Form2:=TForm2.Create(nil);
  Form2.showmodal;
  freeandnil(form2);
end;

procedure TForm1.MenuItem2Click(Sender: TObject);
begin
  if Instrukcja.Visible=false then begin
   Instrukcja.visible:=true;
   credits.visible:=false;
   end else begin
     Instrukcja.visible:=false;
     credits.visible:=true;
   end;
end;

procedure TForm1.MenuItem3Click(Sender: TObject);
begin
     if Credits.Visible=true then credits.visible:=false
     else begin
       credits.visible:=true;
       instrukcja.Visible:=false;
     end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  AktualnyCzasText.Caption:='Aktualny czas: ' + timetostr(Time);
end;

procedure TForm1.ZapisDoPlikuClick(Sender: TObject);
var plik: textfile;
  s:string;
  i:integer;
  teraz:TDateTime  ;
begin
  teraz:=now;
  s:=PoleZapisPlik.Text+'_'+FormatDateTime('MM-DD-HH-NN-SS',teraz);
  assignfile(plik, s);
    rewrite(plik);
    writeln(plik,'Dodawanie liczb:');
    if length(tablicaliczb)=1 then writeln(plik, tablicaliczb[0].getZawartosc());
    if length(tablicaliczb)=0 then begin showmessage('Brak liczb do zapisania!'); exit; end;
    for i:=1 to length(TablicaLiczb)-1 do
    begin
      s:=TablicaLiczb[i].getZawartosc();
      writeln(plik, s);
    end;
    writeln(plik,'Wynik przyblizony: '+PoleWynikPrzyblizony.Text);
    writeln(plik, 'Wynik dokladny: '+PoleWynikDokladny.Text);
    ShowMessage('Zapisywanie do pliku: '+s+' udane!');
  closefile(plik);
end;

procedure TForm1.PoleZapisPlikClick(Sender: TObject);
begin
  PoleZapisPlik.Text:='';
end;

procedure TForm1.PoleZapisPlikEditingDone(Sender: TObject);
var czy:integer;
begin
  czy:=pos('.txt', PoleZapisPlik.text)    ;
  if czy=0 then PoleZapisPlik.text:=PoleZapisPlik.text + '.txt';
end;

procedure TForm1.CzyscListeClick(Sender: TObject);
var i:integer;
begin
  for i:=0 to length(TablicaLiczb)-1 do  //czyszczenie tablicy obiektów
  begin
    TablicaLiczb[i]:=nil;
  end;
  PoleZapisPlik.Text:='';
  PoleWynikDokladny.Text:='';
  PoleWynikPrzyblizony.Text:='';
  SetLength(TablicaLiczb, 0);
  ListaLiczb.Clear;
end;

procedure TForm1.DaneZPlikuClick(Sender: TObject);
var
Dialog : TOpenDialog;
plik: TextFile;
s: string;
begin
  Dialog:=TOpenDialog.Create(self);
  Dialog.Filter :='Text file|*.txt|';   //
  if Dialog.execute then begin
    PoleOdczytPlik.Text:=(Dialog.filename);
    AssignFile(plik,(Dialog.filename));
    reset(plik);                          //reset potrzebny do odczytu
    while not EoF(plik) do
    begin
      readln(plik, s);
      dodaj(s);
    end;
    CloseFile(plik);
  end;
  Dialog.free;
end;

procedure TForm1.PoleLiczbaClick(Sender: TObject);
begin
  PoleLiczba.Text:='';
end;
                  //miejsce wpisywania liczby
procedure TForm1.PoleLiczbaKeyPress(Sender: TObject; var Key: char);
var i,ile:integer;
begin
  ile:=0;
  for i:=1 to length(PoleLiczba.Text) do begin
    if PoleLiczba.text[i]=',' then inc(ile);
  end;
  if ((ile>=1) and (key=',')) then begin
    key:=#0;
    exit;
  end;
  if Key=#13 then Dodaj(PoleLiczba.text);   //jesli enter to uruchamia procedure dodaj(s)
  if (Key in ['0'..'9', ',', #8 ]) then begin
   exit;
   end;
  key:=#0;
   //#8 backspace
   //blokuje wpisywanie danych innych niż litera, przecinek, backspace
end;

                   //przycisk 'dodaj liczbe'
procedure TForm1.DodajLiczbeClick(Sender: TObject);
begin
  Dodaj(PoleLiczba.Text);
end;

procedure TForm1.Dodaj(s:string);
var obiekt:TLiczba;
begin
  obiekt:=TLiczba.Create();
  if obiekt.checkZawartosc(s)=1 then  //sprawdzanie czy zawartosc jest liczbą
  begin
    if s[length(s)]=',' then s:=s+'0';//jesli jest przecinek na ostatniej pozycji dodaj 0
    if s[1]=',' then s:='0'+s;
    obiekt.setZawartosc(s);
    if ((length(tablicaliczb))=1) then begin
      setlength(tablicaliczb,3);
      tablicaliczb[2]:=obiekt;
      tablicaliczb[1]:=TLiczba.create();
      tablicaliczb[1].setZawartosc(tablicaliczb[0].getZawartosc());
    end else if length(tablicaliczb)<>1 then
    begin
      setlength(TablicaLiczb, length(TablicaLiczb)+1);
      TablicaLiczb[length(TablicaLiczb)-1]:=obiekt;
    end;
    Wyrownaj();
    DodawaniePrzyblizone();
    DodawanieWszystkich();
    wyrownaj();
  end;
end;

 procedure TForm1.Wyrownaj();
 var i,k,z,dl1,dl2, dl_maxa, dl_maxb,dl_max_a, dl_max_b:integer;   //maxa max dlugosc stringa przed przecinkiem  dla calej tab
     s:string;                                     //maxbb max dlugosc stringa po przecinku  dla calej tab
begin                                             //max calkowita dlugosc stringa
    dl_maxa:=0; dl_maxb:=0;          //dl1 dl2 tymczasowa dlugosc danego stringa
  for i:=0 to length(TablicaLiczb)-1 do
  begin
   dl_max_a:=0; dl_max_b:=0;
   s:=TablicaLiczb[i].getZawartosc();
   for z:=1 to length(s) do
   begin
     if s[z]=',' then break;
     inc(dl_max_a);   //licz ile jest liczb przed przecinkiem
   end;
   if dl_max_a=length(s) then TablicaLiczb[i].setZawartosc(s+',0');
   for z:=dl_max_a+1 to length(s)-1 do
     inc(dl_max_b); //licz ile jest liczb po przecinku
   if dl_maxa<dl_max_a then
     dl_maxa:=dl_max_a; //zastąpienie nowym max_a
   if dl_maxb<dl_max_b then
     dl_maxb:=dl_max_b; //zastąpienie nowym max_b
  end;

 for i:=0 to length(TablicaLiczb)-1  do
 begin
   dl1:=0;dl2:=0;
   s:=TablicaLiczb[i].getZawartosc();
   for z:=1 to length(s) do
   begin
     if s[z]=',' then break;
     inc(dl1);   //licz ile jest liczb przed przecinkiem w i-tym wyrazie
   end;
     for z:=dl1+1 to length(s)-1 do inc(dl2); //licz ile jest liczb po przecinku w i-tym wyrazie
     for k:=1 to (dl_maxa-dl1) do s:='0'+s;
     for k:=1 to dl_maxb-dl2 do s:=s+'0';
   TablicaLiczb[i].setSformatowanaZawartosc(s);
 end;
 ListaLiczb.Clear;
 if length(tablicaliczb)=1 then ListaLiczb.Items.Add(Tablicaliczb[0].getSformatowanaZawartosc());
  for i:=1 to length(TablicaLiczb)-1 do
  begin
    ListaLiczb.Items.add(TablicaLiczb[i].getSformatowanaZawartosc());
  end;

end;

procedure TForm1.DodawaniePrzyblizone();
var s:string;
  suma, k:extended;
  i:integer;
begin
  suma:=0;k:=0;
  if (length(TablicaLiczb)=1) then PoleWynikPrzyblizony.Text:=TablicaLiczb[0].getzawartosc() else
  begin
    for i:=1 to length(TablicaLiczb)-1 do
    begin
      s:=TablicaLiczb[i].getZawartosc();
      k:=strtofloat(s);
      suma:=suma+k;
    end;
    PoleWynikPrzyblizony.Text:=floattostr(suma);
  end;
end;

procedure TForm1.DodawanieWszystkich();
var suma:string;
begin
   suma:=TablicaLiczb[0].getsformatowanaZawartosc();
   if length(tablicaliczb)>1 then begin
     suma:=(dodawaniedwoch(TablicaLiczb[length(tablicaliczb)-1].getSformatowanaZawartosc(), suma));
     delete(suma, 1, IleZer(suma));
     tablicaliczb[0].setzawartosc(suma);
   end;
   PoleWynikDokladny.Text:=suma;
end;

function TForm1.DodawanieDwoch(a:string; b:string):string;
var suma:string;
 c, z, x, m, p, pos2:integer;
begin
  pos2:=pos(',', b);
  setlength(suma, length(b));
  m:=0;
  for p:=length(suma) downto 1 do
  begin
    if (a[p]=',') then continue;
    z:=ord(a[p])-48; x:=ord(b[p])-48;
    if m=1 then begin
    c:=z+x+1;
    m:=0;
    end
    else c:=z+x;
    if c>=10 then m:=1 else m:=0;
    if m=1 then suma[p]:=chr((c mod 10)+48) else suma[p]:=chr((c)+48) end;
  suma[pos2]:=',';
     if m=1 then suma:=concat('1',suma);
   DodawanieDwoch:=suma;
end;

function TForm1.IleZer(liczba:string):integer;
var i, ile:integer;
begin
  ile:=0;
  for i:=1 to length(liczba) do begin
    if (liczba[i]='0') then inc(ile) else break;
  end;
  IleZer:=ile;
end;

                 //przycisk KoniecProgramu
procedure TForm1.KoniecProgramuClick(Sender: TObject);
var i:integer;
begin
  for i:=0 to length(TablicaLiczb)-1 do  //czyszczenie tablicy obiektów
  begin
    TablicaLiczb[i]:=nil;
  end;
  close;//KoniecProgramu aplikacji
end;

end.


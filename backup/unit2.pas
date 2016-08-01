unit Unit2;
{$mode objfpc}{$H+}
interface

uses
  Classes, SysUtils, Dialogs;
type
  TLiczba = class
  private
    zawartosc : String;                          //Zmienna przechowujaca wartosc liczby
    sformatowanaZawartosc:String;                 //zmienna przechowujaca wyrownana wartosc liczby do innych liczb2
  public
    procedure setZawartosc(liczba:string);             //zapis liczby do zawartosci
    procedure setSformatowanaZawartosc(str:string);    //zapis wyrownanej zawartosci
    function getZawartosc():String;                    //Pobieranie zmiennej zawartosc
    function getSformatowanaZawartosc():String;        //pobieranie sformatowanej zawartosci
    function checkZawartosc(str:string):integer;    //sprawdzanie czy jest liczbą,
  end;

  var
    TablicaLiczb: array of TLiczba;//tablica liczb typu TLiczba


implementation
procedure TLiczba.setZawartosc(liczba:string);
begin
   zawartosc:=liczba;
   setSformatowanaZawartosc(liczba);
end;


function TLiczba.getZawartosc():String;
begin
    getZawartosc:=zawartosc;
end;


procedure TLiczba.setSformatowanaZawartosc(str:string);
begin
   sformatowanaZawartosc:=str;
end;


function TLiczba.getSformatowanaZawartosc():String;
begin
    getSformatowanaZawartosc:=sformatowanaZawartosc;
end;
function TLiczba.checkZawartosc(str:string):integer;  //sprawdzanie czy wpisany ciag jest liczba
var Liczba:string;
    i, k, l_0:integer;   //k-licznik przecinka; l_0 licznik zer
begin
   Liczba:=str;
   if Liczba='' then  //czy pusty znak
   begin
     checkZawartosc:=0;
     exit;
   end;
   k:=0; l_0:=0;
   for i:=1 to (Length(liczba)) do
   begin
      if (Liczba[i]=',') then inc(k);
      if k=length(str) then begin
        checkzawartosc:=0;
        exit;
      end;
      if k>1 then
      begin
        showmessage('Liczba zawiera więcej niż 1 przecinek');
        checkZawartosc:=0;
        exit;
      end;
      if not (Liczba[i] in ['0'..'9', ',' ]) then      //czy jest liczbą rzeczywista
      begin
        checkZawartosc:=0;
        exit;
      end;
      if Liczba[i]='0' then inc(l_0);
   end;
   if (l_0>=length(liczba)) then //sprawdz czy same 0
   begin
     checkZawartosc:=0;
     showmessage('Nie możesz dodać samych 0');
     exit;
   end;
   checkZawartosc:=1;
end;

end.


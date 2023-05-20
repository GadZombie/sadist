unit sad_var;

interface
uses wave,dos,mouse,crt;

type
obrr=array[1..5,0..63,0..9,0..9] of byte;
snieg_tabl=array[1..1000] of record
                     x,y:integer;
                     kol,pod,plan:byte;
                     jest:boolean;
                     end;
paleta_typ=array[0..255,0..2] of byte;
Sc=array [0..199, 0..319] of byte;
fonty_tabl=array[0..59,1..6,1..5] of byte;
menu_ikony_tabl=array[0..9,0..319] of byte;
kowadla_tabl=array[1..10] of record
             x:integer;
             y,Sy,dy:real;
             jest,stoi:byte;
             end;
kowadla_obr_tabl=array[1..6,1..17] of byte;

const
bronie    :array[0..19] of byte=(0,1,18,12,13,11,14,17,15,19, 4, 5,16, 6, 7, 8,10, 9, 2, 3);
                                {0,1, 2, 3, 4, 5, 6, 7, 8, 9,10,11,12,13,14,15,16,17,18,19}
bronie_rev:array[0..19] of byte=(0,1,18,19,10,11,13,14,15,17,16, 5, 3, 4, 6, 8,12, 7, 2, 9);
strz:array[1..3,1..3] of byte=
                      ((255,255,255),
                       (255,254,255),
                       (  0,255,  0));
kolory:array[1..30] of byte=(
                            23, {1  szary}
                            31, {2  bialy}
                            38, {3  c.zolty}
                            45, {4  j.zolty}
                            165,{5  c.zielony}
                            173,{6  j.zielony}
                            180,{7  c.brazowy}
                            52, {8  c.pomaranczowy}
                            185,{9  j.brazowy}
                            60, {10 j.pomaranczowy}
                            70, {11 c.czerwony}
                            85, {12 c.rozowy}
                            94, {13 j. -||-}
                            101,{14 c.fiolet}
                            110,{15 j.-||-}
                            119,{16 c.niebieski}
                            127,{17 j.-||-}
                            76, {18 krew}
                            152,{19 c.metal}
                            159,{20 j.metal}
                            250,{21 rysowanie w tle 1}
                            251,{22 rysowanie w tle 2}
                            141,{23 sople}
                            190,{24 schody}
                            250,{25 most zwykœy}
                            25 ,{26 lina}
                            184,{27 kœadka pozioma}
                            185,{28 belka pionowa}
                            251,{29 belka pionowa w tle}
                            23  {30 cegla szara}
                            );
kol_min:array[0..20] of byte=(24,24,24,24,24,24,79,79,24,24,24,24,127,127,24,24,24,24,24,24,24);
kol_min_bum:array[0..20] of byte=(135,143,143,143,143,135,130,24,24,24,24,24,24,24,24,24,24,24,24,24,24);
maxpoc=80;
maxsyf=400;
maxsnieg=500;
maxludzie=50;
maxsople=300;
maxszczyt=32;
maxminy=99;
maxkaw=50;
Old_Int = $66;
co_robi_txt:array[1..8] of string[10]=
      ('IDZ/BIE','IDZIE','BIEGNIE','KOPIE','STOI','BLOKUJE','PANIKA','I/B/S/P');
cien:array[0..14] of byte=(0,0,0,0,0,1,0,0,1,1,0,1,1,0,0);
gest_rmk=100;
nieba:array[0..16,1..15,0..2] of byte=
((( 0, 0, 0),( 0, 0, 0),( 0, 0, 0),( 0, 0, 0),( 0, 0, 0),( 0, 0, 0),( 0, 0, 0),( 0, 0, 0),
  ( 0, 0, 0),( 0, 0, 0),( 0, 0, 0),( 0, 0, 0),( 0, 0, 0),( 0, 0, 0),( 0, 0, 0)),
 (( 0, 0,32),( 0, 0,29),( 0, 0,27),( 0, 0,25),( 0, 0,22),( 0, 0,20),( 0, 0,18),( 0, 0,16),
  ( 0, 0,13),( 0, 0,11),( 0, 0, 9),( 0, 0, 6),( 0, 0, 4),( 0, 0, 2),( 0, 0, 0)),
 (( 0, 0, 0),( 0, 0, 5),( 0, 0,10),( 0, 0,15),( 0, 0,20),( 0, 0,25),( 0, 0,31),( 0, 7,35),
  ( 0,15,39),( 0,23,43),( 0,31,47),( 0,39,51),( 0,47,55),( 0,55,59),( 0,63,63)),
 (( 0, 0,35),( 2, 4,37),( 4, 9,39),( 6,13,41),( 8,18,43),(11,22,45),(13,27,47),(15,31,48),
  (17,36,50),(19,40,52),(22,45,54),(24,49,56),(26,54,58),(28,58,60),(31,63,62)),
 ((40,48,59),(38,45,56),(36,43,54),(34,41,51),(32,39,49),(30,36,46),(28,34,44),(27,32,42),
  (25,30,39),(23,28,37),(21,25,34),(19,23,32),(17,21,29),(15,19,27),(14,17,25)),
 ((50,50,51),(48,49,49),(47,47,48),(45,46,47),(44,44,46),(42,42,45),(41,41,44),(39,39,43),
  (38,37,42),(36,36,41),(35,34,40),(33,32,39),(32,31,38),(30,29,37),(29,28,36)),
 ((29,31,33),(26,28,30),(24,26,28),(22,24,25),(20,22,23),(18,19,21),(16,17,18),(14,15,16),
  (12,13,14),(10,11,11),( 8, 8, 9),( 6, 6, 7),( 4, 4, 4),( 2, 2, 2),( 0, 0, 0)),
 (( 0, 8,27),( 5, 8,23),(11, 8,20),(17, 8,16),(23, 8,13),(29, 8,10),(35, 8, 6),(41, 8, 3),
  (47, 8, 0),(49,13, 0),(52,18, 0),(55,23, 0),(57,28, 0),(60,33, 0),(63,38, 0)),
 ((31, 0, 0),(33, 3, 0),(35, 6, 0),(36, 9, 0),(38,12, 0),(39,16, 0),(41,19, 0),(42,22, 0),
  (44,25, 0),(46,28, 0),(47,32, 0),(49,35, 0),(50,38, 0),(52,41, 0),(54,45, 0)),
 (( 1, 0,22),( 3, 0,20),( 6, 0,18),( 9, 0,17),(12, 0,15),(14, 0,14),(17, 0,12),(20, 0,10),
  (23, 0, 9),(26, 0, 7),(28, 0, 6),(31, 0, 4),(34, 0, 3),(37, 0, 1),(39, 0, 0)),
 ((32, 0,15),(31, 0,13),(30, 0,12),(29, 0,11),(28, 0,10),(27, 0, 9),(26, 0, 8),(25, 0, 7),
  (24, 0, 6),(23, 0, 5),(22, 0, 4),(21, 0, 3),(20, 0, 2),(19, 0, 1),(18, 0, 0)),
 (( 0, 0, 0),( 3, 0, 2),( 6, 1, 4),(10, 1, 7),(13, 2, 9),(17, 2,12),(20, 3,14),(23, 4,16),
  (27, 4,19),(30, 5,21),(34, 5,24),(37, 6,26),(41, 6,29),(44, 7,31),(48, 8,34)),
 ((46,32, 0),(43,30, 3),(40,29, 6),(36,27,10),(33,26,13),(30,24,16),(26,23,20),(23,21,23),
  (20,20,26),(16,18,30),(13,17,33),(10,15,36),( 6,14,40),( 3,12,43),( 0,11,47)),
 ((52,52, 0),(49,52, 0),(46,52, 0),(43,52, 0),(41,52, 0),(38,52, 0),(35,52, 0),(32,52, 0),
  (27,51, 6),(22,50,13),(18,49,20),(13,48,26),( 9,47,33),( 4,46,40),( 0,45,46)),
 ((48,48, 0),(47,46, 2),(47,45, 5),(47,44, 8),(47,43,10),(46,42,13),(46,41,16),(46,40,19),
  (46,39,21),(46,38,24),(45,37,27),(45,36,29),(45,35,32),(45,34,35),(44,32,38)),
 (( 0,15, 1),( 0,16, 2),( 0,17, 3),( 0,19, 4),( 0,20, 5),( 0,21, 7),( 0,22, 8),( 0,24, 9),
  ( 0,25,10),( 0,26,11),( 0,27,13),( 0,29,14),( 0,30,15),( 0,31,16),( 0,33,18)),
 ((63, 0, 0),(59, 0, 0),(55, 0, 0),(51, 0, 0),(46, 0, 0),(42, 0, 0),(38, 0, 0),(34, 0, 0),
  (29, 0, 0),(26, 0, 0),(21, 0, 0),(17, 0, 0),(12, 0, 0),( 9, 0, 0),( 4, 0, 0)));
co_robi:array[1..6] of byte=(1,2,5,0,4,6);
co_robi2:array[1..4] of byte=(0,1,2,6);

schemat:array[1..8] of record
        il_obiekt:byte;
        obiekt:array[1..7] of longint;
        textura,brzeg:longint;
        end=
        ((il_obiekt:6;
          obiekt:(49,1335,3541,4883,8457,12095,0);
          textura:13389;
          brzeg:30851),
         (il_obiekt:2;
          obiekt:(33129,34847,0,0,0,0,0);
          textura:38053;
          brzeg:55515),
         (il_obiekt:3;
          obiekt:(57313,59519,63093,0,0,0,0);
          textura:64291;
          brzeg:81753),
         (il_obiekt:7;
          obiekt:(83551,84837,86179,90393,93111,96685,100467);
          textura:103665;
          brzeg:121127),
         (il_obiekt:5;
          obiekt:(122925,124211,125553,129075,132409,0,0);
          textura:135311;
          brzeg:152773),
         (il_obiekt:4;
          obiekt:(171489,173575,176677,178067,0,0,0);
          textura:155051;
          brzeg:180549),
         (il_obiekt:6;
          obiekt:(191053,192195,193353,194519,173575,182347,0);
          textura:195773;
          brzeg:203151),
         (il_obiekt:7;
          obiekt:(182347,183533,184675,185801,187259,188545,189831);
          textura:191053;
          brzeg:201147));

naz_obj:array[1..33] of record
                        tex,ob:byte;
                        nazwa:string[10];
                        end=(
         (tex:1; ob:1; nazwa:'KRZAK'),
         (tex:1; ob:2; nazwa:'CHOINKA1'),
         (tex:1; ob:5; nazwa:'CHOINKA2'),
         (tex:3; ob:1; nazwa:'CHOINKA3'),
         (tex:1; ob:4; nazwa:'DRZEWO1'),
         (tex:4; ob:3; nazwa:'DRZEWO2'),
         (tex:4; ob:6; nazwa:'DRZEWO3'),
         (tex:4; ob:7; nazwa:'DRZEWO4'),
         (tex:5; ob:3; nazwa:'DRZEWO5'),
         (tex:5; ob:4; nazwa:'DRZEWO6'),
         (tex:3; ob:2; nazwa:'DRZEWO7'),
         (tex:6; ob:2; nazwa:'DRZEWO8'),
         (tex:2; ob:2; nazwa:'PALMA1'),
         (tex:5; ob:5; nazwa:'PALMA2'),
         (tex:2; ob:1; nazwa:'KAKTUS'),
         (tex:1; ob:3; nazwa:'KAMIEn1'),
         (tex:1; ob:6; nazwa:'KAMIEn2'),
         (tex:7; ob:4; nazwa:'KAMIEn3'),
         (tex:4; ob:4; nazwa:'SlUP TEL.'),
         (tex:3; ob:3; nazwa:'BAlWAN'),
         (tex:6; ob:1; nazwa:'KOsc1'),
         (tex:6; ob:3; nazwa:'KOsc2'),
         (tex:6; ob:4; nazwa:'CZASZKA'),
         (tex:8; ob:1; nazwa:'NAGROBEK1'),
         (tex:8; ob:2; nazwa:'NAGROBEK2'),
         (tex:8; ob:3; nazwa:'NAGROBEK3'),
         (tex:7; ob:1; nazwa:'NAGROBEK4'),
         (tex:7; ob:2; nazwa:'NAGROBEK5'),
         (tex:7; ob:3; nazwa:'NAGROBEK6'),
         (tex:8; ob:4; nazwa:'GRoB1'),
         (tex:8; ob:5; nazwa:'SIATKA1'),
         (tex:8; ob:6; nazwa:'SIATKA2'),
         (tex:8; ob:7; nazwa:'WYKOP'));

kolory_druzyn:array[1..5,0..2] of byte=
              ((63, 5,10),
               ( 0,25,63),
               ( 0,50, 0),
               (50, 0,50),
               (40,40,40));

var
wybrany:Integer;
obraz:^obrr;
mkol:array[0..16,0..16] of byte;
kursor:array[0..16,0..16] of byte;
postm:array[1..50,1..10,1..10] of byte;
zaznaczony,menu,Smenu:byte;
kl:array[0..127] of boolean;
kl_wcisn:array[0..127] of byte;
S_kier,S_sila:integer;
Smx,Smy,Smx2,Smy2,mx,my,_Smx2,_Smy2,mmx,mmy,button,
strzelaja_do_siebie,
bron,sila_broni,
rodzaj_dziala,sila_dziala,
rodzaj_min,
bron_odlamki,sila_odlamki,
rodzaj_syfkow,raca_dlug:integer;
il_ludzi,max_ludzi:array[1..5] of integer;
guzik,Sguzik,klik:array[1..2] of boolean;
plik:file of byte;
VoiceData : Array [0..80] of WaveData;
karta_muzyczna,jest_dzwiek:boolean;
post:array[1..10,1..50] of real;
czy_ma_trzymac:byte;
post_corobi,Npost_corobi,
post_zawroc,
post_przenies,
post_wychodzi,
post_pali,
post_rodzsmierc:array[1..50] of byte;
post_zdycha:array[1..50] of integer;
post_strzela:array[1..50] of record
                             dl,jak:byte;
                             sz:real;
                             kier:shortint;
                             end;
miny:array[1..maxminy] of record
                         x,y,dx,dy:real;
                         jest:boolean;
                         miga,bum,pozycja:byte;
                         end;
pada_snieg:shortint;
mozebycsnieg,ilsnieg,il_min:integer;
snieg_mniej,snieg_wiecej:integer;
snieg:^snieg_tabl;
poc:array[1..7,1..maxpoc] of real;
poc_dzw:array[1..maxpoc] of boolean;
poc_sek:array[1..maxpoc] of integer;
poc_hom:array[1..maxpoc] of record
        x,y:integer;
        dl:word;
        ktory:shortint;
        jest:boolean;
        end;
poc_hom_ust:record
            x,y:integer;
            sila,pod,ustaw:byte;
            ktory:shortint;
            end;
syf:array[1..maxsyf] of record
                        jest:byte;
                        x,y,dx,dy:real;
                        kol,zmaz:byte;
                        end;
sop:array[1..4,1..maxsyf] of real;
rys_kol,rys_grub,sz_snieg:shortint;
burza,l_bija,l_strzelaja,l_szaleni,miesko,sa_sople,kap_krew,licz_utopionych,
smierc_wybuch,wychodza_do_gory,jest_kursor,jestekrbum,jestblysk,jestblysk_wtle,jest_sz_snieg,jest_2_plany,czm,jest_obrmenu,
jest_komentarze,jest_tooltip,tooltip_widoczny,jest_ranienie,
Mnowy,Mzapis,Modczyt,Mopcje,Mopcje2,Medytor,Mwyjscie,Mpok_rekordy,Mpomoc,Mabout,Mnoweobraz:boolean;
zmiana:array[1..5] of byte;
re,dl_sopli:shortint;
szczyt:array[0..maxszczyt] of record
                       x:integer;
                       y:real;
                       end;
punkt_wyjscia:array[1..5] of record
                             x,y:integer;
                             gora:boolean;
                             pod:byte;
                             jak,kier,
                             kiedy,szyb:shortint;
                             end;
kt_punkt_wyjscia,druzyna_z_kursora:byte;

wyr:string;
wybrana_postac:array[1..50] of byte;
ramka:array[1..gest_rmk*4] of byte;
post_naglowie:array[1..50] of byte;
pod_strz:array[1..50,1..3,1..3] of byte;
Sbron:integer;
poc2:array[1..50] of record
                     jest:boolean;
                     x,y,dx,dy:real;
                     sila:byte;
                     end;
pliki:array[1..255] of string[8];
nazwy_wpl:array[1..255] of string[20];
ostatni_plik:string[8];
ostatnie_obr:array[1..5] of string[8];
ustaw:array[1..5] of record
      naglowek:string[14];
      nazwa_post:string[20];
      szyb_chod,
      s_bicia,
      s_poc,
      bije,
      strzela:byte;
      kol:array[242..244,0..2] of byte;
      waga:byte;
      end;
dzwieki:array[1..5] of record
        nazwa:array[0..7] of string[12];
        rozmiar:array[0..7] of word;
        end;
dzwiek_p:pointer;
myszka:record
       r,z:byte;
       end;
pal,pal_gl:paleta_typ;
pal_tlo:array[0..15,0..2] of byte;
a,a1,a2,a3,pox,poy,po1:integer;
scr_x1,scr_x2,scr_y1,scr_y2:word;
scr,scr2:^sc;
niebo_odwroc,zazn_ramki,zoom,wolno_wyl_mysz:boolean;
fonty:^fonty_tabl;
menu_ikony:^menu_ikony_tabl;
ekrbum,rodzaj_tla,niebo:shortint;
ramka_wsp:array[1..2] of record
                     x,y:integer;
                     end;
Save_Int : pointer;
pod_celow:byte;
dl_pomocy,lit:word;
wys_pom:integer;
dziura_na_dole,kol_pom,blysk_pioruna:byte;
y_pom:shortint;
kaw:array[1..maxkaw] of record
                        jest,znik:boolean;
                        x,y,dx,dy:real;
                        sx,sy:integer;
                        kol,pod:array[1..4] of byte;
                        stoi,jeszcze_krew:byte;
                        end;
rob_obiekt_numr:byte;
rob_obiekt_odwr,rob_obiekt_jest,trzyma_shift:boolean;

trupow_na_raz:integer;
bedzie_komentarz:record
                 x,y:integer;
                 end;
komentarz:record
          jaki:string[50];
          dl,x,y:integer;
          end;

Zmx,Zmy:real;

kowadlo:^kowadla_tabl;
kowadlo_obr:^kowadla_obr_tabl;


tekst_pomocy:array[1..9266] of char;

implementation


end.
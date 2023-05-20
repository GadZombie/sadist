uses crt, mouse, dos, wave, sadunit, sad_rek, sad_graf, sad_var, xms, timer;

{ * } PROCEDURE sprawdz_rzuty;
begin
  if post_przenies[a] > 0 then
  begin
    post[2, a] := mx - 4;
    post[3, a] := my - 4;
    if (trzyma_shift) and (czy_ma_trzymac = 0) then
      post_przenies[a] := 1
    else
      post_przenies[a] := 0;
    post[7, a] := post[7, a] + Zmx / 10;
    post[6, a] := post[6, a] + Zmy / 10;
    post[8, a] := 1;
    if Zmx = 0 then
    begin
      if post[7, a] > 0 then
        post[7, a] := post[7, a] - 0.1;
      if post[7, a] < 0 then
        post[7, a] := post[7, a] + 0.1;
    end;
    if Zmy = 0 then
    begin
      if post[6, a] > 0 then
        post[6, a] := post[6, a] - 0.1;
      if post[6, a] < 0 then
        post[6, a] := post[6, a] + 0.1;
    end;
    if (czy_ma_trzymac > 0) then
    begin
      post[7, a] := sin(S_kier / 5) * (S_sila / 4);
      post[6, a] := cos(S_kier / 5) * (S_sila / 4);
    end;
  end;
end;

{ * } PROCEDURE zran(jak: byte);
var
  d: byte;
begin
  if (jest_ranienie) and (abs(post[6 + jak, a]) > (4 - jak)) then
  begin
    for d := 0 to 10 do
      nowysyf(post[2, a] + 3 + random(4), post[3, a] + 3 + random(4), random - 0.5, -0.5 - random, 72, 6, 0);
    graj_dzwiek(VoiceData[19 + (10 * trunc(post[10, a]))], 0.8 + random / 3, 1 + trunc(post[10, a]));
    post[9, a] := post[9, a] - abs(post[6 + jak, a]);
    czm := true;
  end;
end;

{ * } PROCEDURE postacie;
var
  xf, yf, ee, pods, pod2, pod3, d2: byte;
  h, c, d, ef, a1: integer;
  b: real;
  kolejnosc: array [1 .. 5] of byte;
begin
  for a := 1 to maxludzie do
    post_corobi[a] := Npost_corobi[a];

  for a := 1 to maxludzie do
  begin
    if post[1, a] = 1 then
    begin
      if (post_pali[a] = 1) and (zmiana[1] = 0) then
      begin
        h := round(post[2, a]) + 3 + random(4);
        d := round(post[3, a]) + 3 - random(4);
        if getpix(h, d) <= 15 then
          nowysyf(h, d, random / 2 - 0.25, -random / 2 - 0.5, 205, 3, 1);
        if post[9, a] > 0 then
          post[9, a] := post[9, a] - 0.5;
        if ((post_corobi[a] = 6) and (random(100) = 0)) or ((post_corobi[a] <> 6) and (random(20) = 0)) then
        begin
          graj_dzwiek(VoiceData[22 + (10 * trunc(post[10, a]))], 0.8 + random / 3, 1 + trunc(post[10, a]));
          Npost_corobi[a] := 6;
        end;
      end;
      if post_strzela[a].dl > 0 then
        dec(post_strzela[a].dl);
      d := 0;
      if (abs(post[6, a]) > 1) or (abs(post[7, a]) > 1) then
        d := 1;
      b := 0;
      for a1 := 1 to maxminy do
      begin
        if miny[a1].jest then
        begin
          if (post[2, a] + 7 >= miny[a1].x) and (post[2, a] + 3 <= miny[a1].x) and (post[3, a] + 12 >= miny[a1].y) and
            (post[3, a] <= miny[a1].y) then
          begin
            if miny[a1].bum < 130 then
              miny[a1].bum := 130;
          end;
        end;
      end;
      pods := getpix(trunc(post[2, a]) + 4, trunc(post[3, a]) + 9);
      if ((pods > 15) and (pods < 192) and (pods < 250) or ((post[3, a] > 189) and (dziura_na_dole = 0))) and
        (post[8, a] = 3) and (post[6, a] > 1.4) then
        graj_dzwiek(VoiceData[19 + (10 * trunc(post[10, a]))], 0.8 + random / 3, 1 + trunc(post[10, a]));
      if (pods > 15) and (pods < 192) and (pods < 250) or ((post[3, a] > 189) and (dziura_na_dole = 0)) then
      begin
        if post_corobi[a] in [0, 4, 7] then
          b := 0;
        if post_corobi[a] in [1, 3, 5] then
          b := -0.5;
        if post_corobi[a] in [2, 6] then
          b := -1.4;
        if (post_corobi[a] = 7) and (post_rodzsmierc[a] >= 1) then
          b := -1.4;
        if (not wychodza_do_gory) and ((getpix(trunc(post[2, a]) + 4, trunc(post[3, a]) + 8) > 15) and
          (getpix(trunc(post[2, a]) + 4, trunc(post[3, a]) + 8) < 192)) and
          ((getpix(trunc(post[2, a]) + 4, trunc(post[3, a]) + 7) > 15) and
          (getpix(trunc(post[2, a]) + 4, trunc(post[3, a]) + 7) < 192)) and
          ((getpix(trunc(post[2, a]) + 4, trunc(post[3, a]) + 6) > 15) and
          (getpix(trunc(post[2, a]) + 4, trunc(post[3, a]) + 6) < 192)) and
          ((getpix(trunc(post[2, a]) + 4, trunc(post[3, a]) + 5) > 15) and
          (getpix(trunc(post[2, a]) + 4, trunc(post[3, a]) + 5) < 192)) and
          ((getpix(trunc(post[2, a]) + 4, trunc(post[3, a]) + 4) > 15) and
          (getpix(trunc(post[2, a]) + 4, trunc(post[3, a]) + 4) < 192)) and
          ((getpix(trunc(post[2, a]) + 4, trunc(post[3, a]) + 3) > 15) and
          (getpix(trunc(post[2, a]) + 4, trunc(post[3, a]) + 3) < 192)) then
          b := 0;
        zran(0);
        post[6, a] := -abs(post[6, a]) / 5;
        post[7, a] := -post[7, a];
        zran(1);
        if (pods > 25) and (pods <= 31) and (random(2) = 0) then
          putpix(trunc(post[2, a]) + 4, trunc(post[3, a]) + 9, pods - 1, 0);
      end;
      pod2 := getpix(trunc(post[2, a]) + 4, trunc(post[3, a]) + 2);
      pod3 := getpix(trunc(post[2, a]) + 5, trunc(post[3, a]) + 2);
      if (pod2 > 15) and (pod2 < 192) and (pod3 > 15) and (pod3 < 192) then
      begin
        if (post_naglowie[a] < 60) then
          inc(post_naglowie[a]);
      end
      else
        post_naglowie[a] := 0;
      if post_naglowie[a] >= 60 then
      begin
        post[9, a] := post[9, a] - 0.5;
        czm := true;
      end;
      if (pods > 15) and (pods < 192) and (pods < 250) and (pod2 > 15) and (pod2 < 192) and (pod2 < 250) and
        (pod3 > 15) and (pod3 < 192) and (pod3 < 250) then
        post_wychodzi[a] := 1
      else
        post_wychodzi[a] := 0;
      c := 0;
      for yf := 0 to 9 do
      begin
        if (post[4, a] > 0) and (getpix(trunc(post[2, a]) + 8, trunc(post[3, a]) + yf) > 15) and
          (getpix(trunc(post[2, a]) + 8, trunc(post[3, a]) + yf) < 192) then
          inc(c);
        if (post[4, a] < 0) and (getpix(trunc(post[2, a]) + 1, trunc(post[3, a]) + yf) > 15) and
          (getpix(trunc(post[2, a]) + 1, trunc(post[3, a]) + yf) < 192) then
          inc(c);
      end;
      if (post_zawroc[a] = 1) then
      begin
        post[4, a] := -post[4, a];
        post_zawroc[a] := 0;
      end;
      if (post[8, a] = 2) and (random(40) = 0) then
        post[4, a] := -post[4, a];
      if (post_corobi[a] <> 5) and (c > 7) and (post_wychodzi[a] = 0) then
      begin
        post[4, a] := -post[4, a];
        { if abs(post[7,a])>2 then begin
          for d:=0 to 10 do
          nowysyf(post[2,a]+3+random(4),post[3,a]+3+random(4),random-0.5,-0.5-random,72,6,0);
          end; }

      end;
      if (post_corobi[a] = 6) and (c <= 7) and (random(300) = 0) then
      begin
        post[4, a] := -post[4, a];
        graj_dzwiek(VoiceData[22 + (10 * trunc(post[10, a]))], 0.8 + random / 3, 1 + trunc(post[10, a]));
      end;
      if (post_corobi[a] = 5) and (c > 2) and (post_wychodzi[a] = 0) and (post[8, a] = 0) then
      begin
        for a1 := 0 to 1 do
        begin
          for h := 2 - a1 to 7 + a1 do
          begin
            if (post[4, a] > 0) then
            begin
              if (random(3) = 0) and (h > 1) and (h < 8) and
                (getpix(trunc(post[2, a] + 8 - a1), trunc(post[3, a] + h)) > 15) then
                nowysyf(trunc(post[2, a] + 8 - a1), trunc(post[3, a] + h), -random, random * 2 - 1,
                  getpix(trunc(post[2, a] + 8 - a1), trunc(post[3, a] + h)), 1, 1);
              if (getpix(trunc(post[2, a] + 8 - a1), trunc(post[3, a] + h)) >= 144) and
                (getpix(trunc(post[2, a] + 8 - a1), trunc(post[3, a] + h)) <= 159) then
                post[4, a] := -abs(post[4, a])
              else
                putpix(trunc(post[2, a] + 8 - a1), trunc(post[3, a] + h), 0, 0);
            end;
            if (post[4, a] < 0) then
            begin
              if (random(3) = 0) and (h > 1) and (h < 8) and
                (getpix(trunc(post[2, a] + 1 + a1), trunc(post[3, a] + h)) > 15) then
                nowysyf(trunc(post[2, a] + 1 + a1), trunc(post[3, a] + h), random, random * 2 - 1,
                  getpix(trunc(post[2, a] + 1 + a1), trunc(post[3, a] + h)), 1, 1);
              if (getpix(trunc(post[2, a] + 1 + a1), trunc(post[3, a] + h)) >= 144) and
                (getpix(trunc(post[2, a] + 1 + a1), trunc(post[3, a] + h)) <= 159) then
                post[4, a] := abs(post[4, a])
              else
                putpix(trunc(post[2, a] + 1 + a1), trunc(post[3, a] + h), 0, 0);
            end;
          end;
        end;
        b := 0;
      end;
      post[3, a] := post[3, a] + b + (post[6, a] * (ustaw[trunc(post[10, a]) + 1].waga / 70));
      { } sprawdz_rzuty;
      if (post[6, a] < 3) and (b = 0) then
      begin
        if ((post_corobi[a] in [0, 4]) and ((pods <= 15) or (pods >= 192))) or
          ((post_corobi[a] <> 0) and (post_corobi[a] <> 4)) then
          post[6, a] := post[6, a] + 0.1;
      end;
      if (post[8, a] = 3) and (post[6, a] > 1) then
        post[6, a] := post[6, a] - (random / 4);
      if post[7, a] > 0 then
        post[7, a] := post[7, a] - 0.05;
      if post[7, a] < 0 then
        post[7, a] := post[7, a] + 0.05;
      { 4 } if post[2, a] >= 310 then
        post[4, a] := -(ustaw[trunc(post[10, a]) + 1].szyb_chod / 150);
      { 4 } if post[2, a] <= 1 then
        post[4, a] := ustaw[trunc(post[10, a]) + 1].szyb_chod / 150;
      if post[2, a] <= 1 then
        post[7, a] := abs(post[7, a]);
      if post[2, a] >= 310 then
        post[7, a] := -abs(post[7, a]);
      if post[3, a] <= 1 then
        post[6, a] := abs(post[6, a]);
      { ! } if ((post[3, a] >= 195) and (dziura_na_dole in [1, 2])) or ((post[3, a] >= 200) and (dziura_na_dole = 3))
      then
      begin
        if post[6, a] > 2 then
          post[9, a] := post[9, a] - 50;
        if (dziura_na_dole = 1) and (post_pali[a] = 1) and (random(20) = 0) then
          post_pali[a] := 0;
        if (dziura_na_dole = 2) then
          post_pali[a] := 1;
        if (post[6, a] > 1) and (dziura_na_dole = 1) then
        begin
          for h := 0 to 20 do
          begin
            d2 := random(10);
            if getpix(trunc(post[2, a] + d2), 198) <= 15 then
              nowysyf(post[2, a] + d2, 199 - random(2), ((random / 2) - 0.25) * abs(post[6, a] / 1.4),
                (-random / 1.5) * abs(post[6, a] / 1.5), 224, 5, 1);
          end;
        end;
        if (abs(post[6, a]) > 0.7) and (dziura_na_dole = 1) then
          graj_dzwiek(VoiceData[4], 1.2 + random / 2, 0);
        if (post[9, a] > 0) and (dziura_na_dole <> 3) then
        begin
          if (post[6, a] > -0.5) and (post[3, a] >= 197) and (post[9, a] >= 50) then
            post[6, a] := post[6, a] - 0.2;
          if (post[9, a] < 50) then
            post[6, a] := 0.2;
          post[9, a] := post[9, a] - 1;
          post_corobi[a] := 8;
          if (getpix(trunc(post[2, a] + d2), 198) <= 15) and (dziura_na_dole = 1) then
            nowysyf(post[2, a] + d2, 199 - random(2), ((random / 2) - 0.25) * abs(post[6, a] / 1.4),
              (-0.2 - random / 2) * abs(post[6, a] / 1.5), 224, 5, 1);
          if (post[6, a] > 0.5) then
            post[6, a] := 0.5;
          if (post[6, a] < -0.5) then
            post[6, a] := -0.5;
          if (post[7, a] > 0) then
            post[7, a] := post[7, a] - 0.1;
          if (post[7, a] < 0) then
            post[7, a] := post[7, a] + 0.1;
          if menu = 0 then
            czm := true;
        end
        else
        begin
          dec(il_ludzi[trunc(post[10, a]) + 1]);
          post[1, a] := 0;
          if (post_zdycha[a] >= 10) and (not licz_utopionych) then
            inc(trupy);
          if licz_utopionych then
            inc(trupy);
          if dziura_na_dole = 2 then
            graj_dzwiek(VoiceData[7], 0.7 + random / 2, 0);
          graj_dzwiek(VoiceData[17 + (10 * trunc(post[10, a]))], 0.8 + random / 3, 1 + trunc(post[10, a]));
          if menu in [0, 1] then
            czm := true;
        end;
      end;
      if post[7, a] < -7 then
        post[7, a] := -7;
      if post[7, a] > 7 then
        post[7, a] := 7;
      if post[6, a] < -7 then
        post[6, a] := -7;
      if post[6, a] > 7 then
        post[6, a] := 7;
      if (post[7, a] < 0) and (post[7, a] > -0.1) then
        post[7, a] := 0;
      if (post[7, a] > 0) and (post[7, a] < 0.1) then
        post[7, a] := 0;
      if (post[6, a] < 0) and (post[6, a] > -0.1) then
        post[6, a] := 0;
      if (post[6, a] > 0) and (post[6, a] < 0.1) then
        post[6, a] := 0;
      if (b <> 1) and ((post_zdycha[a] = 0) or (post_rodzsmierc[a] > 1)) and (post_corobi[a] <> 0) and
        (post_corobi[a] <> 8) and (post_corobi[a] <> 4) and (post_strzela[a].dl = 0) and (post_wychodzi[a] = 0) and
        (post[8, a] <> 1) and (post[8, a] <> 3) then
        post[2, a] := post[2, a] + post[4, a];
      if (post_corobi[a] in [2, 6]) and (b <> 1) and
        ((post_zdycha[a] = 0) or ((post_zdycha[a] > 0) and (post_rodzsmierc[a] > 1))) and (post_strzela[a].dl = 0) and
        (post_wychodzi[a] = 0) and (post[8, a] <> 1) and (post[8, a] <> 3) then
        post[2, a] := post[2, a] + post[4, a] * (0.5 + random * 2);
      if (post_corobi[a] = 5) and (b <> 1) and (post_zdycha[a] = 0) and (post_wychodzi[a] = 0) and (post[8, a] <> 1) and
        (post[8, a] <> 3) then
        post[2, a] := post[2, a] - post[4, a] * (random / 1.5);
      post[2, a] := post[2, a] + post[7, a];
      if (post_zdycha[a] > 0) and (post_rodzsmierc[a] = 1) and (post[8, a] <> 1) and (post[8, a] <> 3) then
        post[2, a] := post[2, a] + post[4, a] / 3;
      if (post_corobi[a] <> 0) and (post_corobi[a] <> 4) then
        post[5, a] := post[5, a] + 0.2
      else if random(50) = 0 then
        post[5, a] := random(4);
      if (post[6, a] < -0.5) or (post[6, a] > 2) or (abs(post[7, a]) > 1) then
        post[5, a] := post[5, a] + 0.05;
      if (post[8, a] = 3) then
        post[5, a] := post[5, a] + 0.2;
      if (post[5, a] >= 4) then
        post[5, a] := 0;
      if ((post[6, a] < -0.5) or (post[6, a] > 2) or (abs(post[7, a]) > 0.5)) and (post[8, a] <> 3) then
        post[8, a] := 1
      else
      begin
        if post[8, a] <> 3 then
        begin
          if (post[8, a] = 1) and (post_przenies[a] = 0) and (random(2) = 0) then
            graj_dzwiek(VoiceData[19 + (10 * trunc(post[10, a]))], 0.8 + random / 3, 1 + trunc(post[10, a]));
          post[8, a] := 0;
        end;
      end;
      if (post[6, a] > 2) and (post[8, a] = 1) and (post_corobi[a] <> 6) and (random(20) = 0) then
        post[8, a] := 3;
      if (post[8, a] = 3) and (post_corobi[a] = 6) and (random(20) = 0) then
        post[8, a] := 1;
      if (post[6, a] < 0.7) and (post[8, a] = 3) then
        post[8, a] := 0;

      if (post[9, a] <= 20) and (random(50) = 0) then
        nowysyf(trunc(post[2, a] + 4 + random(2)), trunc(post[3, a] + 4 + random(2)), (random / 4) - 0.125,
          random / 4 - 0.125, 72, 6, 0);

      if (post[8, a] = 0) and (strzelaja_do_siebie > 0) and (post_zdycha[a] = 0) then
      begin
        for ee := 1 to maxludzie do
        begin
          if (post[1, ee] = 1) and (a <> ee) and (((not l_szaleni) and (post[10, ee] <> post[10, a])) or (l_szaleni))
          then
          begin
            if (l_strzelaja) and (post_corobi[a] <= 1) and (ustaw[trunc(post[10, a]) + 1].strzela = 1) and
              (post_strzela[a].dl <= 5) and (post[3, a] <= post[3, ee] + 60) and (post[3, a] >= post[3, ee] - 60) and
              (((post[2, ee] >= post[2, a] - 100) and (post[2, ee] <= post[2, a] - 40)) or
              ((post[2, ee] >= post[2, a] + 40) and (post[2, ee] <= post[2, a] + 100))) and
              (random(390 - (strzelaja_do_siebie * 40)) = 0) then
            begin
              if post[2, ee] > post[2, a] then
                ef := 1
              else
                ef := -1;
              strzal(post[2, a] + 4, post[3, a] + 2, ef * 2 + (random / 2 - 0.25), -1 - (random / 4),
                15 * (ustaw[trunc(post[10, a]) + 1].s_poc / 50), 0, false, true, trunc(post[10, a]), 0, false);
              post_strzela[a].dl := 20;
              post_strzela[a].sz := 5;
              post_strzela[a].kier := ef;
              post_strzela[a].jak := 0;
              czm := true;
            end;
            if (l_strzelaja) and (post_corobi[a] <= 1) and (ustaw[trunc(post[10, a]) + 1].strzela = 1) and
              (post_strzela[a].dl <= 3) and (post[3, a] <= post[3, ee] + 60) and (post[3, a] >= post[3, ee] - 60) and
              (((post[2, ee] >= post[2, a] - 39) and (post[2, ee] <= post[2, a] - 5)) or
              ((post[2, ee] >= post[2, a] + 5) and (post[2, ee] <= post[2, a] + 39))) and
              (random(390 - (strzelaja_do_siebie * 40)) = 0) then
            begin
              if post[2, ee] > post[2, a] then
                ef := 1
              else
                ef := -1;
              strzal(post[2, a] + 4 + ef * 2, post[3, a] + 2, ef + (random / 2 - 0.25), -0.5 - (random / 2),
                15 * (ustaw[trunc(post[10, a]) + 1].s_poc / 50), 0, false, true, trunc(post[10, a]), 0, false);
              post_strzela[a].dl := 10;
              post_strzela[a].sz := 2.5;
              post_strzela[a].kier := ef;
              post_strzela[a].jak := 0;
              czm := true;
            end;
            if (l_bija) and (post_corobi[a] <= 2) and (ustaw[trunc(post[10, a]) + 1].bije = 1) and
              (post_strzela[a].dl = 0) and (post[3, a] <= post[3, ee] + 5) and (post[3, a] >= post[3, ee] - 5) and
              (((post[2, ee] >= post[2, a] - 5) and (post[2, ee] <= post[2, a] + 5))) and
              (random(92 - (strzelaja_do_siebie * 10)) = 0) then
            begin
              if post[2, ee] > post[2, a] then
                ef := 1
              else
                ef := -1;
              post[7, ee] := post[7, ee] + ef * (ustaw[trunc(post[10, a]) + 1].s_bicia / 50);
              post[6, ee] := post[6, ee] - 1 * (ustaw[trunc(post[10, a]) + 1].s_bicia / 50);
              post[8, ee] := 1;
              post[9, ee] := post[9, ee] - (5 * (ustaw[trunc(post[10, a]) + 1].s_bicia / 50)) - random(5);
              if (post_corobi[ee] = 6) then
                post[4, ee] := -post[4, ee];
              post_strzela[a].jak := random(2) + 1;
              case post_strzela[a].jak of
                1:
                  begin
                    post_strzela[a].dl := 20;
                    post_strzela[a].sz := 5;
                  end;
                2:
                  begin
                    post_strzela[a].dl := 12;
                    post_strzela[a].sz := 3;
                  end;
              end;
              post_strzela[a].kier := ef;
              for d := 0 to 5 do
                nowysyf(trunc(post[2, ee] + 3 + random(3)), trunc(post[3, ee] + 1 + random(5)), (random + 0.3) * ef,
                  -random, 72, 6, 0);
              graj_dzwiek(VoiceData[21 + (10 * trunc(post[10, a]))], 0.8 + random / 3, 1 + trunc(post[10, a]));
              czm := true;
            end;
          end;
        end;
      end;
      if (post_corobi[a] = 4) then
      begin
        for ee := 1 to maxludzie do
        begin
          if (a <> ee) and (post[1, ee] = 1) and (post[3, a] <= post[3, ee] + 8) and (post[3, a] >= post[3, ee] - 8) and
            (((post[2, ee] >= post[2, a] - 4) and (post[2, ee] <= post[2, a] + 4))) then
          begin
            if post[2, ee] < post[2, a] then
              post[4, ee] := -abs(post[4, ee]);
            if post[2, ee] > post[2, a] then
              post[4, ee] := abs(post[4, ee]);
          end;
        end;
      end;
      if (post[9, a] <= 0) and (post_zdycha[a] = 0) then
      begin
        post_zdycha[a] := 1;
        czm := true;
        post_rodzsmierc[a] := random(4);
        if miesko then
          case post_rodzsmierc[a] of
            1:
              nowykaw(post[2, a] + 4, post[3, a] + 4, random * 3 * (post[4, a] / post[4, a]), random - 0.5);
            2:
              begin
                nowykaw(post[2, a] + 4, post[3, a] + 4, random * 3 * (post[4, a] / post[4, a]), random - 0.5);
                nowykaw(post[2, a] + 4, post[3, a] + 4, random * -3 * (post[4, a] / post[4, a]), random - 0.5);
              end;
            3:
              nowykaw(post[2, a] + 4, post[3, a] + 4, -random - 0.3, random - 0.5);
          end;
      end;
      if post_zdycha[a] >= 1 then
      begin
        if random(2) = 0 then
        begin
          case post_rodzsmierc[a] of
            { caly } 0:
              nowysyf(post[2, a] + 3 + random(4), post[3, a] + 3 + random(4), random - 0.5, -0.5 - random, 72, 6, 0);
            { noga } 1:
              nowysyf(post[2, a] + 4, post[3, a] + 6, (post[4, a] * (random + 0.5)) * 3, -(random / 2), 72, 6, 0);
            { rece } 2:
              begin
                b := random(2) * 2;
                nowysyf(post[2, a] + 4, post[3, a] + 3, (0.5 + random) * (b - 1), -(random / 4), 72, 6, 0);
              end;
            { glowa } 3:
              nowysyf(post[2, a] + 4, post[3, a] + 4, (random / 2) - 0.25, -1 - random, 72, 6, 0);
          end;
        end;
        inc(post_zdycha[a]);
        post[8, a] := 2;
        Npost_corobi[a] := 7;
        czm := true;
      end;
      if (post_zdycha[a] >= 254) and (post[1, a] = 1) then
      begin
        dec(il_ludzi[trunc(post[10, a]) + 1]);
        if smierc_wybuch then
          bum(trunc(post[2, a] + 4), trunc(post[3, a] + 4), 30, false, true, true, false, true, false, false);
        graj_dzwiek(VoiceData[17 + (10 * trunc(post[10, a]))], 0.8 + random / 3, 1 + trunc(post[10, a]));
        for d := 0 to 50 do
          nowysyf(trunc(post[2, a] - 5 + random(20)), trunc(post[3, a] - 2 + random(14)), (random * 4) - 2,
            random * 4 - 2, 72, 6, 0);
        post[1, a] := 0;
        post[9, a] := 0;
        post_zdycha[a] := 0;
        inc(trupy);
        czm := true;
        inc(trupow_na_raz);
        bedzie_komentarz.x := trunc(post[2, a]);
        bedzie_komentarz.y := trunc(post[3, a]);
        if miesko then
          for a2 := 1 to random(10) do
            nowykaw(post[2, a] + 4, post[3, a] + 4, random * 6 - 3, random * 6 - 3);
      end;
    end
    else
    begin
      if wybrana_postac[a] = 1 then
        wybrana_postac[a] := 0;

      for a1 := 1 to 5 do
        kolejnosc[a1] := a1;

      for a1 := 1 to 10 do
      begin
        c := random(5) + 1;
        d := random(5) + 1;
        d2 := kolejnosc[c];
        kolejnosc[c] := kolejnosc[d];
        kolejnosc[d] := d2;
      end;

      a2 := 0;
      a3 := 0;
      for a1 := 1 to 5 do
        if il_ludzi[kolejnosc[a1]] < max_ludzi[kolejnosc[a1]] then
        begin
          post[10, a] := kolejnosc[a1] - 1;
          a1 := 5;
        end;
      for a1 := 1 to 5 do
      begin
        inc(a2, il_ludzi[a1]);
        inc(a3, max_ludzi[a1]);
      end;
      if (a2 < a3) and (((punkt_wyjscia[trunc(post[10, a] + 1)].szyb = 0) and (random(500) = 0)) or
        ((punkt_wyjscia[trunc(post[10, a] + 1)].szyb > 0) and (punkt_wyjscia[trunc(post[10, a] + 1)].kiedy = 0))) then
      begin
        punkt_wyjscia[trunc(post[10, a] + 1)].kiedy := punkt_wyjscia[trunc(post[10, a] + 1)].szyb * 5;
        for yf := 1 to 10 do
        begin
          for xf := 1 to 10 do
          begin
            postm[a, xf, yf] := 0;
          end;
        end;
        czm := true;
        post[1, a] := 1; { jest? }
        post_pali[a] := 0;

        inc(il_ludzi[trunc(post[10, a]) + 1]);

        if punkt_wyjscia[trunc(post[10, a] + 1)].gora then
        begin
          post[2, a] := random(280) + 20; { x }
          post[3, a] := 0; { y }
        end
        else
        begin
          post[2, a] := punkt_wyjscia[trunc(post[10, a] + 1)].x - 4; { x }
          post[3, a] := punkt_wyjscia[trunc(post[10, a] + 1)].y; { y }
        end;
        case punkt_wyjscia[trunc(post[10, a] + 1)].kier of
          1:
            post[4, a] := 0;
          2:
            post[4, a] := random(2);
          3:
            post[4, a] := 1;
        end;
        { 4 } if post[4, a] = 0 then
          post[4, a] := -(ustaw[trunc(post[10, a]) + 1].szyb_chod / 150)
        else
          post[4, a] := (ustaw[trunc(post[10, a]) + 1].szyb_chod / 150); { kierunek }
        if punkt_wyjscia[trunc(post[10, a] + 1)].szyb > 0 then
          post[5, a] := 0
        else
          post[5, a] := random(4); { krok animacji }
        post[6, a] := 2; { dy }
        post[7, a] := 0; { dx }
        post[8, a] := 1; { 1 gdy sie kreci w powietrzu,0 gdy nie,2 gdy zdycha }
        post[9, a] := 200; { energia }
        post_zdycha[a] := 0; { kiedy umrze? }
        post_naglowie[a] := 0; { ile czasu ma cos na glowie }
        case punkt_wyjscia[trunc(post[10, a] + 1)].jak of { co robi }
          0:
            Npost_corobi[a] := co_robi[random(6) + 1];
          1:
            Npost_corobi[a] := random(2) + 1;
          2 .. 7:
            Npost_corobi[a] := co_robi[punkt_wyjscia[trunc(post[10, a] + 1)].jak - 1];
          8:
            Npost_corobi[a] := co_robi2[random(4) + 1];
        end;
        post_przenies[a] := 0; { przenoszenie mysza }
      end;
    end;
  end;
end;

{ * } PROCEDURE postacie2;
var
  xf, yf, ee, pods, pod2, pod3, d2: byte;
  h, c, d, ef, a1: integer;
  b: real;
  { var }
  odw: byte;
  { b:real; }
begin
  snieg_sypie;
  for a := 1 to maxludzie do
  begin
    if post[1, a] = 1 then
    begin
      if post[4, a] >= 0 then
        odw := 0;
      if post[4, a] < 0 then
        odw := 1;
      if post_corobi[a] in [1, 3, 6, 7] then
      begin { idzie }
        b := trunc(post[5, a]) + 1;
      end;
      if post_corobi[a] in [2] then
      begin { biegnie }
        b := trunc(post[5, a]) + 5;
      end;
      if post_corobi[a] in [5] then
      begin { kopie }
        b := trunc(post[5, a]) + 17;
      end;
      if post_corobi[a] in [6, 8] then
      begin { panika }
        b := trunc(post[5, a]) + 53;
      end;
      if post_corobi[a] in [0] then
        b := trunc(post[5, a]) + 13; { stoi }
      if post_corobi[a] in [4] then
        b := trunc(post[5, a]) + 33; { blokuje }
      if post_strzela[a].dl > 0 then
      begin
        case post_strzela[a].jak of
          0:
            b := 28 - trunc(post_strzela[a].dl / post_strzela[a].sz); { strzela }
          1:
            b := 32 - trunc(post_strzela[a].dl / post_strzela[a].sz); { kopie }
          2:
            b := 52 - trunc(post_strzela[a].dl / post_strzela[a].sz); { bije }
        end;
        if post_strzela[a].kier >= 0 then
          odw := 0
        else
          odw := 1;
      end;
      if post_wychodzi[a] = 1 then
        b := trunc(post[5, a]) + 57; { wspina sie }
      if post[8, a] = 1 then
        b := trunc(post[5, a]) + 9; { leci }
      if post[8, a] = 3 then
        b := trunc(post[5, a]) + 61; { macha rekami }
      if post[8, a] = 2 then
      begin
        case post_rodzsmierc[a] of
          0:
            b := trunc(post[5, a]) + 21; { taniec sm }
          2:
            b := trunc(post[5, a]) + 37; { bez rak }
          3:
            b := trunc(post[5, a]) + 41; { bez glowy }
          1:
            b := trunc(post[5, a]) + 45; { bez nogi }
        end;
      end;
      sobr(round(post[2, a]), round(post[3, a]), trunc(b), a, odw, trunc(post[10, a] + 1));
      { if post[10,a]=0 then sobr(round(post[2,a]),round(post[3,a]),trunc(b),a,odw,1);
        if post[10,a]=1 then sobr(round(post[2,a]),round(post[3,a]),trunc(b),a,odw,2); }
    end;
  end;
end;

{ * } PROCEDURE sople;
var
  a, b, c, d, lx, ly: word;
begin
  for a := 1 to maxsople do
  begin
    if sop[1, a] = 1 then
    begin
      sop[3, a] := sop[3, a] + 1;
      if (sop[3, a] > 199) and (dziura_na_dole > 0) then
        sop[1, a] := 0;
      b := getpix(round(sop[2, a]), round(sop[3, a]));
      if (sop[3, a] >= 199 - 1) and (dziura_na_dole = 0) then
        b := 21;
      if ((b > 15) and (b < 192)) or ((b >= 229) and (b <= 248)) or ((b >= 250) and (b <= 251)) then
      begin
        if b in [229 .. 248] then
        begin
          for c := 0 to 10 do
            nowysyf(sop[2, a], sop[3, a], (random * 2 - 1), random * 2 - 1, 72, 6, 0);
          bum(trunc(sop[2, a]), trunc(sop[3, a]), 5 + random(10), false, false, false, false, true, false, false);
        end;
        sop[1, a] := 0;
        if random(2) = 1 then
          putpix(round(sop[2, a]), round(sop[3, a]), round(sop[4, a]), 0);
        if random(2) = 0 then
          nowysyf(sop[2, a], sop[3, a] - 1, (random - 0.5), -random, 134, 3, 0);
      end;
    end
    else
    begin
      if (sa_sople) and (random(30) = 0) then
      begin
        lx := random(320);
        ly := random(188) + 10;
        if (getpix(lx, ly) >= 139) and (getpix(lx, ly) <= 141) then
        begin
          for d := ly to 199 do
          begin
            if (getpix(lx, d) >= 139) and (getpix(lx, d) <= 141) then
              nowysopel(lx, d, scr^[d, lx])
            else
              d := 199;
          end;
        end;
      end;

    end;
  end;
end;

{ * } PROCEDURE resetuj_ustawienia(jak: byte);
begin
  bron := 0;
  strzelaja_do_siebie := 0;
  burza := false;
  pada_snieg := 0;
  dziura_na_dole := 0;
  sa_sople := true;
  niebo := 1;
  for a1 := 1 to 5 do
    for a := 0 to 2 do
      pal_gl[228 + a1, a] := kolory_druzyn[a1, a];
  rys_kol := 1;
  rys_grub := 5;
  sila_broni := 5;
  rodzaj_dziala := 0;
  rodzaj_min := 0;
  rodzaj_syfkow := 0;
  sila_dziala := 5;
  bron_odlamki := 5;
  sila_odlamki := 5;
  raca_dlug := 3;
  jest_2_plany := true;
  kap_krew := false;
  l_strzelaja := false;
  l_bija := false;
  jest_dzwiek := true;
  for a := 1 to 5 do
  begin
    punkt_wyjscia[a].gora := true;
    punkt_wyjscia[a].x := a * 60 - 20;
    punkt_wyjscia[a].y := 12;
    punkt_wyjscia[a].kier := 2;
    punkt_wyjscia[a].jak := 2;
    punkt_wyjscia[a].szyb := 1;
    punkt_wyjscia[a].kiedy := 0;
  end;

  niebo_odwroc := false;
  dl_sopli := 0;
  smierc_wybuch := true;
  wychodza_do_gory := true;
  jestekrbum := true;
  jestblysk := false;
  jestblysk_wtle := false;
  jest_sz_snieg := false;
  sz_snieg := 50;
  if jak = 1 then
    for a := 1 to 5 do
      ostatnie_obr[a] := 'LUDZIE';
  l_szaleni := false;
  jest_obrmenu := false;
  miesko := true;
  resetuj_gory;
  if dziura_na_dole = 0 then
    zmaz_wode;
  imie_sadysty := 'SADYSTA';
  druzyna_z_kursora := 0;
  przerob_obr_nieba(1);
  with poc_hom_ust do
  begin
    x := 160;
    y := 100;
    sila := 5;
    ustaw := 0;
  end;
  jest_komentarze := false;
  jest_tooltip := false;
  jest_ranienie := true;
end;

{ * } PROCEDURE zapisz_kfg;
var
  b, b2, c, d: byte;
  plik: file;
begin
  assign(plik, 'sadist.cfg');
  filemode := 1;
{$I-}
  rewrite(plik, 1);
  if IOResult = 0 then
  begin
    b := 1;
    blockwrite(plik, b, 1); { zapis numeru wersji programu!!!!! }
    b := ord(bron);
    blockwrite(plik, b, 1);
    b := ord(strzelaja_do_siebie);
    blockwrite(plik, b, 1);
    b := ord(burza);
    blockwrite(plik, b, 1);
    b := ord(pada_snieg);
    blockwrite(plik, b, 1);
    b := ord(dziura_na_dole);
    blockwrite(plik, b, 1);
    b := ord(sa_sople);
    blockwrite(plik, b, 1);
    b := ord(niebo);
    blockwrite(plik, b, 1);

    blockwrite(plik, pal_gl[229], 15);
    b := ord(rys_kol);
    blockwrite(plik, b, 1);
    b := ord(rys_grub);
    blockwrite(plik, b, 1);
    b := ord(sila_broni);
    blockwrite(plik, b, 1);
    b := ord(bron_odlamki);
    blockwrite(plik, b, 1);
    b := ord(sila_odlamki);
    blockwrite(plik, b, 1);
    b := ord(kap_krew);
    blockwrite(plik, b, 1);
    b := ord(l_strzelaja);
    blockwrite(plik, b, 1);
    b := ord(l_bija);
    blockwrite(plik, b, 1);
    for a := 0 to maxszczyt do
    begin
      b := szczyt[a].x div 256;
      b2 := szczyt[a].x mod 256;
      blockwrite(plik, b, 1);
      blockwrite(plik, b2, 1);
      b := ord(trunc(szczyt[a].y));
      blockwrite(plik, b, 1);
    end;
    b := rodzaj_tla;
    blockwrite(plik, b, 1);
    b := ord(jest_dzwiek);
    blockwrite(plik, b, 1);
    { b:=ord(punkt_wyjscia[1].gora);write(plik,b);
      b:=punkt_wyjscia[1].x div 256;b2:=punkt_wyjscia[1].x mod 256;
      write(plik,b);write(plik,b2);
      b:=ord(punkt_wyjscia[1].y);write(plik,b);
      b:=ord(punkt_wyjscia[2].gora);write(plik,b);
      b:=punkt_wyjscia[2].x div 256;b2:=punkt_wyjscia[2].x mod 256;
      write(plik,b);write(plik,b2);
      b:=ord(punkt_wyjscia[2].y);write(plik,b);
      b:=ord(punkt_wyjscia[1].kier);write(plik,b);
      b:=ord(punkt_wyjscia[1].jak);write(plik,b);
      b:=ord(punkt_wyjscia[2].kier);write(plik,b);
      b:=ord(punkt_wyjscia[2].jak);write(plik,b);
      b:=ord(punkt_wyjscia[1].szyb);write(plik,b);
      b:=ord(punkt_wyjscia[1].kiedy);write(plik,b);
      b:=ord(punkt_wyjscia[2].szyb);write(plik,b);
      b:=ord(punkt_wyjscia[2].kiedy);write(plik,b); }
    blockwrite(plik, punkt_wyjscia, sizeof(punkt_wyjscia));
    b := ord(jest_2_plany);
    blockwrite(plik, b, 1);
    b := ord(niebo_odwroc);
    blockwrite(plik, b, 1);
    b := ord(dl_sopli);
    blockwrite(plik, b, 1);
    b := ord(smierc_wybuch);
    blockwrite(plik, b, 1);
    b := ord(wychodza_do_gory);
    blockwrite(plik, b, 1);
    b := ord(jestekrbum);
    blockwrite(plik, b, 1);
    b := ord(sila_dziala);
    blockwrite(plik, b, 1);
    b := ord(jestblysk);
    blockwrite(plik, b, 1);
    b := ord(jest_sz_snieg);
    blockwrite(plik, b, 1);
    b := ord(sz_snieg);
    blockwrite(plik, b, 1);
    { wyr:=ostatnie_obr[1];b:=length(wyr);
      blockwrite(plik,b,1);for c:=1 to b do begin d:=ord(wyr[c]);blockwrite(plik,d,1);end;
      wyr:=ostatnie_obr[2];b:=length(wyr);
      blockwrite(plik,b,1);for c:=1 to b do begin d:=ord(wyr[c]);blockwrite(plik,d,1);end; }
    blockwrite(plik, ostatnie_obr, sizeof(ostatnie_obr));

    b := ord(l_szaleni);
    blockwrite(plik, b, 1);
    b := length(imie_sadysty);
    blockwrite(plik, b, 1);
    for a := 1 to b do
    begin
      c := ord(imie_sadysty[a]);
      blockwrite(plik, c, 1);
    end;
    b := ord(rodzaj_dziala);
    blockwrite(plik, b, 1);
    b := ord(jest_obrmenu);
    blockwrite(plik, b, 1);
    b := ord(rodzaj_syfkow);
    blockwrite(plik, b, 1);
    b := ord(licz_utopionych);
    blockwrite(plik, b, 1);
    b := ord(raca_dlug);
    blockwrite(plik, b, 1);
    b := ord(jestblysk_wtle);
    blockwrite(plik, b, 1);
    b := ord(rodzaj_min);
    blockwrite(plik, b, 1);
    b := ord(miesko);
    blockwrite(plik, b, 1);
    blockwrite(plik, druzyna_z_kursora, 1);
    blockwrite(plik, poc_hom_ust, sizeof(poc_hom_ust));
    blockwrite(plik, jest_komentarze, 1);
    blockwrite(plik, jest_tooltip, 1);
    blockwrite(plik, jest_ranienie, 1);
    close(plik);
  end;
{$I+}
end;

{ * } PROCEDURE wczytaj_kfg;
var
  b, b2, c, d: byte;
  plik, plik2, spraw: file;
  wr: word;
begin
  resetuj_ustawienia(1);
  assign(plik, 'sadist.cfg');
  filemode := 0;
{$I-}
  reset(plik, 1);
  if IOResult = 0 then
  begin
    if not eof(plik) then
    begin
      blockread(plik, b, 1);
      bron := b;
    end;
    if not eof(plik) then
    begin
      blockread(plik, b, 1);
      bron := b;
    end;
    if not eof(plik) then
    begin
      blockread(plik, b, 1);
      strzelaja_do_siebie := b;
    end;
    if not eof(plik) then
    begin
      blockread(plik, b, 1);
      if b = 0 then
        burza := false
      else
        burza := true;
    end;
    if not eof(plik) then
    begin
      blockread(plik, b, 1);
      pada_snieg := b;
    end;
    if not eof(plik) then
    begin
      blockread(plik, b, 1);
      dziura_na_dole := b;
    end;
    if not eof(plik) then
    begin
      blockread(plik, b, 1);
      if b = 0 then
        sa_sople := false
      else
        sa_sople := true;
    end;
    if not eof(plik) then
    begin
      blockread(plik, b, 1);
      niebo := b;
    end;

    if not eof(plik) then
      blockread(plik, pal_gl[229], 15);
    { if not eof(plik) then begin blockread(plik,pal_gl[229,0],1);end;
      if not eof(plik) then begin blockread(plik,pal_gl[229,1],1);end;
      if not eof(plik) then begin blockread(plik,pal_gl[229,2],1);end;
      if not eof(plik) then begin blockread(plik,pal_gl[233,0],1);end;
      if not eof(plik) then begin blockread(plik,pal_gl[233,1],1);end;
      if not eof(plik) then begin blockread(plik,pal_gl[233,2],1);end; }
    if not eof(plik) then
    begin
      blockread(plik, b, 1);
      rys_kol := b;
    end;
    if not eof(plik) then
    begin
      blockread(plik, b, 1);
      rys_grub := b;
    end;
    if not eof(plik) then
    begin
      blockread(plik, b, 1);
      sila_broni := b;
    end;
    if not eof(plik) then
    begin
      blockread(plik, b, 1);
      bron_odlamki := b;
    end;
    if not eof(plik) then
    begin
      blockread(plik, b, 1);
      sila_odlamki := b;
    end;
    if not eof(plik) then
    begin
      blockread(plik, b, 1);
      if b = 0 then
        kap_krew := false
      else
        kap_krew := true;
    end;
    if not eof(plik) then
    begin
      blockread(plik, b, 1);
      if b = 0 then
        l_strzelaja := false
      else
        l_strzelaja := true;
    end;
    if not eof(plik) then
    begin
      blockread(plik, b, 1);
      if b = 0 then
        l_bija := false
      else
        l_bija := true;
    end;
    for a := 0 to maxszczyt do
    begin
      if not eof(plik) then
        blockread(plik, b, 1);
      if not eof(plik) then
      begin
        blockread(plik, b2, 1);
        szczyt[a].x := b * 256 + b2;
      end;
      if not eof(plik) then
      begin
        blockread(plik, b, 1);
        szczyt[a].y := b;
      end;
    end;
    if not eof(plik) then
    begin
      blockread(plik, b, 1);
      rodzaj_tla := b;
    end;
    if not eof(plik) then
    begin
      blockread(plik, b, 1);
      if b = 0 then
        jest_dzwiek := false
      else
        jest_dzwiek := true;
    end;
    { if not eof(plik) then begin blockread(plik,b);if b=0 then punkt_wyjscia[1].gora:=false else punkt_wyjscia[1].gora:=true;
      end;
      if not eof(plik) then blockread(plik,b);if not eof(plik) then begin blockread(plik,b2);punkt_wyjscia[1].x:=b*256+b2;end;
      if not eof(plik) then begin blockread(plik,b);punkt_wyjscia[1].y:=b;end;
      if not eof(plik) then begin blockread(plik,b);if b=0 then punkt_wyjscia[2].gora:=false else punkt_wyjscia[2].gora:=true;
      end;
      if not eof(plik) then blockread(plik,b);if not eof(plik) then begin blockread(plik,b2);punkt_wyjscia[2].x:=b*256+b2;end;
      if not eof(plik) then begin blockread(plik,b);punkt_wyjscia[2].y:=b;end;
      if not eof(plik) then begin blockread(plik,b);punkt_wyjscia[1].kier:=b;end;
      if not eof(plik) then begin blockread(plik,b);punkt_wyjscia[1].jak:=b;end;
      if not eof(plik) then begin blockread(plik,b);punkt_wyjscia[2].kier:=b;end;
      if not eof(plik) then begin blockread(plik,b);punkt_wyjscia[2].jak:=b;end;
      if not eof(plik) then begin blockread(plik,b);punkt_wyjscia[1].szyb:=b;end;
      if not eof(plik) then begin blockread(plik,b);punkt_wyjscia[1].kiedy:=b;end;
      if not eof(plik) then begin blockread(plik,b);punkt_wyjscia[2].szyb:=b;end;
      if not eof(plik) then begin blockread(plik,b);punkt_wyjscia[2].kiedy:=b;end; }
    if not eof(plik) then
      blockread(plik, punkt_wyjscia, sizeof(punkt_wyjscia));
    if not eof(plik) then
    begin
      blockread(plik, b, 1);
      if b = 0 then
        jest_2_plany := false
      else
        jest_2_plany := true;
    end;
    if not eof(plik) then
    begin
      blockread(plik, b, 1);
      if b = 0 then
        niebo_odwroc := false
      else
        niebo_odwroc := true;
    end;
    if not eof(plik) then
    begin
      blockread(plik, b, 1);
      dl_sopli := b;
    end;
    if not eof(plik) then
    begin
      blockread(plik, b, 1);
      if b = 0 then
        smierc_wybuch := false
      else
        smierc_wybuch := true;
    end;
    if not eof(plik) then
    begin
      blockread(plik, b, 1);
      if b = 0 then
        wychodza_do_gory := false
      else
        wychodza_do_gory := true;
    end;
    if not eof(plik) then
    begin
      blockread(plik, b, 1);
      if b = 0 then
        jestekrbum := false
      else
        jestekrbum := true;
    end;
    if not eof(plik) then
    begin
      blockread(plik, b, 1);
      sila_dziala := b;
    end;
    if not eof(plik) then
    begin
      blockread(plik, b, 1);
      if b = 0 then
        jestblysk := false
      else
        jestblysk := true;
    end;
    if not eof(plik) then
    begin
      blockread(plik, b, 1);
      if b = 0 then
        jest_sz_snieg := false
      else
        jest_sz_snieg := true;
    end;
    if not eof(plik) then
    begin
      blockread(plik, b, 1);
      sz_snieg := b;
    end;
    { if not eof(plik) then begin
      blockread(plik,b,1);wyr:='';
      for c:=1 to b do begin if not eof(plik) then blockread(plik,d,1);wyr:=wyr+chr(d);end;ostatnie_obr[1]:=wyr;
      end;
      if not eof(plik) then begin
      blockread(plik,b,1);wyr:='';
      for c:=1 to b do begin if not eof(plik) then blockread(plik,d,1);wyr:=wyr+chr(d);end;ostatnie_obr[2]:=wyr;
      end; }
    if not eof(plik) then
      blockread(plik, ostatnie_obr, sizeof(ostatnie_obr));

    if not eof(plik) then
    begin
      blockread(plik, b, 1);
      if b = 0 then
        l_szaleni := false
      else
        l_szaleni := true;
    end;
    if not eof(plik) then
    begin
      blockread(plik, b, 1);
      imie_sadysty := '';
      for a := 1 to b do
      begin
        blockread(plik, c, 1);
        imie_sadysty := imie_sadysty + chr(c);
      end;
    end
    else
      imie_sadysty := 'SADYSTA';
    if not eof(plik) then
    begin
      blockread(plik, b, 1);
      rodzaj_dziala := b;
    end;
    if not eof(plik) then
    begin
      blockread(plik, b, 1);
      if b = 0 then
        jest_obrmenu := false
      else
        jest_obrmenu := true;
    end;
    if not eof(plik) then
    begin
      blockread(plik, b, 1);
      rodzaj_syfkow := b;
    end;
    if not eof(plik) then
    begin
      blockread(plik, b, 1);
      if b = 0 then
        licz_utopionych := false
      else
        licz_utopionych := true;
    end;
    if not eof(plik) then
    begin
      blockread(plik, b, 1);
      raca_dlug := b;
    end;
    if not eof(plik) then
    begin
      blockread(plik, b, 1);
      if b = 0 then
        jestblysk_wtle := false
      else
        jestblysk_wtle := true;
    end;
    if not eof(plik) then
    begin
      blockread(plik, b, 1);
      rodzaj_min := b;
    end;
    if not eof(plik) then
    begin
      blockread(plik, b, 1);
      if b = 0 then
        miesko := false
      else
        miesko := true;
    end;
    if not eof(plik) then
      blockread(plik, druzyna_z_kursora, 1);
    if not eof(plik) then
      blockread(plik, poc_hom_ust, sizeof(poc_hom_ust));
    if not eof(plik) then
      blockread(plik, jest_komentarze, 1);
    if not eof(plik) then
      blockread(plik, jest_tooltip, 1);
    if not eof(plik) then
      blockread(plik, jest_ranienie, 1);
    close(plik);
  end
  else
  begin
    resetuj_ustawienia(1);
  end;
  zmien_niebo;
  assign(plik2, '_temp.sds');
  filemode := 0;
  reset(plik2);
  if IOResult = 0 then
  begin
    nowy(0);
    blockread(plik2, scr^, 500, wr);
    move(scr^, Mem[$A000: 0000], 64000);
    close(plik2);
  end
  else
    nowy(1);
  S_sila := 20;
  S_kier := 16;

  assign(spraw, 'POSTACI\' + ostatnie_obr[1] + '.SDP');
  filemode := 0;
{$I-}reset(spraw); {$I+}
  if IOResult = 0 then
    close(spraw)
  else
    ostatnie_obr[1] := 'LUDZIE';
  assign(spraw, 'POSTACI\' + ostatnie_obr[2] + '.SDP');
{$I-}reset(spraw); {$I+}
  if IOResult = 0 then
    close(spraw)
  else
    ostatnie_obr[2] := 'LUDZIE';
{$I+}
end;

{ * } PROCEDURE ustawianieludzi;
var
  juz: boolean;
  druzyna, ki1, ki2: byte;
begin
  tlo_menu;
  pisz(133, 33, 'OPCJE LUDZI', 79, 0);
  bar3(100, 157, 220, 165, 148, 156, 159);
  pisz(150, 159, 'WRoc', 31, 0);

  bar2(117, 44, 202, 50, 16);
  pisz(122, 45, '** DRUzYNA 1 **', 229, 0);
  bar3(125, 55, 194, 60, 148, 156, 159);
  pisz(120, 55, 'R', 79, 0);
  bar3(125, 62, 194, 67, 148, 156, 159);
  pisz(120, 62, 'G', 175, 0);
  bar3(125, 69, 194, 74, 148, 156, 159);
  pisz(120, 69, 'B', 127, 0);
  bar3(84, 77, 150, 85, 148, 156, 159);
  pisz(102, 79, 'ZWYKlY', 31, 0);
  bar3(170, 77, 236, 85, 148, 156, 159);
  pisz(188, 79, 'LOSOWY', 31, 0);

  bar3(100, 90, 220, 98, 148, 156, 159);
  bar3(100, 101, 220, 109, 148, 156, 159);
  bar3(100, 112, 220, 120, 148, 156, 159);
  bar3(100, 123, 220, 131, 148, 156, 159);

  juz := false;
  druzyna := 1;
  ki1 := 1;
  ki2 := 1;
  repeat
    klawisze;
    dec(ki2);
    if ki2 <= 1 then
    begin
      inc(ki1);
      if ki1 > 64 then
        ki1 := 1;
      bar2(100, 42, 110, 51, 16);
      pobr(100, 42, ki1, 1, 24, 228 + druzyna, 0, druzyna);
      bar2(209, 42, 219, 51, 16);
      pobr(209, 42, ki1, 1, 24, 228 + druzyna, 1, druzyna);
      ki2 := 20;
    end;

    if smierc_wybuch then
      pisz(143, 92, 'WYBUCHY', 111, 0)
    else
      pisz(143, 92, 'WYBUCHY', 101, 0);
    if wychodza_do_gory then
      pisz(140, 103, 'WYCHODZa', 111, 0)
    else
      pisz(140, 103, 'WYCHODZa', 101, 0);
    if l_szaleni then
      pisz(140, 114, 'SZALEnCY', 111, 0)
    else
      pisz(140, 114, 'SZALEnCY', 101, 0);
    if miesko then
      pisz(145, 125, 'MIeSKO', 111, 0)
    else
      pisz(145, 125, 'MIeSKO', 101, 0);
    mysz;
    mysz2;
    move(scr^, Mem[$A000: 0000], 64000);
    for a := 0 to 66 do
      drawline(126 + a, 56, 126 + a, 59, trunc(64 + a / 4.2), 2);
    for a := 0 to 66 do
      drawline(126 + a, 63, 126 + a, 66, trunc(160 + a / 4.2), 2);
    for a := 0 to 66 do
      drawline(126 + a, 70, 126 + a, 73, trunc(112 + a / 4.2), 2);
    bar3(126 + pal_gl[228 + druzyna, 0], 56, 130 + pal_gl[228 + druzyna, 0], 59, 148, 159, 138);
    bar3(126 + pal_gl[228 + druzyna, 1], 63, 130 + pal_gl[228 + druzyna, 1], 66, 148, 159, 138);
    bar3(126 + pal_gl[228 + druzyna, 2], 70, 130 + pal_gl[228 + druzyna, 2], 73, 148, 159, 138);

    if (klik[1]) then
    begin
      wyb_przy_kur;
      if (mysz_w(84, 77, 150, 85)) then
      begin
        for a := 0 to 2 do
          pal_gl[228 + druzyna, a] := kolory_druzyn[druzyna, a];
        cala_paleta(1, 0);
      end;
      if (mysz_w(170, 77, 236, 85)) then
      begin
        pal_gl[228 + druzyna, 0] := random(64);
        pal_gl[228 + druzyna, 1] := random(64);
        pal_gl[228 + druzyna, 2] := random(64);
        cala_paleta(1, 0);
      end;
      if (mysz_w(100, 92, 220, 98)) then
      begin
        if smierc_wybuch then
          smierc_wybuch := false
        else
          smierc_wybuch := true;
      end;
      if (mysz_w(100, 101, 220, 109)) then
      begin
        if wychodza_do_gory then
          wychodza_do_gory := false
        else
          wychodza_do_gory := true;
      end;
      if (mysz_w(100, 112, 220, 120)) then
      begin
        if l_szaleni then
          l_szaleni := false
        else
          l_szaleni := true;
      end;
      if (mysz_w(100, 123, 220, 131)) then
      begin
        if miesko then
          miesko := false
        else
          miesko := true;
      end;
      if (mysz_w(100, 157, 220, 165)) then
        juz := true;

      if mysz_w(117, 44, 202, 50) then
      begin
        inc(druzyna);
        if druzyna >= 6 then
          druzyna := 1;
        str(druzyna, wyr);
        bar2(117, 44, 202, 50, 16);
        pisz(122, 45, '** DRUzYNA ' + wyr + ' **', 228 + druzyna, 0);
      end;
    end;
    if (klik[2]) and (mysz_w(117, 44, 202, 50)) then
    begin
      dec(druzyna);
      if druzyna <= 0 then
        druzyna := 5;
      str(druzyna, wyr);
      bar2(117, 44, 202, 50, 16);
      pisz(122, 45, '** DRUzYNA ' + wyr + ' **', 228 + druzyna, 0);
    end;

    if guzik[1] then
    begin
      if mysz_w(128, 56, 191, 59) then
      begin
        pal_gl[228 + druzyna, 0] := mx - 128;
        cala_paleta(1, 0);
      end;
      if mysz_w(128, 63, 191, 66) then
      begin
        pal_gl[228 + druzyna, 1] := mx - 128;
        cala_paleta(1, 0);
      end;
      if mysz_w(128, 70, 191, 73) then
      begin
        pal_gl[228 + druzyna, 2] := mx - 128;
        cala_paleta(1, 0);
      end;
    end;
    if ((kl[1]) and (kl_wcisn[1] = 0)) then
    begin
      juz := true;
      kl_wcisn[1] := 1;
    end;
  until juz;
  Mopcje := false;
end;

{ * } PROCEDURE ustawianiegry;
var
  juz: boolean;
  bg: array [0 .. 3] of byte;

begin
  tlo_menu;
  pisz(130, 33, 'OGoLNE OPCJE', 79, 0);

  str(memavail, wyr);
  while length(wyr) < 6 do
    insert('0', wyr, 1);
  pisz(85, 168, 'PAMIec:' + wyr, 170, 0);
  str(XMSmemavail, wyr);
  while length(wyr) < 8 do
    insert('0', wyr, 1);
  pisz(175, 168, 'XMS:' + wyr, 170, 0);

  bar3(72, 42, 180, 50, 148, 156, 159);
  pisz(83, 44, 'RODZAJ NIEBA:', 31, 0);

  case niebo of
    0 .. 16:
      for a := 1 to 7 do
        drawline(159, 42 + a, 169, 42 + a, a * 2, 2);
  else
    for a := 1 to 7 do
    begin
      for a1 := 1 to 11 do
      begin
        putpix(158 + a1, 42 + a, scr2^[trunc(a * 28.3), trunc(a1 * 28.3)], 0);
      end;
    end;
  end;
  bar3(185, 42, 248, 50, 148, 156, 159); { odwroc (niebo) }

  bar3(72, 52, 159, 60, 148, 156, 159); { ruch ekranu }
  bar3(161, 52, 248, 60, 148, 156, 159); { blysk piorunow }

  bar3(72, 62, 159, 70, 148, 156, 159); { wielkosc opadow }
  bar3(161, 62, 248, 70, 148, 156, 159); { blysk w tle }

  bar3(72, 72, 159, 80, 148, 156, 159); { suwak od sniegu i deszczu }
  bar3(161, 72, 248, 80, 148, 156, 159); { 2 plany sniegu }

  bar3(72, 82, 159, 90, 148, 156, 159); { licz utopionych }
  bar3(161, 82, 248, 90, 148, 156, 159); { obrazek menu }

  bar3(72, 92, 159, 100, 148, 156, 159); { tooltip }
  bar3(161, 92, 248, 100, 148, 156, 159); { texty }

  bar3(72, 102, 159, 110, 148, 156, 159); { ranienie }

  bar3(100, 112, 220, 120, 148, 156, 159);
  pisz(105, 114, 'TWOJE IMIe:', 31, 0);
  pisz(165, 114, imie_sadysty, 47, 0);

  bar3(95, 146, 215, 154, 148, 156, 159);
  pisz(100, 148, 'STANDARDOWE USTAWIENIA', 31, 0);
  bar3(215, 146, 225, 154, 148, 156, 159);
  bar2(217, 148, 223, 152, 79); { guziczek stand.ust }
  bar3(100, 157, 220, 165, 148, 156, 159);
  pisz(150, 159, 'WRoc', 31, 0);
  juz := false;

  (* bar3(100, 72,220, 80,148,156,159); {dzwiek} *)
  { if jest_dzwiek then pisz(145,74,'DxWIeK',95,0)
    else pisz(145,74,'DxWIeK',85,0); }

  repeat
    klawisze;
    if niebo_odwroc then
      pisz(201, 44, 'ODWRoc', 95, 0)
    else
      pisz(201, 44, 'ODWRoc', 85, 0);

    if jestekrbum then
      pisz(88, 54, 'RUCH EKRANU', 95, 0)
    else
      pisz(88, 54, 'RUCH EKRANU', 85, 0);
    if jestblysk then
      pisz(169, 54, 'BlYSK PIORUNoW', 95, 0)
    else
      pisz(169, 54, 'BlYSK PIORUNoW', 85, 0);

    if jest_sz_snieg then
      pisz(77, 64, 'WIELKOsc OPADoW', 95, 0)
    else
      pisz(77, 64, 'WIELKOsc OPADoW', 85, 0);
    if jestblysk_wtle then
      pisz(174, 64, 'BlYSKI W TLE', 95, 0)
    else
      pisz(174, 64, 'BlYSKI W TLE', 85, 0);

    if jest_2_plany then
      pisz(169, 74, '2 PLANY OPADoW', 95, 0)
    else
      pisz(169, 74, '2 PLANY OPADoW', 85, 0);

    if licz_utopionych then
      pisz(77, 84, 'LICZ UTOPIONYCH', 95, 0)
    else
      pisz(77, 84, 'LICZ UTOPIONYCH', 85, 0);
    if jest_obrmenu then
      pisz(169, 84, 'RYSUNEK W MENU', 95, 0)
    else
      pisz(169, 84, 'RYSUNEK W MENU', 85, 0);

    if jest_tooltip then
      pisz(88, 94, 'PODPOWIEDZI', 95, 0)
    else
      pisz(88, 94, 'PODPOWIEDZI', 85, 0);
    if jest_komentarze then
      pisz(179, 94, 'KOMENTARZE', 95, 0)
    else
      pisz(179, 94, 'KOMENTARZE', 85, 0);

    if jest_ranienie then
      pisz(77, 104, 'RANY OD UDERZEn', 95, 0)
    else
      pisz(77, 104, 'RANY OD UDERZEn', 85, 0);

    { suwak od sniegu i deszczu }
    if jest_sz_snieg then
      for a := 73 to 157 do
        drawline(a, 73, a, 79, 20 + trunc((a - 73) / 8.5), 2)
    else
      for a := 73 to 157 do
        drawline(a, 73, a, 79, 148 + trunc((a - 73) / 16), 2);
    bar3(72 + trunc((sz_snieg) / (100 / 80)), 73, 77 + trunc((sz_snieg) / (100 / 80)), 79, 148, 159, 138);

    bar2(148, 43, 157, 49, 156);
    str(niebo + 1, wyr);
    while length(wyr) < 2 do
      insert('0', wyr, 1);
    pisz(148, 44, wyr, 31, 0);

    mysz;
    mysz2;
    move(scr^, Mem[$A000: 0000], 64000);
    if (klik[2]) and (mysz_w(72, 42, 180, 50)) then
    begin
      wyb_przy_kur;
      dec(niebo);
      if niebo < 0 then
        niebo := 16 + 14;
      zmien_niebo;
    end;
    if ((klik[1]) or (klik[2])) and (mysz_w(185, 42, 248, 50)) then
    begin
      if klik[2] then
        wyb_przy_kur;
      if niebo_odwroc then
        niebo_odwroc := false
      else
        niebo_odwroc := true;
      zmien_niebo;
    end;
    if (klik[1]) then
    begin
      wyb_przy_kur;
      if (mysz_w(72, 42, 180, 50)) then
      begin
        inc(niebo);
        if niebo > 16 + 14 then
          niebo := 0;
        zmien_niebo;
      end;
      if (mysz_w(72, 52, 159, 60)) then
      begin
        if jestekrbum then
          jestekrbum := false
        else
          jestekrbum := true;
      end;
      if (mysz_w(161, 52, 248, 60)) then
      begin
        if jestblysk then
          jestblysk := false
        else
          jestblysk := true;
      end;
      if (mysz_w(161, 62, 248, 70)) then
      begin
        if jestblysk_wtle then
          jestblysk_wtle := false
        else
          jestblysk_wtle := true;
      end;
      if (mysz_w(72, 62, 159, 70)) then
      begin
        if jest_sz_snieg then
          jest_sz_snieg := false
        else
          jest_sz_snieg := true;
      end;
      if (mysz_w(161, 72, 248, 80)) then
      begin
        if jest_2_plany then
          jest_2_plany := false
        else
          jest_2_plany := true;
      end;
      if (mysz_w(210, 146, 225, 154)) then
      begin
        resetuj_ustawienia(0);
        zmien_niebo;
      end;
      if (mysz_w(161, 82, 248, 90)) then
      begin
        if jest_obrmenu then
          jest_obrmenu := false
        else
          jest_obrmenu := true;
      end;
      if (mysz_w(72, 82, 159, 90)) then
      begin
        if licz_utopionych then
          licz_utopionych := false
        else
          licz_utopionych := true;
      end;

      if (mysz_w(72, 92, 159, 100)) then
      begin
        if jest_tooltip then
          jest_tooltip := false
        else
          jest_tooltip := true;
      end;
      if (mysz_w(161, 92, 248, 100)) then
      begin
        if jest_komentarze then
          jest_komentarze := false
        else
          jest_komentarze := true;
      end;

      if (mysz_w(72, 102, 159, 110)) then
      begin
        if jest_ranienie then
          jest_ranienie := false
        else
          jest_ranienie := true;
      end;

      if (mysz_w(100, 157, 220, 165)) then
        juz := true;

      if (mysz_w(100, 112, 220, 120)) then
      begin
        imie_sadysty := wpisz(imie_sadysty, 10, 165, 112, true);
        bar2(164, 113, 215, 119, 156);
        pisz(165, 114, imie_sadysty, 47, 0);
      end;
    end;
    if (guzik[1]) and (mysz_w(75, 72, 155, 80)) then
      sz_snieg := trunc((mx - 73) * (100 / 80));

    if ((kl[1]) and (kl_wcisn[1] = 0)) then
    begin
      juz := true;
      kl_wcisn[1] := 1;
    end;
  until juz;
  Mopcje2 := false;
  if (not jest_obrmenu) then
    ekran_ukryty(0)
  else
    ekran_ukryty(2);
end;

{ * } PROCEDURE wczytaj_pomoc;
var
  b: byte;
  plik: file;
begin
  assign(plik, 'sadist.dat' { 'sadist.pmc' } );
{$I-}
  filemode := 0;
  reset(plik, 1);
  seek(plik, 273610);
{$I+}
  dl_pomocy := 1;
  if IOResult = 0 then
  begin
    blockread(plik, tekst_pomocy, sizeof(tekst_pomocy));
    dl_pomocy := sizeof(tekst_pomocy);
    close(plik);
  end;
  for a := 1 to dl_pomocy do
    tekst_pomocy[a] := chr(255 - ord(tekst_pomocy[a]));
end;

{ * } PROCEDURE pok_tekst;
var
  x, y: byte;
begin
  bar2(77, 45, 249, 145, 154);
  scr_y1 := 45;
  scr_y2 := 145;
  lit := wys_pom;
  kol_pom := 31;
  x := 0;
  y := 0;
  repeat
    if (x >= 34) and (tekst_pomocy[lit] <> #13) then
    begin
      x := 0;
      inc(y);
    end;
    if (tekst_pomocy[lit] <> #13) and (tekst_pomocy[lit] <> #64) then
    begin
      pisz(77 + x * 5, 23 + y * 6 + y_pom, tekst_pomocy[lit], kol_pom, 0);
      inc(x);
      inc(lit);
    end
    else
    begin
      case tekst_pomocy[lit] of
        #13:
          begin
            inc(y);
            x := 0;
            inc(lit);
          end;
        #64:
          begin
            inc(lit);
            kol_pom := ord(tekst_pomocy[lit]);
            inc(lit);
          end;
      end;
    end;
  until (lit >= dl_pomocy) or (y > 20);
  scr_y1 := 11;
  scr_y2 := 199;
end;

{ * } PROCEDURE pomoc;
var
  juz, pt: boolean;
begin
  bar3(70, 30, 250, 175, 148, 154, 159);
  pisz(148, 33, 'POMOC', 79, 0);
  bar3(100, 157, 220, 165, 148, 156, 159);
  pisz(150, 159, 'WRoc', 31, 0);
  bar3(100, 147, 155, 155, 148, 156, 159);
  pisz(112, 149, 'WSTECZ', 31, 0);
  bar3(165, 147, 220, 155, 148, 156, 159);
  pisz(180, 149, 'DALEJ', 31, 0);
  bar3(72, 44, 76, 146, 148, 156, 159);
  juz := false;
  pt := true;
  y_pom := 0;
  wys_pom := 1;
  repeat
    klawisze;
    putpix(73, 45 + trunc((100 / (dl_pomocy - 400)) * wys_pom), 79, 0);
    putpix(74, 45 + trunc((100 / (dl_pomocy - 400)) * wys_pom), 79, 0);
    mysz;
    mysz2;
    move(scr^, Mem[$A000: 0000], 64000);
    putpix(73, 45 + trunc((100 / (dl_pomocy - 400)) * wys_pom), 156, 0);
    putpix(74, 45 + trunc((100 / (dl_pomocy - 400)) * wys_pom), 156, 0);
    if (klik[1]) then
    begin
      wyb_przy_kur;
      if mysz_w(100, 157, 220, 165) then
        juz := true;
    end;
    if (guzik[1]) and (mysz_w(72, 44, 75, 145)) then
    begin
      wys_pom := trunc((my - 44) / (100 / (dl_pomocy - 400)));
      if wys_pom < 0 then
        wys_pom := 0;
      if wys_pom >= dl_pomocy - 400 then
        wys_pom := dl_pomocy - 400;
      pt := true;
    end;
    if (guzik[1]) then
    begin
      if (mysz_w(165, 147, 220, 155)) and (wys_pom < dl_pomocy - 400) then
      begin
        dec(y_pom);
        pt := true;
      end;
      if (mysz_w(100, 147, 155, 155)) and (wys_pom > 1) then
      begin
        inc(y_pom);
        pt := true;
      end;
    end;
    if (guzik[2]) then
    begin
      if (mysz_w(165, 147, 220, 155)) and (wys_pom < dl_pomocy - 400) then
      begin
        dec(y_pom, 2);
        pt := true;
      end;
      if (mysz_w(100, 147, 155, 155)) and (wys_pom > 1) then
      begin
        inc(y_pom, 2);
        pt := true;
      end;
    end;
    if y_pom < 0 then
    begin
      inc(y_pom, 6);
      repeat
        inc(wys_pom);
      until tekst_pomocy[wys_pom] = #13;
    end;
    if y_pom > 5 then
    begin
      dec(y_pom, 6);
      repeat
        dec(wys_pom);
      until (tekst_pomocy[wys_pom] = #13) or (wys_pom < 0);
      if wys_pom < 0 then
        wys_pom := 0;
    end;
    if ((kl[1]) and (kl_wcisn[1] = 0)) then
    begin
      juz := true;
      kl_wcisn[1] := 1;
    end;
    if pt then
    begin
      pok_tekst;
      pt := false;
    end;
  until ((kl[1]) and (kl_wcisn[1] = 0)) or (juz);
  Mpomoc := false;
  scr_y1 := 11;
  scr_y2 := 199;
end;

{ * } PROCEDURE zapis;
var
  plik2: file;
  wr, licz_min: word;
  b, b2: byte;
  DirInfo: SearchRec;
  x: integer;
  bb, il_plikow: byte;
  pt, juz, anuluj: boolean;
  nazwa_pliku: string[8];
begin
  tlo_menu;
  pisz(147, 33, 'ZAPIS', 79, 0);
  bar3(100, 157, 155, 165, 148, 156, 159);
  pisz(122, 159, 'OK', 31, 0);
  bar3(165, 157, 220, 165, 148, 156, 159);
  pisz(178, 159, 'ANULUJ', 31, 0);
  bar3(100, 147, 155, 155, 148, 156, 159);
  pisz(112, 149, 'WSTECZ', 31, 0);
  bar3(165, 147, 220, 155, 148, 156, 159);
  pisz(180, 149, 'DALEJ', 31, 0);
  FindFirst('TERENY\*.sds', Archive, DirInfo);
  x := 0;
  il_plikow := 0;
  while DosError = 0 do
  begin
    inc(x);
    inc(il_plikow);
    wyr := DirInfo.Name;
    bb := length(wyr);
    for a := bb downto bb - 3 do
      wyr[a] := ' ';
    pliki[x] := wyr;
    FindNext(DirInfo);
  end;
  repeat
    a := 0;
    for x := 1 to il_plikow - 1 do
    begin
      if pliki[x] > pliki[x + 1] then
      begin
        a := 1;
        wyr := pliki[x];
        pliki[x] := pliki[x + 1];
        pliki[x + 1] := wyr;
      end;
    end;
  until a = 0;
  x := 1;
  pt := true;
  juz := false;
  anuluj := false;
  nazwa_pliku := ostatni_plik;
  repeat
    klawisze;
    mysz;
    mysz2;
    move(scr^, Mem[$A000: 0000], 64000);
    if pt then
    begin
      bar3(130, 46, 190, 128, 148, 156, 159);
      for a := 1 to 12 do
      begin
        if a + x - 1 <= il_plikow then
          pisz(140, a * 6 + 45, pliki[a + x - 1], 31, 0);
      end;
      bar3(130, 131, 190, 139, 148, 156, 159);
      pisz(140, 133, nazwa_pliku, 47, 0);
      pt := false;
    end;
    if (guzik[2]) then
    begin
      if (mysz_w(165, 147, 220, 155)) and (x < il_plikow - 10) then
      begin
        inc(x);
        pt := true;
      end;
      if (mysz_w(100, 147, 155, 155)) and (x > 1) then
      begin
        dec(x);
        pt := true;
      end;
    end;
    if (klik[1]) then
    begin
      wyb_przy_kur;
      if (mysz_w(165, 147, 220, 155)) and (x < il_plikow - 10) then
      begin
        inc(x);
        pt := true;
      end;
      if (mysz_w(100, 147, 155, 155)) and (x > 1) then
      begin
        dec(x);
        pt := true;
      end;
      if (mysz_w(133, 51, 187, 124)) and ((((my - 51) div 6) + x) <= il_plikow) then
      begin
        nazwa_pliku := pliki[((my - 51) div 6) + x];
        pt := true;
      end;
      if mysz_w(100, 157, 155, 165) then
        juz := true;
      if mysz_w(165, 157, 220, 165) then
        anuluj := true;
      if mysz_w(130, 131, 190, 139) then
      begin
        nazwa_pliku := wpisz(nazwa_pliku, 8, 140, 131, false);
        pt := true;
      end;
    end;
    if ((kl[1]) and (kl_wcisn[1] = 0)) then
    begin
      anuluj := true;
      kl_wcisn[1] := 1;
    end;

  until (juz) or (anuluj);

  if juz then
  begin
    ostatni_plik := nazwa_pliku;
    { for a:=30 to 175 do move (scr_ukryty^[a,70], scr^[a,70], 180); }
    ekran_ukryty(0);

    { if (menu) or (sz_menu) then napisy(0); }
    { if (ile_wybr>0) then napisy_o_wybranym(0); }
    { if (my<10) and (ile_wybr=0) then sz_menu:=true else sz_menu:=false; }
    zmaz_miny;
    zmaz_kaw;
    zmaz_ramke;
    mysz;
    zmaz_strz;
    snieg_zmaz;
    syfki_zmaz;
    postacie_zmaz;
    for a := 1 to maxpoc do
    begin
      if poc[1, a] = 1 then
        putpix(round(poc[2, a]), round(poc[3, a]), 0, 0);
    end;
    sople_zmaz;

    assign(plik2, 'TERENY\' + nazwa_pliku + '.sds');
    filemode := 1;
{$I-}
    rewrite(plik2, 1);
{$I+}
    if IOResult = 0 then
    begin
      blockwrite(plik2, scr^, 64000);
      b := ord(burza);
      blockwrite(plik2, b, 1);
      b := ord(pada_snieg);
      blockwrite(plik2, b, 1);
      b := ord(dziura_na_dole);
      blockwrite(plik2, b, 1);
      b := ord(niebo);
      blockwrite(plik2, b, 1);
      b := ord(punkt_wyjscia[1].gora);
      blockwrite(plik2, b, 1);
      b := punkt_wyjscia[1].x div 256;
      b2 := punkt_wyjscia[1].x mod 256;
      blockwrite(plik2, b, 1);
      blockwrite(plik2, b2, 1);
      b := ord(punkt_wyjscia[1].y);
      blockwrite(plik2, b, 1);
      b := ord(punkt_wyjscia[2].gora);
      blockwrite(plik2, b, 1);
      b := punkt_wyjscia[2].x div 256;
      b2 := punkt_wyjscia[2].x mod 256;
      blockwrite(plik2, b, 1);
      blockwrite(plik2, b2, 1);
      b := ord(punkt_wyjscia[2].y);
      blockwrite(plik2, b, 1);
      b := ord(punkt_wyjscia[1].kier);
      blockwrite(plik2, b, 1);
      b := ord(punkt_wyjscia[1].jak);
      blockwrite(plik2, b, 1);
      b := ord(punkt_wyjscia[2].kier);
      blockwrite(plik2, b, 1);
      b := ord(punkt_wyjscia[2].jak);
      blockwrite(plik2, b, 1);
      b := ord(punkt_wyjscia[1].szyb);
      blockwrite(plik2, b, 1);
      b := ord(punkt_wyjscia[1].kiedy);
      blockwrite(plik2, b, 1);
      b := ord(punkt_wyjscia[2].szyb);
      blockwrite(plik2, b, 1);
      b := ord(punkt_wyjscia[2].kiedy);
      blockwrite(plik2, b, 1);
      b := ord(niebo_odwroc);
      blockwrite(plik2, b, 1);
      licz_min := 0;
      for a := 1 to maxminy do
      begin
        if miny[a].jest then
          inc(licz_min);
      end;
      b := ord(licz_min);
      blockwrite(plik2, b, 1);
      if licz_min > 0 then
      begin
        for a := 1 to maxminy do
        begin
          if miny[a].jest then
          begin
            b := trunc(miny[a].x) div 256;
            b2 := trunc(miny[a].x) mod 256;
            blockwrite(plik2, b, 1);
            blockwrite(plik2, b2, 1);
            b := trunc(miny[a].y);
            blockwrite(plik2, b, 1);
          end;
        end;
      end;
      blockwrite(plik2, punkt_wyjscia[3], 30);
      close(plik2);
    end;
    ekran_ukryty(1);
    postacie_pok;
    for a := 1 to maxpoc do
    begin
      if poc[1, a] = 1 then
        putpix(round(poc[2, a]), round(poc[3, a]), 245, 0);
    end;
    sople_pok;
    syfki_pok;
    snieg_pok;
    pok_strz;
    pok_miny;
    pok_kaw;
    pok_ramke;
  end;

  Mzapis := false;
end;

{ * } PROCEDURE napisy_do_edytora;
begin
  scr_y1 := 0;
  napisy_do_rysowania;
  { pisz(0,0,'ZRoB GoRY',159,0);
    pisz(60,0,'ZMAz CAlE',159,0); }
  scr_y1 := 11;
end;

{ * } PROCEDURE rob_gory;
var
  x, y, dlyg, Gk, Gdk, Gk2, s_my, aa: integer;
  yg, dyg: real;
  juz, anuluj: boolean;

  BMPFile: File;
  Lines: word;
  b: byte;
  rx, ry: longint;
  lin: array [1 .. 320] of byte;
  Header: record bfType: word;
  bfSize, bfReserved, bfOffBits, biSize, Width, Height: longint;
  biPlanes, biBitCount: word;
  biCompression, biSizeImage, biXPelsPerMeter, biYPelsPerMeter, biClrUsed, biClrImportant: longint;
end;

{ + } PROCEDURE pokaz_kontur;
var
  a: byte;
begin
  Gk := Gk + Gdk;
  if Gk >= 15 then
    Gdk := -1;
  if Gk <= 0 then
  begin
    Gdk := 1;
    inc(Gk2);
  end;
  if Gk2 > 10 then
    Gk2 := 0;

  for a := 1 to maxszczyt do
  begin
    drawline(szczyt[a - 1].x, 199 - trunc(szczyt[a - 1].y), szczyt[a].x, 199 - trunc(szczyt[a].y),
      16 + Gk + Gk2 * 16, 3);
  end;
  for a := 0 to maxszczyt do
  begin
    Mem[$A000: 0000 + szczyt[a].x + 320 * (199 - trunc(szczyt[a].y))] := 191 - Gk - Gk2 * 16;
  end;
end;

begin
  juz := false;
  anuluj := false;
  Gk := 0;
  Gdk := 1;
  wczytaj_ikony(4);
  Smenu := 255;
  repeat
    klawisze;
    pokaz_ikony;
    scr_y1 := 0;
    for a := 0 to 1 do
      siatka(1 + a * 10);
    for a := 0 to 9 do
    begin
      putpix(50 + rodzaj_tla * 10 + a, 0, 79, 0);
      putpix(50 + rodzaj_tla * 10 + a, 9, 79, 0);
      putpix(50 + rodzaj_tla * 10, a, 79, 0);
      putpix(50 + rodzaj_tla * 10 + 9, a, 79, 0);
    end;
    scr_y1 := 11;
    mysz;
    mysz2;
    while keypressed do
      readkey;

    if klik[1] then
    begin
      for a := 0 to maxszczyt do
      begin
        if (mx >= szczyt[a].x - 2) and (mx <= szczyt[a].x + 2) and (my >= 199 - szczyt[a].y - 2) and
          (my <= 199 - szczyt[a].y + 2) then
        begin
          repeat
            s_my := my;
            mysz;
            mysz2;
            if kl[29] then
            begin
              if (my > s_my) and (a > 0) and (szczyt[a - 1].y > szczyt[a].y) then
              begin
                szczyt[a - 1].y := szczyt[a - 1].y + (s_my - my) / 1.8;
                if (my > s_my) and (a > 1) and (szczyt[a - 2].y > szczyt[a - 1].y) then
                begin
                  szczyt[a - 2].y := szczyt[a - 2].y + (s_my - my) / 3;
                  if (my > s_my) and (a > 2) and (szczyt[a - 3].y > szczyt[a - 2].y) then
                    szczyt[a - 3].y := szczyt[a - 3].y + (s_my - my) / 7;
                end;
              end;
              if (my < s_my) and (a > 0) and (szczyt[a - 1].y < szczyt[a].y) then
              begin
                szczyt[a - 1].y := szczyt[a - 1].y + (s_my - my) / 1.8;
                if (my < s_my) and (a > 1) and (szczyt[a - 2].y < szczyt[a - 1].y) then
                begin
                  szczyt[a - 2].y := szczyt[a - 2].y + (s_my - my) / 3;
                  if (my < s_my) and (a > 2) and (szczyt[a - 3].y < szczyt[a - 2].y) then
                    szczyt[a - 3].y := szczyt[a - 3].y + (s_my - my) / 7;
                end;
              end;
              if (my > s_my) and (a < maxszczyt) and (szczyt[a + 1].y > szczyt[a].y) then
              begin
                szczyt[a + 1].y := szczyt[a + 1].y + (s_my - my) / 1.8;
                if (my > s_my) and (a < maxszczyt - 1) and (szczyt[a + 2].y > szczyt[a + 1].y) then
                begin
                  szczyt[a + 2].y := szczyt[a + 2].y + (s_my - my) / 3;
                  if (my > s_my) and (a < maxszczyt - 2) and (szczyt[a + 3].y > szczyt[a + 2].y) then
                    szczyt[a + 3].y := szczyt[a + 3].y + (s_my - my) / 7;
                end;
              end;
              if (my < s_my) and (a < maxszczyt) and (szczyt[a + 1].y < szczyt[a].y) then
              begin
                szczyt[a + 1].y := szczyt[a + 1].y + (s_my - my) / 1.8;
                if (my < s_my) and (a < maxszczyt - 1) and (szczyt[a + 2].y < szczyt[a + 1].y) then
                begin
                  szczyt[a + 2].y := szczyt[a + 2].y + (s_my - my) / 3;
                  if (my < s_my) and (a < maxszczyt - 2) and (szczyt[a + 3].y < szczyt[a + 2].y) then
                    szczyt[a + 3].y := szczyt[a + 3].y + (s_my - my) / 7;
                end;
              end;
            end;
            szczyt[a].x := mx;
            szczyt[a].y := 199 - my;
            if (a = 0) and (szczyt[a].x > 0) then
              szczyt[a].x := 0;
            if (a = maxszczyt) and (szczyt[a].x < 319) then
              szczyt[a].x := 319;
            if (a > 0) and (a < maxszczyt) and (szczyt[a].x <= szczyt[a - 1].x) then
              szczyt[a].x := szczyt[a - 1].x + 1;
            if (a > 0) and (a < maxszczyt) and (szczyt[a].x >= szczyt[a + 1].x) then
              szczyt[a].x := szczyt[a + 1].x - 1;
            if (szczyt[a].y < 0) then
              szczyt[a].y := 0;
            if (szczyt[a].y > 188) then
              szczyt[a].y := 188;
            move(scr^, Mem[$A000: 0000], 64000);
            pokaz_kontur;
          until not guzik[1];
          a := maxszczyt;
        end;
      end;
    end;
    if (klik[1]) and (mysz_w(50, 0, 119, 9)) then
      rodzaj_tla := trunc(mx / 10) - 5;
    if (klik[1]) and (mysz_w(30, 0, 39, 9)) then
      resetuj_gory;
    if (klik[1]) and (mysz_w(40, 0, 49, 9)) then
      losuj_gory;

    move(scr^, Mem[$A000: 0000], 64000);
    pokaz_kontur;
    if kl[1] then
      anuluj := true;
    if (klik[2]) and (my >= 11) then
      juz := true;
  until (juz) or (anuluj);
  move(scr^, Mem[$A000: 0000], 64000);

  if juz then
  begin
    yg := szczyt[0].y;
    dyg := (szczyt[0].y - szczyt[1].y) / (szczyt[1].x - szczyt[0].x);
    dlyg := szczyt[1].x - szczyt[0].x;
    x := 0;

    assign(BMPFile, 'graf.dat');
    filemode := 0;
    reset(BMPFile, 1);
    seek(BMPFile, schemat[rodzaj_tla + 1].brzeg);
    blockread(BMPFile, Header, sizeof(Header));
    rx := Header.Width;
    ry := Header.Height;
    seek(BMPFile, schemat[rodzaj_tla + 1].brzeg + 1078);
    Lines := ry;

    for a := 0 to 319 do
    begin
      if yg >= 1 then
        drawline(a, 199, a, 199 - trunc(yg), 253, 2);

      blockread(BMPFile, lin, rx);
      for aa := 0 to rx - 1 do
      begin
        b := lin[rx - aa];
        if (b > 0) and (yg >= 1) then
          putpix(a, (198 - trunc(yg)) + aa, b, 0);
      end;
      dec(Lines);
      if Lines = 0 then
      begin
        seek(BMPFile, 1078 + schemat[rodzaj_tla + 1].brzeg);
        Lines := ry;
      end;

      yg := yg - dyg;
      dec(dlyg);
      if (dlyg <= 0) and (x < maxszczyt - 1) then
      begin
        inc(x);
        dyg := (szczyt[x].y - szczyt[x + 1].y) / (szczyt[x + 1].x - szczyt[x].x);
        dlyg := szczyt[x + 1].x - szczyt[x].x;
      end;
    end;
    close(BMPFile);
    zrob_texture(rodzaj_tla + 1);
  end;
  move(scr^, Mem[$A000: 0000], 64000);
end;

{ * } PROCEDURE edytor;
var
  x, y: integer;
  _zoom: boolean;
begin
  _zoom := zoom;
  zoom := false;
  { if (menu) or (sz_menu) then napisy(0); }
  { if (ile_wybr>0) then napisy_o_wybranym(0); }
  { if (my<10) and (ile_wybr=0) then sz_menu:=true else sz_menu:=false; }
  zmaz_miny;
  zmaz_kaw;
  zmaz_ramke;
  mysz;
  zmaz_strz;
  snieg_zmaz;
  syfki_zmaz;
  postacie_zmaz;
  for a := 1 to maxpoc do
  begin
    if poc[1, a] = 1 then
      putpix(round(poc[2, a]), round(poc[3, a]), 0, 0);
  end;
  Sbron := bron;
  bron := 3;
  sople_zmaz;
  { -------- }
  repeat
    mysz;
  until (not guzik[1]) and (not guzik[2]);
  wczytaj_ikony(4);
  Smenu := 255;
  repeat
    klawisze;
    if czm then
    begin
      pokaz_ikony;
      scr_y1 := 0;
      for a := 0 to 8 do
        siatka(31 + a * 10);
      napisy_do_edytora;
    end;
    mysz;
    if rob_obiekt_jest then
      rysowanie_obiektow(0)
    else
      wszystko_do_rysowania(0);
    mysz2;
    guziki_w_rysowaniu;
    if ((mx >= 0) and (mx < 10) and (my >= 0) and (my < 10) and (klik[1])) then
      rob_gory;
    if ((mx >= 10) and (mx < 20) and (my >= 0) and (my < 10) and (klik[1])) then
    begin
      for y := 0 to 199 do
      begin
        for x := 0 to 319 do
        begin
          putpix(x, y, 0, 0);
        end;
      end;
    end;
    move(scr^, Mem[$A000: 0000], 64000);
    if rob_obiekt_jest then
      rysowanie_obiektow(2)
    else
      wszystko_do_rysowania(2);
    while keypressed do
      readkey;
  until kl[1];
  napisy_do_edytora;
  { -------- }
  postacie_pok;
  for a := 1 to maxpoc do
  begin
    if poc[1, a] = 1 then
      putpix(round(poc[2, a]), round(poc[3, a]), 245, 0);
  end;
  sople_pok;
  syfki_pok;
  snieg_pok;
  pok_strz;
  pok_ramke;
  pok_miny;
  pok_kaw;
  bron := Sbron;
  zoom := _zoom;
  Medytor := false;
  czm := true;
end;

{ * } PROCEDURE menu_esc;
var
  juz, wyjdz: boolean;
begin
  zmaz_ikony;
  mysz;
  zaznaczony := 0;
  kl_wcisn[1] := 1;
  juz := false;
  wyjdz := false;
  tooltip_widoczny := false;
  Sbron := bron;
  bron := 3;
  { assign(plik,'sad_temp.tmp');
    rewrite(plik,1);
    for a:=30 to 175 do blockwrite(plik,scr^[a,70], 180);
    {move (scr^[a,70], scr_ukryty^[a,70], 180); }
  { close(plik); }
  ekran_ukryty(1);
  repeat
    tlo_menu;

    { str(XMSMaxAvail,wyr);
      pisz(0,15,wyr,79,1);
      str(XMSMemAvail,wyr);
      pisz(0,25,wyr,79,1);
    }

    bar3(100, 39, 220, 47, 148, 156, 159);
    pisz(150, 41, 'NOWY', 31, 0);
    bar3(100, 49, 220, 57, 148, 156, 159);
    pisz(130, 51, 'ZAPIS TERENU', 31, 0);
    bar3(100, 59, 220, 67, 148, 156, 159);
    pisz(127, 61, 'ODCZYT TERENU', 31, 0);
    bar3(100, 69, 220, 77, 148, 156, 159);
    pisz(145, 71, 'EDYTOR', 31, 0);
    bar3(100, 79, 220, 87, 148, 156, 159);
    pisz(133, 81, 'OPCJE LUDZI', 31, 0);
    bar3(100, 89, 220, 97, 148, 156, 159);
    pisz(130, 91, 'OGoLNE OPCJE', 31, 0);
    bar3(100, 99, 220, 107, 148, 156, 159);
    pisz(125, 101, 'ODCZYT POSTACI', 31, 0);
    bar3(100, 109, 220, 117, 148, 156, 159);
    pisz(117, 111, 'NAJWIeKSI SADYsCI', 31, 0);
    bar3(100, 119, 220, 127, 148, 156, 159);
    pisz(148, 121, 'POMOC', 31, 0);
    bar3(100, 129, 220, 137, 148, 156, 159);
    pisz(133, 131, 'O PROGRAMIE', 31, 0);
    bar3(100, 139, 220, 147, 148, 156, 159);
    pisz(120, 141, 'WYJsCIE DO DOS''A', 31, 0);
    bar3(100, 153, 220, 161, 148, 156, 159);
    pisz(133, 155, 'WRoc DO GRY', 47, 0);

    napisz_tekst;

    repeat
      klawisze;
      mysz;
      mysz2;
      move(scr^, Mem[$A000: 0000], 64000);
      if (klik[1]) then
      begin
        wyb_przy_kur;
        if (mysz_w(100, 39, 220, 47)) then
        begin
          Mnowy := true;
          juz := true;
          wyjdz := true;
        end;
        if (mysz_w(100, 49, 220, 57)) then
        begin
          Mzapis := true;
          juz := true;
        end;
        if (mysz_w(100, 59, 220, 67)) then
        begin
          Modczyt := true;
          juz := true;
        end;
        if (mysz_w(100, 69, 220, 77)) then
        begin
          Medytor := true;
          juz := true;
          wyjdz := true;
        end;
        if (mysz_w(100, 79, 220, 87)) then
        begin
          Mopcje := true;
          juz := true;
        end;
        if (mysz_w(100, 89, 220, 97)) then
        begin
          Mopcje2 := true;
          juz := true;
          repeat
            mysz;
          until not guzik[1];
        end;
        if (mysz_w(100, 99, 220, 107)) then
        begin
          Mnoweobraz := true;
          juz := true;
          wyjdz := true;
        end;
        if (mysz_w(100, 109, 220, 117)) then
        begin
          Mpok_rekordy := true;
          juz := true;
        end;
        if (mysz_w(100, 119, 220, 127)) then
        begin
          Mpomoc := true;
          juz := true;
        end;
        if (mysz_w(100, 129, 220, 137)) then
        begin
          Mabout := true;
          juz := true;
        end;
        if (mysz_w(100, 139, 220, 147)) then
        begin
          Mwyjscie := true;
          juz := true;
          wyjdz := true;
        end;
        if (mysz_w(100, 153, 220, 161)) then
        begin
          wyjdz := true;
          juz := true;
        end;
      end;
      while keypressed do
        readkey;
    until ((kl[1]) and (kl_wcisn[1] = 0)) or (juz);
    if kl[1] then
      wyjdz := true;
    if Mzapis then
      zapis;
    if Modczyt then
      wczytaj;
    if Mopcje then
      ustawianieludzi;
    if Mopcje2 then
      ustawianiegry;
    if Mpok_rekordy then
      pok_rekordy;
    if Mpomoc then
      pomoc;
    if Mabout then
      o_programie;
    kl_wcisn[1] := 1;
    klik[1] := false;
    klik[2] := false;
    juz := false;
  until wyjdz;

  { assign(plik,'sad_temp.tmp');
    reset(plik,1);
    for a:=30 to 175 do blockread(plik,scr^[a,70], 180);
    close(plik);
    erase(plik);
    {for a:=30 to 175 do move (scr_ukryty^[a,70], scr^[a,70], 180); }
  ekran_ukryty(0);
  if Mnowy then
    nowy(1);
  bron := Sbron;
  kl_wcisn[1] := 1;
  klik[1] := false;
  klik[2] := false;

  zapisz_kfg;
  czm := true;
  { wczytaj_ikony(1); }
end;

{ * } PROCEDURE wybierz_nowe_obrazki;
var
  plik2, spraw: file;
  wr, licz_min: word;
  DirInfo: SearchRec;
  x: integer;
  b, b2, bb, il_plikow, druzyna: byte;
  pt, juz, anuluj: boolean;
  nazwa_pliku: string[8];
  druzyny: array [1 .. 5] of string[8];
begin
  zmaz_miny;
  zmaz_kaw;
  zmaz_ramke;
  mysz;
  zmaz_strz;
  snieg_zmaz;
  syfki_zmaz;
  postacie_zmaz;
  for a := 1 to maxpoc do
  begin
    if poc[1, a] = 1 then
      putpix(round(poc[2, a]), round(poc[3, a]), 0, 0);
  end;
  Sbron := bron;
  bron := 3;
  sople_zmaz;
  ekran_ukryty(1);

  { -------- }
  tlo_menu;
  pisz(125, 33, 'ODCZYT POSTACI', 79, 0);
  bar3(100, 157, 155, 165, 148, 156, 159);
  pisz(122, 159, 'OK', 31, 0);
  bar3(165, 157, 220, 165, 148, 156, 159);
  pisz(178, 159, 'ANULUJ', 31, 0);
  bar3(100, 147, 155, 155, 148, 156, 159);
  pisz(112, 149, 'WSTECZ', 31, 0);
  bar3(165, 147, 220, 155, 148, 156, 159);
  pisz(180, 149, 'DALEJ', 31, 0);
  bar3(80, 131, 126, 139, 148, 156, 159);
  pisz(83, 133, 'DRUzYNA1', 229, 0);
  FindFirst('POSTACI\*.sdp', Archive, DirInfo);
  x := 0;
  il_plikow := 0;
  while DosError = 0 do
  begin
    inc(x);
    inc(il_plikow);
    wyr := DirInfo.Name;
    bb := length(wyr);
    for a := bb downto bb - 3 do
      wyr[a] := ' ';
    pliki[x] := wyr;
    FindNext(DirInfo);
  end;
  repeat
    a := 0;
    for x := 1 to il_plikow - 1 do
    begin
      if pliki[x] > pliki[x + 1] then
      begin
        a := 1;
        wyr := pliki[x];
        pliki[x] := pliki[x + 1];
        pliki[x + 1] := wyr;
      end;
    end;
  until a = 0;

  for x := 1 to il_plikow do
  begin
    assign(plik2, 'POSTACI\' + pliki[x] + '.SDP');
    filemode := 0;
    reset(plik2, 1);
    blockread(plik2, nazwy_wpl[x], 15);
    blockread(plik2, nazwy_wpl[x], 21);
    close(plik2);
  end;

  for a := 1 to 5 do
    druzyny[a] := ostatnie_obr[a];
  x := 1;
  pt := true;
  juz := false;
  anuluj := false;
  druzyna := 1;
  nazwa_pliku := ostatnie_obr[1];
  assign(plik2, 'POSTACI\' + nazwa_pliku + '.SDP');
{$I-}
  reset(plik2);
{$I+}
  if IOResult = 0 then
    close(plik2)
  else
  begin
    nazwa_pliku := pliki[1];
  end;
  repeat
    klawisze;
    mysz;
    mysz2;
    move(scr^, Mem[$A000: 0000], 64000);
    if pt then
    begin
      bar3(80, 46, 240, 128, 148, 156, 159);
      for a := 1 to 12 do
      begin
        if a + x - 1 <= il_plikow then
        begin
          pisz(85, a * 6 + 45, pliki[a + x - 1], 31, 0);
          pisz(135, a * 6 + 45, nazwy_wpl[a + x - 1], 111, 0);
          if pliki[a + x - 1] = druzyny[druzyna] then
          begin
            fillchar(scr^[a * 6 + 44, 83], 154, 228 + druzyna);
            fillchar(scr^[a * 6 + 50, 83], 154, 228 + druzyna);
            for b := 0 to 4 do
            begin
              putpix(83, a * 6 + 45 + b, 228 + druzyna, 0);
              putpix(236, a * 6 + 45 + b, 228 + druzyna, 0);
            end;
          end;
        end;
      end;
      bar3(130, 131, 190, 139, 148, 156, 159);
      pisz(140, 133, nazwa_pliku, 47, 0);
      pt := false;
    end;
    if (guzik[2]) then
    begin
      if (mysz_w(165, 147, 220, 155)) and (x < il_plikow - 10) then
      begin
        inc(x);
        pt := true;
      end;
      if (mysz_w(100, 147, 155, 155)) and (x > 1) then
      begin
        dec(x);
        pt := true;
      end;
    end;
    if (klik[1]) then
    begin
      wyb_przy_kur;
      if (mysz_w(165, 147, 220, 155)) and (x < il_plikow - 10) then
      begin
        inc(x);
        pt := true;
      end;
      if (mysz_w(100, 147, 155, 155)) and (x > 1) then
      begin
        dec(x);
        pt := true;
      end;
      if (mysz_w(80, 51, 240, 124)) and ((((my - 51) div 6) + x) <= il_plikow) then
      begin
        nazwa_pliku := pliki[((my - 51) div 6) + x];
        druzyny[druzyna] := pliki[((my - 51) div 6) + x];
        pt := true;
      end;
      if mysz_w(100, 157, 155, 165) then
        juz := true;
      if mysz_w(165, 157, 220, 165) then
        anuluj := true;
      if mysz_w(80, 131, 126, 139) then
      begin
        inc(druzyna);
        if druzyna >= 6 then
          druzyna := 1;
        bar3(80, 131, 126, 139, 148, 156, 159);
        str(druzyna, wyr);
        pisz(83, 133, 'DRUzYNA' + wyr, 228 + druzyna, 0);
        nazwa_pliku := druzyny[druzyna];
        pt := true;
      end;
    end;
    if (klik[2]) and (mysz_w(80, 131, 126, 139)) then
    begin
      dec(druzyna);
      if druzyna <= 0 then
        druzyna := 5;
      bar3(80, 131, 126, 139, 148, 156, 159);
      str(druzyna, wyr);
      pisz(83, 133, 'DRUzYNA' + wyr, 228 + druzyna, 0);
      nazwa_pliku := druzyny[druzyna];
      pt := true;
    end;

    if ((kl[1]) and (kl_wcisn[1] = 0)) then
    begin
      anuluj := true;
      kl_wcisn[1] := 1;
    end;

  until (juz) or (anuluj);

  if juz then
  begin
    for a := 1 to 5 do
    begin
      if druzyny[a] <> ostatnie_obr[a] then
      begin
        wczytaj_nowe_obrazki(druzyny[a], a);
        ostatnie_obr[a] := druzyny[a];
        wczytaj_nowe_dzwieki(a);
      end;
    end;
    cala_paleta(1, 0);
  end;
  { -------- }
  ekran_ukryty(0);

  postacie;
  postacie2;
  postacie_pok;
  for a := 1 to maxpoc do
  begin
    if poc[1, a] = 1 then
      putpix(round(poc[2, a]), round(poc[3, a]), 245, 0);
  end;
  sople_pok;
  syfki_pok;
  snieg_pok;
  pok_strz;
  pok_ramke;
  pok_miny;
  pok_kaw;
  bron := Sbron;
  Mnoweobraz := false;
  menu_esc;
end;

{ * } BEGIN
  if not mousepresent then
  begin
    writeln('Ten program wymaga myszy!');
    halt;
  end;
  GetIntVec($9, Save_Int);
  SetIntVec(Old_Int, Save_Int);
  fillchar(kl, sizeof(kl), 0);
  SetIntVec($9, @Get_Keyb_Int);

  poczatek_programu;

  if paramstr(1) <> 'bezintro' then
    winieta;
  obrazki;
  wczytaj_pal;
  wstep;
  obraz_myszy(0);
  menu := 1;
  jest_kursor := true;
  ostatni_plik := 'BEZNAZWY';
  trupy := 0;
  miejsce := 11;
  kt_punkt_wyjscia := 1;
  wolno_wyl_mysz := true;
  mousewindow(0, 0, 319 * 2, 199 * 4);
  SetMickeys(4, 3);
  setmouseposition(319, 199 * 2);
  wczytaj_pomoc;
  if paramstr(1) <> 'bezintro' then
  begin
    pisz(102, 2, 'NACIsNIJ PRZYCISK MYSZY', 254, 0);
    move2(scr^, Mem[$A000: 0000], 64000);
    repeat
      mysz;
    until (klik[1]) or (klik[2]);
    schowaj_winiete;
  end;
  wczytaj_kfg;
  wczytaj_rek;
  if bron = 13 then
    obraz_myszy(1);

  for a1 := 1 to 5 do
  begin
    wczytaj_nowe_obrazki(ostatnie_obr[a1], a1);
    wczytaj_nowe_dzwieki(a1);
  end;

  wczytaj_ikony_z_plikow;
  trupow_na_raz := 0;
  cala_paleta(1, 0);
  menu_esc;
  inicjujtimer;
  gettime(ostatni.g, ostatni.m, ostatni.s, ostatni.ss);
  suma.g := 0;
  suma.m := 0;
  suma.s := 0;
  suma.ss := 0;
  Smenu := 255;
  rob_obiekt_numr := 1;
  czy_ma_trzymac := 0;
  repeat
    if (kl[54]) or (kl[42]) then
      trzyma_shift := true
    else
      trzyma_shift := false;

    if (trupow_na_raz >= 3) and (jest_komentarze) then
      nowy_komentarz(bedzie_komentarz.x, bedzie_komentarz.y, 95, trupow_na_raz - 3);

    gettime(teraz.g, teraz.m, teraz.s, teraz.ss);
    if (ostatni.s <> teraz.s) and (guzik[1]) and (my > 10) and (bron = 17) then
      graj_dzwiek(VoiceData[9], 1, 0);
    if (ostatni.s <> teraz.s) and (not guzik[1]) and (my > 10) and (bron = 17) then
      graj_dzwiek(VoiceData[11], 1, 0);
    if (ostatni.s <> teraz.s) then
    begin
      trupow_na_raz := 0;
      ostatni.g := teraz.g;
      ostatni.m := teraz.m;
      ostatni.s := teraz.s;
      ostatni.ss := teraz.ss;
      inc(suma.s);
      if suma.s >= 60 then
      begin
        dec(suma.s, 60);
        inc(suma.m);
        if suma.m >= 60 then
        begin
          dec(suma.m, 60);
          inc(suma.g);
        end;
      end;
      { if menu=1 then czm:=true; }
    end;
    inc(zmiana[1]);
    if zmiana[1] >= 2 then
      zmiana[1] := 0;
    inc(zmiana[2]);
    if zmiana[2] >= 5 then
      zmiana[2] := 0;
    inc(zmiana[3]);
    if zmiana[3] >= 14 then
      zmiana[3] := 0;
    inc(zmiana[4]);
    if zmiana[4] >= 4 then
      zmiana[4] := 0;
    if komentarz.dl > 0 then
      dec(komentarz.dl);
    if ekrbum > 0 then
      dec(ekrbum);
    for a := 1 to 10 do
      if punkt_wyjscia[a].kiedy > 0 then
        dec(punkt_wyjscia[a].kiedy);

    klawisze;
    zmaz_ramke;
    mysz;
    zmaz_strz;
    snieg_zmaz;
    sople_zmaz;
    sople;
    syfki_zmaz;
    zmaz_miny;
    zmaz_kaw;
    postacie_zmaz;
    pokaz_kowadla;
    ruch_kowadla;
    postacie;
    zmaz_kowadla;
    postacie2;
    ruch_kaw;
    postacie_pok;
    if (guzik[1]) and (my > 10) and (bron = 17) then
    begin
      ciecie; { ciecie pila }
      if (klik[1]) then
        graj_dzwiek(VoiceData[9], 1, 0);
    end;
    if burza then
      case random(250) of
        0:
          pierony(random(320), 0);
        2:
          blysk_pioruna := 10;
      end;
    if blysk_pioruna > 0 then
    begin
      if jestblysk_wtle then
        pieron_w_tle(blysk_pioruna - 1);
      dec(blysk_pioruna);
    end;

    if (klik[1]) and (bron = 10) and (my > 10) then
      pierony(mx, my);
    pociski;
    pociski2;
    syfki;
    ruch_miny;
    sople_pok;
    syfki_pok;
    snieg_pok;
    if (kl[56]) and (kl_wcisn[56] = 0) then
    begin
      ramka_wsp[1].x := mx;
      ramka_wsp[1].y := my;
      ramka_wsp[2].x := mx;
      ramka_wsp[2].y := my;
      zazn_ramki := true;
      kl_wcisn[56] := 1;
      czm := true;
    end;
    if (kl[56]) and (kl_wcisn[56] = 1) then
    begin
      ramka_wsp[2].x := mx;
      ramka_wsp[2].y := my;
    end;
    if (not kl[56]) and (zazn_ramki) then
    begin
      zaznacz_ramka;
      zazn_ramki := false;
      czm := true;
    end;
    sprawdz_zaznaczonych;
    if (klik[2]) and (kl[29]) then
    begin
      if zaznaczony > 0 then
      begin
        if wybrana_postac[zaznaczony] = 1 then
          wybrana_postac[zaznaczony] := 0
        else
          wybrana_postac[zaznaczony] := 1;
      end;
      klik[2] := false;
      czm := true;
      if ile_wybr > 0 then
      begin
        menu := 0;
        czm := true;
      end;
    end;
    if (klik[2]) and (my >= 10) and (not kl[29]) then
    begin
      u_ile_wybr;
      if zaznaczony > 0 then
      begin
        wybrana_postac[zaznaczony] := 1;
        klik[2] := false;
      end
      else
        u_ile_wybr;
      if ile_wybr > 0 then
      begin
        menu := 0;
        czm := true;
      end;
    end;
    if (menu = 0) and ((mx >= 90) and (mx < 100) and (my < 10) and (my >= 0) and (klik[1])) then
    begin
      u_ile_wybr;
      klik[1] := false;
    end;
    if (ile_wybr = 0) and (menu = 0) then
    begin
      menu := 2;
      czm := true;
    end;
    if (trzyma_shift) and (czy_ma_trzymac = 0) then
    begin
      for a := 1 to maxludzie do
      begin
        if (post[1, a] = 1) and (mx >= post[2, a]) and (mx <= post[2, a] + 9) and (my >= post[3, a]) and
          (my <= post[3, a] + 9) then
          post_przenies[a] := 1
      end;
    end;
    if kl[29] then
      czy_ma_trzymac := 10;
    if czy_ma_trzymac > 0 then
      dec(czy_ma_trzymac);
    if ((kl[57]) and (kl_wcisn[57] = 0)) or ((kl[68]) and (kl_wcisn[68] = 0)) then
    begin
      inc(menu);
      if menu > 2 then
      begin
        if ile_wybr = 0 then
          menu := 1
        else
          menu := 0;
      end;
      kl_wcisn[57] := 1;
      kl_wcisn[68] := 1;
      czm := true;
    end;
    if ((kl[83]) and (kl_wcisn[83] = 0)) or ((bron = 11) and (klik[2])) then
    begin
      kl_wcisn[83] := 1;
      for a := 1 to maxminy do
      begin
        if (miny[a].jest) and (mx >= miny[a].x - 3) and (mx <= miny[a].x + 3) and (my >= miny[a].y - 3) and
          (my <= miny[a].y + 3) then
        begin
          miny[a].jest := false;
          a := maxminy;
        end;
      end;
      czm := true;
    end;

    spr_strz;
    pok_strz;
    spr_ramke;
    pok_ramke;
    pok_miny;
    pok_kaw;

    if rob_obiekt_jest then
      rysowanie_obiektow(0)
    else
      wszystko_do_rysowania(0);
    if Smenu <> menu then
    begin
      case menu of
        0:
          wczytaj_ikony(1);
        1:
          wczytaj_ikony(2);
        2:
          wczytaj_ikony(3);
      end;
      Smenu := menu;
    end;
    if (czm) and (zmiana[2] = 0) then
    begin
      case menu of
        0:
          begin
            pokaz_ikony;
            napisy_o_wybranym(1);
          end;
        1:
          begin
            pokaz_ikony;
            napisy;
          end;
        2:
          begin
            pokaz_ikony;
            napisy_broni;
          end;
      end;
      czm := false;
    end;

    { if (ile_wybr>0) then begin wczytaj_ikony(1);napisy_o_wybranym(1);end; }

    pokaz_kowadla;
    mysz2;
    if kl[75] then
      inc(S_kier);
    if kl[77] then
      dec(S_kier);
    if (kl[72]) and (S_sila < 40) then
      inc(S_sila);
    if (kl[80]) and (S_sila > 1) then
      dec(S_sila);
    if (guzik[2]) and ((bron in [0, 1, 4, 5, 11, 12, 15, 16, 18]) or (trzyma_shift)) then
    begin
      if Smx2 < Smx then
        inc(S_kier);
      if Smx2 > Smx then
        dec(S_kier);
      if (Smy2 < Smy) and (S_sila < 40) then
        inc(S_sila);
      if (Smy2 > Smy) and (S_sila > 1) then
        dec(S_sila);
    end;
    if S_kier >= 32 then
      dec(S_kier, 32);
    if S_kier <= -1 then
      inc(S_kier, 32);

    { 1 MENU }
    if ((kl[59]) or ((menu = 1) and (mx >= 0) and (mx < 20) and (my < 10) and (klik[1]))) and (kl_wcisn[59] = 0) then
    begin
      inc(strzelaja_do_siebie);
      if strzelaja_do_siebie > 9 then
        strzelaja_do_siebie := 0;
      kl_wcisn[59] := 1;
      czm := true;
    end;
    if ((menu = 1) and (mx >= 0) and (mx < 20) and (my < 10) and (klik[2])) then
    begin
      dec(strzelaja_do_siebie);
      if strzelaja_do_siebie < 0 then
        strzelaja_do_siebie := 9;
      czm := true;
    end;
    if ((kl[60]) or ((menu = 1) and (mx >= 20) and (mx < 30) and (my < 10) and (klik[1]))) and (kl_wcisn[60] = 0) then
    begin
      if burza then
        burza := false
      else
        burza := true;
      kl_wcisn[60] := 1;
      czm := true;
    end;
    if ((kl[61]) or ((menu = 1) and (mx >= 30) and (mx < 40) and (my < 10) and (klik[1]))) and (kl_wcisn[61] = 0) then
    begin
      case pada_snieg of
        0:
          pada_snieg := 1;
        1:
          pada_snieg := 0;
        2:
          pada_snieg := 3;
        3:
          pada_snieg := 2;
      end;
      kl_wcisn[61] := 1;
      czm := true;
    end;
    if ((kl[62]) or ((menu = 1) and (mx >= 40) and (mx < 50) and (my < 10) and (klik[1]))) and (kl_wcisn[62] = 0) then
    begin
      case pada_snieg of
        0:
          pada_snieg := 3;
        1:
          pada_snieg := 2;
        2:
          pada_snieg := 1;
        3:
          pada_snieg := 0;
      end;
      kl_wcisn[62] := 1;
      czm := true;
    end;
    if (kl[63]) and (kl_wcisn[63] = 0) then
    begin
      inc(dziura_na_dole);
      if dziura_na_dole > 3 then
        dziura_na_dole := 0;
      kl_wcisn[63] := 1;
      czm := true;
      if dziura_na_dole in [0, 3] then
        zmaz_wode;
    end;
    if ((kl[64]) or ((menu = 1) and (mx >= 80) and (mx <= 89) and (my < 10) and (klik[1]))) and (kl_wcisn[64] = 0) then
    begin
      if sa_sople then
        sa_sople := false
      else
        sa_sople := true;
      kl_wcisn[64] := 1;
      czm := true;
    end;
    if ((kl[65]) or ((menu = 1) and (mx >= 90) and (mx <= 99) and (my < 10) and (klik[1]))) and (kl_wcisn[65] = 0) then
    begin
      if kap_krew then
        kap_krew := false
      else
        kap_krew := true;
      kl_wcisn[65] := 1;
      czm := true;
    end;
    if ((kl[66]) or ((menu = 1) and (mx >= 100) and (mx <= 109) and (my < 10) and (klik[1]))) and (kl_wcisn[66] = 0)
    then
    begin
      if l_strzelaja then
        l_strzelaja := false
      else
        l_strzelaja := true;
      kl_wcisn[66] := 1;
      czm := true;
    end;
    if ((kl[67]) or ((menu = 1) and (mx >= 110) and (mx <= 119) and (my < 10) and (klik[1]))) and (kl_wcisn[67] = 0)
    then
    begin
      if l_bija then
        l_bija := false
      else
        l_bija := true;
      kl_wcisn[67] := 1;
      czm := true;
    end;
    if (menu = 1) then
    begin
      if (mx >= 0) and (mx < 180) and (my < 10) and (jest_tooltip) then
      begin
        nowy_komentarz(mx, my, 95, -(mx div 10) - 51);
        tooltip_widoczny := true;
      end;
      if (mx >= 220) and (mx < 320) and (my < 10) and (jest_tooltip) then
      begin
        nowy_komentarz(mx, my, 95, -((mx - 220) div 20) - 150);
        tooltip_widoczny := true;
      end;
      for a := 1 to 5 do
      begin
        if ((mx >= 200 + a * 20) and (mx < 220 + a * 20) and (my < 10) and (klik[2])) then
        begin
          if max_ludzi[a] > 0 then
            dec(max_ludzi[a]);
          czm := true;
        end;
        if ((mx >= 200 + a * 20) and (mx < 220 + a * 20) and (my < 10) and (klik[1])) then
        begin
          if max_ludzi[1] + max_ludzi[2] + max_ludzi[3] + max_ludzi[4] + max_ludzi[5] < maxludzie then
            inc(max_ludzi[a]);
          czm := true;
        end;
      end;
      if (mysz_w(120, 0, 129, 9)) and (klik[1]) then
      begin
        if smierc_wybuch then
          smierc_wybuch := false
        else
          smierc_wybuch := true;
        czm := true;
      end;
      if (mysz_w(130, 0, 139, 9)) and (klik[1]) then
      begin
        if wychodza_do_gory then
          wychodza_do_gory := false
        else
          wychodza_do_gory := true;
        czm := true;
      end;
      if (mysz_w(140, 0, 149, 9)) and (klik[1]) then
      begin
        if l_szaleni then
          l_szaleni := false
        else
          l_szaleni := true;
        czm := true;
      end;
      if (mysz_w(150, 0, 159, 9)) and (klik[1]) then
      begin
        if jest_dzwiek then
          jest_dzwiek := false
        else
          jest_dzwiek := true;
        czm := true;
      end;
      if (mysz_w(50, 0, 79, 9)) and (klik[1]) then
      begin
        a := dziura_na_dole;
        dziura_na_dole := trunc(mx / 10) - 4;
        if a = dziura_na_dole then
          dziura_na_dole := 0;
        zmaz_wode;
        czm := true;
      end;
    end;

    { 2 MENU }
    if menu = 2 then
    begin
      if (mx >= 0) and (mx < 200) and (my < 10) and (klik[1]) then
      begin
        a1 := bron;
        bron := bronie[trunc(mx / 10)];
        if (a1 = 13) xor (bron = 13) then
        begin
          zmien_mysz;
          if a1 = 13 then
            obraz_myszy(0);
          if bron = 13 then
            obraz_myszy(1);
        end;
        czm := true;
      end;
      if (mx >= 0) and (mx < 200) and (my < 10) and (jest_tooltip) then
      begin
        nowy_komentarz(mx, my, 95, -(mx div 10) - 1);
        tooltip_widoczny := true;
      end;
      case bron of
        0:
          begin
            if (mx >= 284) and (mx < 319) and (my >= 2) and (my < 7) and (klik[1]) then
            begin
              inc(sila_broni);
              if sila_broni > 14 then
                sila_broni := 1;
              czm := true;
            end;
            if (mx >= 284) and (mx < 319) and (my >= 2) and (my < 7) and (klik[2]) then
            begin
              dec(sila_broni);
              if sila_broni < 1 then
                sila_broni := 14;
              czm := true;
            end;
          end;
        1:
          begin
            if (mx >= 239) and (mx < 279) and (my >= 2) and (my < 7) and (klik[1]) then
            begin
              inc(bron_odlamki);
              if bron_odlamki > 10 then
                bron_odlamki := 2;
              czm := true;
            end;
            if (mx >= 239) and (mx < 279) and (my >= 2) and (my < 7) and (klik[2]) then
            begin
              dec(bron_odlamki);
              if bron_odlamki < 2 then
                bron_odlamki := 10;
              czm := true;
            end;
            if (mx >= 284) and (mx < 319) and (my >= 2) and (my < 7) and (klik[1]) then
            begin
              inc(sila_odlamki);
              if sila_odlamki > 10 then
                sila_odlamki := 1;
              czm := true;
            end;
            if (mx >= 284) and (mx < 319) and (my >= 2) and (my < 7) and (klik[2]) then
            begin
              dec(sila_odlamki);
              if sila_odlamki < 1 then
                sila_odlamki := 10;
              czm := true;
            end;
          end;
        2:
          begin
            if (mx >= 215) and (mx < 235) and (my >= 2) and (my < 7) and (klik[1]) then
            begin
              inc(kt_punkt_wyjscia);
              if kt_punkt_wyjscia > 5 then
                kt_punkt_wyjscia := 1;
              czm := true;
            end;
            if (mx >= 215) and (mx < 235) and (my >= 2) and (my < 7) and (klik[2]) then
            begin
              dec(kt_punkt_wyjscia);
              if kt_punkt_wyjscia < 1 then
                kt_punkt_wyjscia := 5;
              czm := true;
            end;

            if (mx >= 239) and (mx < 260) and (my >= 2) and (my < 7) and ((klik[1]) or (klik[2])) then
            begin
              if punkt_wyjscia[kt_punkt_wyjscia].gora then
                punkt_wyjscia[kt_punkt_wyjscia].gora := false
              else
                punkt_wyjscia[kt_punkt_wyjscia].gora := true;
              czm := true;
            end;
            if (mx >= 264) and (mx < 270) and (my >= 2) and (my < 7) and (klik[1]) then
            begin
              inc(punkt_wyjscia[kt_punkt_wyjscia].kier);
              if punkt_wyjscia[kt_punkt_wyjscia].kier > 3 then
                punkt_wyjscia[kt_punkt_wyjscia].kier := 1;
              czm := true;
            end;
            if (mx >= 264) and (mx < 270) and (my >= 2) and (my < 7) and (klik[2]) then
            begin
              dec(punkt_wyjscia[kt_punkt_wyjscia].kier);
              if punkt_wyjscia[kt_punkt_wyjscia].kier < 1 then
                punkt_wyjscia[kt_punkt_wyjscia].kier := 3;
              czm := true;
            end;
            if (mx >= 274) and (mx < 280) and (my >= 2) and (my < 7) and (klik[1]) then
            begin
              inc(punkt_wyjscia[kt_punkt_wyjscia].szyb);
              if punkt_wyjscia[kt_punkt_wyjscia].szyb > 9 then
                punkt_wyjscia[kt_punkt_wyjscia].szyb := 0;
              czm := true;
            end;
            if (mx >= 274) and (mx < 280) and (my >= 2) and (my < 7) and (klik[2]) then
            begin
              dec(punkt_wyjscia[kt_punkt_wyjscia].szyb);
              if punkt_wyjscia[kt_punkt_wyjscia].szyb < 0 then
                punkt_wyjscia[kt_punkt_wyjscia].szyb := 9;
              czm := true;
            end;
            if (mx >= 284) and (mx < 320) and (my >= 2) and (my < 7) and (klik[1]) then
            begin
              inc(punkt_wyjscia[kt_punkt_wyjscia].jak);
              if punkt_wyjscia[kt_punkt_wyjscia].jak > 8 then
                punkt_wyjscia[kt_punkt_wyjscia].jak := 0;
              czm := true;
            end;
            if (mx >= 284) and (mx < 320) and (my >= 2) and (my < 7) and (klik[2]) then
            begin
              dec(punkt_wyjscia[kt_punkt_wyjscia].jak);
              if punkt_wyjscia[kt_punkt_wyjscia].jak < 0 then
                punkt_wyjscia[kt_punkt_wyjscia].jak := 8;
              czm := true;
            end;
          end;
        3:
          guziki_w_rysowaniu;
        4, 5, 16:
          begin
            if (mx >= 275) and (mx < 315) and (my >= 2) and (my < 7) and ((klik[1]) or (klik[2])) then
            begin
              if rodzaj_syfkow = 0 then
                rodzaj_syfkow := 1
              else
                rodzaj_syfkow := 0;
              czm := true;
            end;
          end;
        8:
          begin
            if (mx >= 269) and (mx < 319) and (my >= 2) and (my < 7) and (klik[1]) then
            begin
              inc(dl_sopli);
              if dl_sopli > 10 then
                dl_sopli := 0;
              czm := true;
            end;
            if (mx >= 269) and (mx < 319) and (my >= 2) and (my < 7) and (klik[2]) then
            begin
              dec(dl_sopli);
              if dl_sopli < 0 then
                dl_sopli := 10;
              czm := true;
            end;
          end;
        9:
          begin
            if (mx >= 270) and (mx < 315) and (my >= 2) and (my < 7) and (klik[1]) then
            begin
              inc(druzyna_z_kursora);
              if druzyna_z_kursora > 4 then
                druzyna_z_kursora := 0;
              czm := true;
            end;
          end;
        12:
          begin
            if (mx >= 284) and (mx < 319) and (my >= 2) and (my < 7) and (klik[1]) then
            begin
              inc(sila_dziala);
              if sila_dziala > 9 then
                sila_dziala := 1;
              czm := true;
            end;
            if (mx >= 284) and (mx < 319) and (my >= 2) and (my < 7) and (klik[2]) then
            begin
              dec(sila_dziala);
              if sila_dziala < 1 then
                sila_dziala := 9;
              czm := true;
            end;
            if (mx >= 239) and (mx < 279) and (my >= 2) and (my < 7) and ((klik[1]) or (klik[2])) then
            begin
              if rodzaj_dziala = 0 then
                rodzaj_dziala := 1
              else
                rodzaj_dziala := 0;
              czm := true;
            end;
          end;
        11:
          begin
            if (klik[1]) and (mysz_w(204, 2, 239, 7)) then
              for a := 1 to maxminy do
                if miny[a].jest then
                  miny[a].bum := 150 - random(20);
            if (mx >= 244) and (mx < 284) and (my >= 2) and (my < 7) and ((klik[1]) or (klik[2])) then
            begin
              if rodzaj_min = 0 then
                rodzaj_min := 1
              else
                rodzaj_min := 0;
              czm := true;
            end;
          end;
        15:
          begin
            if (mx >= 244) and (mx < 319) and (my >= 2) and (my < 7) and (klik[1]) then
            begin
              inc(raca_dlug);
              if raca_dlug > 9 then
                raca_dlug := 1;
              czm := true;
            end;
            if (mx >= 244) and (mx < 319) and (my >= 2) and (my < 7) and (klik[2]) then
            begin
              dec(raca_dlug);
              if raca_dlug < 1 then
                raca_dlug := 9;
              czm := true;
            end;
          end;
        18:
          begin
            if (mx >= 284) and (mx < 319) and (my >= 2) and (my < 7) and (klik[1]) then
            begin
              inc(poc_hom_ust.sila);
              if poc_hom_ust.sila > 14 then
                poc_hom_ust.sila := 1;
              czm := true;
            end;
            if (mx >= 284) and (mx < 319) and (my >= 2) and (my < 7) and (klik[2]) then
            begin
              dec(poc_hom_ust.sila);
              if poc_hom_ust.sila < 1 then
                poc_hom_ust.sila := 14;
              czm := true;
            end;
            if (mx >= 244) and (mx < 279) and (my >= 2) and (my < 7) and (klik[1]) then
            begin
              poc_hom_ust.ustaw := 1;
              czm := true;
            end;
          end;
      end;
    end;
    { ------- }

    if menu = 0 then
    begin
      if (mx >= 0) and (mx < 100) and (my < 10) and (jest_tooltip) then
      begin
        nowy_komentarz(mx, my, 95, -(mx div 10) - 101);
        tooltip_widoczny := true;
      end;
      if (kl[2]) or ((mx >= 0) and (mx < 10) and (my < 10) and (my >= 0) and (klik[1])) then
        ustaw_post(0);
      if (kl[3]) or ((mx >= 10) and (mx < 20) and (my < 10) and (my >= 0) and (klik[1])) then
        ustaw_post(1);
      if (kl[4]) or ((mx >= 20) and (mx < 30) and (my < 10) and (my >= 0) and (klik[1])) then
        ustaw_post(2);
      if ((kl[5]) and (kl_wcisn[5] = 0)) or ((mx >= 30) and (mx < 40) and (my < 10) and (my >= 0) and (klik[1])) then
      begin
        ustaw_post(3);
        kl_wcisn[5] := 1;
      end;
      if (kl[6]) or ((mx >= 40) and (mx < 50) and (my < 10) and (my >= 0) and (klik[1])) then
        ustaw_post(4);
      if (kl[7]) or ((mx >= 50) and (mx < 60) and (my < 10) and (my >= 0) and (klik[1])) then
        ustaw_post(5);
      if (kl[8]) or ((mx >= 60) and (mx < 70) and (my < 10) and (my >= 0) and (klik[1])) then
        ustaw_post(6);
      if ((kl[9]) and (kl_wcisn[9] = 0)) or ((mx >= 70) and (mx < 80) and (my < 10) and (my >= 0) and (klik[1])) then
      begin
        for a := 1 to maxludzie do
        begin
          if (wybrana_postac[a] = 1) then
          begin
            post[9, a] := 0;
            graj_dzwiek(VoiceData[17 + (10 * trunc(post[10, a]))], 0.8 + random / 3, 1 + trunc(post[10, a]));
          end;
        end;
        czm := true;
        kl_wcisn[9] := 1;
      end;
      if ((kl[10]) and (kl_wcisn[10] = 0)) or ((mx >= 80) and (mx < 90) and (my < 10) and (my >= 0) and (klik[1])) then
      begin
        for a := 1 to maxludzie do
        begin
          if wybrana_postac[a] = 1 then
          begin
            post[9, a] := post[9, a] + 50;
            if post[9, a] > 999 then
              post[9, a] := 999;
          end;
        end;
        kl_wcisn[10] := 1;
        czm := true;
      end;
    end;
    if (kl[1]) and (kl_wcisn[1] = 0) then
      menu_esc;
    if Medytor then
      edytor;
    if Mnoweobraz then
      wybierz_nowe_obrazki;

    if (tooltip_widoczny) and (my >= 10) and (jest_tooltip) then
    begin
      komentarz.dl := 0;
      tooltip_widoczny := false;
    end;

    guziki_strzelania;

    if (guzik[1]) and (my > 10) then
    begin
      case bron of
        4, 5, 16:
          begin
            case bron of
              4:
                begin
                  a1 := 72;
                  a2 := 6;
                  a := 0;
                end;
              16:
                begin
                  a1 := 204;
                  a2 := 3;
                  a := 1;
                end;
              5:
                begin
                  a1 := 213;
                  a2 := 7;
                  a := 1;
                end;
            end;
            case rodzaj_syfkow of
              0:
                nowysyf(round(mx + sin(((8 + random(16)) / 5) * (6 + random(20)))),
                  round(my + cos(((8 + random(16)) / 5) * (6 + random(20)))), (random * 2 - 1) * (S_sila / 30),
                  (random * 4 - 2) * (S_sila / 30), a1, a2, a);
              1:
                nowysyf(mx - 1 + random(3), my - 1 + random(3), sin(S_kier / 5) * (S_sila / 9) + (random * 0.2),
                  cos(S_kier / 5) * (S_sila / 9) + (random * 0.2), a1, a2, a);
            end;
          end;
        6:
          begin
            for a := 1 to maxsnieg do
            begin
              if not snieg^[a].jest then
              begin
                snieg^[a].x := mx - 2 + random(5);
                snieg^[a].y := my;
                snieg^[a].kol := 208 + random(5);
                snieg^[a].jest := true;
                snieg^[a].plan := 0;
                inc(ilsnieg);
                a := maxsnieg;
              end;
            end;
          end;
        7:
          nowakropla(mx - 4 + random(9), my, 224 + random(5));
        8:
          begin
            if (random(5) = 0) then
            begin
              a1 := random(5);
              for a2 := 0 to dl_sopli * 5 + random(5) do
              begin
                nowysopel(mx - 2 + a1, my + a2, 139 + random(3));
              end;
            end;
          end;
        11:
          begin
            if (rodzaj_min = 1) and (zmiana[4] = 0) then
              nowamina(mx, my, trunc(sin(S_kier / 5) * (S_sila / 6)), trunc(cos(S_kier / 5) * (S_sila / 6)));
            czm := true;
          end;
        12:
          begin
            if (zmiana[4] = 0) then
            begin
              case rodzaj_dziala of
                0:
                  strzal2(mx, my, trunc(sin(S_kier / 5) * 5), trunc(cos(S_kier / 5) * 5), sila_dziala * 4 + 3, 1.3);
                1:
                  strzal2(mx, my, sin(S_kier / 5) * 5 + (random * 2 - 1), cos(S_kier / 5) * 5 + (random * 2 - 1),
                    sila_dziala * 4 + 5, 2);
              end;
            end;
          end;
      end;
    end;
    if ((kl[44]) and (kl_wcisn[44] = 0)) or ((menu = 1) and (mysz_w(160, 0, 169, 9)) and (klik[1])) then
    begin
      kl_wcisn[44] := 1;
      if zoom then
        zoom := false
      else
        zoom := true;
      czm := true;
    end;

    punkt_wyjscia[kt_punkt_wyjscia].pod := scr^[punkt_wyjscia[kt_punkt_wyjscia].y, punkt_wyjscia[kt_punkt_wyjscia].x];
    if (not punkt_wyjscia[kt_punkt_wyjscia].gora) and (zmiana[3] < 7) and (bron = 2) then
      scr^[punkt_wyjscia[kt_punkt_wyjscia].y, punkt_wyjscia[kt_punkt_wyjscia].x] := 228 + kt_punkt_wyjscia;

    if poc_hom_ust.ktory > 0 then
      poc_hom_ust.pod := scr^[trunc(post[3, poc_hom_ust.ktory] - 2), trunc(post[2, poc_hom_ust.ktory] + 5)]
    else
      poc_hom_ust.pod := scr^[poc_hom_ust.y, poc_hom_ust.x];
    if (zmiana[3] >= 7) and (bron = 18) then
    begin
      if poc_hom_ust.ktory > 0 then
        scr^[trunc(post[3, poc_hom_ust.ktory] - 2), trunc(post[2, poc_hom_ust.ktory] + 5)] := 96 + zmiana[3]
      else
        scr^[poc_hom_ust.y, poc_hom_ust.x] := 96 + zmiana[3];
    end;

    pod_celow := getpix(mx + trunc(sin(S_kier / 5) * (S_sila / 3)), my + trunc(cos(S_kier / 5) * (S_sila / 3)));
    if (jest_kursor) and ((bron in [0, 1, 4, 5, 11, 12, 15, 16, 18]) or (trzyma_shift)) then
      putpix(mx + trunc(sin(S_kier / 5) * (S_sila / 3)), my + trunc(cos(S_kier / 5) * (S_sila / 3)), 31, 0);

    if (dziura_na_dole = 1) and (zmiana[2] = 0) then
      rysuj_wode;
    if (dziura_na_dole = 2) and (zmiana[2] = 0) then
      rysuj_ogien;

    if (kl[88]) and (kl_wcisn[88] = 0) then
    begin
      graj_dzwiek(VoiceData[12], 1, 0);
      shot;
      kl_wcisn[88] := 1;
    end;

    pox := mx - 80; { pox:=trunc(mx/1.99); }
    if pox < 0 then
      pox := 0;
    if pox > 160 then
      pox := 160;
    poy := my - 50; { poy:=trunc(my/1.99); }
    if poy < 0 then
      poy := 0;
    if poy > 100 then
      poy := 100;

    pokaz_ekran;
    zmaz_kowadla;

    if (jest_kursor) and ((bron in [0, 1, 4, 5, 11, 12, 15, 16, 18]) or (trzyma_shift)) then
      putpix(mx + trunc(sin(S_kier / 5) * (S_sila / 3)), my + trunc(cos(S_kier / 5) * (S_sila / 3)), pod_celow, 0);

    if (zmiana[3] >= 7) then
    begin
      if poc_hom_ust.ktory > 0 then
        scr^[trunc(post[3, poc_hom_ust.ktory] - 2), trunc(post[2, poc_hom_ust.ktory] + 5)] := poc_hom_ust.pod
      else
        scr^[poc_hom_ust.y, poc_hom_ust.x] := poc_hom_ust.pod;
    end;

    if (not punkt_wyjscia[kt_punkt_wyjscia].gora) and (zmiana[3] < 7) then
      scr^[punkt_wyjscia[kt_punkt_wyjscia].y, punkt_wyjscia[kt_punkt_wyjscia].x] := punkt_wyjscia[kt_punkt_wyjscia].pod;
    if rob_obiekt_jest then
      rysowanie_obiektow(2)
    else
      wszystko_do_rysowania(2);
    while keypressed do
      readkey;
    czekaj(1);

  until Mwyjscie;
  a := random(5) + 1;
  graj_dzwiek(VoiceData[17 + (10 * (a - 1))], 0.7 + random / 2, a);
  if miejsce = 11 then
    sprawdz_rek
  else
    aktualizuj_aktualny_rek;
  zapisz_rek;
  zapis_na_koniec;
  zakoncztimer;
  zamknij;

end.
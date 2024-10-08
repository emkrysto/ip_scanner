@echo off
setlocal enabledelayedexpansion

rem Określenie zakresu sieci - np. 192.168.0.0/24
set "network=192.168.0."

rem Ustalamy czas oczekiwania na odpowiedź w milisekundach
set "timeout=200"

rem Nazwa pliku wyjściowego
set "output_file=wynik_skanowania.txt"

rem Usuwa plik wynikowy, jeśli już istnieje, aby zacząć od nowa
if exist "%output_file%" del "%output_file%"

echo Skanowanie sieci w zakresie %network%1 - %network%254...
echo ----------------------------------------------------

echo Skanowanie sieci w zakresie %network%1 - %network%254... >> "%output_file%"
echo ---------------------------------------------------- >> "%output_file%"

rem Pętla, która przechodzi przez wszystkie adresy IP od 1 do 254
for /l %%i in (1,1,254) do (
    rem Wykonaj ping i przefiltruj wynik w celu znalezienia linii zawierającej "Reply from"
    for /f "tokens=*" %%j in ('ping -n 1 -w !timeout! !network!%%i ^| find "Reply from"') do (
        rem Wyświetl wynik w konsoli
        set "ping_result=%%j"

        rem Uzyskaj adres MAC na podstawie adresu IP
        set "mac_address=N/A"
        for /f "tokens=1,2 delims= " %%m in ('arp -a ^| find /i "!network!%%i"') do (
            rem %%m to adres IP, %%n to adres MAC
            set "mac_address=%%n"
        )

        rem Sprawdź, czy ping był udany
        if defined ping_result (
            rem Wyświetl pełne informacje
            echo !ping_result! Mac: !mac_address! >> "%output_file%"
            echo !ping_result! Mac: !mac_address!
        )
    )
)

echo ----------------------------------------------------
echo Skanowanie zakończone
echo ---------------------------------------------------- >> "%output_file%"
echo Skanowanie zakończone. Wyniki zapisane w pliku >> "%output_file%"

endlocal
pause

rem czas wykonania skanowania
rem 200ms x 254adresów = 50800ms = 50.8sekundy

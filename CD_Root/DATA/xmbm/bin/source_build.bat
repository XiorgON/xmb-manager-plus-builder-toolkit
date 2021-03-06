@echo off
title Build Source
for /f "tokens=1,2 delims==" %%G in (settings.ini) do set %%G=%%H
call "%bindir%\global_prechecks.bat" %0

:first
SETLOCAL ENABLEDELAYEDEXPANSION
call "%bindir%\global_messages.bat" "BUILDING"
if exist "%pkgsource%" rmdir /Q /S "%pkgsource%" >NUL
if not exist "%pkgsource%" mkdir "%pkgsource%" >NUL

FOR /F "tokens=*" %%A IN ('CHCP') DO FOR %%B IN (%%~A) DO SET CodePage=%%B
chcp 65001 >NUL

echo.
echo CREATING theme packs source files ...
echo.
if exist "%pkgsource%\themepacks" rmdir /Q /S "%pkgsource%\themepacks"
for /f "tokens=1,2 delims=." %%Y IN ('dir /b %pkgbasesources%\APPTITLID\USRDIR\IMAGES\*.') DO (
echo - %%Y theme pack source files ...
if not exist "%pkgsource%\themepacks\%%Y\%id_xmbmp%\USRDIR\IMAGES" mkdir "%pkgsource%\themepacks\%%Y\%id_xmbmp%\USRDIR\IMAGES"
xcopy /Y "%pkgbasesources%\APPTITLID\ICON0.PNG" "%pkgsource%\themepacks\%%Y\%id_xmbmp%" >NUL
xcopy /Y /E "%pkgbasesources%\APPTITLID\USRDIR\IMAGES\%%Y\*.*" "%pkgsource%\themepacks\%%Y\%id_xmbmp%\USRDIR\IMAGES" >NUL
del /Q /S %pkgsource%\themepacks\%%Y\%id_xmbmp%\USRDIR\IMAGES\themeinfo.xml >NUL
copy /Y "%pkgbasesources%\APPTITLID\USRDIR\IMAGES\themeinfo.xml" "%pkgsource%\themepacks\%%Y\%id_xmbmp%\USRDIR\IMAGES\themeinfo.xml" >NUL
%external%\ssr\ssr --nobackup --dir "%pkgsource%\themepacks\%%Y\%id_xmbmp%\USRDIR\IMAGES" --include "themeinfo.xml" --alter --search "THEMENAME" --replace "%%Y"
%external%\ssr\ssr --nobackup --dir "%pkgsource%\themepacks\%%Y\%id_xmbmp%\USRDIR\IMAGES" --include "themeinfo.xml" --alter --search "APPTITLID" --replace "%id_xmbmp%"
%external%\ssr\ssr --nobackup --dir "%pkgsource%\themepacks\%%Y\%id_xmbmp%\USRDIR\IMAGES" --include "themeinfo.xml" --alter --search "XMBMP-VERSION" --replace "%working_version%"
copy /Y "%pkgbasesources%\APPTITLID\PARAM-PATCH.SFX" "%pkgsource%\themepacks\%%Y\%id_xmbmp%\PARAM.SFX" >NUL
%external%\ssr\ssr --nobackup --encoding utf8 --dir "%pkgsource%\themepacks\%%Y\%id_xmbmp%" --include "PARAM.SFX" --alter --search "0.00" --replace "%working_version%"
%external%\ssr\ssr --nobackup --encoding utf8 --dir "%pkgsource%\themepacks\%%Y\%id_xmbmp%" --include "PARAM.SFX" --alter --search "APPTITLID" --replace "%id_xmbmp%"
%external%\ssr\ssr --nobackup --encoding utf8 --dir "%pkgsource%\themepacks\%%Y\%id_xmbmp%" --include "PARAM.SFX" --alter --search "DESCRIPTION" --replace "Theme Pack (%%Y)"
)

echo.
echo CREATING core source files ...
echo.
echo - Preparing ...
FOR %%A IN (hdd0-cfw hdd0-cfw-full hdd0-cobra usb000 usb001 usb006 hfw) DO (
if exist "%pkgsource%\core-%%A" rmdir /Q /S "%pkgsource%\core-%%A" >NUL
if not exist "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\FEATURES" mkdir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\FEATURES"
if not exist "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\IMAGES" mkdir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\IMAGES"
xcopy /Y "%pkgbasesources%\APPTITLID\USRDIR\*.xml" "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR" >NUL
xcopy /Y "%pkgbasesources%\APPTITLID\USRDIR\FEATURES\*.xml" "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\FEATURES" >NUL
xcopy /E /Y "%pkgsource%\themepacks\%default_theme%\%id_xmbmp%\USRDIR\IMAGES\*.*" "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\IMAGES\" >NUL
)

FOR %%A IN (hdd0-cfw hdd0-cfw-full hdd0-cobra) DO (
if not exist "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\resource" mkdir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\resource"
xcopy /Y "%pkgbasesources%\APPTITLID\*.PNG" "%pkgsource%\core-%%A\%id_xmbmp%" >NUL
xcopy /Y "%pkgbasesources%\APPTITLID\PARAM.SFX" "%pkgsource%\core-%%A\%id_xmbmp%" >NUL
for /f "tokens=1,2 delims=*" %%X IN ('dir /b "%pkgbasesources%\APPTITLID\USRDIR\resource\*.355"') DO (
if not exist "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\resource\%%X" mkdir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\resource\%%X"
xcopy /Y /E "%pkgbasesources%\APPTITLID\USRDIR\resource\%%X\*.*" "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\resource\%%X\" >NUL
)
IF [%%A]==[hdd0-cfw] (
xcopy /Y "%pkgbasesources%\APPTITLID\USRDIR\resource\category_game_tool2.xml.*" "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\resource" >NUL
xcopy /Y "%pkgbasesources%\APPTITLID\USRDIR\resource\category_game.xml.*" "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\resource" >NUL
copy /Y "%pkgbasesources%\APPTITLID\USRDIR\EBOOT-CFW.ELF" "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\EBOOT.ELF" >NUL
)
IF [%%A]==[hdd0-cfw-full] (
xcopy /Y "%pkgbasesources%\APPTITLID\USRDIR\resource\category_game_tool2.xml.*" "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\resource" >NUL
xcopy /Y "%pkgbasesources%\APPTITLID\USRDIR\resource\category_game.xml.*" "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\resource" >NUL
copy /Y "%pkgbasesources%\APPTITLID\USRDIR\EBOOT-CFW-WITH-341.ELF" "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\EBOOT.ELF" >NUL
for /f "tokens=1,2 delims=*" %%X IN ('dir /b "%pkgbasesources%\APPTITLID\USRDIR\resource\*.341"') DO (
if not exist "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\resource\%%X" mkdir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\resource\%%X"
xcopy /Y /E "%pkgbasesources%\APPTITLID\USRDIR\resource\%%X\*.*" "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\resource\%%X\" >NUL
)
)
IF [%%A]==[hdd0-cobra] (
xcopy /Y "%pkgbasesources%\APPTITLID\USRDIR\resource\category_tv.xml.*" "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\resource" >NUL
xcopy /Y "%pkgbasesources%\APPTITLID\USRDIR\resource\category_gam2.xml.*" "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\resource" >NUL
copy /Y "%pkgbasesources%\APPTITLID\USRDIR\EBOOT-COBRA.ELF" "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\EBOOT.ELF" >NUL
)
)

for /f "tokens=1,2 delims=." %%S IN ('dir /b %languageinisdir%\*.ini') DO (
if exist "%languageinisdir%\%%S.rco.tmp" del /Q /S %languageinisdir%\%%S.rco.tmp >NUL
copy /y NUL %languageinisdir%\%%S.rco.tmp >NUL
for /f "tokens=1,2 delims==" %%G in (%languageinisdir%\%%S.ini) DO (
IF NOT [%%H]==[] echo 	^<Text name^="%%G"^>%%H^</Text^> >> %languageinisdir%\%%S.rco.tmp
)
echo ^</TextLang^> >> %languageinisdir%\%%S.rco.tmp
)

FOR %%A IN (hdd0-cfw hdd0-cfw-full hdd0-cobra) DO (
echo - core %%A source files ...
FOR /f "tokens=1,2 delims=*" %%C IN ('dir /b "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\resource\*.rco.*"') DO (
FOR /f "tokens=1,2 delims=." %%E IN ('dir /b "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\resource\%%C\Text\*.xml"') DO (
set LCODE=%default_lang%
FOR /F "tokens=1,2 delims==" %%G IN (%languageinisdir%\language_map.ini) DO (
IF [%%H]==[%%E] set LCODE=%%G
)
%external%\ssr\ssr --nobackup --encoding utf8 --dir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\resource\%%C\Text" --include "%%E.xml" --alter --search "/SSR_CR//SSR_LF/</TextLang>" --replace "" >NUL
%external%\ssr\ssr --nobackup --encoding utf8 --dir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\resource\%%C\Text" --include "%%E.xml" --alter --search "</TextLang>" --replace "" >NUL
type %languageinisdir%\!LCODE!.rco.tmp >> %pkgsource%\core-%%A\%id_xmbmp%\USRDIR\resource\%%C\Text\%%E.xml
)
)
%external%\ssr\ssr --nobackup --encoding utf8 --dir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\FEATURES" --include "Download_*.xml" --alter --search "<Pair key=''info''><String>LANG_INFO_DOWNLOADMANAGER-HOMEBREW-AUTHOR: " --replace "<Pair key=''info''><String>"
%external%\ssr\ssr --nobackup --encoding utf8 --dir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\FEATURES" --include "*.xml" --alter --search "<Pair key=''title''><String>LANG" --replace "<Pair key=''title_rsc''><String>LANG"
%external%\ssr\ssr --nobackup --encoding utf8 --dir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\FEATURES" --include "*.xml" --alter --search "<Pair key=''info''><String>LANG" --replace "<Pair key=''info_rsc''><String>LANG"
%external%\ssr\ssr --nobackup --encoding utf8 --dir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR" --include "*.xml" --alter --search "<Pair key=''title''><String>LANG" --replace "<Pair key=''title_rsc''><String>LANG"
%external%\ssr\ssr --nobackup --encoding utf8 --dir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR" --include "*.xml" --alter --search "<Pair key=''info''><String>LANG" --replace "<Pair key=''info_rsc''><String>LANG"
%external%\ssr\ssr --nobackup --encoding utf8 --dir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR" --include "game_settings.xml" --alter --search "<Query class=''type:x-xmb/folder-pixmap'' key=''languages'' attr=''languages'' src=''#seg_settings_languages''/>" --replace ""
%external%\ssr\ssr --nobackup --encoding utf8 --dir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR" --include "game_settings.xml" --alter --search "seg_current_theme_LANGUAGE-CODE" --replace "seg_current_theme"
)
del /Q /S %languageinisdir%\*.tmp >NUL

echo - Finalizing ...
for /f "tokens=1,2 delims=*" %%A IN ('dir /b "%pkgsource%\core-hdd0-*."') DO (
%external%\ssr\ssr --nobackup --encoding utf8 --dir "%pkgsource%\%%A\%id_xmbmp%\USRDIR" --include "game_settings.xml" --alter --search "Latest_version_XXX.html" --replace "Latest_version_%%A.html"
%external%\ssr\ssr --nobackup --encoding utf8 --dir "%pkgsource%\%%A\%id_xmbmp%\USRDIR" --include "*.xml" --alter --search "FILEPROVIDER_BASE_URL" --replace "%fileprovider_base_url%"
%external%\ssr\ssr --nobackup --encoding utf8 --dir "%pkgsource%\%%A\%id_xmbmp%\USRDIR\FEATURES" --include "*.xml" --alter --search "FILEPROVIDER_BASE_URL" --replace "%fileprovider_base_url%"
%external%\ssr\ssr --nobackup --encoding utf8 --dir "%pkgsource%\%%A\%id_xmbmp%\USRDIR" --include "*.xml" --alter --search "APPTITLID" --replace "%id_xmbmp%"
%external%\ssr\ssr --nobackup --encoding utf8 --dir "%pkgsource%\%%A\%id_xmbmp%\USRDIR\FEATURES" --include "*.xml" --alter --search "APPTITLID" --replace "%id_xmbmp%"
%external%\ssr\ssr --nobackup --encoding utf8 --dir "%pkgsource%\%%A\%id_xmbmp%\USRDIR" --include "*.xml" --alter --search "XMBMP-VERSION" --replace "%working_version%"
%external%\ssr\ssr --nobackup --encoding utf8 --dir "%pkgsource%\%%A\%id_xmbmp%\USRDIR\FEATURES" --include "*.xml" --alter --search "XMBMP-VERSION" --replace "%working_version%"
rename %pkgsource%\%%A\%id_xmbmp%\USRDIR\EBOOT.ELF EBOOT.ELF.TMP >NUL
%external%\binmay\binmay.exe -i %pkgsource%\%%A\%id_xmbmp%\USRDIR\EBOOT.ELF.TMP -o %pkgsource%\%%A\%id_xmbmp%\USRDIR\EBOOT2.ELF.TMP -s t:APPTITLID -r t:%id_xmbmp%
%external%\binmay\binmay.exe -i %pkgsource%\%%A\%id_xmbmp%\USRDIR\EBOOT2.ELF.TMP -o %pkgsource%\%%A\%id_xmbmp%\USRDIR\EBOOT.ELF -s t:"***** XMB Manager Plus 0.00 (Rebug PM 1.1) *****" -r t:"***** XMB Manager Plus %working_version% (Rebug PM 1.1) *****"
del /Q /S %pkgsource%\%%A\%id_xmbmp%\USRDIR\*.TMP >NUL
%external%\ssr\ssr --nobackup --encoding utf8 --dir "%pkgsource%\%%A\%id_xmbmp%" --include "PARAM.SFX" --alter --search "0.00" --replace "%working_version%"
%external%\ssr\ssr --nobackup --encoding utf8 --dir "%pkgsource%\%%A\%id_xmbmp%" --include "PARAM.SFX" --alter --search "APPTITLID" --replace "%id_xmbmp%"
%external%\ssr\ssr --nobackup --encoding utf8 --dir "%pkgsource%\%%A\%id_xmbmp%" --include "PARAM.SFX" --alter --search " DESCRIPTION" --replace ""
IF [%%A]==[core-hdd0-cfw-full] %external%\ssr\ssr --nobackup --encoding utf8 --dir "%pkgsource%\%%A\%id_xmbmp%" --include "PARAM.SFX" --alter --search "3.55" --replace "3.41"
%external%\ssr\ssr --nobackup --encoding utf8  --dir "%pkgsource%\%%A\%id_xmbmp%\USRDIR\resource" --include "*.new" --alter --search "APPTITLID" --replace "%id_xmbmp%"
%external%\ssr\ssr --nobackup --encoding utf8  --dir "%pkgsource%\%%A\%id_xmbmp%\USRDIR\resource" --include "*.new" --alter --search "XMBMP-VERSION" --replace "%working_version%"
)

FOR %%A IN (usb000 usb001 usb006 hfw) DO (
echo - core %%A source files ...
FOR /F "tokens=1,2 delims==" %%G IN (%languageinisdir%\%default_lang%.ini) DO (
FOR /F "tokens=1,2 delims=-" %%E IN ('echo %%G') DO (
FOR /F "tokens=1,2,3 delims=_" %%O IN ('echo %%E') DO (
IF [%%Q]==[MAIN] %external%\ssr\ssr --nobackup --recurse --encoding utf8 --dir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR" --include "game_main.xml" --alter --search "%%G" --replace "%%H"
IF [%%Q]==[SETTINGS] %external%\ssr\ssr --nobackup --recurse --encoding utf8 --dir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR" --include "game_settings.xml" --alter --search "%%G" --replace "%%H"
IF [%%Q]==[FILEMANAGER] %external%\ssr\ssr --nobackup --recurse --encoding utf8 --dir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\FEATURES" --include "File_Manager.xml" --alter --search "%%G" --replace "%%H"
IF [%%Q]==[GAMEDATAMANAGER] %external%\ssr\ssr --nobackup --recurse --encoding utf8 --dir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\FEATURES" --include "Game_Data_Manager.xml" --alter --search "%%G" --replace "%%H"
IF [%%Q]==[USERDATAMANAGER] %external%\ssr\ssr --nobackup --recurse --encoding utf8 --dir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\FEATURES" --include "User_Data_Manager.xml" --alter --search "%%G" --replace "%%H"
IF [%%Q]==[GAMEMANAGER] %external%\ssr\ssr --nobackup --recurse --encoding utf8 --dir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\FEATURES" --include "Game_Manager.xml" --alter --search "%%G" --replace "%%H"
IF [%%Q]==[HOMEBREWMANAGER] %external%\ssr\ssr --nobackup --recurse --encoding utf8 --dir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\FEATURES" --include "Homebrew_Manager.xml" --alter --search "%%G" --replace "%%H"
IF [%%Q]==[WEBLINKS] %external%\ssr\ssr --nobackup --recurse --encoding utf8 --dir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\FEATURES" --include "Links.xml" --alter --search "%%G" --replace "%%H"
IF [%%Q]==[MULTIMEDIAMANAGER] %external%\ssr\ssr --nobackup --recurse --encoding utf8 --dir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\FEATURES" --include "Multimedia_Manager.xml" --alter --search "%%G" --replace "%%H"
IF [%%Q]==[PACKAGEMANAGER] %external%\ssr\ssr --nobackup --recurse --encoding utf8 --dir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\FEATURES" --include "Package_Manager.xml" --alter --search "%%G" --replace "%%H"
IF [%%Q]==[DOWNLOADMANAGER] %external%\ssr\ssr --nobackup --recurse --encoding utf8 --dir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\FEATURES" --include "Download_Manager.xml" --alter --search "%%G" --replace "%%H"
IF EXIST "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\FEATURES\Personal_Area.xml" IF [%%Q]==[PERSONALAREA] %external%\ssr\ssr --nobackup --encoding utf8 --dir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\FEATURES" --include "Personal_Area.xml" --alter --search "%%G" --replace "%%H"
)
)
)
%external%\ssr\ssr --nobackup --encoding utf8 --dir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR" --include "game_settings.xml" --alter --search "seg_current_theme_LANGUAGE-CODE" --replace "seg_current_theme_%default_lang%"
%external%\ssr\ssr --nobackup --recurse --encoding utf8 --dir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR" --include "*.xml" --alter --search "FILEPROVIDER_BASE_URL" --replace "%fileprovider_base_url%"
%external%\ssr\ssr --nobackup --recurse --encoding utf8 --dir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR" --include "*.xml" --alter --search "APPTITLID" --replace "%id_xmbmp%"
%external%\ssr\ssr --nobackup --recurse --encoding utf8 --dir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR" --include "*.xml" --alter --search "XMBMP-VERSION" --replace "%working_version%"
if not exist "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\resource\cfw" mkdir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\resource\cfw" >NUL
if not exist "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\resource\rebug" mkdir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\resource\rebug" >NUL
if not exist "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\resource\cobra" mkdir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\resource\cobra" >NUL
if not exist "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\resource\nfw" mkdir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\resource\nfw" >NUL
copy "%pkgbasesources%\APPTITLID\USRDIR\resource\category_game.xml.new" "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\resource\cfw\category_game.xml" >NUL
copy "%pkgbasesources%\APPTITLID\USRDIR\resource\category_game_tool2.xml.new" "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\resource\rebug\category_game_tool2.xml" >NUL
copy "%pkgbasesources%\APPTITLID\USRDIR\resource\category_gam2.xml.new" "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\resource\cobra\category_gam2.xml" >NUL
copy "%pkgbasesources%\APPTITLID\USRDIR\resource\category_tv.xml.new" "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\resource\nfw\category_tv.xml" >NUL
%external%\ssr\ssr --nobackup --recurse --dir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\resource" --include "*.xml" --alter --search "APPTITLID" --replace "%id_xmbmp%"
%external%\ssr\ssr --nobackup --recurse --dir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR\resource" --include "*.xml" --alter --search "XMBMP-VERSION" --replace "%working_version%"
if not [%%A]==[hfw] %external%\ssr\ssr  --nobackup --recurse --encoding auto --dir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR" --include "*.xml" --alter --search "/dev_hdd0/game/%id_xmbmp%" --replace "/dev_%%A/PS3/%id_xmbmp%"
if [%%A]==[hfw] (
%external%\ssr\ssr  --nobackup --recurse --dir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR" --include "*.xml" --alter --search "/dev_hdd0/game/%id_xmbmp%" --replace "/dev_usb000/PS3/%id_xmbmp%"
%external%\ssr\ssr  --nobackup --dir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR" --include "game_settings.xml" --alter --search ".pkg" --replace ".rar"
)
%external%\ssr\ssr  --nobackup --dir "%pkgsource%\core-%%A\%id_xmbmp%\USRDIR" --include "game_settings.xml" --alter --search "Latest_version_XXX.html" --replace "Latest_version_%%A.html"
mkdir "%pkgsource%\core-%%A\PS3" >NUL
move /Y "%pkgsource%\core-%%A\%id_xmbmp%" "%pkgsource%\core-%%A\PS3\" >NUL
)
chcp %CodePage% >NUL

echo.
echo CREATING package configuration file ...
echo.
copy "%bindir%\package.conf.template" "%pkgsource%\package-%id_xmbmp%.conf" >NUL
%external%\ssr\ssr --nobackup --encoding auto --dir "%pkgsource%" --include "package-%id_xmbmp%.conf" --alter --search "APPTITLID" --replace "%id_xmbmp%"
%external%\ssr\ssr --nobackup --encoding auto --dir "%pkgsource%" --include "package-%id_xmbmp%.conf" --alter --search "CONTENT_TYPE" --replace "%type_xmbmp%"
%external%\ssr\ssr --nobackup --encoding auto --dir "%pkgsource%" --include "*.conf" --alter --search "APP_VER = 0.00" --replace "APP_VER = %working_version%"
copy "%pkgsource%\package-%id_xmbmp%.conf" "%pkgsource%\package-%id_xmbmp%-PATCH.conf" >NUL
%external%\ssr\ssr --nobackup --encoding auto --dir "%pkgsource%" --include "package-%id_xmbmp%-PATCH.conf" --alter --search "%type_xmbmp%" --replace "%type_xmbmp_patch%"

move /Y "%pkgbasesources%\resource" "%pkgbasesources%\APPTITLID\USRDIR\" >NUL

:done
call "%bindir%\global_messages.bat" "SOURCE-BUILDING-OK"
goto :end

:end
exit

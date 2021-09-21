@ECHO OFF
REM This is plugin installer for GVim windows

ECHO\
ECHO\
ECHO - - - - - - - - - - - - - - - - - 
ECHO\
ECHO  Vim/Gvim installer for Windows  
ECHO\
ECHO - - - - - - - - - - - - - - - - - 
ECHO\




ECHO\
REM ファイルディレクトリを変数として設定
ECHO Step1. Set files path.

SET HOME_PATH=%HOMEDRIVE%%HOMEPATH%
SET CURRENT_DIR=%~dp0
SET TARGET_DIR=%HOME_PATH%\GVim\

ECHO   Home dir   : %HOME_PATH%
ECHO   Source dir : %CURRENT_DIR%
ECHO   Target dir : %TARGET_DIR%




ECHO\
REM ターゲットディレクトリ作成
ECHO Step2. Make Target dir.

IF EXIST %TARGET_DIR% (
    REM 存在すればサブディレクトリも削除してからターゲットディレクトリを作成
    ECHO   Target dir is existed. Remake target dir.
    RMDIR /s /q %TARGET_DIR%
    MKDIR %TARGET_DIR%
) ELSE (
    REM ターゲットディレクトリを作成
    ECHO   Target dir is not existed. Make target dir.
    MKDIR %TARGET_DIR%
)




ECHO\
REM vimrc をホームディレクトリに _vimrc, _gvimrc としてコピー
REM  hoge > nul でコマンドメッセージを非表示
ECHO Step3. Copy vimrc to home dir.

SET VIMRC_SRC=%CURRENT_DIR%vimrc_alone
SET VIMRC_DST1=%HOME_PATH%\_vimrc
SET VIMRC_DST2=%HOME_PATH%\_gvimrc

COPY %VIMRC_SRC% %VIMRC_DST1% > nul
COPY %VIMRC_SRC% %VIMRC_DST2% > nul

ECHO   Copy : %VIMRC_SRC%   to   %VIMRC_DST1%
ECHO   Copy : %VIMRC_SRC%   to   %VIMRC_DST2%




ECHO\
REM FZF用バイナリを所定の場所にコピー (BIN_SRCは適宜変更すること！)
ECHO Step4. Copy binary for FZF.

SET BIN_SRC=%CURRENT_DIR%bins\fzf_bin\fzf-0.23.0-windows_amd64\fzf
SET BIN_DST=%HOME_PATH%\GVim\repos\github.com\junegunn\fzf\bin\fzf.exe

REM (F= ファイル、D= ディレクトリ)? と聞いてくる処理を自動化するため以下の記述になる
ECHO F | XCOPY %BIN_SRC% %BIN_DST% /R /Y > nul

ECHO   Copy source : %BIN_SRC%
ECHO   Copy target : %BIN_DST%




ECHO\
REM FZF用(Ripgrep)バイナリを所定の場所にコピー(BIN_SRCは適宜変更すること！)
ECHO Step5. Copy binary for Ripgrep on FZF.

SET BIN_SRC=%CURRENT_DIR%bins\rg\ripgrep-12.1.1-x86_64-pc-windows-msvc\rg
SET BIN_DST=%HOME_PATH%\GVim\repos\github.com\junegunn\fzf\bin\rg.exe

REM (F= ファイル、D= ディレクトリ)? と聞いてくる処理を自動化するため以下の記述になる
ECHO F | XCOPY %BIN_SRC% %BIN_DST% /R /Y > nul

ECHO   Copy source : %BIN_SRC%
ECHO   Copy target : %BIN_DST%




ECHO\
ECHO\
REM 終了
ECHO Complete!
ECHO Please reload vim.
ECHO\
ECHO\


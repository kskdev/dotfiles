@ECHO off
SETLOCAL

REM --- このバッチファイルがあるディレクトリを基準にする ---
SET DOTFILES_DIR=%~dp0

REM --- WindowsでのVSCode設定ディレクトリのパス (配置に注意．) ---
SET VSCODE_SETTINGS_DIR=%APPDATA%\Code\User

ECHO.
ECHO  Copying VSCode settings...
ECHO ============================

REM --- 設定ファイルを所定の場所にコピーする ---
ECHO "Settings.json Target   : %VSCODE_SETTINGS_DIR%\settings.json"
ECHO "Keybindings.json Target: %VSCODE_SETTINGS_DIR%\keybindings.json"
COPY /Y "%DOTFILES_DIR%settings.json" "%VSCODE_SETTINGS_DIR%\settings.json"
COPY /Y "%DOTFILES_DIR%keybindings.json" "%VSCODE_SETTINGS_DIR%\keybindings.json"
ECHO Settings and keybindings have been copied.


ECHO.
ECHO  Installing VSCode extensions...
ECHO ================================

REM --- extensions.txt を一行ずつ読み込んで、拡張機能をインストールする ---
FOR /F "usebackq tokens=*" %%L IN ("%DOTFILES_DIR%\extensions.txt") DO (
    ECHO Installing %%L...
    code --force --install-extension %%L
)

ECHO.
ECHO ============================
ECHO  Done! VSCode setup is complete.
ECHO.

ENDLOCAL
PAUSE
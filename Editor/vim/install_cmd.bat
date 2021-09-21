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
REM �t�@�C���f�B���N�g����ϐ��Ƃ��Đݒ�
ECHO Step1. Set files path.

SET HOME_PATH=%HOMEDRIVE%%HOMEPATH%
SET CURRENT_DIR=%~dp0
SET TARGET_DIR=%HOME_PATH%\GVim\

ECHO   Home dir   : %HOME_PATH%
ECHO   Source dir : %CURRENT_DIR%
ECHO   Target dir : %TARGET_DIR%




ECHO\
REM �^�[�Q�b�g�f�B���N�g���쐬
ECHO Step2. Make Target dir.

IF EXIST %TARGET_DIR% (
    REM ���݂���΃T�u�f�B���N�g�����폜���Ă���^�[�Q�b�g�f�B���N�g�����쐬
    ECHO   Target dir is existed. Remake target dir.
    RMDIR /s /q %TARGET_DIR%
    MKDIR %TARGET_DIR%
) ELSE (
    REM �^�[�Q�b�g�f�B���N�g�����쐬
    ECHO   Target dir is not existed. Make target dir.
    MKDIR %TARGET_DIR%
)




ECHO\
REM vimrc ���z�[���f�B���N�g���� _vimrc, _gvimrc �Ƃ��ăR�s�[
REM  hoge > nul �ŃR�}���h���b�Z�[�W���\��
ECHO Step3. Copy vimrc to home dir.

SET VIMRC_SRC=%CURRENT_DIR%vimrc_alone
SET VIMRC_DST1=%HOME_PATH%\_vimrc
SET VIMRC_DST2=%HOME_PATH%\_gvimrc

COPY %VIMRC_SRC% %VIMRC_DST1% > nul
COPY %VIMRC_SRC% %VIMRC_DST2% > nul

ECHO   Copy : %VIMRC_SRC%   to   %VIMRC_DST1%
ECHO   Copy : %VIMRC_SRC%   to   %VIMRC_DST2%




ECHO\
REM FZF�p�o�C�i��������̏ꏊ�ɃR�s�[ (BIN_SRC�͓K�X�ύX���邱�ƁI)
ECHO Step4. Copy binary for FZF.

SET BIN_SRC=%CURRENT_DIR%bins\fzf_bin\fzf-0.23.0-windows_amd64\fzf
SET BIN_DST=%HOME_PATH%\GVim\repos\github.com\junegunn\fzf\bin\fzf.exe

REM (F= �t�@�C���AD= �f�B���N�g��)? �ƕ����Ă��鏈�������������邽�߈ȉ��̋L�q�ɂȂ�
ECHO F | XCOPY %BIN_SRC% %BIN_DST% /R /Y > nul

ECHO   Copy source : %BIN_SRC%
ECHO   Copy target : %BIN_DST%




ECHO\
REM FZF�p(Ripgrep)�o�C�i��������̏ꏊ�ɃR�s�[(BIN_SRC�͓K�X�ύX���邱�ƁI)
ECHO Step5. Copy binary for Ripgrep on FZF.

SET BIN_SRC=%CURRENT_DIR%bins\rg\ripgrep-12.1.1-x86_64-pc-windows-msvc\rg
SET BIN_DST=%HOME_PATH%\GVim\repos\github.com\junegunn\fzf\bin\rg.exe

REM (F= �t�@�C���AD= �f�B���N�g��)? �ƕ����Ă��鏈�������������邽�߈ȉ��̋L�q�ɂȂ�
ECHO F | XCOPY %BIN_SRC% %BIN_DST% /R /Y > nul

ECHO   Copy source : %BIN_SRC%
ECHO   Copy target : %BIN_DST%




ECHO\
ECHO\
REM �I��
ECHO Complete!
ECHO Please reload vim.
ECHO\
ECHO\


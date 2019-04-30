{
  Delphi / Kylix open source DbExpress driver for ODBC

  Copyright (c) 2001-2012 Edward Benson

  This library is free software; you can redistribute it and/or
  modify it under the terms of the GNU Lesser General Public
  License as published by the Free Software Foundation; either
  version 2.1 of the License, or (at your option) any later version.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
  See the GNU Lesser General Public License for more details.
  
  VendorLib can reference:
  32bit: HKEY_LOCAL_MACHINE\SOFTWARE\WOW6432Node\ODBCINST.INI
  64bit: HKEY_LOCAL_MACHINE\SOFTWARE\ODBC\ODBCINST.INI
}

The Open-dbExpress project is a home for Open Source dbExpress drivers.

dbExpress as cross-platform data access technology developed by Borland for its Kylix, Delphi and
C++ Builder products. It takes the best ideas from the BDE (Borland Database Engine), Borland
ADOExpress, and other technologies such as Microsoft ADO.

Note -- dbExpress drivers can only be used with Borland products, specifically: Borland Kylix (for
Linux); Borland Delphi version 6 and above (for Microsoft Windows); Borland C++ Builder version 6
and above (for Microsoft Windows).

The latest version is only available from the project CVS repository.

Home page:
  http://open-dbexpress.sourceforge.net/

Project Home Page:
  https://sourceforge.net/projects/open-dbexpress/

Download page:
  http://sourceforge.net/projects/open-dbexpress/files/

What to do at occurrence of problems:
*************************************

English:
========

Use:
  1) Uninstall old package PkgDbxXXDrv{%DelphiVersion%}.bpl and remove old search path

  2) Install the package into the IDE
       dbxoodbc\lib\{%DelphiVersion%}\dbxoodbc*.bpl
     or
       dbxoodbc\lib\{%DelphiVersion%}\dbxoodbc*_emb.bpl
     The second option does not require an external "dbxoodbc.dll"

  3) Copy files
      "dbxoodbc\lib\dbxoodbc_driver\(%Platform%)\release\*dbxoodbc*"
      to one from system "%path%" directories (ie "{%DELPHI}\Bin").

  4) Add the module to your project:
       uses
         ..., DbxXXDrv;

     To embed a "dbxoodbc.dll" in your project add to a project module:
       uses
         ..., DbxOpenOdbcStatic;

If you have problems with the driver it is necessary for you to make the following steps:

1) If it is possible to switch on in your project next units:
       uses
         ..., DbxOpenOdbcStatic, DbxXXDrv;

2) If debugging with included DbxOpenOdbc.pas does not decide your problem you need to
   switch on the mode of journalizing.

3) For inclusion on of the mode of journalizing, you need to switch on in "DbxOpenOdbc_options.inc" unit
   of an option {$DEFINE _DEBUG_} and {$DEFINE _TRACE_CALLS_}; and to switch off an
   option {.$DEFINE _RELEASE_}. After that you need to rebuild your project or
   OpenODBC the driver.

4) Debug messages can be seen in Delphi IDE, in the window "Event Log". But it is accessible
   only in an event of start of the application from the environment of development.
   Otherwise it is necessary to take advantage of the special program "Debug View":
   http://technet.microsoft.com/en-us/sysinternals/bb896647
   More in detail about it is indicated in "DbxOpenOdbcTrace.pas unit.

5) In the debug window versions of the Database, ODBC the driver, OpenODBC, parameters of
   connection are indicated. If you want to ask connected with your problem necessarily indicate
   this information. It will allow to find faster a key to your problem.
   In the journal the history of calls of methods ...

6) Some files (*.7z) are packed by archiver "7-Zip":
     http://www.7-zip.org
     http://sourceforge.net/projects/sevenzip/

RUSSIAN CP:Win1251:
===================

Использование:
  1) Удалите старые пакеты PkgDbxXXDrv{%DelphiVersion%}.bpl и пути поиска исходных текстов в настройках IDE (глобальных и для проекта)

  2) Установите в IDE пакет
       dbxoodbc\lib\{%DelphiVersion%}\dbxoodbc*.bpl
     или
       dbxoodbc\lib\{%DelphiVersion%}\dbxoodbc*_emb.bpl
     Второй варианту не требуется внешняя "dbxoodbc.dll"

  3) Скопировать файл(ы) 
      "dbxoodbc\lib\dbxoodbc_driver\(%Platform%)\release\*dbxoodbc*"
      в одну из папок из системных путей "%path%" (это может быть и папка с IDE "{%DELPHI}\Bin").

  4) Добавьте в ваш проект модуль:
       uses
         ..., DbxXXDrv;
     Для встраивания "dbxoodbc.dll" в ваш проект добавьте к проекту модуль:
       uses
         ..., DbxOpenOdbcStatic;

Если вы имеете проблемы с драйвером, то вам необходимо сделать следующие шаги:

1) Если это возможно, то включите в ваш проект модули:
       uses
         ..., DbxOpenOdbcStatic, DbxXXDrv;

2) Если отладка с подключенным DbxOpenOdbc.pas не решает вашу проблему, то вам нужно
   включить режим журналирования.

3) Для включения режима журналирования, вам нужно включить в модуле "DbxOpenOdbc_options.inc" опции
   {$DEFINE _DEBUG_} и {$DEFINE _TRACE_CALLS_}; и выключить опцию {.$DEFINE _RELEASE_}.
   После этого вам нужно пересобрать ваш проект или OpenODBC драйвер.

4) Отладочные сообщения можно увидеть в Delphi IDE, в окне "Event Log", для случая запуска
   приложения из среды разработки. Иначе нужно воспользоваться специальной программой "Debug View":
   http://technet.microsoft.com/en-us/sysinternals/bb896647
   Подробнее про неё указано в модуле "DbxOpenOdbcTrace.pas".

5) В отладочном окне указаны версии Базы Данных, ODBC драйвера, OpenODBC, параметры соединения.
   Если вы захотите задать вопросы связанные с вашей проблемой, то обязательно укажите эту информацию.
   Это позволит быстрее найти ключ к вашей проблеме.
   Кроме этого в журнале ведётся история вызовов с указанием потока...

----
.EOF

#SingleInstance,Ignore
#Persistent
#NoTrayIcon

/*
Process, Close, Workrave Checker.exe
Process, Close, aWorkrave Checker_P2.exe
ExitApp
*/

Loop
{
Process, Exist, WRC.exe
if ErrorLevel = 0
{
Run, WRC.exe
}
sleep 500
}
#SingleInstance,Ignore
#Persistent
#NoTrayIcon

Loop
{
Process, Exist, AWRC.exe
if ErrorLevel = 0
{
Run, AWRC.exe
}
Process, Exist, Workrave.exe
if ErrorLevel = 0
{
Run, C:\Program Files\Workrave\lib\Workrave.exe
}
sleep 500
}
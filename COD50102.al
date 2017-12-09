codeunit 50102 InstalacionAPP
{
    Subtype=Install;
    trigger OnInstallAppPerDatabase();
    var
        info:ModuleInfo;
    begin
        NavApp.GetCurrentModuleInfo(info);
        if info.AppVersion = info.DataVersion then 
        begin
            NavApp.RestoreArchiveData(50120);
            NavApp.RestoreArchiveData(50121);
            NavApp.RestoreArchiveData(50122);
            NavApp.RestoreArchiveData(50123);
            NavApp.RestoreArchiveData(50124);
        end
    end;
    
}
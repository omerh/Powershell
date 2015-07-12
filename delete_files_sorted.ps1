#how many to keep
$rotation = 5
#Root folder
$rootfolder = "\\UNC\PATH"
#Get all sub folders
$folders = Get-ChildItem $rootfolder 

foreach ($folder in $folders)
{
    $keep = Get-ChildItem $rootfolder\$folder | Sort-Object LastWriteTime -Descending | Select-Object -first $rotation
    $deletes = Get-ChildItem -Exclude $keep $rootfolder\$folder | Sort-Object LastWriteTime -Descending

    foreach ($delete in $deletes)
    {
        $delete >> D:\deployments.txt
        write-host $delete
        Remove-Item $delete -Recurse -Force
    }
}

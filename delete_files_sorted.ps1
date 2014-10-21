$marketing = "\\unc_path\Images\"
$folders = Get-ChildItem $marketing 

foreach ($folder in $folders)
{
    $keep = Get-ChildItem $marketing$folder | Sort-Object LastWriteTime -Descending | Select-Object -first 3
    $deletes = Get-ChildItem -Exclude $keep $marketing$folder | Sort-Object LastWriteTime -Descending

    foreach ($delete in $deletes)
    {
        $delete >> D:\advisor-dele.txt
        Remove-Item $delete
    }

}

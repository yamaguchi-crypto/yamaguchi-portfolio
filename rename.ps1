# rename.ps1
# 日本語の画像ファイル名を index.html が参照する英数字名へ一括リネームします。
# 使い方(cmd): powershell -ExecutionPolicy Bypass -File rename.ps1

$ErrorActionPreference = 'Stop'
$works   = Join-Path $PSScriptRoot 'images\works'
$posters = Join-Path $PSScriptRoot 'images\posters'

function RenameSeq($folder, $cond, $prefix) {
  $files = Get-ChildItem -LiteralPath $folder -Filter *.jpg | Where-Object $cond | Sort-Object Name
  $i = 0
  foreach ($f in $files) {
    $i++
    $new = '{0}-{1:00}.jpg' -f $prefix, $i
    Rename-Item -LiteralPath $f.FullName -NewName $new
    Write-Host ("  {0}  ->  {1}" -f $f.Name, $new)
  }
  if ($i -eq 0) { Write-Host "  (該当なし: $prefix)" }
}

function RenameOne($pattern, $new) {
  $m = @(Get-ChildItem -LiteralPath $posters -Filter *.jpg | Where-Object { $_.Name -like $pattern })
  if ($m.Count -eq 1) {
    Rename-Item -LiteralPath $m[0].FullName -NewName $new
    Write-Host ("  {0}  ->  {1}" -f $m[0].Name, $new)
  } elseif ($m.Count -eq 0) {
    Write-Host "  [見つかりません] $pattern"
  } else {
    Write-Host "  [複数該当 $($m.Count)件] $pattern"
  }
}

Write-Host "=== WORKS (写真) ==="
RenameSeq $works { $_.Name -like '*Field*' } 'infield'
RenameSeq $works { $_.Name -like 'レ*' -and $_.Name -notlike '*drive*' } 'record'
RenameSeq $works { $_.Name -like '汽*' } 'kisuiiki'
RenameSeq $works { $_.Name -like '見*' } 'unseen'

Write-Host ""
Write-Host "=== POSTERS (ポスター) ==="
RenameOne '*反射*'     '2018-hansha.jpg'
RenameOne '*採録*'     '2018-sairoku.jpg'
RenameOne '*ふぁちゅ*' '2018-fachuasu.jpg'
RenameOne '*旋風*'     '2018-senpu.jpg'
RenameOne '*storage2*' '2018-storage2.jpg'
RenameOne '*Overlap*'  '2018-overlap.jpg'
RenameOne '*AUPE*'     '2017-aupe.jpg'
RenameOne '*strage1*'  '2017-strage1.jpg'
RenameOne '*AREA*'     '2017-area.jpg'
RenameOne '*卒業*'     '2017-sotsuten.jpg'
RenameOne '*SILENT*'   '2017-silent.jpg'
RenameOne '*SYUHEN*'   '2016-syuhen.jpg'
RenameOne '*到津*'     '2016-itozu.jpg'
RenameOne '*レコード*' '2016-record.jpg'
RenameOne '*知らない*' '2016-shiranai.jpg'
RenameOne '2015*'      '2015-monochrome.jpg'

Write-Host ""
Write-Host "=== 完了後の works フォルダ ==="
Get-ChildItem -LiteralPath $works -Filter *.jpg | Select-Object -ExpandProperty Name
Write-Host ""
Write-Host "=== 完了後の posters フォルダ ==="
Get-ChildItem -LiteralPath $posters -Filter *.jpg | Select-Object -ExpandProperty Name
Write-Host ""
Write-Host "リネーム処理が終わりました。"

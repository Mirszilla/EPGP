$wow = "C:\Users\anari\Desktop\World of Warcraft 3.3.5a\WTF\Account\TETANUSZ\SavedVariables\IcecrownGuildExport.lua"
$out = "C:\Users\anari\Desktop\Coreandalts\epgp.json"

if (!(Test-Path $wow)) {
    Write-Host "ERRO: ficheiro WoW nao encontrado"
    exit
}

$content = Get-Content $wow -Raw

$matches = [regex]::Matches(
    $content,
    '\["([^"]+)"\].*?\["ep"\]\s*=\s*(\d+).*?\["gp"\]\s*=\s*(\d+)',
    'Singleline'
)

$data = @{}

foreach ($m in $matches) {
    $name = $m.Groups[1].Value
    $ep = $m.Groups[2].Value
    $gp = $m.Groups[3].Value
    $data[$name] = "$ep,$gp"
}

$data | ConvertTo-Json -Depth 3 | Set-Content $out -Encoding UTF8

Write-Host "EPGP atualizado com sucesso"

if (Get-Command git -ErrorAction SilentlyContinue) {
    git add .
    git commit -m "Auto EPGP update"
    git push
} else {
    Write-Host "Git nao instalado - apenas JSON atualizado"
}
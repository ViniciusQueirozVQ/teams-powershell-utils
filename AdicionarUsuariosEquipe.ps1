param( 
    [string]$GroupId = "",
    [string]$ListaMembros = "",
    [string]$ListaProprietarios = "",
    [string]$NomeEquipe = ""
)

# Início lista de funções
Function CriarOuLocalizarEquipe {
    param(
        [string]$NomeEquipe = "",
        [string]$GroupId = ""
    )

    #Definindo a descrição para a mesma equipe
    $DescricaoEquipe = $NomeEquipe
    $EmailEquipe = $NomeEquipe

    # Remoção de espaços virgulas e traços para criação e emails viculados as equipes do teams
    $EmailEquipe = $EmailEquipe.Replace(" ", "")
    $EmailEquipe = $EmailEquipe.Replace(",", "")
    $EmailEquipe = $EmailEquipe.Replace("-", "")

    <# Adicionar codigo para identificacao posterior(Opcional) ex: $codigoIdentificador="2021" #>
    $codigoIdentificador = "u215-"
    $EmailEquipe = $codigoIdentificador + $EmailEquipe

    # Remoção de Caracteres especiais do email (~,Ç, ã, etc)
    $EmailEquipe = [Text.Encoding]::ASCII.GetString([Text.Encoding]::GetEncoding("Cyrillic").GetBytes($EmailEquipe)).ToLower()
    
    try {
        If ($GroupId -ne "") {
            $Equipe = Get-Team -GroupId $GroupId
            Write-Host "Equipe"$Equipe.DisplayName"localizada com sucesso!" -ForegroundColor Black -BackgroundColor White
        }
        ElseIf ($NomeEquipe -ne "" -or $Equipe.DisplayName -eq "") {
            $Equipe = New-Team -DisplayName $NomeEquipe  -Description $DescricaoEquipe -MailNickName $EmailEquipe -Template EDU_Class -AllowCreateUpdateChannels 0 -AllowCreateUpdateRemoveConnectors 0 -AllowGiphy 0 -AllowStickersAndMemes 0 -AllowCustomMemes 0 -AllowGuestCreateUpdateChannels 0 -AllowGuestDeleteChannels 0 -AllowDeleteChannels 0 -AllowAddRemoveApps 0 -AllowCreateUpdateRemoveTabs 0
            Write-Host "Nova Equipe"$Equipe.DisplayName"criada com sucesso!" -ForegroundColor Black -BackgroundColor White
        }
    }
    catch {
        Write-Host "Erro ao localizar equipe["$($_.Exception.Message)"]" -ForegroundColor Red
    }

    return $Equipe

}

Function AdicionarUsuarios {
    param(
        [Parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]
        [string]$CaminhoListaCSV,
        [switch]$Proprietario
    )
    
    $Usuarios = Import-Csv -Path $CaminhoListaCSV
    
    $Regra = 'Member'
    $TipoUsuario = 'Membro'
    If ($Proprietario) {
        $Regra = 'Owner'
        $TipoUsuario = 'Proprietario'
    }

    Write-Host "Adicionando "$Usuarios.count $TipoUsuario"(s) ..." -ForegroundColor Black -BackgroundColor White
    
    # Percorrendo a lista de {Membros e/ou Proprietarios}
    $Progresso = 0
    for ($index = 0; $index -lt $Usuarios.count; $index++) {
        $Usuario = $Usuarios[$index]
        $Progresso = ($index + 1)
        $Percentual = [Math]::Floor($Progresso / $Usuarios.count * 100)
    
        try {
            Add-TeamUser -Role $Regra -GroupId $Equipe.GroupId -user $Usuario.email.ToLower()
            Write-Host ""$Usuario.email.ToLower()"foi adicionado(a) como $TipoUsuario(a) a equipe"$Equipe.DisplayName"" -ForegroundColor Green
        }
        catch {
            Write-Host "Erro ao adicionar o $TipoUsuario"$Usuario.email"a equipe"$Equipe.DisplayName"":["$($_.Exception.Message)"]"" -ForegroundColor Red
        }
        Write-Host "Progresso: $Progresso de" $Usuarios.count"- $Percentual %" -ForegroundColor Yellow
        Write-Host ""
        
    }

    Write-Host "100% do(s) $TipoUsuario(s) Verificados(s)" -ForegroundColor Green
    Write-Host "Verifique a equipe pelo aplicativo do teams ou pela web" -ForegroundColor Green
}


#Inicio da Execução do Código PRINCIAL (MAIN)

$Equipe = CriarOuLocalizarEquipe -GroupId $GroupId -NomeEquipe $NomeEquipe

If (($Null -eq $Equipe.GroupId) -OR ("" -eq $Equipe.GroupId)) {
    Write-Host "Nenhum membro ou proprietario adicionado. A equipe nao foi criada ou nao existe!" -ForegroundColor White -BackgroundColor Red
    Write-Host "Verifique se o ID da Equipe (GroupID) foi escrito corretamente ou se o nome para a nova equipe foi escrito!" -ForegroundColor White -BackgroundColor Red
}
Else {
    If ($ListaMembros -ne "") { AdicionarUsuarios -CaminhoListaCSV $ListaMembros } 
    If ($ListaProprietarios -ne "") { AdicionarUsuarios -CaminhoListaCSV $ListaProprietarios -Proprietario }
}

#Fim da Execução do Código

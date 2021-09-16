# teams-powershell-utils
## Scripts para Operações em Massa no MS Teams via PowerShell

1. Primeiramente, é necessário instalar o módulo do teams no powershell. Para instruções de como instalar, vá para a documentação oficial da Microsoft 
[Link Oficial](https://docs.microsoft.com/pt-br/microsoftteams/teams-powershell-install)

2. Depois, Connecte-se ao teams digitando o seguinte comando no powershell:

```
Connect-MicrosoftTeams 
```
3. Utilização dos scripts:
   Para se utilizar os scripts, após o download do projeto, os exemplos abaixo assumem que o terminal está aberto na raiz do projeto.
   Então recomenda-se copiar o projeto na raiz das unidades (C: D: F:, etc). Recomenda-se que utilze o comando em uma pasta e/ou caminho que não contenha espaços
   
   Ex: D:\teams-powershell-utils
   Uma forma simples de verificar se o terminal está de fato, basta visualizar o primeiro caminho no topo do terminal ou digitar o comando ```pwd``` no terminal.
   
  - Uso do Script AdicionarUsuariosEquipe.ps1
  
  o comando segue essa estrutura:
  ```
  .\AdicionarUsuariosEquipe.ps1 -GroupId ID_DA_EQUIPE_EXISTENTE -NomeEquipe "NOME_PARA_NOVA_EQUIPE" -ListaProprietarios CAMINHO_DA_LISTA_EM_CSV -ListaMembros CAMINHO_DA_LISTA_EM_CSV
  ```
  O parâmetro -GroupId se refere ao ID da equipe no teams. No [Centro de Administração do Microsoft 365](https://admin.microsoft.com/) (Antigo Office 365) é possível obter isso de forma rápida. Mas um usuário comum pode utilzar o comando ```Get-Team``` para listar todas as equipes que ele faz parte.
</br>Por isso, o comando pode demorar um pouco para listar todas as equipes. 
</br> Portanto se a largura de banda de internet não for um grande problema, utlize junto com o parâmetro -NumberOfThreads {valor entre 1 e 20} para ajudar reduzir o tempo para a exibição das equipes.
Exemplo: 
```
Get-Team -NumberOfThreads 6
```
A equipe pode ser pesquisada pelo nome de exibição, usando o parametro -DisplayName, entre aspas.
Get-Team -DisplayName "Nome da Equipe de Teste"
Mas informações sobre o Get-Team em : [Documentação Get-Team ](https://docs.microsoft.com/en-us/powershell/module/teams/get-team?view=teams-ps)

O parâmetro não deve ser usado caso a equipe não exista (já que não haverá um id). Nesse caso, use o parâmetro -NomeEquipe para criar novas equipes.
Se o parâmetro GroupID for usado com o -NomeEquipe, então será usado o GroupID. O script não muda o nome de uma equipe existente.

-ListaProprietarios e -ListaMembros são os caminhos dos respectivos arquivos de proprietários e membros, no formato CSV. Ambos podem ser omitidos, mas pelo menos um é obrigatório ser usado. Com relação aos caminhos das listas dos arquivos, o mesmo vale para a pasta do projeto. Evite usar espaços.

O arquivo CSV deve conter essa coluna com o cabeçalho email, usado como uma identificação única do usuário. O arquivo CSV pode conter outras colunas, mas devem estar separadas por vírgura ```,```.

email | 
------------ | 
usuario1@email.com.br
usuario2@email.com.br
usuario3@email.com.br
usuario4@email.com.br

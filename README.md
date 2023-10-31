# Terraform OnePet

Este setup cria uma máquina (ou quantas for necessário) na GCP, com Docker e autenticada com GitHub.

## Sobre a autenticação
No arquivo variables.tf defina as variáveis, especialmente o token de autenticação do GitHub.

Essa autenticação é super importante para o processo de CD do GitHub Actions.

## Autenticação na GCP
Gere um novo serviço no IAM da Google, atríbua as permissões, e por último baixe o aquivo gcp.json para a raiz do projeto.
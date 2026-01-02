# aws-secure-web-lab

Infrastructure AWS sécurisée déployée avec Terraform.

## Objectif
Projet de laboratoire pour pratiquer :
- Cloud AWS
- Réseau
- Sécurité
- Infrastructure as Code (Terraform)

## Architecture
- VPC
- Sous-réseau public
- Sous-réseau privé
- Internet Gateway
- NAT Gateway
- EC2 (public & privé)
- Security Groups

## Sécurité
- Accès SSH contrôlé
- Sous-réseau privé sans accès direct Internet
- NAT Gateway pour trafic sortant
- Variables sensibles hors GitHub

## Déploiement
```bash
terraform init
terraform plan
terraform apply
```
## Nettoyage
```bash
terraform destroy
```
## Technologies
 - AWS
 - Terraform
 - Windows PowerShell
 - Git/Github


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
- Subnet public
- Subnet privé
- Internet Gateway
- NAT Gateway
- EC2 (public & privé)
- Security Groups

## Sécurité
- Accès SSH contrôlé
- Subnet privé sans accès direct Internet
- NAT Gateway pour trafic sortant
- Variables sensibles hors GitHub

## Déploiement
```bash
terraform init
terraform plan
terraform apply

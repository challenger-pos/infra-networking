# Infra-Networking

Este projeto contém a infraestrutura de rede AWS gerenciada com Terraform, projetada para suportar aplicações cloud-native com alta disponibilidade e segurança.

## 🎯 Propósito

Provisionar uma infraestrutura de rede completa e escalável na AWS, incluindo:
- VPC com segmentação adequada
- Subnets públicas e privadas para diferentes casos de uso
- NAT Gateways para acesso controlado à internet
- Route tables para roteamento seguro
- Suporte para EKS, RDS, Lambda e outros serviços AWS

## 📁 Estrutura do Projeto

```
infra-networking/
├── modules/
│   └── vpc-networking/          # Módulo reutilizável de rede
│       ├── vpc.tf              # Configuração da VPC
│       ├── subnets.tf          # Definição das subnets
│       ├── internet-gateway.tf # Gateway de internet
│       ├── nat-gateway.tf      # NAT Gateways
│       ├── route-tables.tf     # Tabelas de roteamento
│       ├── variables.tf        # Variáveis do módulo
│       └── outputs.tf          # Saídas do módulo
└── envs/
    ├── dev/                    # Configurações do ambiente de desenvolvimento
    │   ├── main.tf            # Configuração principal
    │   ├── variables.tf       # Variáveis do ambiente
    │   ├── outputs.tf         # Saídas do ambiente
    │   └── backend.tf         # Configuração do backend
    ├── homologation/          # Configurações do ambiente de homologação
    │   ├── main.tf            # Configuração principal
    │   ├── variables.tf       # Variáveis do ambiente
    │   ├── outputs.tf         # Saídas do ambiente
    │   └── backend.tf         # Configuração do backend
    └── production/            # Configurações do ambiente de produção
        ├── main.tf            # Configuração principal
        ├── variables.tf       # Variáveis do ambiente
        ├── outputs.tf         # Saídas do ambiente
        └── backend.tf         # Configuração do backend
```

## 🏗️ Arquitetura de Rede

### Subnets Configuradas

- **Públicas** (`10.0.1.0/24`, `10.0.2.0/24`): Para NAT Gateway, Bastion Host, Load Balancers
- **Privadas - Aplicações** (`10.0.10.0/24`, `10.0.11.0/24`): Para nodes do EKS e aplicações
- **Privadas - Banco de Dados** (`10.0.20.0/24`, `10.0.21.0/24`): Para instâncias RDS
- **Privadas - Lambda** (`10.0.30.0/24`, `10.0.31.0/24`): Para Lambda functions com VPC

### Componentes de Rede

- **VPC**: `10.0.0.0/16` com DNS habilitado
- **Internet Gateway**: Para acesso público das subnets públicas
- **NAT Gateway**: Configurado como single gateway (dev) para economia de custos
- **Route Tables**: Configuração separada para subnets públicas e privadas

## 🚀 Como Usar

### Pré-requisitos
- Terraform >= 1.0
- AWS CLI configurado
- Permissões adequadas na AWS

### Deploy dos Ambientes

#### Ambiente de Desenvolvimento
```bash
cd envs/dev
terraform init
terraform plan
terraform apply
```

#### Ambiente de Homologação
```bash
cd envs/homologation
terraform init
terraform plan
terraform apply
```

#### Ambiente de Produção
```bash
cd envs/production
terraform init
terraform plan
terraform apply
```

### Customização

Para criar novos ambientes:
1. Copie a pasta `envs/dev` para `envs/<novo-ambiente>`
2. Ajuste as variáveis em `variables.tf`
3. Modifique a configuração do NAT Gateway conforme necessidade:
   - `single_nat_gateway = true` para economia (dev/staging)
   - `one_nat_gateway_per_az = true` para alta disponibilidade (prod)

## 📊 Saídas Úteis

Após o deploy, você terá acesso a:
- IDs das subnets para configurar outros serviços
- IDs dos NAT Gateways
- IDs das route tables
- VPC ID para referência em outros módulos

## 🔧 Variáveis Principais

- `project_name`: Nome do projeto para nomenclatura
- `environment`: Ambiente (dev, homologation, production)
- `region`: Região AWS
- `vpc_cidr`: Bloco CIDR da VPC
- `availability_zones`: Lista de AZs para distribuição

## 🏷️ Tags Automáticas

Todos os recursos são automaticamente taggados com:
- `Environment`: Ambiente atual
- `ManagedBy`: "Terraform"
- `Repository`: "infra-networking"
- `Project`: Nome do projeto

## 🔄 CI/CD com GitHub Actions

O projeto inclui um workflow automatizado para deploy da infraestrutura:

### Gatilhos de Execução

- **Branch `main`**: Deploy automático para ambiente **production**
- **Branch `homologation`**: Deploy automático para ambiente **homologation**
- **Manual**: Execução sob demanda via `workflow_dispatch`

### Configuração Necessária

Configure os seguintes secrets no repositório GitHub:
- `AWS_ACCESS_KEY_ID`: Chave de acesso da AWS
- `AWS_SECRET_ACCESS_KEY`: Chave secreta da AWS

### Processo do Pipeline

1. **Checkout** do código fonte
2. **Configuração** das credenciais AWS
3. **Setup** do Terraform versão 1.9.7
4. **Init** com backend S3 específico por ambiente
5. **Plan** para validação das mudanças
6. **Apply** automático das alterações
7. **Outputs** para capturar IDs dos recursos criados

### Estrutura de State

Os arquivos de estado são armazenados no S3 com a seguinte estrutura:
```
s3://tf-state-challenge-bucket/v4/networking/{environment}/terraform.tfstate
```

O workflow garante isolamento completo entre ambientes e deploy seguro da infraestrutura de rede.
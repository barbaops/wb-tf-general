# 📘 Módulo Terraform: Tags Padronizadas para CMDB
Este módulo garante que todos os recursos criados com Terraform ou Terragrunt tenham tags padronizadas para governança, rastreamento no CMDB e gestão de custos.

## 📌 Estrutura das Tags
Abaixo estão as tags exigidas e suas descrições:


| **Tag**              | **Descrição**  | **Obrigatória?** | **Valores Aceitos** |
|----------------------|---------------|------------------|----------------------|
| `CR` | Centro de Custo | ✅ | String |
| `team_owner` | Time responsável pelo recurso | ✅ | String |
| `risk_expose` | Risco de exposição do recurso | ✅ | `Low`, `Medium`, `High`, `Critical` |
| `project` | Nome do projeto ao qual o recurso pertence | ✅ | String |
| `system` | Nome da aplicação (EKS, ECS, EC2, etc.) | ✅ | String |
| `management_by` | Quem gerencia o recurso | ✅ | `terraform`, `crossplane`, `manual` |
| `status` | Estado do recurso | ✅ | `in_use`, `not_used`, `migration` |
| `SLA` | Acordo de SLA do recurso | ✅ | String |
| `maintenance_window` | Janela de manutenção | ✅ | Ex: `seg-sex/03:00-05:00` |
| `criticality` | Criticidade do recurso para o negócio | ✅ | `Low`, `Medium`, `High`, `Critical` |
| `created_at` | Data de criação do recurso | ✅ | Formato ISO 8601 (Gerado automaticamente) |
| `update_at` | Data da última atualização | ✅ | Formato ISO 8601 (Gerado automaticamente) |
| `repo` | Link do repositório do produto (se aplicável) | ❌ | String |
| `extra_tags` | Tags adicionais específicas do projeto | ❌ | Mapa de strings |

⚠️ **IMPORTANTE:** Se qualquer **tag obrigatória estiver vazia ou inválida**, o Terraform **interrompe a execução** com um erro.


## 📂 Estrutura do Módulo
``````
terraform-modules/
└── tags/
    ├── main.tf
    ├── variables.tf
    ├── outputs.tf
    ├── README.md
``````

---

# 🚀 Exemplos de Uso

## 🟢 Exemplo: Terraform

Dentro do seu projeto Terraform, utilize o módulo assim:

### 📌 Código Terraform

``````hcl
module "tags" {
  source             = "./terraform-modules/tags"
  cr                 = "123456"
  team_owner         = "Time de Segurança"
  risk_expose        = "High"
  project            = "Projeto Alpha"
  system             = "EKS"
  management_by      = "terraform"
  status             = "in_use"
  sla                = "99.9%"
  maintenance_window = "seg-sex/03:00-05:00"
  criticality        = "Critical"
  repo               = "https://github.com/empresa/projeto"

  extra_tags = {
    "business_unit" = "TI"
    "compliance"    = "ISO 27001"
  }
}

resource "aws_s3_bucket" "example" {
  bucket = "meu-bucket-exemplo"

  tags = module.tags.tags
}
``````

## 🟠 Exemplo: Terragrunt (Simples)
No Terragrunt, podemos chamar o módulo de forma centralizada.


### 📂 Estrutura de Pastas

``````
infra/
├── terragrunt.hcl
└── modules/
    ├── tags/
    │   ├── main.tf
    │   ├── variables.tf
    │   ├── outputs.tf
``````

### 📌 Arquivo infra/terragrunt.hcl

``````hcl
terraform {
  source = "./modules/tags"
}

inputs = {
  cr                 = "123456"
  team_owner         = "Time de Segurança"
  risk_expose        = "High"
  project            = "Projeto Alpha"
  system             = "EKS"
  management_by      = "terraform"
  status             = "in_use"
  sla                = "99.9%"
  maintenance_window = "seg-sex/03:00-05:00"
  criticality        = "Critical"
  repo               = "https://github.com/empresa/projeto"

  extra_tags = {
    "business_unit" = "TI"
    "compliance"    = "ISO 27001"
  }
}

``````

## 🟡 Exemplo: Terragrunt com Valores Reutilizáveis

Para evitar repetição e reutilizar as mesmas tags em múltiplos módulos, podemos separar os valores das tags.

### 📂 Estrutura de Pastas

``````
infra/
├── _config/
│   ├── tags.hcl
├── app1/
│   ├── terragrunt.hcl
├── app2/
│   ├── terragrunt.hcl
``````

###📌 Arquivo _config/tags.hcl

``````hcl

inputs = {
  cr                 = "123456"
  team_owner         = "Time de Segurança"
  risk_expose        = "High"
  project            = "Projeto Alpha"
  system             = "EKS"
  management_by      = "terraform"
  status             = "in_use"
  sla                = "99.9%"
  maintenance_window = "seg-sex/03:00-05:00"
  criticality        = "Critical"
  repo               = "https://github.com/empresa/projeto"

  extra_tags = {
    "business_unit" = "TI"
    "compliance"    = "ISO 27001"
  }
}
``````

### 📌 Arquivo app1/terragrunt.hcl

``````hcl
terraform {
  source = "../modules/tags"
}

include {
  path = find_in_parent_folders()
}

include "common_tags" {
  path = "${get_repo_root()}/_config/tags.hcl"
}
``````

### 📌 Arquivo app2/terragrunt.hcl
``````hcl
terraform {
  source = "../modules/tags"
}

include {
  path = find_in_parent_folders()
}

include "common_tags" {
  path = "${get_repo_root()}/_config/tags.hcl"
}
``````

Agora todas as aplicações reutilizam os valores de _config/tags.hcl, garantindo consistência e evitando duplicação de código. 🔥

## ✅ Vantagens do Módulo
✔ Garante governança: Todas as tags obrigatórias são aplicadas.
✔ Valida valores automaticamente: Evita erros de tags inválidas.
✔ Reutilizável: Pode ser usado em múltiplos projetos com Terraform e Terragrunt.
✔ Automático: Datas são geradas sem necessidade de input manual.
✔ Melhor organização: Com Terragrunt, os valores podem ser centralizados.

---

# Changelogs / Version

| **Version tag**              | **Descrição**  |
|----------------------|---------------|
| `1.0.0` | Criação do modulo e adição de tags padrões |

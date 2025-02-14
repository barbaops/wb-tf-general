variable "created_at" {
  description = "Data de criação do recurso"
  type        = string
  default     = timestamp()
}

variable "updated_at" {
  description = "Data da última atualização do recurso"
  type        = string
  default     = timestamp()
}

# Variables required
variable "cr" {
  description = "Centro de Custo"
  type        = string
}

variable "team_owner" {
  description = "Time responsável"
  type        = string
}

variable "risk_expose" {
  description = "Risco de Exposição (Low, Medium, High, Critical)"
  type        = string

  validation {
    condition     = contains(["Low", "Medium", "High", "Critical"], var.risk_expose)
    error_message = "O campo 'risk_expose' deve ser um dos valores: Low, Medium, High, Critical."
  }
}

variable "project" {
  description = "Nome do projeto"
  type        = string
}

variable "system" {
  description = "Nome da aplicação (EKS, ECS, EC2, etc.)"
  type        = string
}

variable "management_by" {
  description = "Recurso que faz a gerência (terraform, crossplane, manual)"
  type        = string
}

variable "status" {
  description = "Estado do recurso (in_use, not_used, migration)"
  type        = string
}

variable "sla" {
  description = "Acordo de SLA"
  type        = string
}

variable "maintenance_window" {
  description = "Janela de manutenção (ex: seg-sex/03:00-05:00)"
  type        = string
}

variable "criticality" {
  description = "Criticidade do recurso para o negócio (Low, Medium, High, Critical)"
  type        = string

  validation {
    condition     = contains(["Low", "Medium", "High", "Critical"], var.criticality)
    error_message = "O campo 'criticality' deve ser um dos valores: Low, Medium, High, Critical."
  }
}

# Not required
variable "repo" {
  description = "Link do repositório do produto (se criado por automação)"
  type        = string
  default     = ""
}

variable "extra_tags" {
  description = "Tags adicionais opcionais"
  type        = map(string)
  default     = {}
}

locals {
  required_tags = {
    "CR"                 = var.cr
    "team_owner"         = var.team_owner
    "risk_expose"        = var.risk_expose
    "project"            = var.project
    "system"             = var.system
    "management_by"      = var.management_by
    "status"             = var.status
    "SLA"                = var.sla
    "maintenance_window" = var.maintenance_window
    "criticality"        = var.criticality
  }
  missing_tags = [for key, value in local.required_tags : key if value == ""]
}

resource "null_resource" "validate_tags" {
  count = length(local.missing_tags) > 0 ? 1 : 0

  provisioner "local-exec" {
    command = "echo 'Erro: As seguintes tags estão vazias: ${join(", ", local.missing_tags)}' && exit 1"
  }
}

output "tags" {
  value = merge(
    local.required_tags,
    {
      "created_at" = var.created_at
      "update_at"  = var.updated_at
      "repo"       = var.repo
    },
    var.extra_tags
  )
}

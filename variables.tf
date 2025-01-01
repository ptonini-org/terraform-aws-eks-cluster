variable "name" {}

variable "region" {}

variable "kubernetes_version" {
  default  = "1.28"
  nullable = false
}

variable "security_group" {
  type = object({
    enabled = optional(bool, true)
    vpc = optional(object({
      id = string
    }))
    ingress_rules = optional(map(object({
      from_port        = number
      to_port          = optional(number)
      protocol         = optional(string)
      cidr_blocks      = optional(set(string))
      ipv6_cidr_blocks = optional(set(string))
      prefix_list_ids  = optional(set(string))
      security_groups  = optional(set(string))
    })), {})
  })
  default  = { enabled = false }
  nullable = false
}

variable "vpc_config" {
  type = object({
    subnet_ids              = set(string)
    endpoint_private_access = optional(bool, true)
    endpoint_public_access  = optional(bool, false)
    public_access_cidrs     = optional(set(string))
    security_group_ids      = optional(set(string))
  })
}

variable "node_groups" {
  type = map(object({
    ssh_key                = string
    subnet_ids             = list(string)
    instance_type          = string
    desired_size           = number
    max_size               = optional(number)
    min_size               = optional(number)
    labels                 = optional(map(string))
    user_data              = optional(string)
    vpc_security_group_ids = optional(list(string))
    tags                   = optional(map(any))
    taints = optional(map(object({
      effect = string
      key    = string
    })))
  }))
  default  = {}
  nullable = false
}

variable "addons" {
  type     = set(string)
  default  = []
  nullable = false
}

variable "sa_roles" {
  type = map(object({
    namespace   = string
    policy_arns = set(string)
  }))
  default  = {}
  nullable = false
}

variable "openid_connect_provider" {
  type = object({
    client_id_list  = set(string)
    thumbprint_list = set(string)
  })
  default = null
}

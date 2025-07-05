[![Terraform](https://github.com/1cepeak/terraform-playbook/actions/workflows/terraform.yml/badge.svg)](https://github.com/1cepeak/terraform-playbook/actions/workflows/terraform.yml)

# terraform-playbook

Описание инфраструктуры (IaC) с помощью Terraform для серверов управляемых Proxmox VE

## Первоначальная настройка

Добавить `PM_API_TOKEN_ID` и `PM_API_TOKEN_SECRET` в переменные окружения. Предварительно создать API токен в инстансе Proxmox VE.

```shell
export PM_API_TOKEN_ID="your_pve_api_token_id"
export PM_API_TOKEN_SECRET="your_pve_api_secret_key"
```

```shell
terraform init
```

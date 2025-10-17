[![Terraform](https://github.com/1cepeak/terraform-playbook/actions/workflows/terraform.yml/badge.svg)](https://github.com/1cepeak/terraform-playbook/actions/workflows/terraform.yml)

# terraform-playbook

Описание инфраструктуры (IaC) с помощью Terraform для серверов управляемых Proxmox VE.

## Параметры конфигурации

| Переменная                 | Пример значения                      | Описание                                                         |
|----------------------------|--------------------------------------|------------------------------------------------------------------|
| `PROXMOX_ENDPOINT`         | http://127.0.0.1:8006                | Адрес инстанса Proxmox VE                                        |
| `PROXMOX_USER`             | root                                 | Имя пользователя в реалме Linux PAM                              |
| `PROXMOX_API_TOKEN_ID`     | root-token                           | Идентификатор токена, пренадлежащий пользователю `PROXMOX_USER`  |
| `PROXMOX_API_TOKEN_SECRET` | XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX | Секретный ключ токена, пренадлежащий пользователю `PROXMOX_USER` |
| `PROXMOX_NODE`             | node0                                | Название инстанса Prxmox VE                                      |
| `PROXMOX_PRIVATE_KEY_PATH` | ~/.ssh/id_rsa                        | Путь до приватного ключа                                         |
| `MINIO_ENDPOINT`           | http://127.0.0.1:9000                | Адрес инстанса MinIO                                             |
| `MINIO_SECRET_KEY`         | secret@key                           | Секретный ключ для подключения к REST API MinIO                  |
| `MINIO_USER`               | root                                 | Пользователь MinIO, которому пренадлежита бакеты                 |
| `MINIO_BUCKETS`            | [ "bucket-1", "bucket-2" ]           | Список бакетов MinIO, которые будут созданы                      |

## Инициализация Terraform

Чтобы иницализировать Terraform CLI, предварительно создайте 2 конфигурационных файла:
- `core/s3-backend.config` - настройки подключения к s3 backend для сохранения `terraform.tfstate`
- `core/terraform.tfvars` - остальные настройки

Так же, в директории `core/` примеры файлов конфигурации.

> См. описание всех конфигурационных параметров выше.

#### Пример `core/terraform.tfvars`:

```ini
PROXMOX_ENDPOINT         = "https://127.0.0.2:8006"
PROXMOX_NODE             = "pve"
PROXMOX_USER             = "terraform"
PROXMOX_API_TOKEN_ID     = "your_token_id"
PROXMOX_API_TOKEN_SECRET = "your_token_secret"
PROXMOX_PRIVATE_KEY_PATH = "path_to_private_key"

MINIO_USER    = "minio_user"
MINIO_BUCKETS = ["terraform"]
```

#### Пример `core/s3-backend.config`:

```ini
endpoints = {
  s3 = "http://127.0.0.1:9000"
}

access_key = "your_access_key"
secret_key = "your_secret_key"
```

После создания всех необходимых конфигурационных файлов, запустите команду инициализации Terraform CLI.

```shell
terraform init -backend-config=core/s3-backend.config
```

## Использование

```shell
terraform fmt -check # проверка формата
terraform plan # проверка изменений
terraform apply -input=false # применение изменений
```

При применении изменений к инфраструктуре, придерживайтесь этих правил:
1. Используйте `terraform fmt -check` для проверки корректности форматирования файлов Terraform
2. Используйте `terraform plan` для предварительного просмотра изменений, которые будут применены к инфраструктуре
3. Не используйте `terraform apply` с флагом `-auto-approve` (за исключением если команда выполняется в процессе `CI/CD`)

# Lesson-5 Terraform AWS Infrastructure

Цей проєкт демонструє створення інфраструктури на AWS за допомогою Terraform.  
Він включає налаштування стейтів у S3 з блокуванням через DynamoDB, VPC з приватними та публічними підмережами та ECR для зберігання Docker-образів.

## Структура проєкту
lesson-5/
├── main.tf                 # Головний файл конфігурації, підключає модулі
├── backend.tf              # Налаштування віддаленого бекенду (S3 + DynamoDB)
├── outputs.tf              # Вивід (outputs) ресурсів інфраструктури
├── terraform.tfstate       # Локальний файл стану Terraform
├── terraform.tfstate.backup # Резервна копія файлу стану
├── README.md               # Документація проєкту
└── modules/                # Директорія з модулями
    ├── s3-backend/         # Модуль для бекенду Terraform
    │   ├── s3.tf           # Створення S3 бакета для зберігання стану
    │   ├── dynamodb.tf     # Створення таблиці DynamoDB для блокувань
    │   ├── variables.tf    # Змінні модуля
    │   └── outputs.tf      # Вивід модуля
    ├── vpc/                # Модуль мережевої інфраструктури
    │   ├── vpc.tf          # Створення VPC, підмереж та Internet Gateway
    │   ├── routes.tf       # Налаштування таблиць маршрутизації
    │   ├── variables.tf    # Змінні модуля
    │   └── outputs.tf      # Вивід модуля
    └── ecr/                # Модуль для контейнерного реєстру
        ├── ecr.tf          # Створення репозиторію ECR та політик
        ├── variables.tf    # Змінні модуля
        └── outputs.tf      # Вивід модуля


## Модулі

- **s3-backend**: створює S3-бакет для Terraform state з версіюванням та DynamoDB таблицю для блокування.
- **vpc**: створює VPC, 3 публічні та 3 приватні підмережі, Internet Gateway, NAT Gateway і маршрутизацію.
- **ecr**: створює ECR репозиторій з автоматичним скануванням образів та політикою доступу.

## Команди Terraform

```bash
terraform init     # Ініціалізація Terraform та бекенду
terraform plan     # Перевірка плану створення ресурсів
terraform apply    # Створення ресурсів
terraform destroy  # Видалення ресурсів

Опис модулів

1. Модуль s3-backend

Призначення: віддалене зберігання стану Terraform.

Створює:

S3 бакет з версіонуванням і шифруванням

DynamoDB таблицю для блокування стану (state locking)

Вхідні параметри:

bucket_name — назва S3 бакета

table_name — назва таблиці DynamoDB

Вивід:

s3_bucket_name — ім'я бакета

dynamodb_table_name — ім'я таблиці


2. Модуль vpc

Призначення: створення мережевої інфраструктури.

Створює:

VPC з CIDR блоком

3 публічні та 3 приватні підмережі

Internet Gateway для публічних підмереж

NAT Gateway для приватних підмереж

Route Tables для маршрутизації

Вхідні параметри:

vpc_cidr_block, public_subnets, private_subnets, availability_zones, vpc_name

Вивід:

vpc_id, public_subnets, private_subnets, internet_gateway_id, nat_gateway_id, nat_gateway_public_ip


3. Модуль ecr

Призначення: приватний реєстр Docker-образів.

Створює:

ECR репозиторій з тегами MUTABLE

Автоматичне сканування образів

Шифрування AES256

Політику доступу (pull/push)

Вхідні параметри:

ecr_name, scan_on_push

Вивід:

ecr_repository_url, ecr_repository_arn, ecr_repository_name


Налаштування бекенду

У backend.tf після створення S3 бакета та DynamoDB таблиці розкоментуйте конфігурацію:

terraform {
  backend "s3" {
    bucket         = "ваш-бакет"
    key            = "lesson-5/terraform.tfstate"
    region         = "eu-central-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}


І виконайте:

terraform init -migrate-state


Вивід проєкту

Після terraform apply можна переглянути:

s3_bucket_name — S3 бакет для стану

dynamodb_table_name — таблиця для блокувань

vpc_id, public_subnets, private_subnets, internet_gateway_id, nat_gateway_id, nat_gateway_public_ip

ecr_repository_url, ecr_repository_arn, ecr_repository_name


Додаткові команди
terraform show      # Перегляд поточного стану
terraform output    # Вивід outputs
terraform fmt       # Форматування конфігурації
terraform validate  # Валідація конфігурації

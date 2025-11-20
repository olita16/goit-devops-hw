# Lesson-5 Terraform AWS Infrastructure

Цей проєкт демонструє створення інфраструктури на AWS за допомогою Terraform.  
Він включає налаштування стейтів у S3 з блокуванням через DynamoDB, VPC з приватними та публічними підмережами та ECR для зберігання Docker-образів.

## Структура проєкту

lesson-5/
│
├── main.tf                  # Головний файл для підключення модулів
├── backend.tf               # Налаштування бекенду для стейтів (S3 + DynamoDB)
├── outputs.tf               # Загальне виведення ресурсів
│
├── modules/                 # Каталог з усіма модулями
│   │
│   ├── s3-backend/          # Модуль для S3 та DynamoDB
│   │   ├── s3.tf            # Створення S3-бакета
│   │   ├── dynamodb.tf      # Створення DynamoDB
│   │   ├── variables.tf     # Змінні для S3
│   │   └── outputs.tf       # Виведення інформації про S3 та DynamoDB
│   │
│   ├── vpc/                 # Модуль для VPC
│   │   ├── vpc.tf           # Створення VPC, підмереж, Internet Gateway
│   │   ├── routes.tf        # Налаштування маршрутизації
│   │   ├── variables.tf     # Змінні для VPC
│   │   └── outputs.tf       # Виведення інформації про VPC
│   │
│   └── ecr/                 # Модуль для ECR
│       ├── ecr.tf           # Створення ECR репозиторію
│       ├── variables.tf     # Змінні для ECR
│       └── outputs.tf       # Виведення URL репозиторію ECR
│
└── README.md                # Документація проєкту


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

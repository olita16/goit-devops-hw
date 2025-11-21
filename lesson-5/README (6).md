# Terraform Infrastructure

Цей проєкт демонструє базову інфраструктуру AWS, розгорнуту за допомогою
Terraform з використанням модульної архітектури.

## Структура проєкту

Основна директорія: **lesson-5/**\
У ній знаходяться головні файли Terraform:

-   **main.tf** -- головний файл конфігурації Terraform, де
    підключаються всі модулі.\
-   **backend.tf** -- конфігурація віддаленого бекенду для зберігання
    Terraform state у S3 та блокування через DynamoDB.\
-   **outputs.tf** -- файл з вихідними даними після застосування
    конфігурації.\
-   **README.md** -- документація проєкту.

## Модулі проєкту

Директорія `modules/` містить такі модулі:

### `s3-backend/`

Модуль для інфраструктури Terraform backend.

**Файли:** - `s3.tf` -- створення S3-бакета.\
- `dynamodb.tf` -- створення DynamoDB таблиці для блокування стану.\
- `variables.tf` -- змінні модуля.\
- `outputs.tf` -- вихідні параметри.

### `vpc/`

Модуль для мережевої інфраструктури AWS.

**Файли:** - `vpc.tf` -- створення VPC, публічних і приватних підмереж
та Internet Gateway.\
- `routes.tf` -- налаштування маршрутизації.\
- `variables.tf` -- змінні модуля.\
- `outputs.tf` -- вихідні параметри.

### `ecr/`

Модуль для створення приватного контейнерного реєстру Amazon ECR.

**Файли:** - `ecr.tf` -- створення репозиторію ECR.\
- `variables.tf` -- змінні модуля.\
- `outputs.tf` -- вихідні дані.

## Команди для роботи з Terraform

### 1. Ініціалізація

``` bash
terraform init
```

### 2. Перегляд плану

``` bash
terraform plan
```

### 3. Застосування змін

``` bash
terraform apply
```

### 4. Видалення інфраструктури

``` bash
terraform destroy
```

## Детальний опис модулів

### Модуль `s3-backend`

**Призначення:** зберігання Terraform state у хмарі.

**Створює:** - S3 бакет\
- Версіонування\
- Контроль власності\
- SSE шифрування\
- DynamoDB таблицю для state locking

**Вхідні параметри:** - `bucket_name`\
- `table_name`

**Виводи:** - `s3_bucket_name`\
- `dynamodb_table_name`

### Модуль `vpc`

**Призначення:** створення ізольованої мережі в AWS.

**Створює:** - VPC\
- 3 публічні підмережі\
- 3 приватні підмережі\
- Internet Gateway\
- Маршрутизацію

**Параметри:** - `vpc_cidr_block`\
- `public_subnets`\
- `private_subnets`\
- `availability_zones`\
- `vpc_name`

### Модуль `ecr`

**Призначення:** приватний Docker-реєстр AWS.

**Створює:** - Репозиторій ECR\
- Сканування образів\
- Мутовані теги\
- Шифрування

**Параметри:** - `ecr_name`\
- `scan_on_push`

**Виводи:** - `ecr_repository_url`\
- `ecr_repository_arn`\
- `ecr_repository_name`

## Налаштування бекенду (S3 + DynamoDB)

Після створення ресурсів розкоментуйте в `backend.tf`:

``` hcl
terraform {
  backend "s3" {
    bucket         = "terraform-state-bucket-goithw-rybak"
    key            = "lesson-5/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-locks"
    encrypt        = true
    profile        = "goithw"
  }
}
```

Переміщення локального стейту у бекенд:

``` bash
terraform init -migrate-state
```

## Вивід після `terraform apply`

-   `s3_bucket_name`\
-   `dynamodb_table_name`\
-   `ecr_repository_url`\
-   `ecr_repository_arn`\
-   `ecr_repository_name`

## Додаткові команди

``` bash
terraform show
terraform output
terraform fmt
terraform validate
```

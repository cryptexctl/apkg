# APKG

APKG — это пакетный менеджер для macOS, вдохновленный BSD pkg. Он позволяет устанавливать, удалять, обновлять и управлять пакетами в системе.

## Требования

- macOS 13.0 или новее
- Xcode Command Line Tools
- Swift 5.9 или новее

## Установка

1. Клонируйте репозиторий:
   ```sh
   git clone https://github.com/cryptexctl/apkg.git
   cd apkg
   ```

2. Соберите и установите:
   ```sh
   swift build -c release
   sudo cp .build/release/apkg /usr/local/bin/
   ```

## Использование

APKG поддерживает следующие команды:

- `apkg install <package>` — установка пакета
- `apkg remove <package>` — удаление пакета
- `apkg list` — список установленных пакетов
- `apkg search <query>` — поиск пакетов
- `apkg info <package>` — информация о пакете
- `apkg update` — обновление пакетов

**Примечание:** Все команды требуют прав суперпользователя (sudo).

## Структура проекта

- `Sources/apkg/main.swift` — точка входа
- `Sources/apkg/APKG.swift` — основной класс
- `Sources/apkg/Package.swift` — класс для работы с пакетами

## Лицензия

BSD 2-Clause License 
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

3. Зарегистрируйте в системе:
   ```sh
   sudo apkg register
   ```

4. Установите агент обновления (опционально):
   ```sh
   sudo apkg install-agent
   ```

## Использование

APKG поддерживает следующие команды:

- `apkg install <package>` — установка пакета
- `apkg remove <package>` — удаление пакета
- `apkg list` — список установленных пакетов
- `apkg search <query>` — поиск пакетов
- `apkg info <package>` — информация о пакете
- `apkg update` — обновление пакетов
- `apkg register` — регистрация в системе
- `apkg unregister` — удаление из системы
- `apkg install-agent` — установка агента обновления
- `apkg uninstall-agent` — удаление агента обновления
- `apkg help` — показать справку

**Примечание:** Все команды требуют прав суперпользователя (sudo).

## Интеграция с macOS

APKG интегрируется с macOS следующими способами:

1. Регистрация в системе через pkgutil
2. Автоматическое обновление через LaunchAgent
3. Поддержка локализации (русский и английский языки)
4. Поддержка ARM64 и x86_64 архитектур

## Структура проекта

- `Sources/apkg/main.swift` — точка входа
- `Sources/apkg/APKG.swift` — основной класс
- `Sources/apkg/Package.swift` — класс для работы с пакетами
- `Sources/apkg/Localization.swift` — локализация
- `Sources/apkg/macOSIntegration.swift` — интеграция с macOS
- `Sources/apkg/ru.lproj/Localizable.strings` — русская локализация

## Лицензия

BSD 2-Clause License 
APKG - пакетный менеджер для macOS

Требования:
- macOS 13.0 или новее
- Xcode Command Line Tools
- Swift 5.9 или новее

Установка:
1. Клонировать репозиторий:
   git clone https://github.com/cryptexctl/apkg.git
   cd apkg

2. Собрать и установить:
   swift build -c release
   sudo cp .build/release/apkg /usr/local/bin/

3. Зарегистрировать в системе:
   sudo apkg register

4. Установить агент обновления (опционально):
   sudo apkg install-agent

Использование:
- apkg install <пакет> - Установка пакета
- apkg remove <пакет> - Удаление пакета
- apkg list - Список установленных пакетов
- apkg search <запрос> - Поиск пакетов
- apkg info <пакет> - Информация о пакете
- apkg update - Обновление пакетов
- apkg register - Регистрация в системе
- apkg unregister - Удаление из системы
- apkg install-agent - Установка агента обновления
- apkg uninstall-agent - Удаление агента обновления
- apkg help - Показать справку

Примечание: Все команды требуют прав суперпользователя (sudo).

Интеграция с macOS:
1. Регистрация в системе через pkgutil
2. Автоматическое обновление через LaunchAgent
3. Поддержка локализации (русский и английский языки)
4. Поддержка ARM64 и x86_64 архитектур

Структура проекта:
- Sources/apkg/main.swift - Точка входа
- Sources/apkg/APKG.swift - Основной класс
- Sources/apkg/Package.swift - Класс для работы с пакетами
- Sources/apkg/Localization.swift - Локализация
- Sources/apkg/macOSIntegration.swift - Интеграция с macOS
- Sources/apkg/Resources/en.lproj/Localizable.strings - Английская локализация
- Sources/apkg/Resources/ru.lproj/Localizable.strings - Русская локализация

Лицензия: BSD 2-Clause License 
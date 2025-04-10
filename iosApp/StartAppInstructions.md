# Начальный запуск KMM

- Импортировать репозиторий [MobileUp-KMM-Template](https://github.com/MobileUpLLC/MobileUp-KMM-Template.git)
- Установить [Android Studio](https://developer.android.com/studio?hl=ru)
- Установить [Java](https://www.java.com/ru/)
- Установить [Java JDK 21](https://www.oracle.com/java/technologies/downloads/#jdk21-mac)
- Запустить Android Studio и дождаться окончания загрузки импорта проекта (снизу справа панель)
- Установить плагин "Kotlin Multiplatform" из Android Studio -> Settings -> Plugins
- Перезапустить Android Studio
- Запустить Xcode по файлу проекта шаблона

## FAQ
- Flow - это издатель (асинхронный поток) который не хранит последнее значение как PassthroughSubject.
- StateFlow - это издатель (асинхронный поток) данных как CurrentValueSubject в Combine.
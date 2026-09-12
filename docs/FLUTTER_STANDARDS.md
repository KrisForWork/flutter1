# Стандарты, best practices и паттерны Flutter  
## Для практической работы №2 (типы тестирования)

**Статус:** правила кодирования до старта реализации  
**Принцип:** простой, понятный, чистый код; без overengineering  
**Приложение:** справочник (каталог записей), UI на **русском**

### Зафиксировано

- автотесты: **unit + widget** (без integration)
- нагрузка: **только клиент**
- UI: фильтры + отдельный экран «Нагрузка»

---

## 1. Общие принципы

1. **Простота важнее «умности».** Хватает `ChangeNotifier` — не тащим Bloc/Riverpod.  
2. **Один файл — одна ответственность.**  
3. **Логика тестируется без UI.** Правила фильтрации и валидации — в чистых классах.  
4. **UI тонкий.** Виджеты показывают состояние и вызывают контроллер.  
5. **Имена в коде — английские** (`DirectoryEntry`, `addEntry`), **тексты UI — русские**.  
6. **Нет мёртвого кода.**  
7. **Для widget-тестов — стабильные `Key`.**  
8. Без лишних зависимостей.

---

## 2. Стиль кода Dart / Flutter

### 2.1. Форматирование и анализ

- `dart format .` перед сдачей  
- `flutter analyze` без ошибок  
- `flutter_lints`  
- одинарные кавычки `'...'`  
- trailing commas в многострочных списках  

### 2.2. Именование

| Что | Стиль | Пример |
|-----|-------|--------|
| Файлы | snake_case | `directory_entry.dart` |
| Классы | PascalCase | `DirectoryEntry` |
| Методы | camelCase | `toggleFavorite` |
| Приватное | `_` | `_entries` |
| Keys | понятные строки | `Key('entry_search_field')` |

### 2.3. Виджеты

- `const` где возможно  
- `StatelessWidget` по умолчанию  
- не класть логику в `build()`  
- длинный UI дробить на виджеты (`FilterBar`, `EntryTile`, `AddEntryForm`)  
- списки только через `ListView.builder`

### 2.4. Состояние

```text
UI (widgets) → DirectoryController (ChangeNotifier) → DirectoryRepository
```

- **Repository** — данные, фильтры, генерация (unit / load)  
- **Controller** — выбранные фильтры, поиск, `notifyListeners()`  
- **Widgets** — подписка на controller, русский UI  

Контроллер создаём в `app` и передаём вниз (без глобального синглтона).

### 2.5. Модели

- поля `final`  
- `copyWith`  
- валидация `title` в одном месте (repository)  
- id: счётчик или инжектируемый generator (для стабильных тестов)

### 2.6. Ошибки и пустые данные

- пустое название → не добавляем + понятное русское сообщение  
- пустой список → «Нет записей»  
- нет «пустых» try/catch

### 2.7. Не используем без нужды

- get_it / DI-фреймворки  
- сложный роутинг  
- БД / SharedPreferences  
- freezed / json_serializable  
- integration_test  
- лишние UI-пакеты  

---

## 3. Паттерны

### 3.1. Separation of Concerns  
UI ≠ логика справочника.

### 3.2. Repository  
Единая точка: записи, фильтр, поиск, seed, generate, clear.

### 3.3. Observer (`ChangeNotifier`)  
UI слушает изменения фильтров и списка.

### 3.4. Composition  
Экран = набор маленьких виджетов, не «божественный» State.

### 3.5. Test Pyramid (урезанная под задание)

```text
      /\
     /  \   widget (средне)
    /----\
   /      \ unit (много)
  ----------
```

Integration **не делаем**.

### 3.6. AAA (Arrange–Act–Assert)

```dart
test('фильтр по категории оставляет только нужные записи', () {
  // Arrange
  final repo = DirectoryRepository();
  repo.add(title: 'Unit', description: '...', category: 'Тестирование');
  repo.add(title: 'Widget', description: '...', category: 'Flutter');

  // Act
  final result = repo.filter(category: 'Тестирование');

  // Assert
  expect(result, hasLength(1));
  expect(result.single.title, 'Unit');
});
```

### 3.7. Given–When–Then  
Для чек-листа ручного тестирования.

### 3.8. Лёгкий Page Object / Robot (по желанию)

```dart
class DirectoryRobot {
  DirectoryRobot(this.tester);
  final WidgetTester tester;

  Future<void> search(String query) async { /* ... */ }
  Future<void> selectCategory(String name) async { /* ... */ }
}
```

---

## 4. Best practices по типам тестирования

### 4.1. Ручное

- чек-лист с приоритетами (P0 smoke / P1 core / P2 edge)  
- фильтры и поиск — отдельные кейсы + комбинации  
- шаблон баг-репорта  
- артефакты: `docs/manual/...`

### 4.2. Авто (unit + widget)

**Unit:** repository — add, remove, favorite, filter, search, generate, clear.  
**Widget:** список, пустое состояние, поиск, фильтр категории/избранного, форма добавления.  

Имена тестов на русском или английском — единообразно; предпочтительно понятные русские описания в строке `test('...')`.

**Не делаем:** integration_test.

### 4.3. Нагрузка (клиент)

- экран «Нагрузка» + `Stopwatch`  
- N = 100 / 1_000 / 10_000  
- `test/load/` для замера логики  
- `ListView.builder`  
- в отчёте явно: это клиентская нагрузка, не серверный JMeter/k6  

---

## 5. Testable UI

Ключи (примеры):

```dart
static const searchFieldKey = Key('entry_search_field');
static const addButtonKey = Key('entry_add_button');
static const listKey = Key('entry_list');
static const favoritesFilterKey = Key('filter_favorites');
static const loadGenerateButtonKey = Key('load_generate_button');
Key entryTileKey(String id) => Key('entry_tile_$id');
```

Тексты UI стабильные, чтобы `find.text('Нет записей')` не ломался от случайных правок формулировок.

---

## 6. Список при нагрузке

| Плохо | Хорошо |
|-------|--------|
| `Column` + map на 10k | `ListView.builder` |
| тяжёлые карточки | простой `ListTile` / лёгкий tile |
| фильтр в `build` много раз без нужды | метод repository / кэш результата |

---

## 7. Документирование

- краткий `///` у неочевидных публичных API  
- README / отчёт: как запустить приложение и `flutter test`

---

## 8. Чек-лист перед сдачей

- [ ] `dart format .`  
- [ ] `flutter analyze` — чисто  
- [ ] `flutter test` — зелёный  
- [ ] UI на русском  
- [ ] фильтры + экран «Нагрузка» работают  
- [ ] документы manual / auto / load / REPORT заполнены  
- [ ] нет integration_test  

---

## 9. Стек зависимостей

**runtime:** Flutter Material  
**dev:** `flutter_test`, `flutter_lints`  

Больше ничего не добавляем без отдельного решения.

---

## 10. Структура итогового отчёта (`docs/REPORT.md`)

Для каждого типа (ручное / авто / нагрузка):

1. Определение  
2. Цель  
3. Инструменты и артефакты  
4. Как применяли на справочнике  
5. Результаты  
6. Плюсы / минусы  
7. Когда выбирать  

Плюс сравнительная таблица в конце.

---

## 11. Ожидание

После финального «ок» реализация следует этому файлу и `PLAN_PRACTICAL_02.md`.

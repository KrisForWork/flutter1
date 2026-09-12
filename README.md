# ТестВик (проект `test1`)

Flutter-приложение — учебный справочник статей. Практическая работа по освоению базовых компонентов Flutter: виджеты, экраны, состояние, assets.

---

## 1. Кратко суть

Приложение показывает каталог статей с категориями, поиском и избранным. Можно открыть детали статьи, добавить запись, удалить, перейти на экран клиентской нагрузки (генерация N записей и замер фильтра).

Данные статей и тексты UI загружаются из `assets/`. Логика списка хранится в памяти (`DirectoryRepository`), экраны ходят к ней через `DirectoryController`.

**Поток данных:**

```text
assets (JSON) → Repository → Controller → UI (экраны и виджеты)
```

---

## 2. Дерево виджетов

### Старт

```text
main()
  └─ DirectoryApp                    (app.dart)
       └─ MaterialApp
            └─ DirectoryListPage     (стартовый home)
```

### Главный экран — `DirectoryListPage`

```text
DirectoryListPage
└─ Scaffold
   ├─ AppBar
   │    └─ IconButton → LoadPage
   ├─ body: Column
   │    ├─ TextField                 (поиск)
   │    ├─ FilterBar                 (категории + избранное)
   │    ├─ Text                      (счётчики)
   │    └─ ListView
   │         └─ EntryTile × N        (строка списка)
   ├─ FloatingActionButton → экран добавления
   └─ StudentFooter
```

### Экраны поверх главного (`Navigator.push`)

```text
EntryDetailsPage
└─ Scaffold
   ├─ AppBar (избранное, удалить)
   ├─ body: ListView
   │    ├─ Row: текст слева + Image справа
   │    ├─ описание, Chip категории
   │    ├─ пункты (•)
   │    └─ подробное описание
   └─ StudentFooter

_AddEntryRoute
└─ Scaffold
   ├─ AppBar
   ├─ body: AddEntryForm
   └─ StudentFooter

LoadPage
└─ Scaffold
   ├─ AppBar
   ├─ body: ListView (кнопки N, generate / clear / filter, результат)
   └─ StudentFooter
```

---

## 3. Зависимости друг от друга

### Логика (кто кого вызывает)

```text
Экраны UI
    ↓ методы (add, filter, toggleFavorite, generate…)
DirectoryController
    ↓ хранит и вызывает
DirectoryRepository
    ↓ элементы списка
DirectoryEntry

AppTexts / ArticleAssetsLoader  — читают assets, отдают строки и статьи
```

| Кто | Зависит от | Зачем |
|-----|------------|--------|
| `main.dart` | `AppTexts`, `DirectoryController`, `DirectoryApp` | загрузка и запуск |
| `DirectoryApp` | `DirectoryListPage`, `AppTexts` | оболочка приложения |
| `DirectoryListPage` | `Controller`, `FilterBar`, `EntryTile`, `StudentFooter`, детали / нагрузка / форма | главный экран |
| `EntryDetailsPage` | `Controller`, `StudentFooter` | просмотр статьи |
| `LoadPage` | `Controller`, `StudentFooter` | нагрузка |
| `FilterBar` | `AppTexts`, колбэки списка | фильтры |
| `EntryTile` | `DirectoryEntry` | одна строка |
| `AddEntryForm` | `AppTexts`, колбэк `onSubmit` | добавление |
| `StudentFooter` | `AppTexts` | ФИО / группа |
| `DirectoryController` | `DirectoryRepository`, `AppTexts` | состояние UI |
| `DirectoryRepository` | `DirectoryEntry`, `ArticleAssetsLoader` | данные |
| `ArticleAssetsLoader` | JSON в `assets/articles/` | seed статей |

Экраны **не** читают JSON напрямую и **не** правят список в обход controller.

### Переходы UI

| Откуда | Куда | Как |
|--------|------|-----|
| `DirectoryListPage` | `EntryDetailsPage` | тап по `EntryTile` |
| `DirectoryListPage` | `_AddEntryRoute` + `AddEntryForm` | FAB |
| `DirectoryListPage` | `LoadPage` | кнопка в AppBar |

---

## 4. Структура проекта и файлы

```text
test1/
├── lib/                          # код приложения
│   ├── main.dart                 # точка входа, load + runApp
│   ├── app.dart                  # DirectoryApp → MaterialApp
│   ├── models/
│   │   ├── directory_entry.dart  # модель статьи
│   │   └── student_profile.dart  # ФИО, группа, пути картинок
│   ├── data/
│   │   ├── app_texts.dart        # строки UI из ui.json + категории
│   │   ├── article_assets_loader.dart  # загрузка статей из JSON
│   │   └── directory_repository.dart   # хранилище в памяти
│   ├── state/
│   │   └── directory_controller.dart   # фильтры, команды, notifyListeners
│   └── ui/
│       ├── directory_list_page.dart    # главный список
│       ├── entry_details_page.dart     # детали статьи
│       ├── load_page.dart              # экран нагрузки
│       ├── widget_keys.dart            # Key для widget-тестов
│       └── widgets/
│           ├── filter_bar.dart         # чипы категорий / избранное
│           ├── entry_tile.dart         # элемент списка
│           ├── add_entry_form.dart     # форма добавления
│           └── student_footer.dart     # подвал с ФИО
│
├── assets/
│   ├── texts/ui.json             # все подписи интерфейса
│   ├── articles/
│   │   ├── index.json            # порядок файлов статей
│   │   └── *.json                # одна статья = один файл
│   └── images/                   # profile + иллюстрации статей
│
├── test/
│   ├── helpers/test_assets.dart
│   ├── unit/                     # модель, repository, controller
│   ├── widget/                   # экраны и FilterBar
│   └── load/                     # замеры generate/filter
│
├── docs/                         # план, отчёт, чек-листы, нагрузка
├── android/ ios/ web/ …          # платформенные оболочки Flutter
├── pubspec.yaml                  # зависимости и assets
└── README.md                     # этот файл
```

### Назначение файлов `lib/` (кратко)

| Файл | Отвечает за |
|------|-------------|
| `main.dart` | инициализация, загрузка текстов и статей, `runApp` |
| `app.dart` | тема, `MaterialApp`, стартовый экран |
| `directory_entry.dart` | поля статьи (title, body, points, …) |
| `student_profile.dart` | константы автора и `ArticleImages` |
| `app_texts.dart` | строки UI + `DirectoryCategories` |
| `article_assets_loader.dart` | чтение `assets/articles/*.json` |
| `directory_repository.dart` | add / remove / filter / generate / seed |
| `directory_controller.dart` | связка UI ↔ repository, кэш фильтра |
| `directory_list_page.dart` | список, поиск, переходы |
| `entry_details_page.dart` | страница статьи |
| `load_page.dart` | генерация и замеры |
| `filter_bar.dart` | горизонтальный скролл тегов |
| `entry_tile.dart` | строка списка |
| `add_entry_form.dart` | форма новой записи |
| `student_footer.dart` | ФИО и группа |
| `widget_keys.dart` | стабильные ключи для тестов |

# Практическая работа. Drift, Repository и DI

## Цель работы

Заменить моковый список на локальную SQLite-базу Drift. Доступ к пунктам вынести в репозиторий. Базу, репозиторий и BLoC создавать через DI-контейнер GetIt + Injectable, без ручного `new` этих объектов в UI.

## Структура проекта

```text
lib/
  data/
    testing_data.dart        — начальные записи и тексты заголовков
    app_database.dart        — таблица, миграция, заполнение
    app_database.g.dart      — код Drift, его пишет build_runner
    testing_repository.dart  — репозиторий
  di/
    injection.dart           — контейнер GetIt
    injection.config.dart    — регистрация зависимостей, её пишет build_runner
  bloc/
    home_bloc.dart           — читает список через репозиторий
  pages/
    home_page.dart           — берёт HomeBloc из getIt
    detail_page.dart         — без изменений
```

Скриншот дерева проекта в проводнике IDE вставьте сюда.

## Архитектура слоя данных

Экран по-прежнему работает с моделью `TestingType`. База и репозиторий стоят между экраном и SQLite: страница не открывает файл базы и не пишет SQL.

### Структура таблицы Drift

Таблица `TestingTypes` в `lib/data/app_database.dart`. Класс строки назван `TestingTypeRow`, чтобы не смешивать его с моделью экрана `TestingType`.

| Колонка | Тип | Смысл |
|---|---|---|
| id | integer, ключ | номер строки |
| name | text | название типа |
| short_description | text | короткий текст карточки |
| detailed_description | text | текст DetailPage |
| image | text | путь к изображению, например `assets/images/type_manual.png` |
| icon | text | имя иконки |

В Dart поля записаны в camelCase (`shortDescription`). Drift сам сохраняет их в SQLite как `short_description`.

### Миграция и начальное заполнение

Версия схемы `schemaVersion` равна 1.

- `onCreate` вызывается один раз, когда файла базы ещё нет. Сначала `m.createAll()` создаёт таблицу, затем `_seed()` вставляет пять типов из списка `testingItems`.
- `onUpgrade` пустой: схема ещё не менялась, обновлять старый файл не нужно. Если позже добавится колонка, версию увеличивают и дописывают шаги сюда.
- Файл базы: `testvik.sqlite` в каталоге документов приложения (`getApplicationDocumentsDirectory`).

Повторный запуск таблицу заново не создаёт и начальные строки второй раз не вставляет: `onCreate` срабатывает только для нового файла.

### Паттерн Repository

`TestingRepository` — единственное место, которое читает и меняет таблицу. BLoC не знает про Drift.

Операции:

- `getAll` — все строки, для каждой собирается `TestingType`. Это то, что вызывает `HomeBloc`.
- `insert` — новая строка.
- `update` — замена строки по `id`.
- `delete` — удаление строки по `id`.

На HomePage нужен только `getAll`. Остальные методы есть в репозитории, как набор CRUD, и из экранов не вызываются.

`HomeBloc` по событию `LoadHomeEvent` отдаёт `HomeLoading`, затем `await _repository.getAll()` и состояние `HomeLoaded`. При ошибке — `HomeError`.

DetailPage свой блок не получает. Выбранный `TestingType` по-прежнему передаётся аргументом маршрута. Картинка берётся из поля `image`, которое теперь пришло из колонки базы.

### DI-контейнер

Контейнер — `getIt` в `lib/di/injection.dart`. Функция `configureDependencies()` вызывается в `main` после `WidgetsFlutterBinding.ensureInitialized()` и до `runApp`.

Классы помечены аннотациями, регистрацию пишет генератор в `injection.config.dart`:

- `AppDatabase` — `@lazySingleton`, один экземпляр на всё приложение;
- `TestingRepository` — `@lazySingleton`, в конструктор передаётся эта база;
- `HomeBloc` — `@injectable`, это factory: новый блок на каждый заход на HomePage. Старый блок закрывается вместе со страницей, поэтому общий экземпляр не подходит.

`HomePage` объект не конструирует:

```dart
create: (_) => getIt<HomeBloc>()..add(LoadHomeEvent()),
```

GetIt сам создаёт блок и подставляет в него репозиторий, а репозиторию — базу.

## Экраны

Вставьте скриншот HomePage после перехода на Drift.

Вставьте скриншот DetailPage после перехода на Drift.

Состав экранов тот же: список типов, короткие описания и пути к тем же картинкам из assets. Источник данных — таблица SQLite, а не константа `testingItems` в блоке.

## Программный код

Файлы, которые пишутся вручную:

- `lib/data/app_database.dart`
- `lib/data/testing_repository.dart`
- `lib/di/injection.dart`
- `lib/bloc/home_bloc.dart`
- `lib/main.dart` — вызов `configureDependencies()`
- `lib/pages/home_page.dart` — `getIt<HomeBloc>()`

Файлы, которые создаёт команда `dart run build_runner build` и которые вручную не правят:

- `lib/data/app_database.g.dart`
- `lib/di/injection.config.dart`

База:

```dart
@DataClassName('TestingTypeRow')
class TestingTypes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get shortDescription => text()();
  TextColumn get detailedDescription => text()();
  TextColumn get image => text()();
  TextColumn get icon => text()();
}

@lazySingleton
@DriftDatabase(tables: [TestingTypes])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      await m.createAll();
      await _seed();
    },
    onUpgrade: (Migrator m, int from, int to) async {},
  );
}
```

Репозиторий, чтение списка:

```dart
Future<List<TestingType>> getAll() async {
  final rows = await _db.select(_db.testingTypes).get();
  return rows.map(_toModel).toList();
}
```

Контейнер:

```dart
final getIt = GetIt.instance;

@InjectableInit()
void configureDependencies() => getIt.init();
```

Сгенерированная регистрация:

```dart
gh.lazySingleton<AppDatabase>(() => AppDatabase());
gh.lazySingleton<TestingRepository>(
  () => TestingRepository(gh<AppDatabase>()),
);
gh.factory<HomeBloc>(
  () => HomeBloc(gh<TestingRepository>()),
);
```

Блок:

```dart
@injectable
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc(this._repository) : super(HomeInitial()) {
    on<LoadHomeEvent>(_onLoad);
  }

  final TestingRepository _repository;

  Future<void> _onLoad(LoadHomeEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      final items = await _repository.getAll();
      emit(HomeLoaded(items));
    } on Object {
      emit(HomeError('Не удалось загрузить данные'));
    }
  }
}
```

## Выводы

Drift хранит пункты справочника в файле SQLite, а не в списке, который живёт только пока запущен процесс. Вместе со строкой лежит путь к изображению, поэтому карточка и DetailPage получают картинку из той же записи, что и текст. Таблица описана классом Dart, запросы к ней тоже на Dart, а SQL и класс строки генерируются. Создание файла и первое заполнение собраны в `onCreate`, поэтому схема и стартовые данные не размазаны по экранам.

GetIt и Injectable убирают создание базы, репозитория и блока из страницы. Страница просит готовый `HomeBloc`. Кто от кого зависит, видно по конструкторам и аннотациям: блок зависит от репозитория, репозиторий от базы. Генератор собирает этот порядок сам. База одна на приложение, а блок создаётся заново для экрана. Экран можно менять, не открывая SQLite, а способ хранения можно менять внутри репозитория, не переписывая вёрстку.

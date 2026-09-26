# Практическая работа. Паттерн BLoC

## Цель работы

Изменить ранее разработанное приложение и реализовать управление состоянием страницы HomePage по паттерну BLoC. Данные берутся из локальной коллекции `List`, без внешнего слоя данных (без JSON, сети и репозитория).

## Структура проекта

```text
lib/
  models/
    testing_type.dart      — модель данных
  data/
    testing_data.dart      — коллекция List
  bloc/
    home_event.dart        — события
    home_state.dart        — состояния
    home_bloc.dart         — BLoC
  pages/
    home_page.dart         — HomePage, подписка на состояние
    detail_page.dart       — DetailPage
```

Скриншот дерева проекта в проводнике IDE вставьте сюда.

## Как работает BLoC

BLoC связывает страницу и данные. Страница не читает список сама: она отправляет событие и рисует то, что пришло в состоянии.

1. `HomePage` создаёт `HomeBloc` и сразу добавляет событие `LoadHomeEvent`.
2. Начальное состояние — `HomeInitial`.
3. В обработчике события блок сначала выдаёт `HomeLoading`. На экране в этот момент индикатор загрузки.
4. Затем блок берёт готовый список `testingItems` из `lib/data/testing_data.dart` и выдаёт `HomeLoaded` с этим списком. `BlocBuilder` перерисовывает HomePage: заголовок, карточки типов и горизонтальные изображения.
5. Если при загрузке возникает исключение, блок выдаёт `HomeError` с текстом ошибки. Страница показывает этот текст.
6. По нажатию на карточку открывается `DetailPage`. Ей передаётся выбранный элемент модели `TestingType`. У детальной страницы своего BLoC нет.

Внешний слой данных не подключался: нет запроса к серверу и нет чтения JSON. Источник один — коллекция `List` в файле данных.

## Экраны

Вставьте скриншот HomePage.

Вставьте скриншот DetailPage.

## Программный код

Модель, список, событие, состояния и блок — в файлах:

- `lib/models/testing_type.dart`
- `lib/data/testing_data.dart`
- `lib/bloc/home_event.dart`
- `lib/bloc/home_state.dart`
- `lib/bloc/home_bloc.dart`
- `lib/pages/home_page.dart`
- `lib/pages/detail_page.dart`

Фрагмент блока:

```dart
class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(HomeInitial()) {
    on<LoadHomeEvent>(_onLoad);
  }

  Future<void> _onLoad(LoadHomeEvent event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      emit(HomeLoaded(testingItems));
    } on Object {
      emit(HomeError('Не удалось загрузить данные'));
    }
  }
}
```

Фрагмент страницы:

```dart
return BlocProvider(
  create: (_) => HomeBloc()..add(LoadHomeEvent()),
  child: BlocBuilder<HomeBloc, HomeState>(
    builder: (context, state) {
      if (state is HomeError) {
        return _HomeStatus(message: state.message);
      }
      if (state is! HomeLoaded) {
        return const _HomeStatus();
      }
      return _HomeView(items: state.items);
    },
  ),
);
```

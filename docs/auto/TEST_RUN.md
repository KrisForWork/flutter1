# Автотесты — прогон `flutter test`

**Дата:** 2026-09-11 (прогон REVIEWER после правок)  
**Команда:** `flutter test`  
**Результат:** **All tests passed!** (+60)  
**Analyzer:** `flutter analyze` → **No issues found!**

## Среда

| Параметр | Значение |
|----------|----------|
| ОС | Windows 10 (build 26200) |
| Flutter | 3.35.x (stable) |
| Тип тестов | unit + widget + load (без `integration_test`) |

## Сводка по файлам

| Файл | Уровень | Кейсов (примерно) |
|------|---------|-------------------|
| `test/unit/directory_entry_test.dart` | unit | 4 |
| `test/unit/directory_repository_test.dart` | unit | 22 |
| `test/unit/directory_controller_test.dart` | unit | 10 |
| `test/widget/directory_list_page_test.dart` | widget | 14 |
| `test/widget/filter_bar_test.dart` | widget | 1 |
| `test/widget/load_page_test.dart` | widget | 3 |
| `test/load/directory_repository_load_test.dart` | load | 6 |
| **Итого** | | **60** |

## Вывод прогона (фрагмент)

```
--- LOAD TIMINGS (ms) ---
generate_100: 1
filter_100: 1
generate_1000: 3
filter_1000: 1
generate_10000: 19
filter_10000: 8
...
All tests passed!
```

Повтор: `flutter test` из корня проекта.

## Что покрыто

- Модель: поля, `copyWith`
- Репозиторий: add/trim/reject, remove, favorite, filter/search/комбо, clear, generate (в т.ч. custom id / n≤0), seed
- Контроллер: фильтры, validation, load metrics, кэш `filteredEntries`
- Widget: empty, list, search (+ no match), favorites, category, combo, add+validation, details, навигация на Load, clear→назад
- Load: generate/filter для 100 / 1 000 / 10 000 с точной длиной фильтра

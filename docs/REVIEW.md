# Code review — практическая №2 («Справочник»)

**Дата:** 2026-09-11  
**Роль:** REVIEWER (adversarial)  
**База:** `docs/PLAN_PRACTICAL_02.md`, `docs/FLUTTER_STANDARDS.md`, `lib/`, `test/`, `docs/manual|auto|load`

### Сводка по severity

| Severity | Найдено | Исправлено в review | Осталось |
|----------|---------|---------------------|----------|
| blocker  | 0       | 0                   | 0        |
| high     | 5       | 5                   | 0        |
| medium   | 8       | 5                   | 3        |
| low      | 5       | 1                   | 4        |

`flutter analyze` / `flutter test` после правок: **зелёные** (см. конец файла и `docs/auto/TEST_RUN.md`).

---

## High

### H1 — Повторный `filter` на каждом rebuild списка
| | |
|--|--|
| **Файл** | `lib/state/directory_controller.dart`, `lib/ui/directory_list_page.dart` |
| **Проблема** | `filteredEntries` / `visibleCount` / `visibleFavoriteCount` каждый раз заново фильтровали весь список. На экране после генерации 10 000 записей один rebuild делал до 3 полных проходов — противоречит стандартам (§6: не фильтровать лишний раз в `build`). |
| **Fix applied** | Кэш `_cachedFiltered` с инвалидацией при изменении данных/фильтров; в UI счётчики берутся из одного снимка. Unit-тест на identity кэша. |

### H2 — `generate` + custom `idGenerator` → одинаковые названия
| | |
|--|--|
| **Файл** | `lib/data/directory_repository.dart` |
| **Проблема** | Заголовок брал `_nextId`, который не инкрементируется при инжектируемом генераторе → все «Запись 1». |
| **Fix applied** | Title = `Запись ${count + 1}`; `generate(n<=0)` no-op; unit-тесты на уникальность и на n≤0. |

### H3 — Ложные «PASSED / AUTO» в чек-листе
| | |
|--|--|
| **Файл** | `docs/manual/CHECKLIST_RESULTS.md` |
| **Проблема** | S5 (навигация на «Нагрузка»), F8 (поиск → «Нет записей»), F7 (сброс фильтров), L3 (возврат после clear) помечены AUTO без соответствующих widget-сценариев → риск false green в отчёте. |
| **Fix applied** | Добавлены widget-тесты (открытие Load, пустой поиск, combo-фильтр, clear→назад→empty); результаты чек-листа переписаны честнее. |

### H4 — Слабые assertions в load-тестах
| | |
|--|--|
| **Файл** | `test/load/directory_repository_load_test.dart` |
| **Проблема** | `filtered.length <= n` почти всегда true; не ловит поломку распределения категорий. |
| **Fix applied** | Ожидаемая длина `(n + 2) ~/ 3` для категории «Тестирование» + проверка категории каждой записи. |

### H5 — Мёртвый Key удаления с тайла
| | |
|--|--|
| **Файл** | `lib/ui/widget_keys.dart` |
| **Проблема** | `entryDeleteButton(id)` объявлен, нигде не навешан (удаление только на деталях) — ловушка для будущих тестов. |
| **Fix applied** | Key удалён. |

---

## Medium

### M1 — Сообщение валидации не сбрасывалось при правке полей
| | |
|--|--|
| **Файл** | `lib/ui/widgets/add_entry_form.dart` |
| **Проблема** | После «Введите название записи» ошибка висела, пока не сработает повторный submit / выход. |
| **Fix applied** | `onInputChanged` → `clearValidationError`; widget-тест. |

### M2 — Лишний runtime-пакет `cupertino_icons`
| | |
|--|--|
| **Файл** | `pubspec.yaml` |
| **Проблема** | Стандарты: только Material + `flutter_test` / `flutter_lints`. Пакет не использовался. |
| **Fix applied** | Зависимость удалена. |

### M3 — `prefer_single_quotes` не включён в analyzer
| | |
|--|--|
| **Файл** | `analysis_options.yaml` |
| **Проблема** | Стандарты требуют одинарные кавычки, правило было закомментировано. |
| **Fix applied** | `prefer_single_quotes: true`. |

### M4 — PLAN всё ещё «код не менялся»
| | |
|--|--|
| **Файл** | `docs/PLAN_PRACTICAL_02.md` |
| **Проблема** | Статус и §8 устарели относительно реализации. |
| **Fix applied** | Обновлена статусная пометка. |

### M5 — TEST_RUN / LOAD_REPORT устарели относительно review-прогона
| | |
|--|--|
| **Файл** | `docs/auto/TEST_RUN.md`, `docs/load/LOAD_REPORT.md` |
| **Проблема** | Числа тестов и тайминги не совпадали с актуальным прогоном. |
| **Fix applied** | Обновлены по прогону после review. |

### M6 — Нет widget-покрытия combo / load navigation *(до review)*
| | |
|--|--|
| **Файл** | `test/widget/directory_list_page_test.dart` |
| **Проблема** | План/чек-лист требуют combo-фильтры и переход на Load. |
| **Fix applied** | Тесты добавлены (см. H3). |

### M7 — Счётчик «Всего» не «по текущему фильтру»
| | |
|--|--|
| **Файл** | `lib/ui/directory_list_page.dart` |
| **Проблема** | План: «всего / избранных (по текущему фильтру)». UI: «Показано» (фильтр) · «Всего» (весь справочник) · «Избранных» (в фильтре). Чек-лист S3 закрепляет текущую формулировку. |
| **Recommendation** | Оставить как есть (яснее для демо); при строгом следовании плану заменить «Всего» на filtered total и убрать отдельное «Показано». |

### M8 — README шаблонный
| | |
|--|--|
| **Файл** | `README.md` |
| **Проблема** | Не описывает приложение и команды сдачи. |
| **Recommendation** | Краткая замена содержимым из `docs/REPORT.md` §«Как запустить» (отчёт уже содержит инструкцию). |

---

## Low

### L1 — Дублирование FAB и кнопки «Добавить»
| | |
|--|--|
| **Файл** | `lib/ui/directory_list_page.dart` |
| **Проблема** | Два входа на форму ради Keys — шум в UI. |
| **Recommendation** | Оставить FAB; Key `entry_add_button` повесить на FAB или оставить как discoverability для тестов. |

### L2 — Load page не выбирает фильтры локально
| | |
|--|--|
| **Файл** | `lib/ui/load_page.dart` |
| **Проблема** | «Применить фильтр» использует фильтры с главного экрана — неочевидно без подсказки. |
| **Recommendation** | Подпись «используются текущие фильтры списка» (уже косвенно ок для учебного scope). |

### L3 — Замер UI/FPS на 10k не делался
| | |
|--|--|
| **Файл** | `docs/load/LOAD_REPORT.md` |
| **Проблема** | Клиентская нагрузка логики измерена; scroll/jank на устройстве — нет. |
| **Recommendation** | При сдаче один раз `flutter run` + DevTools Performance на N=10 000 (уже отмечено в отчётах). |

### L4 — `Duration.inMilliseconds` показывает 0 мс на быстрых операциях
| | |
|--|--|
| **Файл** | `lib/ui/load_page.dart` |
| **Recommendation** | При желании показывать микросекунды для sub-ms. |

### L5 — Нет сброса `_nextId` при `clear`
| | |
|--|--|
| **Файл** | `lib/data/directory_repository.dart` |
| **Проблема** | После clear id продолжают расти (titles после fix идут от `count+1`, ids — от счётчика). |
| **Recommendation** | Опционально сбрасывать `_nextId` в `clear()` для «чистого» демо. |

---

## Что проверено и ок

- Русский UI, фильтры (категория / избранное / поиск), детали, избранное, удаление, отдельный экран «Нагрузка».
- SoC: Repository → Controller (`ChangeNotifier`) → UI; `ListView.builder`; без `integration_test`.
- Unit + widget + client load; trim/validation; seed demo.
- `flutter analyze`: No issues found.
- `flutter test`: All tests passed (после review).

---

## Прогон после review

```
flutter analyze  → No issues found!
flutter test     → All tests passed! (+60)
LOAD (ms): generate_100≈1, filter_100≈1, generate_1000≈3–4,
           filter_1000≈1, generate_10000≈18–19, filter_10000≈8–15
```

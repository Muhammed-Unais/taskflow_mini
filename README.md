# TaskFlow Mini — README

A compact task/project management Flutter app built as a take-home exercise. The codebase follows clean architecture patterns with clear separation between presentation, domain and data layers. The project emphasizes testability, maintainability and readable UI.

---

## Summary

* Projects, Tasks, Subtasks (checklist-style)
* Admin assigns/unassigns staff to tasks
* Role-based UI (Admin vs Staff)
* Status report per project (aggregated metrics + "Open tasks by assignee")
* Deterministic filtering and text search inside the task list
* Seeded data for quick evaluation (Project + Users + Tasks + Subtasks)
* Light & Dark theming (primary color `#0EA5E9`)

---

## How to run

**Prerequisites**

* Install Flutter (stable channel)
* Project tested with:

  * **Flutter**: 3.29.2 (March 2025)
  * **Dart**: 3.72.2

**Basic commands**

```bash
# clone repo
git clone <repo-url>

# install packages
flutter pub get

# run on an emulator or connected device
flutter run

# build release APK (split per ABI)
flutter build apk --split-per-abi
```

---

## Architecture overview

The project is organized to keep domain interfaces and implementation details separated and testable. The flow is:

```
UI (presentation)  -->  BLoC  -->  Domain (entities + repository interfaces)  -->  Data (datasources + repository implementations)
```

* **Presentation**: Flutter widgets and `Bloc` classes (flutter\_bloc) implement UI flows and state transitions.
* **Domain**: Entities and repository interfaces live here; business rules belong to this layer.
* **Data**: Local datasources (in-memory) and repository implementations simulate API behavior and latency.
* **Core**: theme, security utilities (permission utilities), and reusable widgets live under `core`.

### Repository layout 


**Feature-first under `src/` (this project includes this structure)**

```
lib/
  src/
    auth/
      domain/
      data/
      presentation/
    projects/
      domain/
      data/
      presentation/
    tasks/
      domain/
      data/
      presentation/
  core/
  main.dart
```

Both layouts preserve the repository pattern (interfaces in domain and implementations in data) and the same BLoC boundaries.

---

## Key packages & why

* **flutter\_bloc + bloc** — robust, testable state management with clear event/state patterns.
* **equatable** — simplifies equality for events, states, and entities; keeps BLoC code clean.
* **go\_router** — declarative routing with deep-linking support (Navigator fallback supported).
* **google\_fonts** — easy access to a broad range of fonts for consistent and modern UI styling.

---

## Decisions & trade-offs

* **Normalized data model**: Tasks are stored separately from projects (each task has a `projectId`). This enables simpler filtering, reporting and independent updates.
* **In-memory datasources with seeding**: Faster iteration for the take-home exercise and straightforward to swap for Hive/Drift later. Simulated latency demonstrates loading and error states.
* **UI-level permission enforcement**: Permissions are centralized in `core/security/permission_utilities.dart` and enforced in the UI. Server-side enforcement would be necessary for production systems.
* **BLoC choice**: BLoC is used for complex flows (TaskBloc, ReportBloc, SubtaskBloc); smaller ephemeral UI state is kept lightweight and local to presentation logic.

---

## Known limitations & next steps

1. **Rebuild granularity**: Some widgets rebuild more than necessary. Next step: adopt `BlocSelector` or value selectors to rebuild specific widgets only.
2. **Refactor & reusable widgets**: Extract repeated UI (cards, chips, dialogs) into a shared `widgets/` library for improved consistency and testability.
3. **Polished UI**: Add refined spacing, micro-interactions, and accessibility improvements (labels, focus order, larger tap targets).
4. **Separate Filter module**: Consider extracting filter/search into a dedicated filter BLoC/repository for separation of concerns and persistence of saved views.
5. **Persistence (optional)**: Migrate to `Drift` or `Hive` for durable local storage with indexed queries for fast reports.
6. **Server-side rules & auth**: Add a backend/service layer to enforce role permissions and store audit logs for critical actions.
7. **Unit & Widget Tests**: Add tests for report calculation, filtering logic and key widgets to improve reliability.
8. **CSV export & pagination**: Add CSV export for reports and pagination for large task lists if dataset grows.

---

## Screenshots

* <img width="1200" height="2670" alt="Screenshot_20250820-002321 taskflow_mini" src="https://github.com/user-attachments/assets/b88df573-7d5f-4e90-968d-78d7b59b0966" />
 (dark theme)
* <img width="1200" height="2670" alt="Screenshot_20250820-002301 taskflow_mini" src="https://github.com/user-attachments/assets/e7dd73d6-80bf-4060-b618-abba0c1c4658" />
 (light theme)

---

## File layout (high level)

```
lib/
  src/ (feature-first layout present)
    auth/
    projects/
    tasks/
  core/
  main.dart
```

---

## Commands & tooling

* `flutter pub get` — fetch dependencies
* `flutter analyze` — static analysis
* `flutter format .` — format codebase

---


*End of README*

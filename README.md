# Finanças App

Finance management app built with Flutter for Android and Web. It provides login by ID, movement listing and creation, summary of income vs expenses, types/means management (future), and export to Excel (future).

![Flutter](https://img.shields.io/badge/Flutter-3.38.1-blue)
![Dart](https://img.shields.io/badge/Dart-3.10.0-blue)
![Platforms](https://img.shields.io/badge/Platforms-Android%20%7C%20Web-success)
![License](https://img.shields.io/badge/License-MIT-lightgrey)

## Technical Requirements

- Flutter SDK: `3.38.1` (stable)
- Dart SDK: `3.10.0`
- Platforms: Android, Web (web enabled)
- Dependencies:
  - `flutter_riverpod` for state management
  - `http` for REST calls
  - `intl` for formatting
- Backend (PHP):
  - `get_movimentacoes.php`
  - `create_movimentacao.php`
  - CORS enabled and preflight (OPTIONS) handled

## Installation & Setup

1. Install Flutter and enable Web:
   
   ```bash
   flutter config --enable-web
   ```

2. Install dependencies:

   ```bash
   flutter pub get
   ```

3. Configure API base URL in `lib/core/constants.dart`:

   ```dart
   class AppConstants {
     static const String apiBaseUrl = 'https://felpsti.com.br/backend_financas';
     static const String getMovementsPath = 'get_movimentacoes.php';
     static const String createMovementPath = 'create_movimentacao.php';
   }
   ```

4. Ensure backend endpoints are accessible and CORS is properly configured (see CORS section).

## Usage

Run on Web:

```bash
flutter run -d chrome
```

Run on Android:

```bash
flutter run -d android
```

If you face local port restrictions, use a high port and explicit hostname:

```bash
flutter run -d chrome --web-port 55123 --web-hostname localhost
```

### App Flow

- Login: select user ID (1 or 2) on `/login`.
- Summary: `/summary` shows income, expenses, and balance.
- Movements: `/movements` lists movements with optional date filter.
- Create Movement: `/create` allows creating new entries (income or expense).
- Bottom navigation is fixed and visible on main pages; login hides it.

## Directory Structure

```
lib/
  app/
    app.dart                  # MaterialApp + routes
  core/
    constants.dart            # API base URL and endpoints
    navigation_provider.dart  # Bottom nav index state
  features/
    auth/
      auth_provider.dart      # userId state
      login_page.dart         # login by ID
    movements/
      models/
        movement.dart         # Movement model
      data/
        movements_api.dart    # HTTP client
        movements_repository.dart
      controllers/
        movements_controller.dart
      ui/
        movements_list_page.dart
        create_movement_page.dart
    summary/
      ui/
        summary_page.dart
  widgets/
    bottom_nav.dart           # Fixed bottom navigation bar
php/
  get_movimentacoes.php
  create_movimentacao.php
```

## CORS Configuration (Backend)

In `php/get_movimentacoes.php` and `php/create_movimentacao.php`:

```php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type');
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
  http_response_code(200);
  exit(0);
}
```

Apache `.htaccess` (optional):

```apache
<IfModule mod_headers.c>
  Header set Access-Control-Allow-Origin "*"
  Header set Access-Control-Allow-Methods "GET, POST, OPTIONS"
  Header set Access-Control-Allow-Headers "Content-Type"
</IfModule>
```

## Development

- Analyze and tests:

  ```bash
  flutter analyze
  flutter test
  ```

- Common commands:

  ```bash
  flutter pub get
  flutter pub outdated
  ```

## Contribution

Contributions are welcome. Please:

- Follow clean architecture and project conventions
- Keep functions small and well-typed
- Add tests for new public APIs
- Run `flutter analyze` and `flutter test` before submitting PRs

## License

MIT License. See `LICENSE` file if present, or treat this project as MIT-licensed.

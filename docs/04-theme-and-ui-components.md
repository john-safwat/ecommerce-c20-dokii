# 04 — Theme and UI Components

This document specifies the design tokens, color palette, typography scale, `AppTheme` configuration, and shared UI component catalogue for the Route E-Commerce Flutter application.

---

## 1. Overview & Architecture

The theme layer lives under `lib/core/theme/` and is registered in Dependency Injection (`get_it` + `injectable`):

```text
lib/core/theme/
├── app_colors.dart    # Abstract AppColors contract and LightColors implementation
└── app_theme.dart     # AppTheme service building Material 3 ThemeData
```

- **`AppColors`** (`lib/core/theme/app_colors.dart`): Abstract color contract defining semantic tokens for surfaces, brand actions, typography, borders, and ratings.
- **`LightColors`** (`@LazySingleton(as: AppColors)`): Light-theme implementation aligned with the Route E-Commerce Figma design specification.
- **`AppTheme`** (`@lazySingleton`): Injects `AppColors` and exposes `ThemeData get theme` wired into `MaterialApp` in `lib/main.dart`.

---

## 2. Color Palette (`AppColors` / `LightColors`)

| Token Getter | Hex / ARGB | Visual Role |
|---|---|---|
| `brightness` | `Brightness.light` | Material color scheme brightness |
| `primaryColor` | `0xFF004182` (`#004182`) | Primary Route brand blue (CTAs, active states, price highlights) |
| `onPrimaryColor` | `0xFFFFFFFF` (`#FFFFFF`) | Text and icons rendered on primary blue surfaces |
| `secondaryColor` | `0xFF06004F` (`#06004F`) | Dark navy for headings, titles, and primary emphasis |
| `onSecondaryColor` | `0xFFFFFFFF` (`#FFFFFF`) | Text and icons rendered on dark navy surfaces |
| `surfaceColor` | `0xFFFFFFFF` (`#FFFFFF`) | Scaffold, card, and app bar background surface |
| `onSurfaceColor` | `0xFF06004F` (`#06004F`) | Default body text and icons on light surfaces |
| `errorColor` | `0xFFBC3018` (`#BC3018`) | Validation error, destructive actions, and sale badges |
| `onErrorColor` | `0xFFFFFFFF` (`#FFFFFF`) | Text and icons rendered on error surfaces |
| `textSecondaryColor` | `0x9906004F` (`#06004F` @ 60%) | Muted body copy, hints,captions, and strikethrough prices |
| `strokeColor` | `0x4D004182` (`#004182` @ 30%) | Card outlines, text field borders, and dividers (`ColorScheme.outline`) |
| `starColor` | `0xFFFDD835` (`#FDD835`) | Product rating star icon fill |

---

## 3. Typography Scale (`AppTheme.theme.textTheme`)

All text styles are mapped into `ThemeData.textTheme` and accessed via `Theme.of(context).textTheme`:

| TextTheme Slot | Size (sp) | Weight | Color Token | Typical Usage |
|---|---|---|---|---|
| `headlineLarge` | `24` | SemiBold (`w600`) | `secondaryColor` | Auth headers, top-level screen titles |
| `headlineMedium` | `20` | SemiBold (`w600`) | `secondaryColor` | Section headers, modal titles |
| `titleLarge` | `20` | Medium (`w500`) | `secondaryColor` | Product detail title, prominent card headers |
| `titleMedium` | `18` | Medium (`w500`) | `secondaryColor` | Section sub-headers, list item titles |
| `titleSmall` | `16` | Medium (`w500`) | `secondaryColor` | Compact card titles, form field labels |
| `bodyLarge` | `16` | Regular (`w400`) | `onSurfaceColor` | Primary body copy, input text |
| `bodyMedium` | `14` | Regular (`w400`) | `onSurfaceColor` | Product card titles, standard descriptions |
| `bodySmall` | `12` | Regular (`w400`) | `textSecondaryColor` | Secondary descriptions, metadata, ratings count |
| `labelLarge` | `18` | Medium (`w500`) | `primaryColor` | Prominent button labels and interactive links |
| `labelMedium` | `14` | Light (`w300`) | `textSecondaryColor` | Helper text, subtle chips |
| `labelSmall` | `11` | Regular (`w400`) | `textSecondaryColor` | Strikethrough old prices, badge captions |

---

## 4. Shared UI Component Catalogue (`lib/core/common_ui/`)

> Every cross-feature primitive in `lib/core/common_ui/` must be documented in the table below before committing (`AGENTS.md` §1).

| Class Name | File Path | Constructor Signature | Purpose |
|---|---|---|---|
| `AppTextField` | `lib/core/common_ui/app_text_field.dart` | `const AppTextField({super.key, required String label, required String hintText, required TextEditingController controller, String? Function(String?)? validator, bool isPassword = false, TextInputType keyboardType = TextInputType.text, TextInputAction textInputAction = TextInputAction.next, List<TextInputFormatter>? inputFormatters, ValueChanged<String>? onFieldSubmitted, bool enabled = true, Color? labelColor})` | Labeled rounded form input with optional password visibility toggle and RTL-aware padding |
| `AppButton` | `lib/core/common_ui/app_button.dart` | `const AppButton({super.key, required String label, required VoidCallback? onPressed, bool isLoading = false, bool isEnabled = true, Color? backgroundColor, Color? foregroundColor, double height = 64, double borderRadius = 15})` | Full-width CTA button with loading spinner and disabled state support |
| `RouteLogo` | `lib/core/common_ui/route_logo.dart` | `const RouteLogo({super.key, double height = 72, Color? color})` | Vector wordmark for the Route brand displayed on auth and home screens |

---

## 5. Golden Rules

1. **Zero Hardcoded Colors or TextStyles**: Never use `Color(0x...)`, `Colors.*`, or raw `TextStyle(fontSize: ...)` inside feature widgets. Always read from `Theme.of(context)` (`colorScheme`, `textTheme`) or `getIt<AppColors>()`.
2. **DI-Managed Theme**: `AppTheme` and `AppColors` are resolved via `getIt` so widgets and tests have a single source of truth.
3. **Catalogue Discipline**: Before creating any `App*` widget in `lib/core/common_ui/`, check Section 4 above and update it in the same commit.

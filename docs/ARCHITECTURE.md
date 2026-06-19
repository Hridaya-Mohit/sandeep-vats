# Sandeep Vats Astrologer — Architecture Document

## Project Overview

A bilingual (Hindi + English) portfolio website for astrologer Sandeep Vats.
Built in Flutter, web-first with future Android/iOS support.

---

## Design Language

- **Theme:** Dark mystical with golden accents
- **Primary background:** Deep dark (near black, e.g. `#0A0A0F`)
- **Accent:** Gold (`#C9A84C`) and muted gold (`#8B6914`)
- **Text:** Off-white (`#F0EAD6`) on dark, dark on gold
- **Fonts:**
  - English: `Cormorant Garamond` (serif, elegant) for headings; `Lato` for body
  - Hindi: `Poppins` or `Tiro Devanagari Sanskrit` for Devanagari text
- **Motifs:** Subtle star/mandala patterns, zodiac icons, celestial gradients

---

## Platform Strategy

| Platform | Priority | Notes |
|----------|----------|-------|
| Web | P0 | Fully responsive, desktop-first |
| Android | P1 | After web is stable |
| iOS | P1 | After web is stable |

---

## Folder Structure

```
lib/
  main.dart                  # App entry point
  app.dart                   # MaterialApp setup, theme, router
  core/
    theme/
      app_theme.dart         # ThemeData, colors, text styles
      app_colors.dart        # Color constants
      app_text_styles.dart   # Text style definitions
    l10n/
      app_localizations.dart # i18n strings (EN + HI)
      strings_en.dart
      strings_hi.dart
    router/
      app_router.dart        # go_router route definitions
    widgets/
      nav_bar.dart           # Sticky top navigation
      footer.dart            # Site footer
      section_wrapper.dart   # Consistent section padding/max-width
  features/
    home/
      home_page.dart         # Assembles all sections in order
    hero/
      hero_section.dart
    about/
      about_section.dart
    services/
      services_section.dart
      service_card.dart
    testimonials/
      testimonials_section.dart
      testimonial_card.dart
    contact/
      contact_section.dart
      contact_form.dart
  data/
    models/
      service_model.dart
      testimonial_model.dart
    content/
      services_data.dart     # Static content for services
      testimonials_data.dart
assets/
  images/                    # Sandeep's photo, section backgrounds
  icons/                     # Zodiac/astrology SVG icons
  fonts/                     # Cormorant Garamond, Lato, Devanagari
docs/
  ARCHITECTURE.md            # This file
```

---

## Pages & Sections

The site is a **single-page application (SPA)** with anchor-based scroll navigation.

### `HomePage` — `/`

All sections are rendered vertically in this order:

| # | Section | Description |
|---|---------|-------------|
| 1 | **HeroSection** | Full-viewport banner with name, tagline (EN+HI), CTA button |
| 2 | **AboutSection** | Photo, bio, credentials, years of experience |
| 3 | **ServicesSection** | Cards: Kundli, Vastu Shastra, Numerology, Prashna, Matching |
| 4 | **TestimonialsSection** | Carousel of client reviews |
| 5 | **ContactSection** | Contact form + phone/WhatsApp links |

---

## Navigation

- Sticky `NavBar` with logo, section links, language toggle (EN / HI)
- On web: horizontal nav links with smooth scroll to anchors
- On mobile (future): hamburger menu drawer
- Language toggle switches the entire app locale between `en` and `hi`

---

## State Management

**Riverpod** (`flutter_riverpod`)

| Provider | Purpose |
|----------|---------|
| `localeProvider` | Tracks current language (EN / HI) |
| `scrollControllerProvider` | Shared scroll controller for nav highlighting |

Chosen because:
- Lightweight for a portfolio (no complex state)
- Easy locale switching without rebuilding the whole tree
- Scales cleanly if dynamic content (bookings, CMS) is added later

---

## Routing

**go_router**

| Route | Widget |
|-------|--------|
| `/` | `HomePage` |
| `/services/:id` | `ServiceDetailPage` (future) |

Anchor scrolling handled via `ScrollController` + `GlobalKey` per section, triggered from the nav bar.

---

## Localisation (i18n)

- Two locales: `en` (English) and `hi` (Hindi)
- Strings stored in `lib/core/l10n/strings_en.dart` and `strings_hi.dart`
- A simple `AppLocalizations` class reads from the active locale
- Language toggle in nav bar updates `localeProvider`, rebuilding string-consuming widgets

---

## Key Dependencies (planned)

```yaml
dependencies:
  flutter_riverpod: ^2.x       # State management
  go_router: ^14.x             # Routing
  google_fonts: ^6.x           # Cormorant Garamond, Lato
  url_launcher: ^6.x           # WhatsApp / phone links
  flutter_animate: ^4.x        # Entrance animations
  visibility_detector: ^0.4.x  # Animate sections on scroll into view

dev_dependencies:
  flutter_lints: ^4.x
```

---

## Responsiveness

Breakpoints handled via `LayoutBuilder` / `MediaQuery`:

| Breakpoint | Width | Layout |
|-----------|-------|--------|
| Mobile | < 600px | Single column, stacked |
| Tablet | 600–1024px | 2-column grids |
| Desktop | > 1024px | Full layout, max-width 1200px centered |

A `ResponsiveWrapper` utility widget will expose `isMobile`, `isTablet`, `isDesktop` booleans for use across sections.

---

## Assets Strategy

- All images served from `assets/images/` (no CDN initially)
- SVG icons for zodiac signs via `flutter_svg`
- Background textures: dark starfield PNG/SVG, kept < 200KB each
- Fonts declared in `pubspec.yaml` under `fonts:`

---

## Future Considerations

- **Blog/Articles section** — astrology tips in EN+HI
- **Online booking form** — integrates with Google Calendar or Calendly embed
- **CMS integration** — replace static `data/content/` with a headless CMS (e.g. Contentful or Sanity) for Sandeep to update content himself
- **Analytics** — Firebase Analytics or Plausible for web traffic
- **SEO** — Flutter web meta tags via `flutter_web_plugins` + custom index.html

---

## Development Phases

| Phase | Scope |
|-------|-------|
| Phase 1 | Theme, NavBar, HeroSection, Footer |
| Phase 2 | AboutSection, ServicesSection |
| Phase 3 | TestimonialsSection, ContactSection |
| Phase 4 | Animations, Responsiveness polish |
| Phase 5 | i18n (Hindi), Language toggle |
| Phase 6 | SEO, Analytics, Deploy |

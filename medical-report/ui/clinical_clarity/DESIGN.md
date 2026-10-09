---
name: Clinical Clarity
colors:
  surface: '#f7f9fb'
  surface-dim: '#d8dadc'
  surface-bright: '#f7f9fb'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f2f4f6'
  surface-container: '#eceef0'
  surface-container-high: '#e6e8ea'
  surface-container-highest: '#e0e3e5'
  on-surface: '#191c1e'
  on-surface-variant: '#434652'
  inverse-surface: '#2d3133'
  inverse-on-surface: '#eff1f3'
  outline: '#737783'
  outline-variant: '#c3c6d4'
  surface-tint: '#2b5bb5'
  primary: '#003178'
  on-primary: '#ffffff'
  primary-container: '#0d47a1'
  on-primary-container: '#a1bbff'
  inverse-primary: '#b0c6ff'
  secondary: '#005faf'
  on-secondary: '#ffffff'
  secondary-container: '#54a0fe'
  on-secondary-container: '#003567'
  tertiary: '#003d36'
  on-tertiary: '#ffffff'
  tertiary-container: '#00564d'
  on-tertiary-container: '#66cebe'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#d9e2ff'
  primary-fixed-dim: '#b0c6ff'
  on-primary-fixed: '#001945'
  on-primary-fixed-variant: '#00429c'
  secondary-fixed: '#d4e3ff'
  secondary-fixed-dim: '#a5c8ff'
  on-secondary-fixed: '#001c3a'
  on-secondary-fixed-variant: '#004786'
  tertiary-fixed: '#8df5e4'
  tertiary-fixed-dim: '#70d8c8'
  on-tertiary-fixed: '#00201c'
  on-tertiary-fixed-variant: '#005048'
  background: '#f7f9fb'
  on-background: '#191c1e'
  surface-variant: '#e0e3e5'
typography:
  display-lg:
    fontFamily: Inter
    fontSize: 36px
    fontWeight: '700'
    lineHeight: 44px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Inter
    fontSize: 32px
    fontWeight: '600'
    lineHeight: 40px
    letterSpacing: -0.015em
  headline-lg-mobile:
    fontFamily: Inter
    fontSize: 26px
    fontWeight: '600'
    lineHeight: 34px
    letterSpacing: -0.01em
  headline-md:
    fontFamily: Inter
    fontSize: 22px
    fontWeight: '600'
    lineHeight: 28px
  title-lg:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 24px
  title-md:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '600'
    lineHeight: 22px
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  body-sm:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 16px
  label-lg:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '600'
    lineHeight: 20px
    letterSpacing: 0.01em
  label-md:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
    letterSpacing: 0.02em
  label-sm:
    fontFamily: Inter
    fontSize: 11px
    fontWeight: '600'
    lineHeight: 14px
    letterSpacing: 0.04em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 1rem
  gutter-mobile: 0.75rem
  margin: 1rem
  margin-tablet: 1.5rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.5rem
  space-xl: 2rem
---

## Brand & Style

This design system embodies a serene, clinical-grade precision tailored for personal health record management. Designed to mitigate user anxiety when navigating sensitive diagnostics, test results, and treatment histories, the interface blends high-reliability enterprise healthcare software with the warmth and approachability of modern consumer mobile applications.

The design movement centers on modern healthcare minimalism paired with tonal layering. The aesthetic prioritizes immediate legibility, high visual contrast for vital statistics, clean separation of chronological health events, and unmistakable verification statuses. It projects authority and institutional trust without feeling cold, intimidating, or overly bureaucratic.

## Colors

The palette establishes an immediate sense of institutional reliability and biological calm:

- **Primary Sapphire (`#0D47A1` & `#1976D2`):** Delivers authority, confidence, and primary structural emphasis. Used for primary app bars, high-priority actions, dominant headings, and active navigational indicators.
- **Sky Soft Accents (`#E3F2FD`):** Provides low-strain interactive surfaces, container fills for selected records, and subtle informational highlights without visual clutter.
- **Teal / Emerald Verified (`#00897B` with `#E0F2F1` container):** Reserved for authenticated laboratory findings, confirmed immunization states, synchronization confirmations, and normal vital ranges.
- **Neutral Canvas (`#F8FAFC` base, `#FFFFFF` surfaces):** A crisp, slate-tinged white ground separating layered cards and clinical dossiers.
- **Critical & Warning Tones:** Crimson (`#D32F2F` with `#FFEBEE` container) strictly flags out-of-range critical values and allergies; Amber (`#ED6C02` with `#FFF3E0`) indicates pending reviews and expiring prescriptions.

## Typography

Typography relies entirely on Inter to ensure uncompromised character clarity across dense numerical datasets, dosages, and medical terminology. 

- **Tabular Numerals (`font-feature-settings: 'tnum'`):** Compulsory for test scores, blood pressure metrics, timestamps, and biometric tracking tables to prevent visual jitter across comparisons.
- **Weights & Hierarchy:** Bold (`700`) is restricted to key biometric figures and critical alert headers. Primary headings utilize Semi-Bold (`600`), while descriptive body and doctor notes use Regular (`400`).
- **Scale Safety:** Mobile viewports clamp display headers to `headline-lg-mobile` (`26px`) to ensure diagnostic screen headers never truncate doctor names, medication names, or multi-syllable conditions.

## Layout & Spacing

The layout is built upon an 8pt base grid with a 4pt baseline subgrid specifically tailored for high-density medical record scanning:

- **Mobile Canvas:** Uses a continuous vertical fluid layout with a default outer canvas margin of `1rem` (16px) and an inner element gap of `0.75rem` (12px) to maximize usable screen estate without cramping.
- **Tablet / Split View:** On larger screens, the canvas shifts to a master-detail 12-column layout (4 columns for the patient record list/timeline, 8 columns for record details and lab trends) with `1.5rem` outer margins.
- **Ergonomics & Touch Safeties:** All critical touch affordances enforce a strict bounding box minimum of 48x48px, preventing misclicks when patients or providers operate the device in urgent, one-handed scenarios.

## Elevation & Depth

Visual depth is achieved through structural tonal layering rather than heavy drop shadows, reinforcing a clean, sterile, clinical visual environment:

- **Level 0 (Base Canvas):** `#F8FAFC` flat canvas for overall background views.
- **Level 1 (Clinical Cards & Sections):** `#FFFFFF` surfaces paired with an ultra-subtle, diffused tinted drop shadow: `0px 2px 8px rgba(15, 23, 42, 0.04)` combined with an ultra-fine border `1px solid rgba(226, 232, 240, 0.8)`.
- **Level 2 (Interactive Floating Surfaces / Action Bars):** Elevated summary sheets and bottom app bars use `0px 6px 16px rgba(13, 71, 161, 0.08)` to introduce a mild sapphire ambient warmth.
- **Level 3 (Modal Sheets & Diagnostic Dialogs):** High-priority confirmation panels and bottom sheets utilize `0px 12px 32px rgba(15, 23, 42, 0.16)` along with a 24% dark slate backdrop blur.

## Shapes

The interface embraces a balanced curvature:

- **Cards & Medical Records:** Enforce a strict `1rem` (16px / `rounded-lg`) corner radius, striking a balance between clinical structure and approachable softness.
- **Form Controls & Inputs:** Standardized at `0.5rem` (8px / base `rounded`) to preserve clear, recognizable boundaries for numeric and text inputs.
- **Badges, Tags, and Pills:** Bound with full pill-shaping (`9999px`) to distinguish clinical statuses (e.g., "Verified", "Fasting", "Abnormal") from structural rectangular cards.

## Components

- **Cards (Medical Records & Vitals):** Container uses white background with 16px border-radius and Level 1 elevation. Vitals cards feature a left accent spine (4px wide) color-coded by metric status (Sapphire for informational, Emerald for normal/verified, Crimson for critical).
- **Buttons:** 
  - *Primary:* Filled with `#0D47A1`, white text, 8px radius, minimum height of 48px, with centered `label-lg` typography.
  - *Secondary / Tonal:* `#E3F2FD` background with `#0D47A1` text for low-friction secondary actions (e.g., "Download PDF", "Share Record").
  - *Tertiary / Plain:* Text-only with Sapphire hover/pressed state states, strictly padded to 48px touch limits.
- **Status Badges & Verification Chips:** Pill-shaped tags with `11px` uppercase bold labels (`label-sm`). "Verified" records use `#00897B` text with an `#E0F2F1` background accompanied by a leading checkmark icon. "Critical" uses `#D32F2F` text on `#FFEBEE`.
- **Form Controls & Inputs:** Text fields stand at 52px height with an 8px radius. Inactive borders use `#E2E8F0`; focused inputs transition to a 2px `#1976D2` outline with an accompanying soft sky glow. Floating labels sit strictly within standard line-heights to eliminate overlap on smaller phone screens.
- **List Items & Record Timelines:** Medical history lists employ chronological dot-and-line markers connected vertically down the left edge. Each timeline node has a 48px minimum row height with explicit visual separation via 8px vertical spacing.
- **Checkboxes & Radios:** Centered within a 48px invisible tap target. Checkboxes feature a 4px rounded corner with `#1976D2` fill when selected.
- **Biometric Quick-Glance Tiles:** Compact square-aspect cards displaying real-time metrics (Heart Rate, Glucose, Blood Pressure) with large tabular numerical displays, sparkline trend graphs, and discreet date-time stamps at the bottom edge.
---
name: Clinical Clarity
colors:
  surface: '#faf8ff'
  surface-dim: '#d2d9f4'
  surface-bright: '#faf8ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f2f3ff'
  surface-container: '#eaedff'
  surface-container-high: '#e2e7ff'
  surface-container-highest: '#dae2fd'
  on-surface: '#131b2e'
  on-surface-variant: '#3f4850'
  inverse-surface: '#283044'
  inverse-on-surface: '#eef0ff'
  outline: '#707881'
  outline-variant: '#bfc7d2'
  surface-tint: '#006398'
  primary: '#006194'
  on-primary: '#ffffff'
  primary-container: '#007bb9'
  on-primary-container: '#fdfcff'
  inverse-primary: '#93ccff'
  secondary: '#00687a'
  on-secondary: '#ffffff'
  secondary-container: '#57dffe'
  on-secondary-container: '#006172'
  tertiary: '#006947'
  on-tertiary: '#ffffff'
  tertiary-container: '#00855b'
  on-tertiary-container: '#f5fff6'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#cce5ff'
  primary-fixed-dim: '#93ccff'
  on-primary-fixed: '#001d31'
  on-primary-fixed-variant: '#004b73'
  secondary-fixed: '#acedff'
  secondary-fixed-dim: '#4cd7f6'
  on-secondary-fixed: '#001f26'
  on-secondary-fixed-variant: '#004e5c'
  tertiary-fixed: '#6ffbbe'
  tertiary-fixed-dim: '#4edea3'
  on-tertiary-fixed: '#002113'
  on-tertiary-fixed-variant: '#005236'
  background: '#faf8ff'
  on-background: '#131b2e'
  surface-variant: '#dae2fd'
typography:
  display-lg:
    fontFamily: Inter
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.02em
  display-lg-mobile:
    fontFamily: Inter
    fontSize: 28px
    fontWeight: '700'
    lineHeight: 34px
    letterSpacing: -0.015em
  headline-lg:
    fontFamily: Inter
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
    letterSpacing: -0.01em
  headline-md:
    fontFamily: Inter
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 26px
    letterSpacing: -0.005em
  headline-sm:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 24px
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-lg-medium:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '500'
    lineHeight: 24px
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  body-md-medium:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '500'
    lineHeight: 20px
  label-md:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.02em
  label-sm:
    fontFamily: Inter
    fontSize: 11px
    fontWeight: '500'
    lineHeight: 14px
    letterSpacing: 0.03em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 1rem
  margin: 1rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 0.75rem
  space-lg: 1rem
  space-xl: 1.5rem
---

## Brand & Style

This design system establishes an empathetic, impeccably structured, and calming interface for personal medical history tracking. The visual tone balances clinical authority with human-centered warmth, stripping away hospital sterility in favor of restorative clarity, quiet confidence, and immediate legibility.

### Design Movement & Aesthetic
The style follows **Modern Healthcare Minimalism** infused with subtle tactile realism. It relies on:
- Crisp white content containers resting on soft slate-tinted canvas backdrops.
- Restrained visual noise with high-contrast, accessible typographic hierarchies.
- Micro-elevations via ambient cool-tinted shadows rather than heavy structural borders.
- Deliberate semantic color signaling that reduces cognitive friction during stress or medical emergencies.

### Target Audience & Emotional Intent
- **Audience:** Patients managing chronic illnesses, caretakers orchestrating multi-provider care, and everyday individuals needing fast access to immunizations, labs, and surgical histories.
- **Emotional Response:** Reassurance, control, security, and unencumbered clarity.

## Colors

The palette is engineered around precision, clinical trust, and AA/AAA accessibility compliance.

### Palette Roles
- **Primary (`#0284C7` - Deep Clinical Sky):** Primary navigation, key interactive triggers, verified credentials, and dominant active states.
- **Secondary (`#06B6D4` - Vitality Teal):** Diagnostic category markers, timeline indicators, secondary actions, and micro-metric accents.
- **Tertiary / Success (`#10B981` - Synced Emerald):** Synced health records, normal test values, stable health metrics, and secure connection indicators.
- **Warning (`#F59E0B` - Amber Vigilance):** Pending provider reviews, upcoming medication renewals, and scheduled follow-ups.
- **Destructive / Urgent (`#EF4444` - Critical Coral):** Abnormal lab values, drug allergy alerts, and emergency contact flags.
- **Neutral Surface Canvas (`#F8FAFC` - Slate Mist):** Foundation background providing soft contrast against cards.
- **Card & Sheet Surface (`#FFFFFF` - Pure White):** Isolated visual cards for individual medical records.
- **Border & Rule (`#E2E8F0` - Soft Slate Border):** Subtle delineation for card perimeters, input borders, and timeline dividers.
- **Text & Glyph Headings (`#0F172A` - Slate 900):** Deep contrast typography ensuring effortless readability under varying light conditions.
- **Text Muted (`#64748B` - Slate 500):** Metadata, timestamps, timestamps, and supporting secondary labels.

## Typography

The design system standardizes on **Inter** across all typographic applications to deliver clinical objectivity, tall x-height legibility on mobile screens, and dense metric organization without sacrificing scan-ability.

### Typographic Hierarchy Rules
- **Display & Section Titles:** Emphasize diagnosis categories and patient record titles with tight negative tracking (`-0.02em`) to maintain compactness.
- **Numeric & Metric Display:** Vitals (blood pressure, glucose levels, heart rates) utilize `headline-lg` with tabular figures where applicable to align values uniformly.
- **Labels & Tags:** Use uppercase or title case with `label-md` for quick verification (e.g., "BLOOD TYPE", "ALLERGY").

## Layout & Spacing

A strictly regimented 4pt/8pt grid governs spatial balance to maintain touch precision on touchscreens while ensuring rapid scanning.

### Layout Philosophy
- **Grid Architecture:** 4-column fluid mobile grid spanning a 375px–430px base width, expanding to full-width containers with max content constraints (640px) on tablet viewports.
- **Margins & Gutters:** Base mobile canvas margin is fixed at `1rem` (16px) with an internal `1rem` gutter between modular cards.
- **Component Breathing Space:** Tight internal grouping of label-to-value pairs (`space-xs` to `space-sm`), contrasted with pronounced macro separation between unrelated clinical categories (`space-xl`).

## Elevation & Depth

To preserve an airy, hygienic aesthetic, depth is realized through tinted ambient luminescence and structural containment rather than dark drop shadows.

### Elevation Hierarchy
- **Level 0 (Canvas Surface):** Neutral `#F8FAFC`, flat.
- **Level 1 (Card & Section Surfaces):** Pure White `#FFFFFF` backed by a multi-layered ambient shadow:
  - `box-shadow: 0 1px 3px 0 rgba(15, 23, 42, 0.04), 0 1px 2px -1px rgba(15, 23, 42, 0.02);`
  - Border: `1px solid #E2E8F0`.
- **Level 2 (Interactive Floating Elements, Timeline Nodes):** Active states, bottom sheets, and floating filter actions:
  - `box-shadow: 0 10px 15px -3px rgba(15, 23, 42, 0.06), 0 4px 6px -4px rgba(15, 23, 42, 0.03);`
  - Border: `1px solid rgba(226, 232, 240, 0.8)`.
- **Level 3 (Modal Alerts & Emergency Overlays):**
  - `box-shadow: 0 20px 25px -5px rgba(15, 23, 42, 0.08), 0 8px 10px -6px rgba(15, 23, 42, 0.04);`

## Shapes

The shape hierarchy provides tactile friendliness while preserving structured modularity.

### Corner Radii Guidelines
- **Record Cards & Containers:** Standardized at `16px` (`rounded-lg`) to soften the interface without looking playful.
- **Input Fields & Dropdowns:** Set to `12px` (`rounded-md`), optimizing corner radius for single-tap focus areas.
- **Badges, Status Chips, & Pills:** Fully rounded `9999px` (Pill) to create distinct contrast against rectangular card surfaces.
- **Action Buttons:** `12px` for primary actions; `9999px` for quick-filter or tag selection chips.

## Components

### Buttons
- **Primary:** Solid `#0284C7` background, white label, height `48px`, border radius `12px`. Hover/Pressed: `#0369A1`.
- **Secondary:** Surface `#FFFFFF`, border `1px solid #E2E8F0`, label `#0F172A`. Pressed: `#F1F5F9`.
- **Emergency / Critical Action:** Solid `#EF4444`, white label, height `48px`.

### Status Chips & Badges
- **Pill Construction:** Height `26px`, padding `0 10px`, typography `label-sm`.
- **Synced / Connected:** Background `rgba(16, 185, 129, 0.12)`, text `#047857`, leading 6px circular dot indicator.
- **Pending Review:** Background `rgba(245, 158, 11, 0.12)`, text `#B45309`, leading warning dot.
- **Alert / Abnormal:** Background `rgba(239, 68, 68, 0.12)`, text `#B91C1C`, leading alert icon.

### Form Inputs & Selectors
- **Input Fields:** Height `50px`, background `#FFFFFF`, border `1px solid #E2E8F0`, radius `12px`, padding `0 14px`.
- **Focus State:** Border color `#0284C7`, ring `0 0 0 3px rgba(2, 132, 199, 0.15)`.
- **Error State:** Border color `#EF4444`, ring `0 0 0 3px rgba(239, 68, 68, 0.15)`.

### Medical Record Cards
- **Structure:** Surface `#FFFFFF`, border `1px solid #E2E8F0`, border radius `16px`, padding `16px`.
- **Header:** Category icon in a `36x36px` soft-tinted square (`rgba(2, 132, 199, 0.08)`), record title in `headline-sm`, right-aligned status chip.
- **Body:** Key-value pairs displayed with `body-md-medium` text and `label-md` muted descriptions.

### Lists & Timeline Entries
- **Timeline Rail:** `2px` vertical line in `#E2E8F0` positioned along the left spine.
- **Node Anchor:** `12px` circular marker filled with `#0284C7` or status color, enveloped in a `4px` white perimeter border.
- **List Dividers:** Recessed divider inset matching left text margin, colored `#F1F5F9`.

### Specialized Healthcare Components
- **Vitals Summary Strip:** Horizontal scroll row of compact cards featuring small telemetry sparks, metric units, and status delta indicators.
- **Allergy Banner:** High-priority warning card at `#FEF2F2` background, `#991B1B` copy, with `1px solid #FECACA` perimeter.
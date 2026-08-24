---
name: CertifyPro
colors:
  surface: '#f8f9ff'
  surface-dim: '#cbdbf5'
  surface-bright: '#f8f9ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#eff4ff'
  surface-container: '#e5eeff'
  surface-container-high: '#dce9ff'
  surface-container-highest: '#d3e4fe'
  on-surface: '#0b1c30'
  on-surface-variant: '#44474d'
  inverse-surface: '#213145'
  inverse-on-surface: '#eaf1ff'
  outline: '#75777e'
  outline-variant: '#c5c6ce'
  surface-tint: '#4e5f7e'
  primary: '#031632'
  on-primary: '#ffffff'
  primary-container: '#1a2b48'
  on-primary-container: '#8293b5'
  inverse-primary: '#b6c7eb'
  secondary: '#775a19'
  on-secondary: '#ffffff'
  secondary-container: '#fed488'
  on-secondary-container: '#785a1a'
  tertiary: '#101721'
  on-tertiary: '#ffffff'
  tertiary-container: '#252c36'
  on-tertiary-container: '#8c93a0'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#d7e2ff'
  primary-fixed-dim: '#b6c7eb'
  on-primary-fixed: '#081b38'
  on-primary-fixed-variant: '#374765'
  secondary-fixed: '#ffdea5'
  secondary-fixed-dim: '#e9c176'
  on-secondary-fixed: '#261900'
  on-secondary-fixed-variant: '#5d4201'
  tertiary-fixed: '#dce3f1'
  tertiary-fixed-dim: '#c0c7d4'
  on-tertiary-fixed: '#151c26'
  on-tertiary-fixed-variant: '#404752'
  background: '#f8f9ff'
  on-background: '#0b1c30'
  surface-variant: '#d3e4fe'
typography:
  display-lg:
    fontFamily: Inter
    fontSize: 48px
    fontWeight: '700'
    lineHeight: 56px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Inter
    fontSize: 32px
    fontWeight: '600'
    lineHeight: 40px
    letterSpacing: -0.01em
  headline-lg-mobile:
    fontFamily: Inter
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  headline-md:
    fontFamily: Inter
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  title-lg:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 28px
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
  label-md:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.05em
rounded:
  sm: 0.125rem
  DEFAULT: 0.25rem
  md: 0.375rem
  lg: 0.5rem
  xl: 0.75rem
  full: 9999px
spacing:
  unit: 4px
  xs: 4px
  sm: 8px
  md: 16px
  lg: 24px
  xl: 40px
  gutter: 24px
  margin-mobile: 16px
  margin-desktop: 48px
  max-width: 1440px
---

## Brand & Style
The brand personality is authoritative, precise, and premium. As a tool for issuing official credentials, the design system must evoke a sense of institutional trust and professional achievement.

The design style is **Corporate / Modern** with a focus on **Refined Minimalism**. It avoids unnecessary ornamentation, instead relying on precise alignment, generous whitespace, and high-quality typography to communicate value. The aesthetic mirrors a high-end SaaS environment where data density is balanced by a clear visual hierarchy, ensuring users feel in control of the certification process.

## Colors
The palette is rooted in a deep navy blue, symbolizing stability and expertise. Professional gold is used sparingly as a high-impact accent color to denote achievement, "premium" features, or primary calls to action.

- **Primary (#1A2B48):** Used for navigation backgrounds, primary headings, and brand-critical elements.
- **Secondary (#C5A059):** Used for "Success" states in a certification context, featured buttons, and decorative accents on certificates.
- **Tertiary (#E8EFFD):** A soft blue tint used for subtle background fills, hover states, and to group related form elements without adding visual weight.
- **Neutral (#64748B):** Reserved for body text, icons, and borders to maintain a professional, low-fatigue interface.

## Typography
The system utilizes **Inter** for all roles to ensure maximum legibility and a systematic, utilitarian feel. 

- **Headlines:** Use tighter letter-spacing and heavier weights to establish a strong structural anchor for pages.
- **Body Text:** Set at a comfortable 16px for primary reading and 14px for secondary data points in tables.
- **Labels:** Use uppercase with increased letter-spacing for small-caps styles in table headers and form category titles to differentiate them from interactive text.

## Layout & Spacing
The layout follows a **Fixed Grid** approach for the dashboard content, centered within a max-width container to maintain readability on ultra-wide monitors.

- **Grid:** 12-column system for desktop, 4-column for mobile.
- **Rhythm:** An 8px base grid drives all spacing decisions.
- **Safe Zones:** Dashboard views should utilize a persistent left-hand sidebar (280px width) with content reflowing in the remaining viewport. On mobile, the sidebar transitions to a bottom-sheet or hamburger menu, and horizontal margins shrink to 16px.

## Elevation & Depth
This design system uses **Tonal Layers** and **Low-Contrast Outlines** rather than heavy shadows to maintain a "flat" professional look.

- **Surface Levels:** The background uses a very light neutral gray (#F8FAFC). Cards and containers are pure white (#FFFFFF) with a 1px border (#E2E8F0).
- **Interactive Depth:** Only the primary "Issue Certificate" buttons and active modals use a soft, highly diffused ambient shadow (10% opacity of the primary color) to indicate their importance.
- **State Changes:** On hover, cards should transition to a subtle Tertiary fill or a slightly darker border rather than lifting via shadows.

## Shapes
The shape language is **Soft**. A subtle 4px radius (0.25rem) is applied to all buttons, input fields, and small UI components. 

- **Cards/Containers:** Use `rounded-lg` (8px) to provide a gentle, modern feel without appearing "playful."
- **Data Tables:** Outer corners are rounded, but internal cell borders remain sharp to preserve the professional grid structure.

## Components
Consistent component behavior ensures the platform feels like a cohesive productivity tool.

- **Buttons:** 
  - *Primary:* Solid Navy (#1A2B48) with white text. 
  - *Accent:* Solid Gold (#C5A059) for high-tier actions. 
  - *Ghost:* Navy outline with transparent fill for secondary navigation.
- **Input Fields:** Use a 1px solid border (#E2E8F0) that thickens and changes to Navy on focus. Labels are always positioned above the field using `label-md` styling.
- **Data Tables:** High-density rows with 8px vertical padding. Use zebra-striping with the Tertiary color for improved readability across long rows.
- **Certificates (Preview):** These should be displayed in a dedicated card with a subtle 1px border and a background shadow to simulate a physical document sitting on the UI surface.
- **Chips/Badges:** Use for status indicators (e.g., "Issued," "Pending," "Revoked"). Use a desaturated version of the status color with high-contrast text for accessibility.
- **Progress Steppers:** Use for the certificate creation flow, utilizing Navy for completed steps and Gold for the active step.
---
name: Kinetic Grid
colors:
  surface: '#f3faff'
  surface-dim: '#c7dde9'
  surface-bright: '#f3faff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#e6f6ff'
  surface-container: '#dbf1fe'
  surface-container-high: '#d5ecf8'
  surface-container-highest: '#cfe6f2'
  on-surface: '#071e27'
  on-surface-variant: '#454652'
  inverse-surface: '#1e333c'
  inverse-on-surface: '#dff4ff'
  outline: '#767683'
  outline-variant: '#c6c5d4'
  surface-tint: '#4c56af'
  primary: '#000666'
  on-primary: '#ffffff'
  primary-container: '#1a237e'
  on-primary-container: '#8690ee'
  inverse-primary: '#bdc2ff'
  secondary: '#0056c5'
  on-secondary: '#ffffff'
  secondary-container: '#0f6df3'
  on-secondary-container: '#fefcff'
  tertiary: '#002108'
  on-tertiary: '#ffffff'
  tertiary-container: '#003912'
  on-tertiary-container: '#00b048'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#e0e0ff'
  primary-fixed-dim: '#bdc2ff'
  on-primary-fixed: '#000767'
  on-primary-fixed-variant: '#343d96'
  secondary-fixed: '#d9e2ff'
  secondary-fixed-dim: '#b0c6ff'
  on-secondary-fixed: '#001945'
  on-secondary-fixed-variant: '#00429b'
  tertiary-fixed: '#69ff87'
  tertiary-fixed-dim: '#3ce36a'
  on-tertiary-fixed: '#002108'
  on-tertiary-fixed-variant: '#00531e'
  background: '#f3faff'
  on-background: '#071e27'
  surface-variant: '#cfe6f2'
typography:
  headline-lg:
    fontFamily: Hanken Grotesk
    fontSize: 28px
    fontWeight: '700'
    lineHeight: 36px
    letterSpacing: -0.02em
  headline-md:
    fontFamily: Hanken Grotesk
    fontSize: 22px
    fontWeight: '600'
    lineHeight: 28px
    letterSpacing: -0.01em
  body-lg:
    fontFamily: Hanken Grotesk
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-md:
    fontFamily: Hanken Grotesk
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  label-md:
    fontFamily: Geist
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
    letterSpacing: 0.05em
  label-sm:
    fontFamily: Geist
    fontSize: 10px
    fontWeight: '600'
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
  base: 4px
  xs: 4px
  sm: 8px
  md: 16px
  lg: 24px
  xl: 32px
  container-padding: 16px
  card-gap: 12px
---

## Brand & Style

The design system is engineered for efficiency, clarity, and technical reliability. It targets an academic and professional audience, balancing the rigor of software development with the accessibility required for daily seat management. 

The visual style is **Corporate / Modern** with a lean toward **Minimalism**. It utilizes structured layouts, high-quality card components, and a rigorous adherence to a technical color palette. The emotional response should be one of "controlled productivity"—users should feel that the environment is organized, the data is accurate, and the interface is an unobtrusive tool for their workflow. 

Key visual identifiers include subtle depth via tonal layering, precision-focused typography, and high-visibility status indicators that mimic terminal or IDE syntax highlighting.

## Colors

The palette is anchored by **Deep Indigo (#1A237E)** to establish authority and professional trust. **Electric Blue (#2979FF)** serves as the primary action color, driving interaction and highlighting active states. 

**Mint Green (#00C853)** is used purposefully for "Approved" states and success confirmations. For system feedback, we introduce a vibrant Orange for "Pending" and a focused Red for "Fined" or "Error" states. **Slate Gray (#455A64)** provides a sophisticated neutral for secondary text, icons, and borders, ensuring high legibility without the harshness of pure black. Backgrounds should utilize a very light cool-gray to reduce eye strain during prolonged use.

## Typography

This design system uses **Hanken Grotesk** for all primary interfaces to maintain a contemporary, sharp, and highly legible appearance. Its geometric roots align with the technical nature of a software house.

For technical metadata, status badges, and seat coordinates, **Geist** is employed. Its monospaced-influenced proportions provide a "developer-centric" feel that differentiates data-points from narrative text. 

- **Headlines:** Reserved for page titles and section headers. Use tight letter-spacing for a modern look.
- **Body:** Optimized for readability in list views and seat descriptions.
- **Labels:** Always used for status badges (Approved, Pending, Fined) and micro-copy.

## Layout & Spacing

The layout follows a **Fluid Grid** model optimized for mobile-first interaction. It utilizes a 4px baseline shift to ensure all elements align to a consistent mathematical rhythm.

- **Margins:** A standard 16px lateral margin is maintained across all screens.
- **Gaps:** Vertical spacing between cards and list items is set to 12px to maximize information density while maintaining a clean aesthetic.
- **Safe Areas:** Adhere strictly to mobile device notches and home indicators, using the `lg` (24px) spacing unit for top-level padding below headers.
- **Touch Targets:** All interactive elements must maintain a minimum height of 48px, even if the visual container is smaller.

## Elevation & Depth

This design system uses **Tonal Layers** combined with **Low-contrast outlines**. Physical shadows are used sparingly to preserve a clean, professional "flat-plus" look.

1.  **Level 0 (Background):** Neutral light gray (#F5F7F9).
2.  **Level 1 (Cards/Surface):** Pure White (#FFFFFF) with a 1px border in a low-opacity Slate Gray (#455A64 at 12%).
3.  **Level 2 (Active/Floating):** Use a very soft, diffused ambient shadow (8px blur, 4% opacity) to indicate items being dragged or primary action buttons.

Depth is primarily communicated through color contrast rather than shadow volume. Active states should use a subtle inset tint of the primary color rather than heavy bevels.

## Shapes

The shape language is **Rounded**, using a 0.5rem (8px) base radius. This provides a approachable feel to a technical application.

- **Standard Components:** Buttons and Cards use 8px corners.
- **Status Badges:** Use a fully pill-shaped (rounded-xl) geometry to distinguish them from interactive buttons.
- **Input Fields:** Match the 8px corner radius for consistency with cards.

## Components

### Buttons
- **Primary:** Deep Indigo background, white text, 8px radius.
- **Secondary:** Transparent background, Electric Blue border (1.5px), Electric Blue text.
- **Ghost:** No background or border, Slate Gray text. Used for "Cancel" or "Back" actions.

### Status Badges
High-visibility markers using the `label-sm` typography:
- **Approved:** Mint Green background (15% opacity) with Mint Green text.
- **Pending:** Orange background (15% opacity) with Orange text.
- **Fined:** Red background (15% opacity) with Red text.

### Cards
Cards are the primary container for seat info. They feature a white background, 8px radius, and a subtle 1px border. Inside, use a 2-column layout: Seat ID/Location on the left, and Status Badge + Timestamp on the right.

### Input Fields
Filled style with a very light gray background and a 2px bottom stroke that turns Electric Blue on focus. Labels should use `label-md` and sit above the field.

### Seat Map Grid
A custom component utilizing a grid of squares.
- **Available:** White with Slate Gray border.
- **Occupied:** Deep Indigo.
- **Selected:** Electric Blue with a pulse animation.
- **Broken/Maintenance:** Slate Gray with a diagonal hatch pattern.
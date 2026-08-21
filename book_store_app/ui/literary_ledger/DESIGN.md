---
name: Literary Ledger
colors:
  surface: '#f9f9ff'
  surface-dim: '#cfdaf2'
  surface-bright: '#f9f9ff'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f0f3ff'
  surface-container: '#e7eeff'
  surface-container-high: '#dee8ff'
  surface-container-highest: '#d8e3fb'
  on-surface: '#111c2d'
  on-surface-variant: '#43474e'
  inverse-surface: '#263143'
  inverse-on-surface: '#ecf1ff'
  outline: '#74777f'
  outline-variant: '#c4c6cf'
  surface-tint: '#476083'
  primary: '#000613'
  on-primary: '#ffffff'
  primary-container: '#001f3f'
  on-primary-container: '#6f88ad'
  inverse-primary: '#afc8f0'
  secondary: '#795900'
  on-secondary: '#ffffff'
  secondary-container: '#ffbf00'
  on-secondary-container: '#6d5000'
  tertiary: '#02060a'
  on-tertiary: '#ffffff'
  tertiary-container: '#191f25'
  on-tertiary-container: '#80878e'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#d4e3ff'
  primary-fixed-dim: '#afc8f0'
  on-primary-fixed: '#001c3a'
  on-primary-fixed-variant: '#2f486a'
  secondary-fixed: '#ffdfa0'
  secondary-fixed-dim: '#fbbc00'
  on-secondary-fixed: '#261a00'
  on-secondary-fixed-variant: '#5c4300'
  tertiary-fixed: '#dde3eb'
  tertiary-fixed-dim: '#c1c7cf'
  on-tertiary-fixed: '#161c22'
  on-tertiary-fixed-variant: '#41474e'
  background: '#f9f9ff'
  on-background: '#111c2d'
  surface-variant: '#d8e3fb'
typography:
  display-lg:
    fontFamily: Hanken Grotesk
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
    letterSpacing: -0.02em
  headline-md:
    fontFamily: Hanken Grotesk
    fontSize: 24px
    fontWeight: '600'
    lineHeight: 32px
  title-sm:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: '600'
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
  label-mono:
    fontFamily: JetBrains Mono
    fontSize: 11px
    fontWeight: '500'
    lineHeight: 14px
    letterSpacing: 0.05em
  data-table-header:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
rounded:
  sm: 0.125rem
  DEFAULT: 0.25rem
  md: 0.375rem
  lg: 0.5rem
  xl: 0.75rem
  full: 9999px
spacing:
  unit: 4px
  container-padding: 24px
  gutter: 16px
  stack-dense: 8px
  stack-comfortable: 16px
---

## Brand & Style
The design system is engineered for the high-utility environment of local bookstore and stationery management. The brand personality is authoritative, organized, and reliable, mirroring the systematic nature of inventory management while retaining the warmth of a local shop.

The visual style is **High-Contrast Modernism**. It prioritizes information density and operational speed over decorative whitespace. The UI utilizes sharp clarity, structured grids, and distinct color-coding to ensure that staff can process transactions, manage stock levels, and review analytics with zero ambiguity. The aesthetic is professional and "utilitarian-premium," favoring crisp edges and logical information hierarchies.

## Colors
The palette is built on a foundation of high-contrast stability.

- **Primary (Deep Navy):** Used for global navigation, primary actions, and structural headers to instill a sense of institutional trust.
- **Secondary (Warm Amber):** Reserved strictly for high-priority calls to action, pending alerts, and critical highlights (e.g., "Low Stock"). This color provides maximum "pop" against the navy and slate.
- **Neutral (Slate/White):** A scale of cool grays provides the background for data tables and secondary information, reducing eye strain during long shifts.
- **Semantic Colors:** Success (Green), Error (Red), and Warning (Orange) are used with high saturation to ensure status badges are immediately glanceable in dense lists.

## Typography
The typography system is optimized for "scanning" rather than long-form reading. 

- **Headlines:** Use **Hanken Grotesk** for its contemporary, sharp terminals. It provides a modern, professional look for page titles and section headers.
- **Body & Data:** **Inter** is the workhorse font, selected for its exceptional legibility at small sizes within dense data tables and inventory lists.
- **Technical Labels:** **JetBrains Mono** is utilized for SKUs, ISBN numbers, and price tags. The monospaced nature ensures that numeric digits align vertically in lists, making price comparisons and code scanning effortless for the eye.

## Layout & Spacing
This design system employs a **4px baseline grid** to achieve high information density. 

- **Layout Model:** A 12-column fluid grid is used for the desktop dashboard. On mobile, the layout collapses to a single column with a bottom-docked navigation bar for ergonomic thumb reach.
- **Density:** To maximize the number of visible rows in inventory views, vertical padding in tables is reduced to `8px` (stack-dense). 
- **Margins:** Main page containers use `24px` margins on desktop to provide some "breathing room" at the edges, while internal component spacing remains tight.

## Elevation & Depth
The design system avoids heavy shadows to maintain a "flat and fast" feel. Depth is communicated through **Tonal Layers and Low-Contrast Outlines**.

- **Surfaces:** The primary background is a very light slate. Cards and data containers use a pure white background with a `1px` border in `#E2E8F0`.
- **Interactivity:** Elements only "lift" slightly on hover using a subtle, low-blur shadow (`0px 4px 12px rgba(0, 31, 63, 0.08)`).
- **Separation:** High-contrast borders are used to distinguish global navigation from the workspace. This "contained" look helps the user focus on the task at hand without visual bleed.

## Shapes
The shape language is **Soft (0.25rem)**. 

Geometric precision is key. Sharp corners are avoided to prevent the UI from feeling "aggressive," but large radii are also avoided to ensure maximum space efficiency for text and data. Buttons, input fields, and chips all share a consistent `4px` (0.25rem) radius. Status badges and tags may use a slightly higher radius (`rounded-lg`) to differentiate them as discrete interactive or informative tokens.

## Components

### Buttons
- **Primary:** Deep Navy background with white text. Bold, sans-serif.
- **Action (Secondary):** Warm Amber background with navy text. Used for "Add to Cart," "Complete Sale," or "Save Changes."
- **Ghost:** Navy border and navy text for tertiary actions like "Cancel" or "Print Receipt."

### Data Tables (The Core)
- **Header:** Slate background with uppercase, semi-bold text.
- **Rows:** Alternating "Zebra" stripes (White / Lightest Gray) for better horizontal tracking.
- **Cell Content:** Left-aligned for text (Book Titles), right-aligned for numbers (Prices, Stock Count).

### Status Badges
- **Low Stock:** Amber background, navy text, accompanied by a small alert icon.
- **Out of Stock:** Red background, white text.
- **In Stock:** Subtle green border with green text (not filled, to reduce visual noise).

### Input Fields
- Use a `1px` solid border. When focused, the border transitions to Deep Navy with a `2px` stroke. Labels are always visible above the field in `label-mono` style.

### Cards
- High-contrast containers with clear headers. Used for "Daily Sales Summary" or "Top Selling Categories." Every card must have a defined `1px` border to maintain the grid's structural integrity.
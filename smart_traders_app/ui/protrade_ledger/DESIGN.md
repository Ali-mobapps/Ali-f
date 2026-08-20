---
name: ProTrade Ledger
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
  on-surface-variant: '#44474f'
  inverse-surface: '#263143'
  inverse-on-surface: '#ecf1ff'
  outline: '#75777f'
  outline-variant: '#c5c6d0'
  surface-tint: '#495e8a'
  primary: '#00020a'
  on-primary: '#ffffff'
  primary-container: '#001b44'
  on-primary-container: '#7084b3'
  inverse-primary: '#b1c6f9'
  secondary: '#bb0114'
  on-secondary: '#ffffff'
  secondary-container: '#e02929'
  on-secondary-container: '#fffbff'
  tertiary: '#010203'
  on-tertiary: '#ffffff'
  tertiary-container: '#1a1d1f'
  on-tertiary-container: '#828587'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#d8e2ff'
  primary-fixed-dim: '#b1c6f9'
  on-primary-fixed: '#001a42'
  on-primary-fixed-variant: '#314671'
  secondary-fixed: '#ffdad6'
  secondary-fixed-dim: '#ffb4ab'
  on-secondary-fixed: '#410002'
  on-secondary-fixed-variant: '#93000d'
  tertiary-fixed: '#e0e3e5'
  tertiary-fixed-dim: '#c4c7c9'
  on-tertiary-fixed: '#191c1e'
  on-tertiary-fixed-variant: '#444749'
  background: '#f9f9ff'
  on-background: '#111c2d'
  surface-variant: '#d8e3fb'
typography:
  headline-lg:
    fontFamily: Hanken Grotesk
    fontSize: 32px
    fontWeight: '700'
    lineHeight: 40px
  headline-lg-mobile:
    fontFamily: Hanken Grotesk
    fontSize: 24px
    fontWeight: '700'
    lineHeight: 32px
  headline-md:
    fontFamily: Hanken Grotesk
    fontSize: 20px
    fontWeight: '600'
    lineHeight: 28px
  body-lg:
    fontFamily: Hanken Grotesk
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-sm:
    fontFamily: Hanken Grotesk
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  label-caps:
    fontFamily: JetBrains Mono
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
    letterSpacing: 0.05em
  data-tabular:
    fontFamily: JetBrains Mono
    fontSize: 14px
    fontWeight: '500'
    lineHeight: 20px
rounded:
  sm: 0.125rem
  DEFAULT: 0.25rem
  md: 0.375rem
  lg: 0.5rem
  xl: 0.75rem
  full: 9999px
spacing:
  container-margin: 1rem
  stack-gap: 1.5rem
  grid-gutter: 0.75rem
  input-padding: 1rem
  table-cell-padding: 0.75rem 0.5rem
---

## Brand & Style

This design system is built for a high-utility mobile invoice generator, prioritizing efficiency, clarity, and industrial reliability. The brand personality is authoritative yet modern, borrowing from the "Corporate / Modern" aesthetic with subtle "Brutalism" influences in its structural grid and table-heavy layouts.

The target audience includes traders, logistics managers, and small business owners who require rapid data entry and clear financial summaries. The UI evokes a sense of organized precision through a high-contrast palette, generous whitespace, and a clear hierarchy that guides the user through the invoice creation process without visual distraction.

## Colors

The palette is derived directly from the "Poultry Smart Traders" visual identity, optimized for digital screens.

- **Primary (Deep Navy):** Used for headers, primary action buttons, and critical structural elements like table headers. It represents stability and professional trust.
- **Secondary (Vibrant Red):** Reserved for accenting critical data (e.g., total due), call-to-actions that require immediate attention, and error states.
- **Surface (Tertiary/White):** A stark white background ensures maximum legibility. The tertiary light grey is used for subtle grouping containers and row zebra-striping.
- **Neutral (Slate):** Used for secondary text, labels, and borders to maintain a professional, subdued tone compared to the primary navy.

## Typography

The system utilizes **Hanken Grotesk** for its sharp, contemporary feel and excellent readability in dense forms. For data-heavy contexts like invoice numbers, quantities, and prices, **JetBrains Mono** is employed to ensure character distinction and vertical alignment in tables.

- **Headlines:** Bold and concise. Use Navy for main titles and Slate for section subtitles.
- **Data Display:** All numerical values in the invoice generator must use the `data-tabular` style (JetBrains Mono) to prevent layout shifting when numbers change.
- **Labels:** Small caps with slight tracking are used for form field labels to differentiate them clearly from user-entered text.

## Layout & Spacing

The layout follows a **Fluid Grid** model optimized for mobile-first workflows. 

- **Structure:** Content is housed in a single-column stack on mobile, expanding to a multi-column "Invoicing Dashboard" on tablets.
- **Grid:** Use a 4-column grid for mobile and 12-column for tablet. Gutters are kept tight (12px) to maximize horizontal space for data tables.
- **Rhythm:** A vertical 8px baseline grid ensures consistent spacing between form fields and list items. 
- **Grouping:** Use the Secondary Surface (light grey) to group related inputs (e.g., Client Information) with 16px internal padding.

## Elevation & Depth

To maintain a "clean and professional" look, this design system avoids heavy shadows, instead using **Tonal Layers** and **Bold Outlines**.

- **Level 0 (Base):** White background.
- **Level 1 (Cards/Containers):** Light grey (#F8FAFC) background with a 1px solid border (#E2E8F0).
- **Level 2 (Active States):** Only primary buttons or floating action buttons (FAB) utilize a very subtle, low-opacity navy shadow to indicate interactability.
- **Structural Lines:** Use 1px or 2px solid lines in Primary Navy for table headers and section dividers, echoing the physical printed invoice style.

## Shapes

The shape language is "Soft" (4px - 8px radius) to balance the clinical nature of financial data with a modern app feel. 

- **Forms & Inputs:** Use the standard `rounded` (4px) setting for a crisp, organized appearance.
- **Primary Buttons:** May use `rounded-lg` (8px) to distinguish them as the primary touch targets.
- **Table Rows:** Should remain sharp (0px) or utilize very minimal rounding to maintain the "grid" integrity of a ledger.

## Components

### Buttons
- **Primary:** Deep Navy background, White text, Bold Hanken Grotesk. Full-width on mobile.
- **Secondary/Ghost:** Transparent background, Navy 1px border, Navy text.
- **Destructive:** Vibrant Red background, White text (use sparingly for "Delete Invoice").

### Form Inputs
- **Text Fields:** White background, 1px Slate border. On focus, the border thickens to 2px Primary Navy.
- **Labels:** Positioned above the field in `label-caps` JetBrains Mono for a technical, ledger-like look.

### Data Tables
- **Header:** Primary Navy background, White `label-caps` text.
- **Rows:** Alternating zebra-stripes (White and Light Grey).
- **Columns:** Right-align all numerical values (Price, Quantity, Total) using JetBrains Mono for alignment.

### Status Chips
- **Paid:** Green tint with dark green text.
- **Pending:** Slate tint with dark slate text.
- **Overdue:** Red tint with dark red text.

### Summary Card
- Positioned at the bottom of the screen or invoice, using a Primary Navy top-border (3px) to anchor the total amount due in Large Bold Navy or Red text.
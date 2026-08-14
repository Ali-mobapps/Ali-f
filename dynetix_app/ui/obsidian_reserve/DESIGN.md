---
name: Obsidian Reserve
colors:
  surface: '#131313'
  surface-dim: '#131313'
  surface-bright: '#3a3939'
  surface-container-lowest: '#0e0e0e'
  surface-container-low: '#1c1b1b'
  surface-container: '#201f1f'
  surface-container-high: '#2a2a2a'
  surface-container-highest: '#353534'
  on-surface: '#e5e2e1'
  on-surface-variant: '#d0c5af'
  inverse-surface: '#e5e2e1'
  inverse-on-surface: '#313030'
  outline: '#99907c'
  outline-variant: '#4d4635'
  surface-tint: '#e9c349'
  primary: '#f2ca50'
  on-primary: '#3c2f00'
  primary-container: '#d4af37'
  on-primary-container: '#554300'
  inverse-primary: '#735c00'
  secondary: '#d3c5ad'
  on-secondary: '#382f1e'
  secondary-container: '#524835'
  on-secondary-container: '#c5b79f'
  tertiary: '#bfcdff'
  on-tertiary: '#082b72'
  tertiary-container: '#97b0ff'
  on-tertiary-container: '#254188'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#ffe088'
  primary-fixed-dim: '#e9c349'
  on-primary-fixed: '#241a00'
  on-primary-fixed-variant: '#574500'
  secondary-fixed: '#f0e0c8'
  secondary-fixed-dim: '#d3c5ad'
  on-secondary-fixed: '#221b0b'
  on-secondary-fixed-variant: '#4f4533'
  tertiary-fixed: '#dbe1ff'
  tertiary-fixed-dim: '#b4c5ff'
  on-tertiary-fixed: '#00174b'
  on-tertiary-fixed-variant: '#27438a'
  background: '#131313'
  on-background: '#e5e2e1'
  surface-variant: '#353534'
  obsidian: '#0A0A0A'
  charcoal-depth: '#1A1A1A'
  champagne-gold: '#D4AF37'
  soft-ivory: '#F7E7CE'
  glass-border: rgba(255, 255, 255, 0.1)
typography:
  headline-xl:
    fontFamily: Hanken Grotesk
    fontSize: 64px
    fontWeight: '700'
    lineHeight: '1.1'
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Hanken Grotesk
    fontSize: 40px
    fontWeight: '600'
    lineHeight: '1.2'
    letterSpacing: -0.01em
  headline-lg-mobile:
    fontFamily: Hanken Grotesk
    fontSize: 32px
    fontWeight: '600'
    lineHeight: '1.2'
  body-lg:
    fontFamily: Inter
    fontSize: 18px
    fontWeight: '400'
    lineHeight: '1.6'
  body-md:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: '1.6'
  label-sm:
    fontFamily: JetBrains Mono
    fontSize: 12px
    fontWeight: '500'
    lineHeight: '1.0'
    letterSpacing: 0.1em
rounded:
  sm: 0.125rem
  DEFAULT: 0.25rem
  md: 0.375rem
  lg: 0.5rem
  xl: 0.75rem
  full: 9999px
spacing:
  unit: 8px
  container-max: 1280px
  gutter: 24px
  margin-mobile: 20px
  section-gap: 120px
---

## Brand & Style
The design system embodies an "Elite Intelligence" persona. It is tailored for high-stakes professionals in tech, creative, and business sectors who value discretion, precision, and prestige. 

The aesthetic is **Premium Minimalist with Glassmorphic accents**. It avoids loud, aggressive marketing tactics in favor of "quiet luxury." The interface should feel like a high-end physical concierge or a private member's club—refined, spacious, and meticulously curated. High-quality imagery should use low-key lighting and deep shadows to maintain the mysterious yet professional atmosphere.

## Colors
The palette is centered on **Obsidian (#0A0A0A)** as the primary canvas to create a sense of infinite depth. 

- **Primary (Champagne Gold):** Used sparingly for call-to-action elements, active states, and high-value highlights.
- **Secondary (Soft Ivory):** Used for primary text and icons to ensure high legibility against dark backgrounds without the harshness of pure white.
- **Neutral (Charcoal):** Used for surface layering and container backgrounds to define structure without breaking the dark-mode immersion.
- **Accents:** Gradients should be subtle, transitioning from a muted gold to a transparent finish to simulate light hitting a metallic surface.

## Typography
The typography strategy blends the modern precision of **Hanken Grotesk** for headlines with the functional clarity of **Inter** for long-form content. 

- **Headlines:** Feature tight letter-spacing and substantial weight to command authority.
- **Labels:** We use **JetBrains Mono** for small labels, course codes, or technical metadata to inject a subtle "tech-forward" feel that contrasts against the more organic sans-serifs.
- **Rhythm:** Generous line-heights are essential to maintain the "premium" feel of breathing room. Never crowd text elements.

## Layout & Spacing
The layout follows a **Fixed Grid** philosophy for desktop to ensure the "boutique" feel remains controlled and cinematic. 

- **Grid:** A 12-column grid with wide gutters (24px) allows for asymmetrical layouts that feel like a high-end editorial magazine.
- **Vertical Rhythm:** Use exaggerated vertical spacing (Section gaps of 120px+) to separate different service offerings, allowing the user to focus on one "premium" module at a time.
- **Mobile:** Transition to a single-column layout with 20px side margins, maintaining the same vertical breathing room relative to the screen height.

## Elevation & Depth
Depth is conveyed through **Glassmorphism** and **Tonal Layering** rather than traditional heavy shadows.

- **Surface Tiers:** Background is Obsidian (#0A0A0A). Containers are Charcoal (#1A1A1A) with a very subtle 1px border of `glass-border`.
- **Glass Effects:** For floating menus and modal cards, use a `backdrop-filter: blur(20px)` with a slightly transparent charcoal background.
- **Shadows:** Use "Ambient Glows" instead of drop shadows. For active elements, apply a very soft, low-opacity gold outer glow (`rgba(212, 175, 55, 0.15)`) to simulate a backlight.

## Shapes
The design system uses a **Soft (0.25rem)** roundedness. This "near-sharp" approach communicates precision, discipline, and professional rigor. 

- **Primary Buttons:** Use a slightly higher roundedness (0.5rem) to make them more inviting and tactile.
- **Cards & Sections:** Keep to the base 4px (0.25rem) radius to maintain a structural, architectural appearance.
- **Media:** Photography and video containers should have the same 4px radius to ensure a cohesive look.

## Components

### Buttons
- **Primary:** Champagne Gold background with Obsidian text. No border. High-gloss finish.
- **Secondary:** Transparent background with a 1px Champagne Gold border. Text in Champagne Gold.
- **Ghost:** Soft Ivory text with no border. Underline appears only on hover.

### Cards (Courses & Services)
- Cards use the glassmorphic style: Charcoal background, 10% opacity white border, and a subtle inner glow. 
- Hover state: The 1px border transitions from white-transparent to solid Champagne Gold.

### Input Fields
- Underline style preferred over boxed inputs. 
- Active state: The underline expands from the center in Champagne Gold.
- Placeholder text: Muted charcoal-gray to keep the interface clean.

### Lists & Navigation
- Navigation items use the **Label-SM** typography (JetBrains Mono).
- Active links are indicated by a small gold dot beneath the text rather than a full bar.

### Specialized Components
- **The "Vault" Card:** For premium academy courses, use a dark-gradient background with a subtle metallic texture overlay to differentiate "VIP" content from standard services.
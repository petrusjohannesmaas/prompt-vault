# Design System Specification: The Precision Archive

## 1. Overview & Creative North Star
The design system is guided by a Creative North Star entitled **"The Precision Archive."** 

Moving beyond the generic utility of standard documentation tools, this system adopts a high-end editorial approach to technical organization. It rejects the "template" look characterized by rigid grids and heavy borders. Instead, it utilizes intentional asymmetry, tonal depth, and a sophisticated layering of surfaces to create an environment that feels both expansive and hyper-organized. We are not just building a vault; we are building a professional workbench for the modern prompt engineer.

## 2. Colors & Tonal Architecture
The palette is rooted in a deep, cinematic slate (`#111317`) contrasted against "Electric Indigo" accents. This creates a focused, low-strain environment where content is the protagonist.

### The Surface Hierarchy
Depth is achieved through background shifts rather than structural lines.
*   **Base Layer:** `surface` (#111317) for the primary application canvas.
*   **Sectioning:** Use `surface-container-low` (#1a1c20) for large sidebar areas and `surface-container` (#1e2024) for main content blocks.
*   **The "No-Line" Rule:** Designers are strictly prohibited from using 1px solid borders to define sections. You must separate global UI areas (Sidebars, Headers, Main Content) solely through shifts in the surface-container tiers.
*   **The Glass & Gradient Rule:** For main CTAs or high-level navigation headers, use a subtle linear gradient transitioning from `primary` (#c1c1ff) to `primary-container` (#5d5cff). For floating overlays, apply a `surface-bright` (#37393e) color with a 20px backdrop-blur to achieve a "frosted glass" effect.

## 3. Typography
We utilize **Inter** as our typographic workhorse. To achieve an editorial feel, we prioritize high-contrast scales and generous leading.

*   **Display (lg/md/sm):** Reserved for hero moments or empty state headers. Use `display-lg` (3.5rem) with -2% tracking to feel authoritative.
*   **Headlines & Titles:** `headline-sm` (1.5rem) should be used for section titles. Ensure a minimum of 48px vertical space above headlines to allow the "Archive" to breathe.
*   **Body (lg/md/sm):** Use `body-md` (0.875rem) as the default for prompt text to maximize density without sacrificing readability.
*   **Labels:** `label-sm` (0.6875rem) should always be uppercase with +5% letter spacing when used for metadata or tags to provide a technical, "engineered" aesthetic.

## 4. Elevation & Depth (The Layering Principle)
In this design system, depth is a physical reality, not a visual effect.

*   **Tonal Layering:** Hierarchy is built by "stacking." A card (`surface-container-highest`) sitting on a section (`surface-container-low`) creates an immediate, soft lift.
*   **Ambient Shadows:** For floating elements (Modals, Popovers), use extra-diffused shadows. 
    *   *Shadow Property:* `0 20px 40px rgba(12, 14, 18, 0.4)`. The shadow color must be a tinted version of `surface-container-lowest`, never a neutral grey.
*   **The Ghost Border Fallback:** If a border is required for accessibility, use the `outline-variant` (#464556) at **15% opacity**. This creates a "Ghost Border" that defines a shape without interrupting the visual flow.
*   **Roundedness Scale:**
    *   `DEFAULT`: 0.5rem (8px) for standard cards and buttons.
    *   `xl`: 1.5rem (24px) for large container groupings to soften the technical edge.

## 5. Components

### Buttons
*   **Primary:** Background: `primary` (#c1c1ff) | Text: `on-primary` (#1500a8). High-gloss finish with a subtle top-down gradient.
*   **Secondary:** Background: `surface-container-highest` | Text: `on-surface`.
*   **Tertiary:** No background. Text: `primary`. Use for low-emphasis actions within dense lists.

### Prompt Cards
Forbid the use of dividers. Use `surface-container-low` for the card body. Upon hover, transition the background to `surface-container-high` and apply the **Ghost Border**.
*   **Content Spacing:** Use 24px internal padding (1.5rem) to ensure the prompt text feels premium and uncrowded.

### Input Fields
*   **Default State:** Background: `surface-container-highest` (#333539).
*   **Focus State:** Apply a 1px "Ghost Border" using `surface-tint` and a 4px soft outer glow of the same color at 10% opacity. 

### Chips & Tags
*   **Action Chips:** Use `secondary-container` (#404188) with `on-secondary-container` (#b1b1ff).
*   **Status Chips:** Use `tertiary-container` (#bf5200) for "Draft" or "Warning" states to provide a warm, non-confrontational highlight.

### Lists
Lists must never use horizontal dividers. Instead, utilize the `surface-container` tiers or a 12px vertical gap between items. This maintains the "Precision Archive" look by treating every list item as a distinct, modular asset.

## 6. Do's and Don'ts

### Do:
*   **Do** use `surface-container-lowest` for the absolute background of nested code blocks to create a "recessed" look.
*   **Do** lean into white space. If a layout feels cluttered, increase the gap between containers rather than adding a border.
*   **Do** use `on-surface-variant` (#c7c4d8) for secondary text to maintain a soft hierarchy.

### Don't:
*   **Don't** use 100% opaque, high-contrast borders. They break the "Glass" illusion.
*   **Don't** use standard "drop shadows" with 0 blur. Shadows must feel like ambient light.
*   **Don't** mix more than two `surface-container` shifts in a single view, or the interface will feel chaotic rather than layered.
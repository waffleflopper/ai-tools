# Details and accessibility

Underlines, selection, forms, decorative text and the floors that keep everything readable.

## Underlines

Default underline position is browser-determined, sometimes too close, sometimes cutting through descenders, sometimes too thin. Pull position and thickness from the font's own metrics:

```css
a {
  text-underline-position: from-font;
  text-decoration-thickness: from-font;
}
```

A dotted underline on an abbreviation:

```css
abbr {
  text-decoration: underline dotted;
}
```

Or tune manually:

```css
a {
  text-decoration-thickness: 1px;
  text-underline-offset: 3px;
  text-decoration-skip-ink: auto;
  text-decoration-color: var(--color-gray-1000);
  transition: text-decoration-color 200ms ease-out;
}

a:hover {
  text-decoration-color: var(--color-gray-1200);
}
```

Animate the custom element however the effect requires.

## Selection

- `::target-text` styles the phrase a shared link scrolls to.
- The Custom Highlight API styles ranges you pick yourself, like search matches, without extra markup.

## Forms and editable text

- `::placeholder` styles the hint in an empty field.
- `caret-color` colors the blinking insertion bar. Color is about as far as caret styling goes; a fully custom caret is hard to build and rarely worth it.

### iOS input zoom

Safari may zoom focused inputs with smaller text. Prefer the project's readable mobile input pattern and preserve user zoom. The two approaches below have different readability and layout tradeoffs; verify the chosen behavior on the supported Safari version.

**Size up on mobile.** The input renders at `16px` on small screens and drops to the design size from the `sm` breakpoint up. Nothing to compensate, but the mobile input no longer matches the desktop one.

```tsx
<input className="text-base sm:text-sm" type="email" />
```

**Scale the text down only when the design requires it.** A `16px` declared font size can avoid size-triggered focus zoom, while a transform renders smaller text. This does not guarantee zoom behavior or readability; verify both on the target browser. The approach also needs two compensating calculations. Widen the element by the inverse of the scale so it still fills its container once shrunk, and divide `line-height` by the same factor so the intended leading survives. `origin-left` pins the text to the start edge, `origin-right` under RTL. Above the breakpoint, drop the transform and set the real size.

```tsx
// 13px rendered from a 16px font-size: 13 / 16 = 0.8125
<div className="flex h-10 items-center rounded-[10px] bg-gray-300 px-2.5">
  <input
    className="h-full w-[calc(100%/0.8125)] origin-left scale-[0.8125] bg-transparent text-base leading-[calc(1.125/0.8125)] sm:w-full sm:scale-100 sm:text-[13px]"
    type="email"
  />
</div>
```

The transform shrinks the whole box, not only the glyphs, so let a wrapper draw the field's surface and keep the input transparent. Preserve the native focus indicator as this example does, or reuse the project's tested focus treatment. If styling focus on the wrapper, ensure input focus visibly activates it. Verify focus visibility and the hit area after scaling; do not remove the outline without a working replacement.

## Decorative text

| Property | Effect |
| --- | --- |
| `::first-letter` | Drop cap, widely supported |
| `::first-line` | Styles only the first line |
| `initial-letter` | Sizes the drop cap; limited support, no Firefox yet |
| `background-clip: text` | Clips a background or gradient to the letter shapes |
| `-webkit-text-stroke` | Outlines the letters; works across modern browsers despite the prefix |
| `text-shadow` | Like `box-shadow` but follows the character shapes |

A text stroke drawing lines inside the letters is the font. The stroke traces every contour, and variable fonts usually keep overlapping shapes unmerged. Static fonts do not have this issue.

## Sizes

Typography must survive the reader changing it: zoom, a larger browser font size, an overridden line height or letter spacing.

| Text | Size |
| --- | --- |
| Long-form body starting point | Around `16px`, verified in the actual typeface and measure |
| Inputs and menus starting point | Around `14px` |
| Captions | `13px` |
| Floor | Rarely below `12px` |

## Font smoothing

Tailwind's `antialiased` sets both properties:

```css
html {
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}
```

```tsx
<html lang="en">
  <body class="font-sans antialiased">
    <main>{children}</main>
  </body>
</html>
```

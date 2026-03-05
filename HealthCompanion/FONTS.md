# Open Sans Font Setup

The app uses **Open Sans** (Google Fonts, SIL Open Font Licence).

## Steps to add fonts to the Xcode project

1. Download Open Sans from https://fonts.google.com/specimen/Open+Sans
2. Extract the following `.ttf` files from the download:
   - `OpenSans-Light.ttf`
   - `OpenSans-Regular.ttf`
   - `OpenSans-Italic.ttf`
   - `OpenSans-SemiBold.ttf`
   - `OpenSans-Bold.ttf`
   - `OpenSans-ExtraBold.ttf`
3. Drag all six files into Xcode → `HealthCompanion/Resources/Fonts/`
   - Make sure **"Copy items if needed"** is checked
   - Make sure **"Add to target: HealthCompanion"** is checked
4. The `Info.plist` already has the `UIAppFonts` array registered — no further changes needed.
5. Build & run. If fonts do not load, verify the file names exactly match those listed above.

## Colour palette — Pastel Garden

| Name        | Hex       | Used for                              |
|-------------|-----------|---------------------------------------|
| Deep Rose   | `#C75F71` | Primary accent, vitals, key actions   |
| Blush Pink  | `#F0B8B8` | Backgrounds, labs, soft highlights    |
| Sage Green  | `#A2AE9D` | Appointments, clinical sections       |
| Warm Brown  | `#54463A` | Text, prescriptions, medical history  |

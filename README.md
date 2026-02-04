# SCH-Hud Reworked (v1.4)

SCH-Hud Reworked is an enhanced version of the original SCH-Hud addon created by neonrage. This addon displays a book on your screen, offering an immersive interface to track your stratagem charges and cooldown timers.

---

## Original Credits

- Thanks to neonrage for the original SCH-Hud addon.
- Original repository link: [SCH-Hud](https://github.com/neon-rage/sch-hud)

---

## Base Features

- The book interface visualizes stratagem information:
  - Left page shows the number of available stratagems.
  - Right page displays the recast timer for the next stratagem.
- The book changes color depending on active Arts:
  - Dark Arts: Purple book with a purple glow when Addendum: Black is active.
  - Light Arts: White book with a yellow glow when Addendum: White is active.
- Originally, the addon was designed to work only when SCH was the main job.

---
## Bug Fixes (Version 1.4)
Changed the way text primitives are drawn and unloaded so that the addon unloads cleanly (for example, when changing jobs)


--


## New Features and Enhancements (Version 1.3)

### New In-Game Commands

Added support for user commands to easily adjust HUD settings without modifying the Lua file.

Use these commands in the Windower console:

- **Display help:**
  ```
  //schud help
  ```
- **Adjust HUD scale:**
  ```
  //schud scale <number>
  ```
  Example:
  ```
  //schud scale 1.2
  ```
- **Move the HUD position:**
  ```
  //schud pos <x> <y>
  ```
  Example:
  ```
  //schud pos 900 1050
  ```

These settings are now saved and persist after reloading the addon.

---

### Bug Fixes and Improvements

- Fixed errors occurring in Odyssey Sheol Gaol and Dynamis Dreamworld where the game restricts or removes the sub job, setting it to level 0.
- Improved auto-display management to ensure the HUD only appears when SCH is active as a main or sub job.
- Refactored graphic scaling and positioning for a cleaner visual experience.

---

## Customization

You no longer need to modify the Lua file to adjust position and scale. Use the in-game commands (see above) to set your preferences.

---

## Installation

1. **Extract the Folder:**
   Extract the `Sch-Hud-Reworked` folder into:

   ```
   Windower/addons/
   ```

2. **Auto-Load on Startup:**
   Add the following line to your `init.txt` in:

   ```
   Windower/scripts/init.txt
   ```

   ```
   lua load Sch-Hud-Reworked
   ```

3. **Manual Load (In-Game):**
   Use these commands in the Windower console:

   ```
   /lua load Sch-Hud-Reworked
   ```

   or

   ```
   /lua l Sch-Hud-Reworked
   ```

4. **Reload After Changes:**
   ```
   /lua reload Sch-Hud-Reworked
   ```
   This ensures your changes take effect.

---

## HUD Color Modes

### Dark Arts:

![Dark Arts](https://i.imgur.com/8rAO6CH.png)

### Addendum Black:

![Addendum Black](https://i.imgur.com/SIti4Qg.png)

### Light Arts:

![Light Arts](https://i.imgur.com/EOPaFdY.png)

### Addendum White:

![Addendum White](https://i.imgur.com/dxxXET8.png)

### Example of In-Game Render:

![In-Game Screenshot](https://i.imgur.com/ChfPOJc.png)

---

## Troubleshooting

If the HUD resets its position after reload, make sure:

- You use the correct in-game commands (`//schud pos` and `//schud scale`).
- The addon has write permissions in `data/settings.xml`.
- Windower is running with admin privileges if needed.

---

SCH-Hud Reworked v1.3 is now more customizable, reliable, and immersive than ever. Let us know if you encounter any issues or have suggestions for improvements.

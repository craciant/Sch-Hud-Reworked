# SCH-Hud Reworked (v1.3)

SCH-Hud Reworked is an enhanced version of the original SCH-Hud addon created by neonrage.  
This addon displays a book on your screen, offering an immersive interface to track your **stratagem charges** and **cooldown timers**.

---

## 🏆 Original Credits:

- Thanks to **neonrage** for the original SCH-Hud addon.
- Original repository link: [SCH-Hud](https://github.com/neon-rage/sch-hud)

---

## 📝 Base Features (from the original SCH-Hud):

- The **book interface** visualizes stratagem information:
  - **Left page** → Shows the number of available stratagems.
  - **Right page** → Displays the recast timer for the next stratagem.
- The book changes color depending on active **Arts**:
  - **Dark Arts** → Purple book, with a purple glow when **Addendum: Black** is active.
  - **Light Arts** → White book, with a yellow glow when **Addendum: White** is active.
- Originally, the addon was designed to work **only when SCH was your main job**.

---

## ✨ New Features and Enhancements (Version 1.3):

### 💩 **New In-Game Commands**

Added support for user commands to easily adjust HUD settings **without modifying the Lua file**.

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

💾 **These settings are now saved and persist after reloading the addon!**

---

### 💩 **Bug Fixes and Improvements**

- **Fixed HUD disappearing in Odyssey Sheol Gaol** when the sub job is forcibly set to level 0.
- **Fixed issues in Dynamis Dreamworld** where the sub job is absent or restricted.
- **Improved auto-display management** to ensure the HUD only appears when SCH (main or sub) is active.
- **Refactored graphic scaling & positioning** for a cleaner visual experience.

---

## 🎨 Customization:

You **no longer** need to modify the Lua file to adjust position and scale.  
Use the in-game commands (see above) to set your preferences.

---

## 📝 Installation:

1️⃣ **Extract the Folder:**  
Extract the `Sch-Hud-Reworked` folder into:

```
Windower/addons/
```

2️⃣ **Auto-Load on Startup:**  
Add the following line to your `init.txt` in:

```
Windower/scripts/init.txt
```

```
lua load Sch-Hud-Reworked
```

3️⃣ **Manual Load (In-Game):**  
Use these commands in the Windower console:

```
/lua load Sch-Hud-Reworked
```

or the shorter version:

```
/lua l Sch-Hud-Reworked
```

4️⃣ **Reload After Changes:**  
After adjusting settings, reload the addon:

```
/lua reload Sch-Hud-Reworked
```

This ensures your changes take effect.

---

## 🖼️ HUD Color Modes:

### **Dark Arts:**

![Dark Arts](https://i.imgur.com/8rAO6CH.png)

### **Addendum Black:**

![Addendum Black](https://i.imgur.com/SIti4Qg.png)

### **Light Arts:**

![Light Arts](https://i.imgur.com/EOPaFdY.png)

### **Addendum White:**

![Addendum White](https://i.imgur.com/dxxXET8.png)

### **Example of In-Game Render:**

![In-Game Screenshot](https://i.imgur.com/ChfPOJc.png)

---

## 🔧 Troubleshooting:

If the HUD resets its position after reload, make sure:

- You use the correct in-game commands (`//schud pos` and `//schud scale`).
- The addon has write permissions in `data/settings.xml`.
- Windower is running with admin privileges (if needed).

---

🚀 **SCH-Hud Reworked v1.3 is now more customizable, reliable, and immersive than ever!**  
Let us know if you encounter any issues or have suggestions for improvements.

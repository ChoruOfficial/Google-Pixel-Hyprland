# 🌌 Exocore System Engine v1.4

### Pixel-Inspired Hyprland Desktop Environment

A **performance-focused Hyprland configuration** built around **Google
Pixel design principles**, glass UI, and a Node.js powered system
engine.

Developed by **Choru Official**

------------------------------------------------------------------------

## 🧠 System Overview

**Exocore** is a desktop orchestration layer for Hyprland.

Instead of static dotfiles, the system runs a **Node.js control engine**
that synchronizes multiple layers of the desktop environment.

It automatically manages:

-   Waybar UI
-   GTK / Qt themes
-   Wallpapers
-   Shell prompt
-   System monitoring

This creates a **Pixel-like desktop experience** with real-time adaptive
UI.

------------------------------------------------------------------------

## ⚡ Core Features

### 🎨 Dynamic Theme Engine

The theme engine synchronizes UI components across the entire system.

Features:

-   Live switching between **Light and Dark mode**
-   Automatic **Waybar CSS variable updates**
-   GTK / Qt / Electron theme synchronization
-   Wallpaper transitions using `swww`
-   Shell prompt updates based on active theme

Theme Flow:

Wallpaper → Theme Engine → Waybar / GTK / Qt / Shell

Everything updates instantly.

------------------------------------------------------------------------

### 🧊 Glassmorphic UI

Modern transparent interface inspired by Google Pixel UI.

Features:

-   Blur based window transparency
-   Frosted Waybar background
-   Smooth Hyprland animations
-   Adaptive opacity for terminals

------------------------------------------------------------------------

### 📊 Intelligent Status Engine

`status.js` powers Waybar system monitoring.

Displays:

-   CPU usage
-   Memory usage
-   Battery status
-   Wi-Fi SSID
-   Real-time clock

Icons automatically change depending on system state.

Example:

Battery 90% → green\
Battery 20% → yellow\
Battery 10% → red

------------------------------------------------------------------------

## 🧪 Pixel Terminal Environment

Powered by **Kitty terminal**.

Features:

-   Google Pixel color palette
-   80% transparent background
-   Nerd Font icons
-   GPU accelerated rendering

### Hacker Mode

Launch a centered transparent terminal.

SUPER + SHIFT + X

------------------------------------------------------------------------

## 🧩 Waybar Control System

Custom Waybar toggle integration.

### Toggle Waybar

SHIFT +\

Instantly hide or show Waybar.

Useful for:

-   screen recording
-   fullscreen apps
-   distraction-free coding

------------------------------------------------------------------------

## 🌐 Chromium Persistent Profile

Chromium launches with a persistent user profile.

SUPER + O

Launch command:

chromium --user-data-dir=\$HOME/.config/chromium-profile

Benefits:

-   profile never resets
-   extensions remain installed
-   cookies stay saved

------------------------------------------------------------------------

## 🧱 Configuration Architecture

The system uses modular configuration files.

\~/.config/hypr

config/ ├─ env.conf ├─ keybinds.conf ├─ appearance.conf └─
autostart.conf

hyprland.conf

This structure keeps the configuration clean and maintainable.

  File              Purpose
  ----------------- ------------------------------
  env.conf          GTK / Qt environment sync
  keybinds.conf     keyboard shortcuts
  appearance.conf   blur, borders, animations
  autostart.conf    services and startup scripts

------------------------------------------------------------------------

## ⌨️ Essential Keybinds

  Action             Keybind
  ------------------ -------------------
  Terminal (Kitty)   SUPER + Q
  File Manager       SUPER + E
  Chromium           SUPER + O
  App Launcher       SUPER + M
  Toggle Waybar      SHIFT + \\
  Reload Config      SUPER + SHIFT + R
  Hacker Mode        SUPER + SHIFT + X

------------------------------------------------------------------------

## 🚀 Installation

### Requirements

Install required packages:

nodejs\
waybar\
swww\
kitty\
wofi\
kvantum\
nwg-look\
xdg-desktop-portal-hyprland\
xdg-desktop-portal-gtk

------------------------------------------------------------------------

### Deploy

Clone the repository:

git clone https://github.com/ChoruOfficial/Google-Pixel-Hyprland.git

Enter the directory:

cd Google-Pixel-Hyprland

Run installer:

chmod +x install.sh\
./install.sh

------------------------------------------------------------------------

## ⚙️ Performance Optimizations

Exocore includes several optimizations:

-   Waybar module caching
-   Reduced animation overhead
-   GPU accelerated terminal rendering
-   Lazy loaded scripts

Result:

lower CPU usage\
faster workspace switching\
smoother animations

------------------------------------------------------------------------

## 🤝 Contributing

If you want to improve the system:

1.  Fork the repository
2.  Create a new branch
3.  Submit a pull request

------------------------------------------------------------------------

## 🧑‍💻 Maintainer

**Choru Official**

Lead Developer of the **Exocore System Engine**

------------------------------------------------------------------------

## 🌌 Stay Peak

Exocore is built for users who want:

-   performance
-   minimalism
-   aesthetic Linux desktops

Designed for **Hyprland power users**.

#!/usr/bin/env node
/**
 * ---------------------------------------------------------
 * PROJECT:  EXOCORE SYSTEM ENGINE
 * AUTHOR:   Choru Official (Johnsteve Costanos)
 * VERSION:  1.3.0
 * ---------------------------------------------------------
 */
const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const HOME = process.env.HOME;
const BASE_DIR = path.join(HOME, '.config/waybar');
const ASSETS_DIR = path.join(BASE_DIR, 'assets/backgrounds');
const THEME_DIR = path.join(BASE_DIR, 'themes');
const STYLE_FILE = path.join(BASE_DIR, 'style.css');
const STATE_FILE = path.join(BASE_DIR, 'current_theme.txt');

try {
    if (!fs.existsSync(STATE_FILE)) fs.writeFileSync(STATE_FILE, 'dark');
    let current = fs.readFileSync(STATE_FILE, 'utf8').trim();
    let next = current === 'dark' ? 'light' : 'dark';

    const themeSource = path.join(THEME_DIR, `pixel-${next}.css`);
    if (fs.existsSync(themeSource)) {
        fs.copyFileSync(themeSource, STYLE_FILE);
    }

    fs.writeFileSync(STATE_FILE, next);

    const gtkMode = next === 'dark' ? 'prefer-dark' : 'prefer-light';
    execSync(`gsettings set org.gnome.desktop.interface color-scheme "${gtkMode}"`);

    const wallPath = path.join(ASSETS_DIR, next);
    if (fs.existsSync(wallPath)) {
        const files = fs.readdirSync(wallPath).filter(f => /\.(jpg|png|jpeg)$/i.test(f));
        if (files.length > 0) {
            const wall = files[Math.floor(Math.random() * files.length)];
            execSync(`swww img "${path.join(wallPath, wall)}" --transition-type grow`);
        }
    }

    execSync('pkill -USR2 waybar || (pkill waybar; waybar &)');
} catch (err) {
    process.exit(1);
}

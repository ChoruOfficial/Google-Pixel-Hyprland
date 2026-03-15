#!/usr/bin/env node

/**
 * PROJECT:  EXOCORE STATUS ENGINE
 * AUTHOR:   Choru Official
 */

const { execSync } = require("child_process");
const mode = process.argv[2];

const glyphs = {
    wifi: { on: "󰤨", off: "󰤭" },
    bt: { on: "󰂱", off: "󰂯", disc: "󰂯" },
    bat: { char: "󱐋", full: "󰁹", med: "󰁾", low: "󰁺" }
};

const colors = { blue: "#8ab4f8", red: "#ea4335", green: "#34a853", yellow: "#fbbc05" };

try {
    switch(mode) {
        case "wifi":
            const ssid = execSync("nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2").toString().trim();
            process.stdout.write(ssid ? `<span color="${colors.blue}">${glyphs.wifi.on}</span> ${ssid}` : `<span color="${colors.red}">${glyphs.wifi.off}</span>`);
            break;

        case "bt":
            const isOn = execSync("bluetoothctl show").toString().includes("Powered: yes");
            const isConn = execSync("bluetoothctl info").toString().includes("Device");
            process.stdout.write(`<span color="${isConn ? colors.blue : (isOn ? "#ffffff" : colors.red)}">${isConn ? glyphs.bt.on : glyphs.bt.off}</span>`);
            break;

        case "bat":
            const cap = parseInt(execSync("cat /sys/class/power_supply/BAT*/capacity | head -1").toString());
            const status = execSync("cat /sys/class/power_supply/BAT*/status | head -1").toString().trim();
            const icon = status === "Charging" ? glyphs.bat.char : (cap > 80 ? glyphs.bat.full : (cap > 30 ? glyphs.bat.med : glyphs.bat.low));
            const color = cap < 20 ? colors.red : (cap < 50 ? colors.yellow : colors.green);
            process.stdout.write(`<span color="${color}">${icon} ${cap}%</span>`);
            break;

        case "mem":
            const mem = execSync("free -m | awk '/Mem:/ {print $3}'").toString().trim();
            process.stdout.write(`  ${(mem/1024).toFixed(1)}G`);
            break;

        case "clock":
            const time = new Date().toLocaleTimeString('en-US', { hour12: false, hour: '2-digit', minute: '2-digit' });
            process.stdout.write(time);
            break;
    }
} catch (e) {
    process.stdout.write("󰣇");
}1

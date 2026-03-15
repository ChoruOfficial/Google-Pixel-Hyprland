#!/usr/bin/env node

/**
 * PROJECT:  EXOCORE STATUS ENGINE (v2.6 - Charging Icon Fix)
 * AUTHOR:   Choru Official
 */

const { execSync } = require("child_process");
const mode = process.argv[2];

const colors = { blue: "#8ab4f8", red: "#ea4335", green: "#34a853", yellow: "#fbbc05" };

try {
    switch(mode) {
        case "bat":
            try {
                // Kunin ang capacity at status
                const cap = execSync("cat /sys/class/power_supply/BAT*/capacity | head -1").toString().trim();
                const status = execSync("cat /sys/class/power_supply/BAT*/status | head -1").toString().trim();

                // DETECTION LOGIC:
                // Kung "Charging" o "Full", magpapakita ng 󱐋 (Kuryente Icon)
                // Kung "Discharging", walang icon (percentage lang)
                let icon = (status === "Charging" || status === "Full") ? "󱐋 " : "";

                // Color coding para sa percentage text
                let color = colors.green;
                if (parseInt(cap) < 20) color = colors.red;
                else if (parseInt(cap) < 50) color = colors.yellow;

                // Output: Halimbawa "󱐋 17%" o kaya "17%" lang
                process.stdout.write(`<span color="${color}">${icon}${cap}%</span>`);
            } catch (e) {
                process.stdout.write("100%");
            }
            break;

        case "wifi":
            try {
                let ssid = execSync("nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2").toString().trim();
                ssid = ssid.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;");
                const interface = execSync("ip route | grep default | awk '{print $5}'").toString().trim();
                let rate = "0";
                try {
                    let rawRate = execSync(`iw dev ${interface} link | grep bitrate`).toString();
                    rate = rawRate.match(/(\d+\.?\d*)/)[1];
                } catch(e) { rate = "N/A"; }
                process.stdout.write(`<span color="${colors.blue}">󰤨</span> ${ssid} <span size="small" alpha="70%">(${rate}M)</span>`);
            } catch (e) { process.stdout.write("󰤭 Off"); }
            break;

        case "mem":
            const mem = execSync("free -m | awk '/Mem:/ {print $3}'").toString().trim();
            process.stdout.write(`  ${(mem/1024).toFixed(1)}G`);
            break;

        case "clock":
            process.stdout.write(new Date().toLocaleTimeString('en-US', { hour12: true, hour: '2-digit', minute: '2-digit' }));
            break;
    }
} catch (e) {
    process.stdout.write("󰣇");
}

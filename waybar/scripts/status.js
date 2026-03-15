#!/usr/bin/env node
const { execSync } = require("child_process");
const mode = process.argv[2];

const colors = { blue: "#8ab4f8", red: "#ea4335", green: "#34a853", yellow: "#fbbc05", white: "#ffffff" };

try {
    switch(mode) {
        case "wifi":
            const wifi = execSync("nmcli -t -f active,ssid,rate dev wifi | grep '^yes'").toString().trim().split(":");
            if (wifi[1]) {
                process.stdout.write(`<span color="${colors.blue}">󰤨</span> ${wifi[1]} <span size='small' color='#999'>(${wifi[2].replace(" Mbit/s", "Mb")})</span>`);
            } else { process.stdout.write(`<span color="${colors.red}">󰤭</span>`); }
            break;

        case "cpu":
            const cpu = execSync("top -bn1 | grep 'Cpu(s)' | awk '{print $2 + $4}'").toString().trim();
            const cpuVal = Math.round(parseFloat(cpu));
            let cpuCol = cpuVal > 80 ? colors.red : (cpuVal > 50 ? colors.yellow : colors.green);
            process.stdout.write(`<span color="${cpuCol}"></span> ${cpuVal}%`);
            break;

        case "bt":
            const isOn = execSync("bluetoothctl show").toString().includes("Powered: yes");
            const isConn = execSync("bluetoothctl info").toString().includes("Device");
            process.stdout.write(`<span color="${isConn ? colors.blue : (isOn ? colors.white : colors.red)}">${isConn ? "󰂱" : "󰂯"}</span>`);
            break;

        case "bat":
            const cap = parseInt(execSync("cat /sys/class/power_supply/BAT*/capacity | head -1").toString());
            const stat = execSync("cat /sys/class/power_supply/BAT*/status | head -1").toString().trim();
            const icon = stat === "Charging" ? "󱐋" : (cap > 80 ? "󰁹" : (cap > 30 ? "󰁾" : "󰁺"));
            process.stdout.write(`<span color="${cap < 20 ? colors.red : colors.green}">${icon} ${cap}%</span>`);
            break;

        case "mem":
            const mem = execSync("free -m | awk '/Mem:/ {print $3}'").toString().trim();
            process.stdout.write(`  ${(mem/1024).toFixed(1)}G`);
            break;

        case "clock":
            process.stdout.write(new Date().toLocaleTimeString('en-US', { hour12: false, hour: '2-digit', minute: '2-digit' }));
            break;
    }
} catch (e) { process.stdout.write("󰣇"); }

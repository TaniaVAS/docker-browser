#!/bin/bash

# Цвета и иконки
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
MAGENTA='\033[0;35m'
RESET='\033[0m'

ICON_TELEGRAM="🚀"
ICON_INSTALL="🛠️"
ICON_STOP="⏹️"
ICON_RES="🫡"
ICON_EXIT="🚪"

# ASCII-логотип и ссылки
display_ascii() {
    echo -e "${CYAN}+-++-++-++-++-++-++-++-++-++-+${RESET}"
    echo -e "${CYAN}|i||n||d||i||v||i||t||i||a||s|${RESET}"
    echo -e "${CYAN}+-++-++-++-++-++-++-++-++-++-+${RESET}"
    echo -e ""
    echo -e "${MAGENTA}Подписывайтесь на Telegram: https://t.me/CryptalikBTC${RESET}"
    echo -e "${MAGENTA}Подписывайтесь на YouTube: https://www.youtube.com/@Cryptalik${RESET}"
    echo -e "${MAGENTA}Здесь про аирдропы и ноды: https://t.me/indivitias${RESET}"
    echo -e "${YELLOW}Купи мне бутылочку кефира %)${RESET}"
    echo -e "${GREEN}0x8a3476d7cd2bf198b2f4dc492d9726e1d1fb25fb${RESET}"
    echo -e ""
    echo -e "${CYAN}Полезные команды:${RESET}"
    echo -e "  - ${YELLOW}Просмотр файлов директории:${RESET} ls"
    echo -e "  - ${YELLOW}Вход в директорию:${RESET} cd docker-browser"
    echo -e "  - ${YELLOW}Выход из директории:${RESET} cd .."
    echo -e "  - ${YELLOW}Веб-браузер по адресу:${RESET} http://your-server-ip:10000"
    echo -e "    (замените your-server-ip на реальный IP вашего сервера и убедитесь, что порт установлен на 10000, если вы его не изменили)."
    echo -e ""
    echo -e "${CYAN}Запуск скрипта:${RESET}"
    echo -e "  1. ${YELLOW}Зайти в директорию:${RESET} cd docker-browser"
    echo -e "  2. ${YELLOW}Запустить скрипт:${RESET} bash chromeGRASS.sh"
    echo -e ""
}

# Функция для установки Docker и Docker Compose
install_docker() {
    echo -e "${GREEN}${ICON_INSTALL} Установка Docker и Docker Compose...${RESET}"
    sudo apt update && sudo apt upgrade -y
    if ! command -v docker &> /dev/null; then
        sudo apt install docker.io -y
        sudo systemctl start docker
        sudo systemctl enable docker
    fi
    if ! command -v docker-compose &> /dev/null; then
        sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.2/docker-compose-$(uname -s)-$(uname -m)" \
        -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
    fi
    echo -e "${GREEN}Docker и Docker Compose установлены.${RESET}"
    read -p "Нажмите Enter, чтобы продолжить... надо нажать, а то мы так немцев не погоним"
}

# Основной процесс установки и настройки
install_browser() {
    echo -e "${YELLOW}Настройка переменных окружения в .env:${RESET}"
    read -p "Введите USERNAME (ЗАПОМНИ!): " USERNAME
    read -p "Введите PASSWORD(ЗАПОМНИ!): " PASSWORD
    read -p "Укажите домашнюю директорию, я указываю HOME (по умолчанию текущая): " HOME_DIR
    HOME_DIR=${HOME_DIR:-$(pwd)}
    read -p "Введите PORT, просто клацни ENTER (по умолчанию 10000): " PORT
    PORT=${PORT:-10000}

    # Создаем .env файл с пользовательскими данными
    echo "USERNAME=${USERNAME}" > .env
    echo "PASSWORD=${PASSWORD}" >> .env
    echo "HOME=${HOME_DIR}" >> .env
    echo "PORT=${PORT}" >> .env

    echo -e "${GREEN}Запуск Docker Compose для установки браузера...${RESET}"
    docker-compose up -d
    echo -e "${GREEN}✅ Браузер успешно установлен и запущен на порту ${PORT}.${RESET}"
    read -p "Нажмите Enter, чтобы продолжить..."
}

restart_browser(){
    echo -e "${YELLOW}Перезапуск браузера...${RESET}"
    docker-compose restart
    echo -e "${GREEN}✅ Браузер перезапущен.${RESET}"
    read -p "Нажмите Enter, чтобы продолжить...Криптан! Жми!"
}

# Остановка сервисов Docker Compose
stop_browser() {
    echo -e "${YELLOW}Остановка браузера...${RESET}"
    docker-compose down
    echo -e "${GREEN}✅ Браузер остановлен.${RESET}"
    read -p "Нажмите Enter, чтобы продолжить...тут без комментариев"
}

# Главное меню
while true; do
    clear
    display_ascii
    echo -e "${CYAN}1.${RESET} ${ICON_INSTALL} Установить браузер"
    echo -e "${CYAN}2.${RESET} ${ICON_STOP} Остановить браузер"
    echo -e "${CYAN}3.${RESET} ${ICON_RES} Перезапустить браузер"
    echo -e "${CYAN}4.${RESET} ${ICON_EXIT} Выход"
    echo -ne "${YELLOW}Выберите опцию [1-4]:${RESET} "
    read choice

    case $choice in
        1)
            install_docker
            install_browser
            ;;
        2)
            stop_browser
            ;;
        3)
            restart_browser
            ;;
        4)
            echo -e "${RED}Выход...${RESET}"
            exit 0
            ;;
        *)
            echo -e "${RED}Неверный ввод. Пожалуйста, попробуйте снова.${RESET}"
            read -p "Нажмите Enter, чтобы продолжить..."
            ;;
    esac
done

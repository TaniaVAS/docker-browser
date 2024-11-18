#!/bin/bash

# Цветовые коды и иконки
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
ICON_BROWSE="🌐"
ICON_EXIT="🚪"

# Функция для отображения ASCII-логотипа и ссылок на соцсети
display_ascii() {
    echo -e "    ${RED}    ____  __ __    _   ______  ____  ___________${RESET}"
    echo -e "    ${GREEN}   / __ \\/ //_/   / | / / __ \\/ __ \\/ ____/ ___/${RESET}"
    echo -e "    ${BLUE}  / / / / ,<     /  |/ / / / / / / / __/  \\__ \\ ${RESET}"
    echo -e "    ${YELLOW} / /_/ / /| |   / /|  / /_/ / /_/ / /___ ___/ / ${RESET}"
    echo -e "    ${MAGENTA}/_____/_/ |_|  /_/ |_/\____/_____/_____//____/  ${RESET}"
    echo -e "    ${MAGENTA}${ICON_TELEGRAM} Подписывайтесь на Telegram: https://t.me/dknodes${RESET}"
    echo -e "    ${MAGENTA}📢 Подписывайтесь на Twitter: https://x.com/dknodes${RESET}"
    echo -e "    ${CYAN}💻 Веб-сайт проекта: https://getgrass.io${RESET}"
    echo -e ""
    echo -e ""
    echo -e ""
}

# Проверка и установка Docker и Docker Compose
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
    read -p "Нажмите Enter для продолжения..."
}

# Основной процесс установки и настройки браузера
install_browser() {
    echo -e "${YELLOW}Настройка переменных среды в .env:${RESET}"
    read -p "Введите имя пользователя (USERNAME): " USERNAME
    read -p "Введите пароль (PASSWORD): " PASSWORD
    read -p "Укажите домашнюю директорию (по умолчанию текущая): " HOME_DIR
    HOME_DIR=${HOME_DIR:-$(pwd)}
    read -p "Введите порт (по умолчанию 10000): " PORT
    PORT=${PORT:-10000}

    # Создание файла .env с данными пользователя
    echo "USERNAME=${USERNAME}" > .env
    echo "PASSWORD=${PASSWORD}" >> .env
    echo "HOME=${HOME_DIR}" >> .env
    echo "PORT=${PORT}" >> .env

    echo -e "${GREEN}Запуск Docker Compose для установки браузера...${RESET}"
    docker-compose up -d
    echo -e "${GREEN}✅ Браузер успешно установлен и работает на порту ${PORT}.${RESET}"
    read -p "Нажмите Enter для продолжения..."
}

# Перезапуск браузера
restart_browser() {
    echo -e "${YELLOW}Перезапуск браузера...${RESET}"
    docker-compose restart
    echo -e "${GREEN}✅ Браузер перезапущен.${RESET}"
    read -p "Нажмите Enter для продолжения..."
}

# Остановка браузера
stop_browser() {
    echo -e "${YELLOW}Остановка браузера...${RESET}"
    docker-compose down
    echo -e "${GREEN}✅ Браузер остановлен.${RESET}"
    read -p "Нажмите Enter для продолжения..."
}

# Переход в браузер
browse_browser() {
    SERVER_IP=$(hostname -I | awk '{print $1}')
    if [ -z "$SERVER_IP" ]; then
        echo -e "${RED}Не удалось определить IP-адрес сервера.${RESET}"
    else
        echo -e "${GREEN}Перейдите в браузер по адресу: http://$SERVER_IP:${PORT}${RESET}"
    fi
    read -p "Нажмите Enter для продолжения..."
}

# Главное меню
while true; do
    clear
    display_ascii
    echo -e "${CYAN}1.${RESET} ${ICON_INSTALL} Установить браузер"
    echo -e "${CYAN}2.${RESET} ${ICON_STOP} Остановить браузер"
    echo -e "${CYAN}3.${RESET} ${ICON_RES} Перезапустить браузер"
    echo -e "${CYAN}4.${RESET} ${ICON_BROWSE} Перейти в браузер"
    echo -e "${CYAN}5.${RESET} ${ICON_EXIT} Выйти"
    echo -ne "${YELLOW}Выберите пункт [1-5]:${RESET} "
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
            browse_browser
            ;;
        5)
            echo -e "${RED}Выход...${RESET}"
            exit 0
            ;;
        *)
            echo -e "${RED}Неверный ввод. Пожалуйста, попробуйте снова.${RESET}"
            read -p "Нажмите Enter для продолжения..."
            ;;
    esac
done

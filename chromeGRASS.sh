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

# Функция отображения ASCII-логотипа и ссылок на Telegram
display_ascii() {
    echo -e "    ${RED}  ___   _____    __    __  __    __  _______   __  _____ ${RESET}"
    echo -e "    ${GREEN} |_ _| | ____|  / /_  / _|/ _|  / /  | ____| | _|__  __| ${RESET}"
    echo -e "    ${BLUE}  | |  |  _|   / __| |  _|  _| / /   |  _|    | _|  |   ${RESET}"
    echo -e "    ${YELLOW}  | |  | |___ | /__| | | | |__ |_/    | |___   |___|   ${RESET}"
    echo -e "    ${MAGENTA}  |_|  |_____|  \____||_| |____|/      |_____|     ${RESET}"
    echo -e "    ${MAGENTA}${ICON_TELEGRAM} Подписывайтесь на Telegram: https://t.me/CryptalikBTC${RESET}"
    echo -e "    ${MAGENTA}📺 Подписывайтесь на YouTube: https://www.youtube.com/@Cryptalik${RESET}"
    echo -e "    ${CYAN}🔗 Здесь про аирдропы и ноды: https://t.me/indivitias${RESET}"
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
    echo -e "${GREEN}Docker и Docker Compose успешно установлены.${RESET}"
    read -p "Нажмите Enter для продолжения..."
}

# Основной процесс установки браузера
install_browser() {
    echo -e "${YELLOW}Настройка переменных окружения в .env:${RESET}"
    read -p "Введите имя пользователя: " USERNAME
    read -p "Введите пароль: " PASSWORD
    read -p "Укажите директорию HOME (по умолчанию текущая): " HOME_DIR
    HOME_DIR=${HOME_DIR:-$(pwd)}
    read -p "Введите порт (по умолчанию 10000): " PORT
    PORT=${PORT:-10000}

    # Создание файла .env с пользовательскими данными
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
restart_browser(){
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
        echo -e "${GREEN}Перейдите в браузер по адресу: http://$SERVER_IP:$PORT${RESET}"
    fi
    read -p "Нажмите Enter для возврата в меню..."
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
            echo -e "${RED}Неверный ввод. Попробуйте снова.${RESET}"
            read -p "Нажмите Enter для продолжения..."
            ;;
    esac
done

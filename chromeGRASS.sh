#!/bin/bash

# Цветовые коды
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
MAGENTA='\033[0;35m'
RESET='\033[0m'

# Иконки
ICON_TELEGRAM="🚀"
ICON_INSTALL="🛠️"
ICON_STOP="⏹️"
ICON_RES="🔄"
ICON_BROWSE="🌐"
ICON_EXIT="🚪"

# Функция отображения ASCII-логотипа
display_ascii() {
    echo -e "    ${GREEN}    ____ ____  _____ ____  _____   ${RESET}"
    echo -e "    ${BLUE}   / ___|  _ \\| ____|  _ \\| ____|  ${RESET}"
    echo -e "    ${YELLOW}  | |  _| |_) |  _| | | | |  _|    ${RESET}"
    echo -e "    ${MAGENTA}  | |_| |  __/| |___| |_| | |___   ${RESET}"
    echo -e "    ${RED}   \\____|_|   |_____|____/|_____|  ${RESET}"
    echo -e "    ${CYAN}${ICON_TELEGRAM} Подписывайтесь на Telegram: https://t.me/CryptalikBTC${RESET}"
    echo -e "    ${CYAN}📺 Подписывайтесь на YouTube: https://www.youtube.com/@Cryptalik${RESET}"
}

# Установка необходимых компонентов
install_dependencies() {
    echo -e "${GREEN}${ICON_INSTALL} Установка необходимых компонентов...${RESET}"
    sudo apt update && sudo apt upgrade -y
    sudo apt install -y git curl docker.io docker-compose bash-coreutils
    echo -e "${GREEN}✅ Все необходимые компоненты установлены.${RESET}"
}

# Настройка Docker-логов
configure_docker_logs() {
    echo -e "${YELLOW}Настройка ограничения логов Docker...${RESET}"
    sudo mkdir -p /etc/docker
    echo '{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "3"
  }
}' | sudo tee /etc/docker/daemon.json
    sudo systemctl restart docker
    echo -e "${GREEN}✅ Логи Docker ограничены до 10МБ.${RESET}"
}

# Основная установка браузера
install_browser() {
    echo -e "${YELLOW}Настройка среды...${RESET}"
    read -p "Введите имя пользователя: " USERNAME
    read -p "Введите пароль: " PASSWORD
    read -p "Введите директорию HOME (по умолчанию текущая): " HOME_DIR
    HOME_DIR=${HOME_DIR:-$(pwd)}
    read -p "Введите порт (по умолчанию 10000): " PORT
    PORT=${PORT:-10000}

    # Создаём .env файл
    echo "USERNAME=${USERNAME}" > .env
    echo "PASSWORD=${PASSWORD}" >> .env
    echo "HOME=${HOME_DIR}" >> .env
    echo "PORT=${PORT}" >> .env

    echo -e "${GREEN}Запуск Docker Compose для установки браузера...${RESET}"
    docker-compose up -d
    echo -e "${GREEN}✅ Браузер успешно установлен и запущен на порту ${PORT}.${RESET}"
}

# Перезапуск браузера
restart_browser() {
    echo -e "${YELLOW}Перезапуск браузера...${RESET}"
    docker-compose restart
    echo -e "${GREEN}✅ Браузер перезапущен.${RESET}"
}

# Остановка браузера
stop_browser() {
    echo -e "${YELLOW}Остановка браузера...${RESET}"
    docker-compose down
    echo -e "${GREEN}✅ Браузер остановлен.${RESET}"
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
    echo -e "${CYAN}2.${RESET} ${ICON_RES} Перезапустить браузер"
    echo -e "${CYAN}3.${RESET} ${ICON_STOP} Остановить браузер"
    echo -e "${CYAN}4.${RESET} ${ICON_BROWSE} Перейти в браузер"
    echo -e "${CYAN}5.${RESET} ${ICON_EXIT} Выйти"
    echo -ne "${YELLOW}Выберите пункт [1-5]: ${RESET}"
    read choice

    case $choice in
        1)
            install_dependencies
            configure_docker_logs
            install_browser
            ;;
        2)
            restart_browser
            ;;
        3)
            stop_browser
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

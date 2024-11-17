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
ICON_RES="🔄"
ICON_EXIT="🚪"

# ASCII-арт и ссылки
display_ascii() {
    echo -e "    ${RED} ██████╗██████╗ ██╗   ██╗██████╗ ████████╗ █████╗ ██╗     ██╗██╗  ██╗${RESET}"
    echo -e "    ${GREEN}██╔════╝██╔══██╗██║   ██║██╔══██╗╚══██╔══╝██╔══██╗██║     ██║╚██╗██╔╝${RESET}"
    echo -e "    ${BLUE}██║     ██████╔╝██║   ██║██████╔╝   ██║   ███████║██║     ██║ ╚███╔╝ ${RESET}"
    echo -e "    ${YELLOW}██║     ██╔═══╝ ██║   ██║██╔═══╝    ██║   ██╔══██║██║     ██║ ██╔██╗ ${RESET}"
    echo -e "    ${MAGENTA}╚██████╗██║     ╚██████╔╝██║        ██║   ██║  ██║███████╗██║██╔╝ ██╗${RESET}"
    echo -e "    ${CYAN} ╚═════╝╚═╝      ╚═════╝ ╚═╝        ╚═╝   ╚═╝  ╚═╝╚══════╝╚═╝╚═╝  ╚═╝${RESET}"
    echo -e "    ${CYAN}${ICON_TELEGRAM} Подписывайтесь на Telegram: https://t.me/CryptalikBTC${RESET}"
    echo -e "    ${CYAN}📺 Подписывайтесь на YouTube: https://www.youtube.com/@Cryptalik${RESET}"
    echo -e ""
}

# Установка Docker и Docker Compose
install_docker() {
    echo -e "${GREEN}${ICON_INSTALL} Устанавливаем Docker и Docker Compose...${RESET}"
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

    echo -e "${GREEN}Настраиваем ограничения логов Docker...${RESET}"
    DOCKER_CONFIG='/etc/docker/daemon.json'
    if [ ! -f "$DOCKER_CONFIG" ]; then
        sudo bash -c "cat > $DOCKER_CONFIG << EOF
{
  \"log-driver\": \"json-file\",
  \"log-opts\": {
    \"max-size\": \"10m\",
    \"max-file\": \"3\"
  }
}
EOF"
    else
        echo -e "${YELLOW}Файл конфигурации Docker уже существует. Пропускаем настройку.${RESET}"
    fi

    echo -e "${GREEN}Перезапускаем Docker для применения настроек...${RESET}"
    sudo systemctl restart docker

    echo -e "${GREEN}Docker и Docker Compose успешно установлены и настроены.${RESET}"
    read -p "Нажмите Enter, чтобы продолжить..."
}

# Установка и запуск браузера
install_browser() {
    echo -e "${YELLOW}Настройте переменные окружения для .env файла:${RESET}"
    read -p "Введите USERNAME: " USERNAME
    read -p "Введите PASSWORD: " PASSWORD
    read -p "Укажите каталог HOME (по умолчанию текущий): " HOME_DIR
    HOME_DIR=${HOME_DIR:-$(pwd)}
    read -p "Введите PORT (по умолчанию 10000): " PORT
    PORT=${PORT:-10000}

    # Создание файла .env
    echo "USERNAME=${USERNAME}" > .env
    echo "PASSWORD=${PASSWORD}" >> .env
    echo "HOME=${HOME_DIR}" >> .env
    echo "PORT=${PORT}" >> .env

    echo -e "${GREEN}Запускаем Docker Compose для установки браузера...${RESET}"
    docker-compose up -d
    echo -e "${GREEN}✅ Браузер успешно установлен и запущен на порту ${PORT}.${RESET}"
    read -p "Нажмите Enter, чтобы продолжить..."
}

# Перезапуск браузера
restart_browser() {
    echo -e "${YELLOW}Перезапускаем браузер...${RESET}"
    docker-compose restart
    echo -e "${GREEN}✅ Браузер перезапущен.${RESET}"
    read -p "Нажмите Enter, чтобы продолжить..."
}

# Остановка браузера
stop_browser() {
    echo -e "${YELLOW}Останавливаем браузер...${RESET}"
    docker-compose down
    echo -e "${GREEN}✅ Браузер остановлен.${RESET}"
    read -p "Нажмите Enter, чтобы продолжить..."
}

# Главное меню
while true; do
    clear
    display_ascii
    echo -e "${CYAN}1.${RESET} ${ICON_INSTALL} Установить браузер"
    echo -e "${CYAN}2.${RESET} ${ICON_STOP} Остановить браузер"
    echo -e "${CYAN}3.${RESET} ${ICON_RES} Перезапустить браузер"
    echo -e "${CYAN}4.${RESET} ${ICON_EXIT} Выйти"
    echo -ne "${YELLOW}Выберите действие [1-4]:${RESET} "
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
            echo -e "${RED}Неверный ввод. Попробуйте ещё раз.${RESET}"
            read -p "Нажмите Enter, чтобы продолжить..."
            ;;
    esac
done

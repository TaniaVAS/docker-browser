#!/bin/bash

# Color codes and icons
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
ICON_BROWSE="🌐"

# Function to display ASCII logo and Telegram link
display_ascii() {
    echo -e "    ${RED}   GGGGG   RRRRR   AAAAA   SSSSS   SSSSS   ${RESET}"
    echo -e "    ${GREEN}  G        R    R  A   A  S       S       ${RESET}"
    echo -e "    ${BLUE}  G  GG    RRRRR   AAAAA  SSSSS   SSSSS   ${RESET}"
    echo -e "    ${YELLOW}  G   G    R  R    A   A      S       S    ${RESET}"
    echo -e "    ${MAGENTA}   GGG     R   R   A   A  SSSSS   SSSSS   ${RESET}"
    echo -e "    ${MAGENTA}${ICON_TELEGRAM} Подписывайтесь на Telegram: https://t.me/CryptalikBTC${RESET}"
    echo -e "    ${MAGENTA}📢 Подписывайтесь на YouTube: https://www.youtube.com/@Cryptalik${RESET}"
    echo -e ""
    echo -e ""
    echo -e ""
}

# Function to install Docker and Docker Compose
install_docker() {
    echo -e "${GREEN}${ICON_INSTALL} Устанавливаем Docker и Docker Compose...${RESET}"
    sudo apt update && sudo apt upgrade -y

    # Устанавливаем необходимые зависимости
    sudo apt install -y apt-transport-https ca-certificates curl software-properties-common lsb-release

    # Устанавливаем Docker
    if ! command -v docker &> /dev/null; then
        curl -fsSL https://get.docker.com -o get-docker.sh
        sudo sh get-docker.sh
        sudo systemctl enable docker
        sudo systemctl start docker
    fi

    # Устанавливаем Docker Compose
    if ! command -v docker-compose &> /dev/null; then
        sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.2/docker-compose-$(uname -s)-$(uname -m)" \
        -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
    fi

    # Устанавливаем ограничение на размер логов Docker
    echo -e "${YELLOW}Настроим ограничения на размер логов Docker...${RESET}"
    sudo mkdir -p /etc/docker
    echo '{
      "log-driver": "json-file",
      "log-opts": {
        "max-size": "10m",
        "max-file": "3"
      }
    }' | sudo tee /etc/docker/daemon.json

    # Перезапуск Docker, чтобы изменения вступили в силу
    sudo systemctl restart docker

    echo -e "${GREEN}Docker и Docker Compose успешно установлены и настроены с ограничением на логи.${RESET}"
}

# Function to clone the repo and set up the environment
setup_browser() {
    echo -e "${YELLOW}Клонируем репозиторий с GitHub...${RESET}"
    git clone https://github.com/TaniaVAS/docker-browser.git
    cd docker-browser

    echo -e "${YELLOW}Настроим права для скрипта chromeGRASS.sh${RESET}"
    chmod ugo+x chromeGRASS.sh

    echo -e "${GREEN}Готово. Скрипт настроен.${RESET}"
}

# Function to get the server IP address
get_ip() {
    IP=$(hostname -I | awk '{print $1}')
    echo $IP
}

# Function to open the browser
open_browser() {
    SERVER_IP=$(get_ip)
    PORT=10000  # или запросить порт от пользователя
    echo -e "${CYAN}Переходим в браузер по адресу http://${SERVER_IP}:${PORT}${RESET}"
    xdg-open "http://${SERVER_IP}:${PORT}" || open "http://${SERVER_IP}:${PORT}"
}

# Main menu
while true; do
    clear
    display_ascii
    echo -e "${CYAN}1.${RESET} ${ICON_INSTALL} Установить браузер"
    echo -e "${CYAN}2.${RESET} ${ICON_STOP} Остановить браузер"
    echo -e "${CYAN}3.${RESET} ${ICON_RES} Перезапустить браузер"
    echo -e "${CYAN}4.${RESET} ${ICON_BROWSE} Перейти в браузер"
    echo -e "${CYAN}5.${RESET} ${ICON_EXIT} Выйти"
    echo -ne "${YELLOW}Выберите опцию [1-5]:${RESET} "
    read choice

    case $choice in
        1)
            install_docker
            setup_browser
            ;;

        2)
            echo -e "${YELLOW}Останавливаем браузер...${RESET}"
            docker-compose down
            echo -e "${GREEN}✅ Браузер остановлен.${RESET}"
            read -p "Нажмите Enter для продолжения..."
            ;;

        3)
            echo -e "${YELLOW}Перезапускаем браузер...${RESET}"
            docker-compose restart
            echo -e "${GREEN}✅ Браузер перезапущен.${RESET}"
            read -p "Нажмите Enter для продолжения..."
            ;;

        4)
            open_browser
            read -p "Нажмите Enter для продолжения..."
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

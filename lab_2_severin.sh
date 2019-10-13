#!/bin/bash
echo "hello"
sudo apt-get install nodejs git build-essential python2.7

#1. Скачиваем cjdns из GitHub.
#Склонируйте репозиторий из GitHub:
cd ~/ITMO_SPO_Task_2
git clone https://github.com/cjdelisle/cjdns.git cjdns
cd cjdns

#2. Компилируем.
./do
#Дождитесь сообщения Build completed successfully, type ./cjdroute to begin setup., и как только оно появится — действуйте дальше:

#Установка
#Запустите cjdroute без параметров для отображения информации и доступных опций:
./cjdroute

#0: Убедитесь, что у вас всё установлено корректно.
answer=$(echo LANG=C cat /dev/net/tun )

#Если ответ: cat: /dev/net/tun: File descriptor in bad state,то всё отлично!

#Если ответ: cat: /dev/net/tun: No such file or directory,то просто создайте его:
if [[ "$answer" == "cat: /dev/net/tun: No such file or directory" ]]
then sudo mkdir /dev/net ; sudo mknod /dev/net/tun c 10 200 && sudo chmod 0666 /dev/net/tun
else echo "--------- Everything is OK! ---------"
fi

answer=$(echo cat /dev/net/tun)
if [[ "$answer" == "cat: /dev/net/tun: Permission denied" ]]
then echo "Ask your provider to turn on TUP\TAP protocol!"
fi

#Если ответ: cat: /dev/net/tun: Permission denied, вы скорее всего используете виртуальный сервер (VPS) на основе технологии виртуализации OpenVZ. Попросите своего провайдера услуг включить TUN/TAP устройство, это стандартный протокол, ваш провайдер должен быть в курсе.

#1: Генерируем новый файл с настройками.
./cjdroute --genconf >> cjdroute.conf

#Запускаем cjdns!
echo "-------- RUN cjdns! --------"
sudo ./cjdroute < cjdroute.conf

#wait 20 seconds
sleep 20

#Остановка cjdns
echo "-------- STOP cjdns! --------"
sudo killall cjdroute

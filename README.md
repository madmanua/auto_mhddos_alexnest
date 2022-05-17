# Опис
 
runner.sh - ПОВНІСТЮ АВТООНОВЛЮВАНИЙ (оновлює цілі та себе) bash-скрипт для Linux-машин, що керує [mhddos_proxy](https://github.com/porthole-ascend-cinnamon/mhddos_proxy) та [proxy_finder](https://github.com/porthole-ascend-cinnamon/proxy_finder)    
Також він автоматично оновлює не лише свій скрипт та цілі, а й скрипт mhddos_proxy та proxy_finder  
Також скрипт імітує роботу людини (вимикає увесь ДДоС на 1-3 (рандомно) хвилин), тому знижується можливість блокування  
Скрипт розподіляє ваші машини по цілям: https://github.com/alexnest-ua/targets/blob/main/targets_linux (цілі беруться звідси: https://t.me/ddos_separ)  
Увесь source code знаходиться тут: https://github.com/alexnest-ua/auto_mhddos_alexnest/blob/main/runner.sh  

[**Варіант для Mac**](https://github.com/alexnest-ua/auto_mhddos_mac)  
[**Варіант для Windows**](https://github.com/alexnest-ua/runner_for_windows)  
[**Варіант для Docker**](https://github.com/alexnest-ua/auto_mhddos_alexnest/tree/docker)   
[**Варіант для Android**](https://telegra.ph/mhddos-proxy-for-Android-with-Termux-03-31)   
  
[**Налаштування**](#%D0%BD%D0%B0%D0%BB%D0%B0%D1%88%D1%82%D1%83%D0%B2%D0%B0%D0%BD%D0%BD%D1%8F-%D0%B2%D1%81%D1%82%D0%B0%D0%BD%D0%BE%D0%B2%D0%BB%D0%B5%D0%BD%D0%BD%D1%8F)  
[**Запуск у фон**](#%D0%B7%D0%B0%D0%BF%D1%83%D1%81%D0%BA-%D0%BD%D0%B0-%D1%80%D0%BE%D0%B1%D0%BE%D1%82%D1%83-%D1%83-%D1%84%D0%BE%D0%BD%D1%96-247-%D0%BD%D0%B0-linux-%D1%81%D0%B5%D1%80%D0%B2%D0%B5%D1%80%D1%96---%D0%BC%D0%BE%D0%B6%D0%BD%D0%B0-%D0%B7%D0%B0%D0%BA%D1%80%D0%B8%D0%B2%D0%B0%D1%82%D0%B8-%D1%82%D0%B5%D1%80%D0%BC%D1%96%D0%BD%D0%B0%D0%BB)  
[**Приклади команд з --debug та без**](#%D0%BF%D1%80%D0%B8%D0%BA%D0%BB%D0%B0%D0%B4%D0%B8-%D0%BA%D0%BE%D0%BC%D0%B0%D0%BD%D0%B4-%D0%B7-%D1%80%D1%96%D0%B7%D0%BD%D0%B8%D0%BC%D0%B8-%D0%BF%D0%B0%D1%80%D0%B0%D0%BC%D0%B5%D1%82%D1%80%D0%B0%D0%BC%D0%B8)  
[**Повернення до фонового процесу**](#%D0%BF%D0%BE%D0%B2%D0%B5%D1%80%D0%BD%D0%B5%D0%BD%D0%BD%D1%8F-%D0%B4%D0%BE-%D1%84%D0%BE%D0%BD%D0%BE%D0%B2%D0%BE%D0%B3%D0%BE-%D0%BF%D1%80%D0%BE%D1%86%D0%B5%D1%81%D1%83)


  
Канал, де координуються цілі: https://t.me/ddos_separ (звідти і беруться сюди цілі, тому якщо у вас на Linux запущено цей скрипт - то можете відповчивати, він все зробить за вас)  
чат де ви можете задати свої питання: https://t.me/+8swDHSe_ROI5MmJi  
також можете писати мені в особисті у телеграм, я завжди усім відповідаю: @brainqdead
  
Туторіал по створенню автоматичних та автономних Linux-серверів: https://auto-ddos.notion.site/dd91326ed30140208383ffedd0f13e5c  

## Налаштування (встановлення)
  
* щоб скачати на Linux-машину:  
```shell
cd ~  
sudo rm -rf auto_mhddos_alexnest
sudo apt install git -y  
git clone https://github.com/alexnest-ua/auto_mhddos_alexnest
```
  
**ОБОВ'ЯЗКОВО** - запуск файлу, який встановить скрипт mhddos_proxy та усі залежності (один раз на новій машині):
```shell
cd ~/auto_mhddos_alexnest
bash setup.sh
```
*чекаємо 5-10 хвилин поки все встановиться.*  

## Запуск на роботу у фоні (24/7 на Linux-сервері) - можна закривати термінал
Запуск автоматичного ДДоСу:  
```shell 
cd ~/auto_mhddos_alexnest
screen -S "runner" bash runner.sh  
```  
  
Натискаємо Ctrl+A , потім Ctrl+D - І ВСЕ ГОТОВО - ПРАЦЮЄ В ФОНІ  
якщо все успішно буде повідомлення [detached from runner]  

* Буде запущено атаку з наступними параметрами за замовчуванням: num_of_copies=1 threads=1500 rpc=1000 debug=""(1 список цілей, 1500 потоків, 1000 запитів на проксі перед відправкою на ціль, без дебагу) та автоматично запустить паралельно наш [proxy_finder](https://github.com/porthole-ascend-cinnamon/proxy_finder)  
  
Далі кожні 5 хвилин воно буде оновлювати список проксі, а кожні 20 хвилин - цілі атаки та перевіряти наявність оновлення (та встановлювати його якщо воно є)  
  

  
Щоб повернутися та/або **вбити** фоновий процес [читайте це](#%D0%BF%D0%BE%D0%B2%D0%B5%D1%80%D0%BD%D0%B5%D0%BD%D0%BD%D1%8F-%D0%B4%D0%BE-%D1%84%D0%BE%D0%BD%D0%BE%D0%B2%D0%BE%D0%B3%D0%BE-%D0%BF%D1%80%D0%BE%D1%86%D0%B5%D1%81%D1%83)

**!!!УВАГА!!!** runner.sh підтримує наступні параметри (САМЕ У ТАКОМУ ПОРЯДКУ ТА ЛИШЕ У ТАКІЙ КІЛЬКОСТІ(мінімум 3)), але можно і без них:  
runner.sh [num_of_copies] [threads] [rpc] [debug]  
- num_of_copies - кількість атакуємих списків цілей за один прохід (але не менше 1, та не більше 3, бо більше 3-ох знижує ефективність)
- threads - кількість потоків (але не менше 1000, та не більше 2000 для одного ядра, 5000 для 2-4 ядер, 10000 для 4+ ядер)
- rpc - кількість запитів на проксі перед відправкою на ціль (але не менше 1000, та не більше 3000)
- debug - можливість дебагу (якщо хочете бачити повний інфу по атаці - у 4-ий параметр додайте --debug)
  
### Приклади команд з різними параметрами:
перед уведенням команд обов'язково зробити ось це:
```shell
cd ~/auto_mhddos_alexnest
```  
  
* У всіх варіантах буде автоматично запущено паралельно наш [proxy_finder](https://github.com/porthole-ascend-cinnamon/proxy_finder)  
  
1. ***Для лінивих*** (буде обрано за замовчуванням: num_of_copies=1, threads=1500 rpc=1000 debug="" (1 список цілей, 1500 потоків, 1000 запитів на проксі перед відправкою на ціль, без дебагу) та автоматично запустить паралельно наш [proxy_finder](https://github.com/porthole-ascend-cinnamon/proxy_finder) )
```shell
screen -S "runner" bash runner.sh 
```
Натискаємо Ctrl+A , потім Ctrl+D - І ВСЕ ГОТОВО - ПРАЦЮЄ В ФОНІ  
якщо все успішно буде повідомлення [detached from runner]  

**CPUs** - це ядра вашого процесора - зазвичай ядер у два рази МЕНШЕ ніж потоків   


2. Слаба машина(1 CPU), саме ці параметри за замовчуванням:
```shell
screen -S "runner" bash runner.sh 1 1500 1000
```
Натискаємо Ctrl+A , потім Ctrl+D - І ВСЕ ГОТОВО - ПРАЦЮЄ В ФОНІ  
якщо все успішно буде повідомлення [detached from runner]  

3. Середня машина(2-4 CPUs):
```shell
screen -S "runner" bash runner.sh 1 2000 2000
```
Натискаємо Ctrl+A , потім Ctrl+D - І ВСЕ ГОТОВО - ПРАЦЮЄ В ФОНІ  
якщо все успішно буде повідомлення [detached from runner]  

4. Нормальна машина(5-8 CPUs):
```shell
screen -S "runner" bash runner.sh 2 4000 2000
```
Натискаємо Ctrl+A , потім Ctrl+D - І ВСЕ ГОТОВО - ПРАЦЮЄ В ФОНІ  
якщо все успішно буде повідомлення [detached from runner]  

5. Потужна машина(9+ CPUs):
```shell
screen -S "runner" bash runner.sh all 6000 2500
```
Натискаємо Ctrl+A , потім Ctrl+D - І ВСЕ ГОТОВО - ПРАЦЮЄ В ФОНІ  
якщо все успішно буде повідомлення [detached from runner]  

  
*також ви можете змінювати параметри на будь-які інші значення, але я рекомендую саме ці.*  
*також можете додавати останнім **4-тим** параметром --debug, що слідкувати за ходом атаки, наприклад:*  
```shell
screen -S "runner" bash runner.sh 1 2000 1000 --debug
```
Натискаємо Ctrl+A , потім Ctrl+D - І ВСЕ ГОТОВО - ПРАЦЮЄ В ФОНІ   
якщо все успішно буде повідомлення [detached from runner]  


* Приклад **БЕЗ** параметру --debug:  
![image](https://user-images.githubusercontent.com/74729549/168069087-1d1d641e-4ded-43b8-99e4-1d0688e3d2f0.png)  
***наступні 5 хвилин буде виводитись лише інформація від proxy_finder про пошук проксі, але атака теж йде паралельно!***  
* Приклад **З** параметром --debug:  
![image](https://user-images.githubusercontent.com/74729549/168068441-0be60ba6-49c7-41de-a89c-c50410a50fef.png)  
  
Далі кожні 5 хвилин воно буде оновлювати список проксі, а кожні 20 хвилин - цілі атаки та перевіряти наявність оновлення (та встановлювати його якщо воно є)  

## Повернення до фонового процесу
* щоб подивитися що там працює у фоні:  
```shell 
screen -ls  
```
* щоб перейти до процесу та дізнатися як у нього справи (що він виводить), пишіть:  
```shell 
screen -r runner  
```
Після цього, якщо хочете **ВБИТИ** процес - натискайте Ctrl+C(або якщо не спрацює - у іншому вікні пишіть `sudo pkill -e -f runner`)  
у випадку якщо вбили успішно буде повідомлення: [screen is terminating]  

* щоб знову від'єднатися, та залишити його працювати:  
Настикаємо Ctrl+A , потім Ctrl+D - І ВСЕ ГОТОВО - ПРАЦЮЄ В ФОНІ  
  

УВАГА!!! Скрипт при рестарті (кожні 20 хвилин) вбиває запущені скрипти саме з mhddos_proxy, тому якщо запускаєте цей скрипт на машині-Linux, то свої атаки mhddos_proxy запускайте лише через docker, а краще на іншій машині [напряму](https://t.me/ddos_separ/990)  
  
## Список цілей  

  
runner.sh підтримує единий [список цілей](https://raw.githubusercontent.com/alexnest-ua/targets/main/targets_linux), який можна тримати на github і постійно оновлювати.  
  
  
  
Цілі не обов'язково видаляти із списку. Їх можна просто закоментувати і розкоментувати пізніше, якщо вони знов знадобляться. Скрипт використовує лише строки, які починаються не на #.  
#test

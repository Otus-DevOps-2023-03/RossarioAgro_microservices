# OTUS HW microservices

## ДЗ по модулю "Применение системы логирования в инфраструктуре на основе Docker"

* Обновил код в директории **/src** репозитория кодом обновленным кодом с функционалом логирования
* С помощью ```yc cli``` создал инстанс в облаке
* С помощью ```docker-machine``` инициализировал на инстансе докер хост систему
* Собрал и запушил образы микросервисов в [DockerHub](https://hub.docker.com/repository/docker/cmero/prometheus/general)
* Добавил образ ```fluentd```
* Развернул систему логирования на стеке ***EFK***
* Настроил сбор структурированных логов, добавив фильтр для парсинга json-логов, приходящих от сервиса ***post***
* Настроил сбор неструктурированных логов, добавив фильтр для парсинга json-логов, приходящих от сервиса ***ui***
* Заменил регулярное выражение для парсинга json-логов, приходящих от сервиса ***ui***, на grok-шаблоны
* Составил конфигурацию ***Fluentd*** так, чтобы разбирались все форматы логов сервиса ***ui***
* Добавил ***Zipkin*** в систему логирования

Для сборки:

* перейти в каталог **logging**, выполнить

    ``` bash
    make
    ```

  > [!NOTE]\
  > не забываем переключаться на удаленный докер демон в Yandex Cloud:\
    ```eval $(docker-machine env docker-host)```

Для проверки:

* приложение - открыть в браузере <http://IP_адрес_созданной_VM:9292>
* ***kibana*** - открыть в браузере <http://IP_адрес_созданной_VM:5601> , перейти в раздел **Discover**, добавить ```fluentd-*``` в **Index pattern**
* ***Zipkin*** - открыть в браузере <http://IP_адрес_созданной_VM:9411>

---
## ДЗ по модулю "Логирование и распределенная трассировка"

---
## ДЗ по модулю "Введение в мониторинг. Модели и принципы работы систем мониторинга"

* С помощью ```yc cli``` создал инстанс в облаке (команды обернул в скрипты)
* С помощью ```docker-machine``` инициализировал на инстансе докер хост систему (команды обернул в скрипты)
* Собрал образы микросервисов, ***Prometheus***
* Развернул на инстансе ***Prometheus*** и ***Node exporter***
* Запушил образы микросервисов и ***Prometheus*** в [DockerHub](https://hub.docker.com/repository/docker/rossarioagro/prometheus/general)
* Написал Makefile для автоматизации действий (полная сборка проекта + отдельно push в [DockerHub](https://hub.docker.com/repository/docker/rossarioagro/prometheus/general))
* Добавил в ***Prometheus*** мониторинг ***MongoDB*** с использованием экспортера (версия образа последняя стабильная)
* Добавил в ***Prometheus*** мониторинг сервисов `comment`, `post`, `ui` с помощью ***blackbox exporter***
Для сборки:

* перейти в каталог **monitoring**, выполнить

    ``` bash
    make
    ```

  > [!NOTE]\
  > не забываем переключаться на удаленный докер демон в Yandex Cloud:\
    ```eval $(docker-machine env docker-host)```

Для отправки образов в [DockerHub](https://hub.docker.com/repository/docker/rossarioagro/prometheus/general):

* перейти в каталог **monitoring**, выполнить

    ``` bash
    make push
    ```

Для проверки:

* мониторинг - открыть в браузере <http://IP_адрес_созданной_VM:9090>
* приложение - открыть в браузере <http://IP_адрес_созданной_VM:9292>

---
# OTUS HW microservices


## ДЗ по модулю "Сетевое взаимодействие Docker контейнеров. Docker Compose. Тестирование образов"

### В ходе ДЗ выполнено

* Познакомился с сетями в ***Docker***, с утилитой ***docker-compose***.
* Собрал образы приложения reddit с помощью ```docker-compose```.
* Запустил приложение ***reddit*** с помощью ```docker-compose```.
* Изменил ```docker-compose.yml``` под кейс с множеством сетей, сетевых алиасов.
* Параметровал с помощью переменных окружений:
  * порт публикации сервиса ui
  * версии сервисов
  * имя проекта
  * имя пользователя
* Параметризованные параметры записал в отдельный файл
* Имя проекта формируется из имени каталога, откуда запускается ```docker-compose```.
  Первая часть имени контейнера (до первого "**-**") - это имя проекта.
  Вторая часть имени контейнера (до второго "**-**") - это название сервиса из ```docker-compose.yml```.
  Изменить имя можно одним из следующих способов (в таком случае изменится только первая часть имени контейнера):
  * при запуске ```docker-compose``` добавить флаг --project-name / -p и указать имя проекта либо задать переменную окружения ```COMPOSE_PROJECT_NAME```
  * в ```docker-compose.yml``` использовать параметр ```name``` (переменная верхнего уровня)
  Также полностью изменить имя контейнера можно, задав параметр ```container_name```, в ```docker-compose.yml```.
* Создал ```docker-compose.override.yml``` для ***reddit*** проекта, который позволяет:
  * изменять код каждого из приложений, не выполняя сборку образа
  * запускать ```puma``` для руби приложений в дебаг режиме с двумя воркерами (флаги ```--debug``` и ```-w 2```)
  > НО!!! при использовании ```docker-machine``` *volumes* с локальной машины не монтируются на удаленную.

Для сборки:

* перейти в каталог **docker-monolith**
* поднять инстанс, запустив скрипт ```docker_machine_create.sh```
* подставить IP адрес созданной VM в скрипт ```docker_machine_create.sh``` и запустить его
* переключиться на удаленный докер демон в Yandex Cloud:

    ``` bash
    eval $(docker-machine env docker-host)
    ```

* перейти в каталог **src**, выполнить

    ``` bash
    docker compose up -d
    ```

> Если в дирректории находится override файл, то запускаем с ключом -f и указываем конкретный compose-файл
> иначе поднимаются контейнеры из override файла.

Для проверки:

* открыть в браузере <http://IP_адрес_созданной_VM:9292>



---

## ДЗ по модулю "Docker образы. Микросервисы "

### В ходе ДЗ выполнено

* Создал новую структуру приложения из трех компонентов
* Создал сеть для контейнеров
* Собрал приложение:

  * post-py - сервис отвечающий за написание постов
  * comment - сервис отвечающий за написание комментариев
  * ui - веб-интерфейс, работающий с другими сервисами

* Реализовал запуск контейнеров с другими сетевыми алиасами
* Собрал все образы на основе Alpine Linux
* Уменьшил размер всех образов
* Подключил volume к контейнеру с БД

Для сборки:

* перейти в каталог **docker-monolith**
* поднять инстанс, запустив скрипт ```docker_machine_create.sh```
* подставить IP адрес созданной VM в скрипт ```docker_machine_create.sh``` и запустить его
* переключиться на удаленный докер демон в Yandex Cloud:

    ``` bash
    eval $(docker-machine env docker-host)
    ```

* Если установлена утилита Make, выполнить команду:

    ``` bash
    make
    ```

* Если утилита Make не установлена:

  * скачать НЕ последний образ MongoDB:

      ``` bash
      docker pull mongo:5.0
      ```

  * перейти в каталог **src**
  * собрать образы с нашими сервисами:

      ``` bash
      docker build -t cmero/post:1.0 ./post-py
      docker build -t cmero/comment:1.0 ./comment
      docker build -t cmero/ui:1.0 ./ui
      ```

  * создать сеть и том для приложения и запустить контейнеры:

      ``` bash
      docker network create reddit
      docker volume create reddit_db
      docker run -d --network=reddit --network-alias=post_db --network-alias=comment_db -v reddit_db:/data/db mongo:5.0
      docker run -d --network=reddit --network-alias=post cmero/post:1.0
      docker run -d --network=reddit --network-alias=comment cmero/comment:1.0
      docker run -d --network=reddit -p 9292:9292 cmero/ui:1.0
      ```

* Для запуска контейнеров с другими сетевыми алиасами:

    ``` bash
    make run_2
    ```

    либо

    ``` bash
    docker run -d --network=reddit --network-alias=post_db2 --network-alias=comment_db2 mongo:5.0
    docker run -d --network=reddit --network-alias=post2 -e POST_DATABASE_HOST=post_db2 cmero/post:1.0
    docker run -d --network=reddit --network-alias=comment2 -e COMMENT_DATABASE_HOST=comment_db2 cmero/comment:1.0
    docker run -d --network=reddit -p 9292:9292 -e POST_SERVICE_HOST=post2 -e COMMENT_SERVICE_HOST=comment2 cmero/ui:1.0
    ```

Для проверки:

* открыть в браузере <http://IP_адрес_созданной_VM:9292>

## ДЗ по модулю "Docker контейнеры. Docker под капотом"

### В ходе ДЗ выполнено

* Установил ***docker***, ***docker-compose***, ***docker-machine***
* Создал свой ```docker image```
* Описал различия между контейнером и образом
* С помощью ```yc cli``` создал ВМ в облаке (команды обернул в скрипты)
* С помощью ```docker-machine``` инициализировал на инстансе докер хост систему (команды обернул в скрипты)
* Собрал образ *reddit* на инстансе, запустил контейнер на его оснве
* Загрузил образ на *docker hub*
* Запустил контейнер на основе образа из *docker hub* на локальной машине

Для сборки:

* перейти в каталог **docker-monolith**
* поднять инстанс, запустив скрипт ```docker_machine_create.sh```
* подставить IP адрес созданной VM в скрипт ```docker_machine_create.sh`` и запустить его:

    ``` bash
    bash env_init.sh
    ```

* переключиться на удаленный докер демон в Yandex Cloud:

    ``` bash
    eval $(docker-machine env docker-host)
    ```

* собрать образ на удаленном хосте:

    ``` bash
    docker build -t reddit:latest .
    ```

    > точка в конце обязательна, она указывает на путь до Docker-контекста

* запустить контейнер на удаленном хосте:

    ``` bash
    docker run --name reddit -d --network=host reddit:latest
    ```

Для проверки:

* открыть в браузере <http://IP_адрес_созданной_VM:9292>

### Задание со *

* Все файлы находятся в каталоге **docker-monolith/infra**
* Реализовал поднятие инстансов с помощью ```Terraform``` (на основе образа *ubuntu-1604-lts*),
их количество задается переменной
* Динамический инвентори генерируется с помощью ```Terraform```
* Написал 2 плейбука ```Ansible``` для установки ```Docker``` и запуска там образа приложения
* Создал ```Packer```-шаблон (```packer.json```), содержащий описание VM с установленным ```Docker```

Для сборки:

* перейти в каталог **docker-monolith/infra**

Для сборки ```Packer```-образа выполнить команду:

* выполнить проверку конфига:
    ``` bash
    packer validate -var-file=variables.json packer.json
    ```

* выполнить сборку образов:

    ``` bash
    packer build -var-file=variables.json packer.json
    ```

* после сборки указать в terraform.tfvars id образа собранного packer

* поднять инстанс, выполнив команды:

    ``` bash
    terraform init
    terraform plan
    terraform apply
    ```

* запустить плейбук ```Ansible``` для скачивания образа и запуска контейнера (плейбук с утановкой докера провижинится Терраформом):

    ``` bash
    ansible-playbook create_start_docker.yml
    ```
> Также в плейбук добавлены переменные для выбора колл-ва экземпляров контейнеров

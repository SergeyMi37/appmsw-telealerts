![](https://raw.githubusercontent.com/SergeyMi37/appmsw-telealerts/main/doc/status-serv.png)
## appmsw-telealerts
[![Gitter](https://img.shields.io/badge/Available%20on-Intersystems%20Open%20Exchange-00b2a9.svg)](https://openexchange.intersystems.com/package/appmsw-telealerts)
[![GitHub all releases](https://img.shields.io/badge/Available%20on-GitHub-black)](https://github.com/SergeyMi37/appmsw-telealerts)
[![license](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)


Organization of message notification and provision of information to users of the messenger Telegam using two bots.

Solution based on project
https://github.com/intersystems-community/TelegramAlerts

During the installation and configuration process, we will create an informant bot and an admin bot, which will allow the informant bot to provide users with the requested content.

## What's new
A service has been added to the project to support informing via telegram messenger and email about the status of products and systems

## Installation with ZPM

If ZPM the current instance is not installed, then in one line you can install the latest version of ZPM.
```
zn "%SYS" d ##class(Security.SSLConfigs).Create("z") s r=##class(%Net.HttpRequest).%New(),r.Server="pm.community.intersystems.com",r.SSLConfiguration="z" d r.Get("/packages/zpm/latest/installer"),$system.OBJ.LoadStream(r.HttpResponse.Data,"c")
```
If ZPM is installed, then ZAPM can be set with the command
```
zpm:USER>install appmsw-telealerts
```

## Installation with Docker

## Prerequisites
Make sure you have [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) and [Docker desktop](https://www.docker.com/products/docker-desktop) installed.

## Installation 
Clone/git pull the repo into any local directory

```
$ git clone https://github.com/SergeyMi37/appmsw-telealerts.git
```

Open the terminal in this directory and run:

```
$ docker-compose build
```

3. Run the IRIS container with your project:

```
$ docker-compose up -d
$ docker-compose exec iris iris session iris
```

## Installation

1 [Instruction-en](https://raw.githubusercontent.com/SergeyMi37/appmsw-telealerts/main/doc/Install-appmsw-telealerts-en-v2.pdf)

2 [Инструкция-ru](https://raw.githubusercontent.com/SergeyMi37/appmsw-telealerts/main/doc/Install-appmsw-telealerts-ru-v2.pdf)
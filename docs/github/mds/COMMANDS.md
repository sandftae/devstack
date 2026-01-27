# DEVSTACK Commands Reference

> **Usage:** `make <command>`  
> **Help:** 
>
> ➜ `make <command> help`  
> ➜ `make <command> h`

---

#### help command
| Command   | Description      |
|:----------|:-----------------|
| list      | list all command |
| ls        | list all command |

---

#### docker container related commands
| Command                  | Description                                                                                                  |
|:-------------------------|:-------------------------------------------------------------------------------------------------------------|
| `make up`                | up docker environment with fancy UI                                                                          |
| `make down`              | down docker environment                                                                                      |
| `make stop`              | the same as 'down'                                                                                           |
| `make restart`           | full restart of the docker environment                                                                       |
| `make php-app`           | execute php-app docker container interactively [-it]                                                         |
| `make web-app`           | execute web-app docker container interactively [-it]                                                         |
| `make node-app`          | the same as 'web-app'                                                                                        |
| `make chmod-sock`        | chmod 777 on docker.sock                                                                                     |
| `make chmod-src`         | chmod 777 on src folder recursively                                                                          |
| `make chmod-project`     | chmod 777 on project root folder recursively                                                                 |
| `make psa`               | run docker ps -a with predefined output                                                                      |
| `make ps`                | run docker ps with predefined output                                                                         |
| `make top`               | show real-time resource usage for containers                                                                 |
| `make stats`             | show a one-time snapshot of container resource usage                                                         |
| `make metrics`           | show docker containers metrics                                                                               |
| `make remove-containers` | stop and remove all docker containers                                                                        |
| `make remove-images`     | remove all PROJECT images                                                                                    |
| `make remove-volumes`    | remove all PROJECT volumes                                                                                   |
| `make remove-networks`   | remove all PROJECT volumes                                                                                   |
| `make rebuild-all`       | rebuild all images that currently compose file contains                                                      |
| `make rebuild-image`     | rebuild a docker image based on name given. USAGE: make rebuild-image name=image_name                        |
| `make logs`              | view logs. USAGE: make logs [service=service-name] <-- for service logs or just [make logs] for all services |
| `make container-ip`      | get container ip by service name or container name. USAGE: make container-ip name=container_name             |
| `make base-network-ip`   | get base network ip                                                                                          |

---

#### magento daily manipulation commands
| Command                         | Description                                                                              |
|:--------------------------------|:-----------------------------------------------------------------------------------------|
| `make cc`                       | run bin/magento cache:clean command                                                      |
| `make cf`                       | run bin/magento cache:flush command                                                      |
| `make seup`                     | run bin/magento setup:upgrade command                                                    |
| `make sedico`                   | run bin/magento setup:di:compile command                                                 |
| `make rm`                       | remove all folders: generated, cache, page_cache, pub/static, and pub/view_preprocessed/ |
| `make cron`                     | run bin/magento cron:run                                                                 |
| `make reindex`                  | run bin/magento idexer:reindex                                                           |
| `make is`                       | check the status of all indexers                                                         |
| `make mode-production`          | set Adobe Commerce instance to production and rebuild NGINX image                        |
| `make mode-developer`           | set Adobe Commerce instance to developer and rebuild NGINX image                         |
| `make mode-show`                | run bin/magento deploy:mode:show                                                         |
| `make static-deploy`            | run bin/magento setup:static-content:deploy -f command                                   |
| `make static-deploy-parallel-2` | run bin/magento setup:static-content:deploy -f -j 2 (2 parallel jobs)                    |
| `make static-deploy-parallel-4` | run bin/magento setup:static-content:deploy -f -j 4 (4 parallel jobs)                    |
| `make sample-data`              | run bin/magento sampledata:deploy                                                        |

---

#### code style section commands
| Command       | Description                                                                                           |
|:--------------|:------------------------------------------------------------------------------------------------------|
| `make phpcs`  | run vendor/bin/phpcs <params> to validate code style. Run make phpcs help to get more understanding   |
| `make cs`     | the same as 'make phpcs'                                                                              |
| `make phpcbf` | run vendor/bin/phpcbf <params> to validate code style. Run make phpcbf help to get more understanding |
| `make cbf`    | the same as 'make phpcbf'                                                                             |
| `make eslint` | run npx eslint <params> to validate code style. Run make eslint help to get more understanding        |
| `make lint`   | he same as 'make eslint'                                                                              |

---

#### pyh-app manipulation commands
| Command               | Description                                                         |
|:----------------------|:--------------------------------------------------------------------|
| `make xdebug-disable` | disable xdebug, rebuild php-app image, and re-run php-app container |
| `make xdebug-enable ` | enable xdebug, rebuild php-app image, and re-run php-app container  |
| `make xdd`            | the same as 'xdebug-disable'                                        |
| `make xde`            | the same as 'xdebug-enable'                                         |
| `make php-set`        | change image container version. USAGE: make php-set-set version=x.x |
| `make php-version`    | display current active PHP version from environment                 |
| `make php-met`        | the same as 'php-version'                                           |

---

#### web-app manipulation commands
| Command             | Description                                                     |
|:--------------------|:----------------------------------------------------------------|
| `make node-set`     | change image container version. USAGE: make node-set version=20 |
| `make node-version` | display current active node.js version from environment         |
| `make node-meta`    | the same as 'node-version'                                      |

---

#### database management commands
| Command                 | Description                                                                                                      |
|:------------------------|:-----------------------------------------------------------------------------------------------------------------|
| `make create-database`  | create database. USAGE: make create-database db=dbname                                                           |
| `make import-database`  | import dump into existing db. USAGE: make import-database db=dbname file=filename.sql                            |
| `make dump-database`    | export database to a zipped file. USAGE: make dump-database db=dbname                                            |
| `make export-database`  | the same as 'dump-database'                                                                                      |
| `make drop-database`    | drop database ba name given. USAGE: make drop-database db=dbname                                                 |
| `make restore-database` | restore a db dump form ./env/dumps/exports folder. USAGE: make restore-database file=zip_filename.zip db=db_name |
| `make enter-database`   | get into mysql located inside database container                                                                 |
| `make list-database`    | list databases created by the client                                                                             |

---

#### commerce project setup commands
| Command                         | Description                                                                                           |
|:--------------------------------|:------------------------------------------------------------------------------------------------------|
| `make commerce-version`         | provides current version and edition version                                                          |
| `make commerce-meta`            | the same as 'commerce-version'                                                                        |
| `make create-ce`                | run 'composer create-project <params>' command for specified community edition (CE) commerce version  |
| `make create-ee`                | run 'composer create-project <params>' command for specified enterprise edition (EE) commerce version |
| `make upgrade-ee`               | upgrade EE commerce version. Usage: make upgrade-ee version=x.x.x                                     |
| `make upgrade-ce`               | upgrade CE commerce version. Usage: make upgrade-ce version=x.x.x                                     |
| `make setup-install`            | run bin/magento setup:install command by using data specified in .commerce.env                        |
| `make create-admin`             | create new admin user or throws an error if exists. Default admin/admin112345                         |
| `make setup-opensearch-configs` | setup OpenSearch configs into 'core_config_data' table                                                |

---

#### composer commands
| Command                 | Description          |
|:------------------------|:---------------------|
| `make composer-install` | run composer install |
| `make composer-update`  | run composer update  |

---

#### varnish management commands
| Command                | Description                                                                                             |
|:-----------------------|:--------------------------------------------------------------------------------------------------------|
| `make varnish-purge`   | purge varnish                                                                                           |
| `make varnish-meta`    | provide varnish env meta data                                                                           |
| `make varnish-disable` | the Varnish is still running, but do not cache any data and do upstream to the backend directly         |
| `make varnish-enable`  | the Varnish is running, and caches requests; backend is not reachable if there is a corresponding cache |

---

#### devstack docker environment builder
| Command               | Description                                             |
|:----------------------|:--------------------------------------------------------|
| `make magma-build`    | helper command is used to up docker environment builder |
| `make devstack`       | opens the devstack dashboard in the browser             |
| `make open-project`   | opens project in the browser                            |
| `make avada-kedavra!` | remove devstack docker environment                      |

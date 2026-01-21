# Project Commands Reference

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
| Command           | Description                                                                                                  |
|:------------------|:-------------------------------------------------------------------------------------------------------------|
| up                | up docker environment with fancy UI                                                                          |
| down              | down docker environment                                                                                      |
| stop              | the same as 'down'                                                                                           |
| restart           | full restart of the docker environment                                                                       |
| php-app           | execute php-app docker container interactively [-it]                                                         |
| web-app           | execute web-app docker container interactively [-it]                                                         |
| node-app          | the same as 'web-app'                                                                                        |
| chmod-sock        | chmod 777 on docker.sock                                                                                     |
| chmod-src         | chmod 777 on src folder recursively                                                                          |
| chmod-project     | chmod 777 on project root folder recursively                                                                 |
| psa               | run docker ps -a with predefined output                                                                      |
| ps                | run docker ps with predefined output                                                                         |
| top               | show real-time resource usage for containers                                                                 |
| stats             | show a one-time snapshot of container resource usage                                                         |
| metrics           | show docker containers metrics                                                                               |
| remove-containers | stop and remove all docker containers                                                                        |
| remove-images     | remove all PROJECT images                                                                                    |
| remove-volumes    | remove all PROJECT volumes                                                                                   |
| remove-networks   | remove all PROJECT volumes                                                                                   |
| rebuild-all       | rebuild all images that currently compose file contains                                                      |
| rebuild-image     | rebuild a docker image based on name given. USAGE: make rebuild-image name=image_name                        |
| logs              | view logs. USAGE: make logs [service=service-name] <-- for service logs or just [make logs] for all services |
| project-meta      | view project meta data like php meta, node meta, composer meta, commerce meta, and etc                       |

---

#### magento daily manipulation commands
| Command                  | Description                                                                              |
|:-------------------------|:-----------------------------------------------------------------------------------------|
| cc                       | run bin/magento cache:clean command                                                      |
| cf                       | run bin/magento cache:flush command                                                      |
| seup                     | run bin/magento setup:upgrade command                                                    |
| sedico                   | run bin/magento setup:di:compile command                                                 |
| rm                       | remove all folders: generated, cache, page_cache, pub/static, and pub/view_preprocessed/ |
| cron                     | run bin/magento cron:run                                                                 |
| reindex                  | run bin/magento idexer:reindex                                                           |
| is                       | check the status of all indexers                                                         |
| mode-production          | set Adobe Commerce instance to production and rebuild NGINX image                        |
| mode-developer           | set Adobe Commerce instance to developer and rebuild NGINX image                         |
| mode-show                | run bin/magento deploy:mode:show                                                         |
| static-deploy            | run bin/magento setup:static-content:deploy -f command                                   |
| static-deploy-parallel-2 | run bin/magento setup:static-content:deploy -f -j 2 (2 parallel jobs)                    |
| static-deploy-parallel-4 | run bin/magento setup:static-content:deploy -f -j 4 (4 parallel jobs)                    |
| sample-data              | run bin/magento sampledata:deploy                                                        |

---

#### code style section commands
| Command  | Description                                                                                           |
|:---------|:------------------------------------------------------------------------------------------------------|
| phpcs    | run vendor/bin/phpcs <params> to validate code style. Run make phpcs help to get more understanding   |
| cs       | the same as 'make phpcs'                                                                              |
| phpcbf   | run vendor/bin/phpcbf <params> to validate code style. Run make phpcbf help to get more understanding |
| cbf      | the same as 'make phpcbf'                                                                             |
| eslint   | run npx eslint <params> to validate code style. Run make eslint help to get more understanding        |
| lint     | he same as 'make eslint'                                                                              |

---

#### pyh-app manipulation commands
| Command        | Description                                                         |
|:---------------|:--------------------------------------------------------------------|
| xdebug-disable | disable xdebug, rebuild php-app image, and re-run php-app container |
| xdebug-enable  | enable xdebug, rebuild php-app image, and re-run php-app container  |
| xdd            | the same as 'xdebug-disable'                                        |
| xde            | the same as 'xdebug-enable'                                         |
| php-set        | change image container version. USAGE: make php-set-set version=x.x |
| php-version    | display current active PHP version from environment                 |
| php-meta       | the same as 'php-version'                                           |

---

#### web-app manipulation commands
| Command      | Description                                                     |
|:-------------|:----------------------------------------------------------------|
| node-set     | change image container version. USAGE: make node-set version=20 |
| node-version | display current active node.js version from environment         |
| node-meta    | the same as 'node-version'                                      |

---

#### database management commands
| Command          | Description                                                                                                      |
|:-----------------|:-----------------------------------------------------------------------------------------------------------------|
| create-database  | create database. USAGE: make create-database db=dbname                                                           |
| import-database  | import dump into existing db. USAGE: make import-database db=dbname file=filename.sql                            |
| dump-database    | export database to a zipped file. USAGE: make dump-database db=dbname                                            |
| export-database  | the same as 'dump-database'                                                                                      |
| drop-database    | drop database ba name given. USAGE: make drop-database db=dbname                                                 |
| restore-database | restore a db dump form ./env/dumps/exports folder. USAGE: make restore-database file=zip_filename.zip db=db_name |
| enter-database   | get into mysql located inside database container                                                                 |
| list-database    | list databases created by the client                                                                             |

---

#### commerce project setup commands
| Command                  | Description                                                                                           |
|:-------------------------|:------------------------------------------------------------------------------------------------------|
| commerce-version         | provides current version and edition version                                                          |
| commerce-meta            | the same as 'commerce-version'                                                                        |
| create-ce                | run 'composer create-project <params>' command for specified community edition (CE) commerce version  |
| create-ee                | run 'composer create-project <params>' command for specified enterprise edition (EE) commerce version |
| upgrade-ee               | upgrade EE commerce version. Usage: make upgrade-ee version=x.x.x                                     |
| upgrade-ce               | upgrade CE commerce version. Usage: make upgrade-ce version=x.x.x                                     |
| setup-install            | run bin/magento setup:install command by using data specified in .commerce.env                        |
| create-admin             | create new admin user or throws an error if exists. Default admin/admin112345                         |
| setup-opensearch-configs | setup OpenSearch configs into 'core_config_data' table                                                |

---

#### composer commands
| Command          | Description          |
|:-----------------|:---------------------|
| composer-install | run composer install |
| composer-update  | run composer update  |

---

#### varnish management commands
| Command         | Description                                                                                             |
|:----------------|:--------------------------------------------------------------------------------------------------------|
| varnish-purge   | purge varnish                                                                                           |
| varnish-meta    | provide varnish env meta data                                                                           |
| varnish-disable | the Varnish is still running, but do not cache any data and do upstream to the backend directly         |
| varnish-enable  | the Varnish is running, and caches requests; backend is not reachable if there is a corresponding cache |

---

#### devstack docker environment builder
| Command        | Description                                             |
|:---------------|:--------------------------------------------------------|
| magma-build    | helper command is used to up docker environment builder |
| devstack       | opens the devstack dashboard in the browser             |
| open-project   | opens project in the browser                            |
| avada-kedavra! | remove devstack docker environment                      |

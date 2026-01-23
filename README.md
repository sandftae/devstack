# DEVSTACK

![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)
![Version](https://img.shields.io/badge/version-0.0.1--beta-orange.svg)
![Environment: Local Only](https://img.shields.io/badge/Environment-local%20only-red.svg)
![Adobe Commerce: >=2.4.5](https://img.shields.io/badge/Adobe%20Commerce-%E2%89%A52.4.5-red?logo=adobe&logoColor=white)
![Build: Makefile](https://img.shields.io/badge/Build-Makefile-4EAA25?logo=gnuterminal&logoColor=white)
![Docker: >20](https://img.shields.io/badge/Docker-%3E20-blue?logo=docker&logoColor=white)
![Compose: V2](https://img.shields.io/badge/Compose-V2-blue?logo=docker&logoColor=white)
![Bash Version](https://img.shields.io/badge/bash-%3E%3D_3.2-blue?logo=gnu-bash&logoColor=white)

---

![Stability](https://github.com/sandftae/devstack/actions/workflows/infrastructure-stability-check.yml/badge.svg) 
![Code Quality](https://github.com/sandftae/devstack/actions/workflows/code-quality.yml/badge.svg) ![Shell Check](https://github.com/sandftae/devstack/actions/workflows/shell-check.yml/badge.svg) 
![Gitleaks](https://img.shields.io/badge/Security-Gitleaks-green) 

[//]: # (![Compatibility]&#40;https://img.shields.io/badge/macOS_Checked-yes-blue&#41;)

---

An interactive, GUI-driven orchestrator designed to build modular Adobe Commerce environments for monolithic or headless development.
Easily toggle between optional services, monitor performance, and manage your entire local infrastructure from a single interface.

<div align="left">
  <img src="docs/github/media/devstack_up.png" alt="Devstack Session"/>
</div>

---

## Devstack gallery

<details>
<summary> 👉 click for a quick visual overview</summary>
<br/>
  <img src="docs/github/media/magma/1.png" width="45%" alt="Commerce Edition"/>
  <img src="docs/github/media/magma/2.png" width="45%" alt="Commerce Edition"/>
  <img src="docs/github/media/magma/3.png" width="45%" alt="Commerce Storefront"/>
  <img src="docs/github/media/magma/4.png" width="45%" alt="Commerce Storefront"/>
  <img src="docs/github/media/magma/5.png" width="45%" alt="Base Configuration"/>
  <img src="docs/github/media/magma/6.png" width="45%" alt="Base Configuration"/>
  <img src="docs/github/media/magma/7.png" width="45%" alt="Base Configuration"/>
  <img src="docs/github/media/magma/meta.png" width="45%" alt="Project Meta"/>
  <img src="docs/github/media/magma/database.png" width="45%" alt="Database"/>
  <img src="docs/github/media/magma/metrics.png" width="45%" alt="Metrics"/>
  <img src="docs/github/media/magma/mode.png" width="45%" alt="Mode"/>
  <img src="docs/github/media/magma/node-set.png" width="45%" alt="Node Set"/>
  <img src="docs/github/media/magma/php-set.png" width="45%" alt="PHP Set"/>
  <img src="docs/github/media/magma/varnish.png" width="45%" alt="Varnish"/>
  <img src="docs/github/media/magma/list.png" width="45%" alt="List"/>
  <img src="docs/github/media/magma/list_2.png" width="45%" alt="List-2"/>
  <img src="docs/github/media/magma/list_3.png" width="45%" alt="List-3"/>
  <img src="docs/github/media/magma/list_4.png" width="45%" alt="List-3"/>
</details>

---

## Architecture

Detailed information about `network topology`, `service dependencies`, and `infrastructure design` can be found here:

👉 **[Internal Infrastructure & Networking Guide](ARCHITECTURE.md)**

---

## 📖 Table of Contents
- [About](#about)
- [Key Features](#key-features)
- [Available Services](#available-services)
- [Getting Started](#getting-started)
    - [Prerequisites](#prerequisites)
    - [Infrastructure Installation](#infrastructure-installation)
    - [Adobe Commerce Installation](#adobe-commerce-installation)
- [Usage](#usage)
- [Database Import/Export](#database-importexport)
- [Accessing the DEVSTACK](#accessing-the-devstack)
- [Default Credentials](#default-credentials)
- [Debugging, Testing & Performance](#debugging--performance)
    - [Xdebug](#xdebug-configuration)
    - [SFTP Server, Crons & Third-Party Integrations](#sftp-server--integration-testing)
    - [Varnish and Adobe Commerce Modes](#varnish-and-varnish-modes)
- [Project Structure](#project-structure)
- [Troubleshooting](#troubleshooting)
- [License](#-license)
- [Author`s Note](#author--s-note)

---

## Overview
**DEVSTACK** is a bash-powered orchestration tool designed specifically for Adobe Commerce developers. Instead of a "one-size-fits-all" approach, this tool uses an interactive **Bash GUI** to help you build a dev environment tailored to your specific project needs.

It handles the complex networking and service dependencies required for Adobe Commerce development, including support for headless frontends.

## Compatibility Matrix
For a full breakdown of which PHP, MySQL, OpenSearch, etc. versions are paired with each Adobe Commerce version, please refer to the **[Service Compatibility Guide](COMPATIBILITY.md)**

## Key Features
* **Interactive GUI:** select services via dialog GUI
* **SSL (HTTP/HTTPS):** automatically generated SSL certs that allows to test app over `https://` locally
* **Version-Specific:** configure compatible versions of services based on targeted Adobe Commerce version
* **Headless Isolation:** `php` and `node` apps are kept in separate containers
* **Headless Configuration:** allows to easy change `node` versions
* **Varnish Modes:** toggle between `silenced` and `unsilenced` modes to test Varnish bugs
* **Telemetry & Monitoring:** Grafana, Prometheus, and cAdvisor for `play-around` testing 
* **Developer Utilities:**
    * **SFTP Server:** local SFTP access to test Adobe Commerce crons and integrations
    * **Centralized Logging:** aggregate logs from all containers into a single searchable view
    * **Env-Init:** resolves Linux permission mismatches between host and the Docker containers
* **Service Dashboard:** **DEVSTACK** service Dashboard to address direct links to active services GUIs

---

## Available Services
**DEVSTACK** consists of over 15 services. While the core services are required, many components like monitoring and headless tools ``are optional``

 **Please, view the full service list available** **[here](docs/github/mds/SERVICES.md)**

---
> [!CAUTION]
> ### Development Limitations
> This tool is created specifically for **local development and testing**. It contains configurations designed for debugging, performance monitoring, and are **not secure** for production or staging.
>
> ### Infrastructure vs. Application
> This tool builds the **"house"** (the services, etc). You are responsible for bringing the **"furniture"**. It means cloning your source code, managing `auth.json` credentials, and etc.

---

## Getting Started

### Prerequisites
* **Good Mood**: We are living in tough time. Let's try to keep our thoughts clear and open to the beautiful
* **OS:** Linux (Ubuntu recommended) version 24.04 or higher LTS. The tool was not tested with MacOS/Windows, but it was written to be capable to work with those OS
* **Docker:** Docker Engine 20.10+ and Docker Compose v2
* **Utilities:** `make`, `bash`

--- 

## Infrastructure Installation
1. **Clone the repository**
    ```bash
    git clone https://github.com/sandftae/devstack.git
   
    cd devstack
    
   # optional cleaning action; be sure you are ONLY deleting devstack`s 
   # git service files/folders, and devstack`s *.md files  
   rm -rf *.md LICENSE .editorconfig .git .gitigonre .editorconfig .ymlinnt .github docs/github
    ```

2. **Launch the DEVSTACK GUI**
    ```bash
   make magma-build 
   ```

> [!NOTE]
> 
>  * once the env build is complete, you will see several new files and folders [have been added](#project-structure)
>  * you **don't need** to edit `/etc/hosts` or `/hosts` file

---

## Adobe Commerce Installation

The **DEVSTACK** provides a `development environment`, but you need to fill in the project source code yourself.

> [!IMPORTANT]
> 
> All installation-related manipulations will be performed based on the Commerce version specified during setup.

---

### Cloned/Existing Adobe Commerce Project Installation


1. **Start Environment**
   
    Before go further, lets start docker environment if not yet:
    ```shell
    make up
    ```

2. **Import Database**
    
    Data import perform either into `default` database **devstack_magento** or into your `custom-named` one.

      - *Default Database*

        This import is simple. Follow steps described:
    
        - put ``db-dump.sql`` file into `./env/dumps/import` folder
        - run import
          ```bash
          make import-database db=devstack_magento file=db-dump.sql
          ```
   
      - *Custom-Named* Database
   
        This import is simple as well, but you need to `create` new database and `switch` commerce instance enviroment to be alligned with the new one. Follow steps described:
        - put ``db-dump.sql`` file into `./env/dumps/import` folder
        - create database and run import
          ```bash
          # step #1: create database
          make create-database db=your_database_name
          
          # step #2: switch the whole commerce instance environment to the new database
          make switch-database db=your_database_name
          
          # step #3: import database
          make import-database db=your_database_name file=db-dump.sql
          ```


> [!TIP]
> See [this](#database-importexport) section to get more details about database management

3. **Backend**

    - `clone project` repository **into** `src/php-app` folder directly
        ```bash
        # go into 'php-app' source folder
       	cd src/php-app
       	
       	# use './' or '.' to force git to clone into the 'php-app' folder directly
	    git clone path-repository.git .
       ```
   
    - run the installation command to deploy the `Adobe Commerce` instance locally
        ```bash
          # run these commands outside of the container, at the Makefile level
          make composer-install
       
          # it configures AC, admin, populate the database
          make setup-install
        
          # change commerce mode to developer  
          make mode-developer
       
          # or to production
          make mode-production  
          
          # use "make mode-show" command to see current mode  
      
          # OPTIONAL: overview, e.g.: commerce version, php, xdebug, etc.
          make project-meta  
          ```
    - default admin/pass is ``admin/admin12345``, run this command to set your own
       ```bash
          make create-admin
       ```

4. **Frontend (default / monolith)**
    - default Adobe Commerce frontend is located in the ``php-app`` folder


5. **Frontend (headless)**
    
    - `clone project` repository **into** `src/web-app` folder
        ```bash
        # go into 'web-app' source folder
        cd src/web-app
        
        # clone the repository
        git clone path-repository.git .
       ```
   
    - go into `web-app` container and run ``npm/yarn deploy commands``
         ```bash
        # go into 'web-app' container
        make web-app
        
        # run install/build commands
        yarn install && yarn dev
       ```

---

### Fresh Adobe Commerce Project Installation
if you are going to use fresh commerce ``EE/CE`` then the flow is the following:

```bash
 # up docker environment
 make up
 
 # for CE version -> specified during configuration version of the CE will be used
 make create-ce
 
 # for EE version -> specified during configuration version of the EE will be used
 make create-ee
 
 # OPTIONALLY: set up sample data before run 'make setup-install' command
 make sample-data
 
 # set the database (default database or your custom-named one) in the alignment with
 # commerce edition and version 
 make setup-install
 
 # change commerce mode to developer  
 make mode-developer
       
 # or to production
 make mode-production  
 
 # use "make mode-show" command to see current mode  
      
 # OPTIONAL: overview, e.g.: commerce version, php, xdebug, etc.
 make commerce-meta
````

--- 

### ``node`` version upgrade/downgrade

The ``web-app`` container is packed with the ``node v.20``.  If you need to ``upgrade/downgrade`` version run this command:
```shell
# see what the command do
make node-set help

# major node version like 16, 18, 20, etc.
make node-set version=MAJOR_NODE_VERSION

# OPTIONAL: run to get node, yarn, npx meta data
make node-meta
```

> [!IMPORTANT]
> 
> `node` version must be changed only by using ``make node-set version=MAJOR_NODE_VERSION`` command

---

### ``php`` version upgrade/downgrade

The ``php-app`` container is packed with the ``Adobe Comemrce`` specific `PHP version`.  If you need to ``upgrade/downgrade`` version run this command:
```shell
# see what the command do
make php-set help

# major php version like 8.0, 8,1, 8.2, etc.
make php-set version=MAJOR_PHP_VERSION

# OPTIONAL: run to get php, xdebug, meta data
make php-meta
```

> [!IMPORTANT]
>
> `php` version must be changed only by using ``make php-set version=MAJOR_PHP_VERSION`` command

---

##  Usage

See this of [commands](docs/github/mds/COMMANDS.md) existing or run the following command in the terminal:

```bash
make list
```

#### Base commands

| Base commands                                 | Description                    |
|-----------------------------------------------|--------------------------------|
| ``make up``                                   | start the docker environment   |
| ``make down``                                 | shutdown the environment       |
| ``make php-app``                              | enter `php-app` container      |
| ``make web-app``                              | enter `web-app` container      |
| ``make cc``                                   | commerce `cache:clean`         |
| ``make cf``                                   | commerce `cache:flush`         |
| ``make seup``                                 | commerce `setup:upgrade`       |
| ``make sedico``                               | commerce `se:di:co`            |
| ``make mode-developer``                       | commerce set `developer` mode  |
| ``make mode-production``                      | commerce set `production` mode |
| ``make mode-show``                            | commerce `current` mode        |
| ``make xdebug-disable``<br/>or<br/>`make xdd` | enable `XDebug`                |
| ``make xdebug-enable``<br/>or<br/>`make xde`  | disable `XDebug`               |


---

#### HELP command
Each command has `help | h` flag, e.g.:
```shell
make list h
make list help

make create-ce h
make create-ce help
```

---

## Database Import/Export

The default Adobe Commerce database is **devstack_magento**. It is created automatically by the `mysql` container. Keep reading to see how to do `create|drop|import|export` database operations yourself.

The **DEVSTACK** provides a robust system for handling Adobe Commerce data, split between **Automated Initialization** and **Manual CLI Import/Export**.

> [!NOTE]
> All SQL files are managed within the `env/dumps/` directory

---

### Automated Seeds (Initialization)
The system **"seeds"** (auto-populate) your database using files in `env/dumps/seed/` under two conditions:

- **the `first run` rule**: This triggers only when the MySQL container is created for the first time
- **the `empty volume` rule**: the `env/volume/mysql` directory must be empty

> [!NOTE]
> 
> **How to Re-Seed?**
> 
> If you need to force the automated import to run again:
> - `make down`
> - `sudo rm -rf env/volume/mysql`
> - `make up`
> 
> **Where is the seeded data stored?**
> - it is imported into the default ``devstack_magento`` database


#### Quick Start or Onboarding strategy for the team(s)
This mechanism is ideal for `sharing a pre-configured `environment with team members. Simply place
a database dump in `env/dumps/seed/` before distributing the env repository. When a new developer runs make `make up`,
they will have a fully populated database without any manual import steps.

> [!IMPORTANT]
>
> **THE "SILENT" SEEDING PROCESS**
>
> The official MySQL Docker image do NOT provide a real-time progress bar or UI notifications. This may be confusing because once you run env the mysql container is
> up and no database import progress bar is shown. So, once you're seeding the database you need to track the process itself. Just check db size once in minute to see db size actually increasing.
> 
> #### Use manual import if you want to have more control over import
---

### Manual Database Import/Export
Use these commands for daily development tasks like importing dumps, creating backups, or creating new database.


| Command                                          | Description                                           |
|:-------------------------------------------------|:------------------------------------------------------|
| `make create-database db=db_name`                | creates a new database if it doesn't exist            |
| `make drop-database db=db_name`                  | drop/delete database                                  |
| `make import-database db=db_name file=dump.sql`  | imports a specific dump into the database             |
| `make dump-database db=db_name`                  | exports a compressed `.sql.gz` to `env/dumps/export/` |

> [!NOTE]
> the `file=` parameter of the **import command** looks inside `env/dumps/import/`

**Examples**

- #### import 

    ```shell
    # 1. create the schema
    make create-database db=staging_db
    
    # 2. import (file must be in env/dumps/import/)
    make import-database db=staging_db file=staging-dump_bak.sql
    ```

- #### dump database
    ```shell
    # this creates a compressed .gz backup in env/dumps/export/
    make dump-database db=staging_db
    ```

---

### Database Folder Purposes

| Folder Path         | Usage         | Behavior                                                     |
|:--------------------|:--------------|:-------------------------------------------------------------|
| `env/dumps/seed/`   | **automatic** | scripts run on env **first-boot**                            |
| `env/dumps/import/` | **manual**    | place external dumps here to use with `make import-database` |
| `env/dumps/export/` | **manual**    | destination for dumps created via `make dump-database`       |

---

## Accessing the DEVSTACK

Once the containers are running, you can access the various parts of the environment using the CLI command URLs below.

### Storefronts & Backend
| Service                  | Local URL                                             | Note                              |
|:-------------------------|:------------------------------------------------------|:----------------------------------|
| **Monolith Frontend**    | https://your-domain.localhost/                        | Default Adobe Commerce storefront |
| **Adobe Commerce Admin** | https://your-domain.localhost/admin                   | Use your custom admin url         |
| **Vue Storefront**       | https://lyour-domain:3000/ <br/> http://0.0.0.0:3000/ | Default Vue storefront            |
| **PWA Studio**           | https://lyour-domain:3000/ <br/> http://0.0.0.0:3000/ | Default PWA storefront            |


---

## DEVSTACK Service Dashboard

**DEVSTACK Dashboard** is a central control panel. It provides a single interface with **direct links and login credentials** for all services included in the stack.
So, you don't need to memorize passwords and links to the services. It is available through the `dashboard`.

You can access the dashboard in two ways:

 * `via browser`

    open the following URL in your browser:  
    **URL:** [https://your-domain.localhost/devstack/](https://your-domain.localhost/devstack/)


 * `via CLI`

    run this command
    
    ```bash
    make devstack
    ````

**The Service Dashboard** view:

<div align="center">
  <img src="docs/github/media/service_dashboard.png" width="45%" alt="Service Dashboard"/>
  <img src="docs/github/media/service_credentials.png" width="45%" alt="Service Credentials"/>
</div>

---

## Default Credentials

Use the following credentials to access the administrative panels of the included services.

| Service                    | Username  | Password     | Note                                       |
|:---------------------------|:----------|:-------------|:-------------------------------------------|
| **Grafana**                | `admin`   | `admin`      | Telemetry & Metrics                        |
| **phpMyAdmin**             | `root`    | `root`       | Database Management                        |
| **Mysql Database**         | `root`    | `root`       | Database Management                        |
| **RabbitMQ**               | `guest`   | `guest`      | Message Queue GUI                          |
| **cAdvisor**               | *None*    | *None*       | Direct container stats                     |
| **OpenSearch**             | `admin`   | `admin`      | Search Engine Dashboard                    |
| **SFTP Server**            | `test`    | `12345`      | Port `22222`                               |
| **Commerce Default Admin** | `admin`   | `admin12345` | run `make create-admin` to create your own |

> [!IMPORTANT]
>
> **Database Access:** For external tools  the MySql port is `3309`

---

## Debugging & Performance

---

### Xdebug Configuration

*Xdebug* configuration covers only `PHPStorm` at this moment. Please, use this [reference](docs/github/mds/XDEBUG.md) to **configure** `PHPStorm`

---
### SFTP Server & Integration Testing

Use the `local SFTP server` to test file processing and `third-party integrations or crons`.


### Connection Methods

 - `FileZilla`

    connect using a visual client to upload and manage test data/files

    <details>
    <summary>👉 view FileZilla setup</summary>
      <img src="docs/github/media/sftp/SFTP_1.png" width="45%"/>
      <img src="docs/github/media/sftp/SFTP_2.png" width="45%"/>
    </details>



 - `Command Line (CLI)`

    connect via `terminal` using the following command:

      ```bash
      sftp -P 2222 test@DOMAIN
      ```

#### SFTP Access Credentials

| **Parameter** | **Value** |
|:--------------|:----------|
| **User**      | `test`    |
| **Password**  | `12345`   |
| **Port**      | `2222`    |
| **Folder**    | `web`     |

> [!NOTE]
> 
> Data that should be processed must be located in the ``web`` folder, otherwise there will be `permission error`

---

### Varnish and Varnish Modes

The Varnish service is always enabled to maintain architectural consistency. The `varnish` container has **two modes** that are helpful for `debugging` purposes.

#### Silence Mode:
 - Varnish is `"silenced"`. The service remains active, but it passes all requests directly to the backend `without caching data`.
      ```bash
      # run to 'silence' the varnish
      make varnish-disable    
      ```

#### Unsilence Mode:
 - Varnish is fully `active`. It processes and cache data, the backend is reached if no valid cache exists for the request
      ```bash
      # run to 'unsilence' the varnish
      make varnish-enable    
      ```

#### `Silence Mode` technical details 

This mode is also known as `Cache Bypass` or `Direct Backend Routing` mechanism. This allows you to run the application
in a full `production mode` (with `Adobe Commerce` generated files) while **forcing Varnish to bypass the cache**. 
This is essential for debugging backend-specific logic, like:
   - `geo-ip resolution`
   - `session handling`
   - `header-based redirects`
   - `store-switching logic`,
 
 that would otherwise be masked by a cached response.

 This is **default** mode for both `developer` and `production` *Adobe Commerce* modes. Most of the time the varnish **is silenced**.

<div align="center">
  <img src="docs/github/media/silence.png" width="45%" alt="Service Dashboard"/>  
  <img src="docs/github/media/unsilence.png" width="45%" alt="Service Credentials"/>
</div>


> [!TIP]
>
> To purge **varnish** run this command:
> ```bash
> make varnish-purge
> ```


---

#### Mode Control Commands Summary

To switch mode logic, use the following commands:

| Commerce mode                         | Command                                 | Result                                                                                                                              | Silence Headers                 |
|:--------------------------------------|:----------------------------------------|:------------------------------------------------------------------------------------------------------------------------------------|:--------------------------------|
| **production**<br/> and **developer** | `make varnish-disable`                  | `varnish is silenced`: direct backend access (no caching)                                                                           | `X-Varnish-Bypass: true`        |
| **production**<br/> and **developer** | `make varnish-enable`                   | `varnish is fully active`: processes and caches data                                                                                | `X-Varnish-Bypass` not provided |

---

### ``X-Varnish-Bypass`` 

> [!WARNING] 
> 
> Keep in mind that the ``X-Varnish-Bypass`` flag is **DEVSTACK** specific/custom variable

When you are in **varnish silence mode**, you can verify if the bypass is active by inspecting the headers of any request.

Look for the `X-Varnish-Bypass` parameter in the global server variables or response headers:

 - `X-Varnish-Bypass: true` — varnish `is silenced`. The request was passed directly to the PHP-FPM/Nginx backend

 - `X-Varnish-Bypass` missed — varnish `is not silenced`. The request is being handled by the caching layer

On backend you can check the bypass status by looking for the `X-Varnish-Bypass` parameter in the global `$_SERVER` variable:

```php
if ($_SERVER['HTTP_X_VARNISH_BYPASS']) {
    # varnish is currently silenced/bypassed ----> do debugging
    # REMEMBER THIS IS FOR DEVELOPMENT PURPOSES ONLY AND SHOULD
    # NOT BE USED IN PRODUCTION OR TEST ENVIRONMENTS!
}

```

---

##  Project Structure

```shell
├── docs/                       # Knowledge folder: put here project-related files you would like to store
├── env/                        # GUI logic, .env file, and Docker templates
│   ├── bash/                   # Devstack service manipulation and manage commands
│   ├── etc/                    # Build and runtime docker service configs
│   ├── dumps/                  # Database management root
│   │   ├── export/             # Destination for 'make dump-database'
│   │   ├── import/             # Source for 'make import-database'
│   │   └── seed/               # Automated init scripts (docker-entrypoint)
│   ├── image/                  # Devstack service images
│   ├── static/                 # Service dashboard static files
│   ├── volume/                 # Persistent container data (MySQL, Redis, etc.)
│   ├── .env                    # Main configuration file
│   ├── compose.common.yml      # Common services
│   ├── compose.env-build.yml   # Devstack environment builder configuration. DO NOT REMOVE
│   ├── compose.php.yml         # Only php container
│   └── compose.yml             # Orchestration file
├── logs/                       # Nginx, Web-app, and PHP-FPM logs
├── src/
│   ├── php-app/                # Adobe Commerce Source Code (PHP)
│   └── web-app/                # Headless Source Code (Node.js)
├── Makefile                    # Core Base commands
└── README.md
└── ROADMAP.md
└── LICENSE
└── .editiorconfig
└── .gitignore
```
---

## Troubleshooting

---

### Error 503 Backend fetch failed
This is the common varnish error. It usually means `Varnish` lost the connection to the Adobe Commerce (Nginx) backend or the backend timed out during a heavy process.

#### Symptoms:
 - a plain white page with the text: `Error 503 Backend fetch failed`
 - varnish is running, but it cannot communicate with the PHP containers

#### Resolution
The fastest way to reset the connection bridge between the cache layer and the application is to restart the environment:
```shell
make down
make up
```

---

### Permissions & Ownership

A common issue with Docker environments is the **permission denied** error, which occurs because many containers run as the
`root` user while your local host uses a standard one (usually, `1000:1000`).

**DEVSTACK** implements an automated permission-handling logic to bridge this gap, ensuring that the services and a user
have access to critical files and folders. The tool automatically synchronizes `read/write` permissions for the following directories:
 - `src/web-app`
 - `src/php-app`
 - `env/.env`
 - `env/*.yml`
- `env/dumps`
- `logs`

For security and data integrity reasons, **DEVSTACK** does not manage permissions for the following folders:
- `volumes`
- `env/volumes`

---

## 📘 Documentation

Refer to [INSIGHTS.md](INSIGHTS.md) for architectural decisions and ideas behind the tool.

---

## 📄 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## Author`s Note

I built **DEVSTACK** out of a simple necessity: I wanted to make my own life easier, especially when `Docker environments` and `Magento` are mentioned in the same sentence.

I've put a lot of heart and "battle-tested" experience into this tool to bridge the gap between complex infrastructure and daily coding. 
It is not ideal and still `evolving`, but I truly hope it saves you time and makes your development process smoother.


**Thank you for using it !**

<br/>

> *"Whatever you do, work at it with all your heart..." — Colossians 3:23*

<br/>

---

<p align="center">
  <img src="docs/github/media/gif/late.gif" height="180px" width="45%" alt="You are late =)"/>
  <img src="docs/github/media/gif/GF_smile.gif" height="182px" width="45%" alt="It is done"/>
</p>

---

<br/>

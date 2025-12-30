# DEVSTACK

![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)
![Version](https://img.shields.io/badge/version-1.0.0--beta-orange.svg)
![Environment: Local Only](https://img.shields.io/badge/Environment-local%20only-red.svg)
![Adobe Commerce: >=2.4.5](https://img.shields.io/badge/Adobe%20Commerce-%E2%89%A52.4.5-red?logo=adobe&logoColor=white)
![OS: Linux Only](https://img.shields.io/badge/OS-Linux%20-yellow?logo=linux&logoColor=white)
![Build: Makefile](https://img.shields.io/badge/Build-Makefile-4EAA25?logo=gnuterminal&logoColor=white)
![Docker: >20](https://img.shields.io/badge/Docker-%3E20-blue?logo=docker&logoColor=white)
![Compose: V2](https://img.shields.io/badge/Compose-V2-blue?logo=docker&logoColor=white)


**A modular, GUI-driven tool for Adobe Commerce, designed to orchestrate monolithic and headless apps on Linux with 
built-in telemetry and simplified service management.**

<div align="left">
  <img src="docs/github/media/devstack_up.png" alt="Devstack Session"/>
</div>

---

## 📖 Table of Contents
- [About](#about)
- [Key Features](#key-features)
- [Available Services](#available-services)
- [The Two-Tier Makefile Strategy](#the-two-tier-makefile-strategy)
- [Getting Started](#-getting-started)
    - [Prerequisites](#prerequisites)
    - [Infrastructure Installation](#infrastructure-installation)
    - [Adobe Commerce Installation](#adobe-commerce-installation)
- [Usage](#-usage)
- [Database Import/Export](#database-importexport)
- [Accessing the DEVSTACK](#-accessing-the-devstack)
- [Default Credentials](#-default-credentials)
- [Debugging & Performance](#debugging--performance)
    - [Xdebug](#xdebug-configuration)
    - [Varnish Tricks](#varnish-tricks)
- [Project Structure](#-project-structure)
- [License](#-license)

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
* **On-Demand Modes:** toggle between `developer` and `production` app modes to test Varnish bugs
* **Telemetry & Monitoring:** Grafana, Prometheus, and cAdvisor ``palyground`` allows to test high-level monitoring
* **Developer Utilities:**
    * **SFTP Server:** local SFTP access to test Adobe Commerce crons and third-party modules syncs
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
> This tool builds the **"house"** (the services, etc). You are responsible for bringing the **"furniture"**. It means cloning your source code, managing `auth.json` credentials, and executing application-level installs like `composer install` or `yarn install`, and etc.

---

## The Two-Tier Makefile Strategy
This tools provide two ways to manage environment based on workflow preferences:

1.  **Makefile (OOTB):** Minimalist. Only contains core commands to `build`, `start`, `stop`, and `enter` containers
2.  **Powermake:** Extended Makefile. Includes dozens of "power" commands for Adobe Commerce and docker

> [!TIP]
> If you want more power, simply copy specific commands (or the whole file) from `Powermake` into `Makefile`

---

## 🚀 Getting Started

### Prerequisites
* **Good Mood**: We are living in tough time. Let's try to keep our thoughts clear and open to the beautiful
* **OS:** Linux (Ubuntu recommended) version 24.04 or higher LTS
* **Docker:** Docker Engine 20.10+ and Docker Compose v2
* **Utilities:** `make`, `bash`

--- 

## Infrastructure Installation
1. **Clone the repository**
    ```bash
    git clone https://github.com/sandftae/devstack.git
   
    cd devstack
    
   # optional cleaning action; be sure you are deleting devstack`s 
   # git service files/folders, and devstack`s *.md files  
   rm -rf *.md LICENSE .editorconfig .git .gitigonre .editorconfig docs/github
    ```

2. **Database Seed and/or Database Import** [``optional step``]

Set **a database dump** to import before run `make magma-build`. See [this](#database-importexport) for more details

3. **Launch the DEVSTACK GUI**
    ```bash
   make magma-build 
   ```
> [!NOTE]
> Once the environment build is complete, you will see that several new files and folders [have been added](#-project-structure)

---

## Adobe Commerce Installation

The **DEVSTACK** provides a `development environment`, but you need to fill in the project source code yourself.

0. **Start Environment**

Before go further, lets start docker environment if not yet:

```shell
make up
```

> [!IMPORTANT] 
> Your **pub** folder must be located **directly in the php-app** directory

1. **Backend**

    - get into the PHP container
    ```bash
    make php-app
   ```
    - `create` database and `import` data into it **manually**, see [Database Import/Export](#database-importexport) section
    - clone your project repository **inside** the container and run composer
   ```bash
    composer install
    ```

2. **Frontend (Default / Monolith)**
    - default Adobe Commerce frontend is located in the ``php-app`` folder

3. **Frontend (Headless)**
    
    - enter the ``web-app`` container
    ```bash
    make web-app 
   ```
   
    - ``clone`` the web project and run ``npm/yarn deploy commands``

---

### ``node`` version upgrade/downgrade

The ``web-app`` container is packed with the ``node v.20``.  If you need to ``upgrade/downgrade`` version run this command:
```shell
# major node version like 16, 18, 20, etc.
make node-set version=MAJOR_NODE_VERSION
```

---

## 🛠 Usage
| Base commands        | Description                         |
|----------------------|-------------------------------------|
| ``make up``          | start the docker environment        |
| ``make down``        | stop and shutdown the environment   |
| ``make php-app``     | enter PHP-app container             |
| ``make web-app``     | enter Web-app container             |
| ``make magma-build`` | run/re-run the GUI devstack builder |

> [!TIP]
>
> Check ``Powermake`` for extended list of cli commands to manage `Adobe Commerce instance`, `docker`, `metrics`, `project root`, and `access`. It has more commands to use then base `Makefile`. See [Two-Tier Makefile Strategy](#the-two-tier-makefile-strategy) section to gain more understanding

---

## Database Import/Export

The default Adobe Commerce database is **devstack_magento**. It is created automatically by the `mysql` container. Keep reading to see how to do `create|drop|import|export` database operations yourself.

The **DEVSTACK** provides a robust system for handling Adobe Commerce data, split between **Automated Initialization** and **Manual CLI Import/Export**. All SQL files are managed within the `env/dumps/` directory.

### Automated Seeds (Initialization)

The system is designed to **"seed"** (auto-populate) your database using SQL files found in `env/dumps/seed/`. However, this process follows strict Docker logic to protect your data.

#### How it works:

 - **the ``"first run"`` rule**: automated import happens **only once** - the very first time the MySQL container is created (either after `make magma-build`, or `make up` commands) 

 - **the ``"empty volume"`` rule**: for the import to trigger, your local `volume/mysql` directory must be empty

 - **target database**: files are automatically imported into the default ``devstack_magento`` database

#### When will it be IGNORED?
If you **have already run** `make up` previously and a database exists on your disk, the system will skip these files. This is a safety feature to prevent accidental overwriting of your current work.

> [!NOTE]
>
> Automated import is a **Quick Start** strategy. If your environment is already initialized, you must perform imports manually, or remove all mysql volumes

* **Location:** `env/dumps/seed/`
* **Behavior:** files (`.sql`, `.sql.gz`, or `.sh`) are executed **ONLY** when the database container is created for the very first time (i.e., when the `env/volume/mysql` directory is empty)
* **Usage:** perfect for **fresh install** data
* **Resetting:** to re-run these scripts located in seed folder, you must delete your local database volume:
    1. `rm -rf env/volume/mysql`
    2. `make up`
> [!WARNING]
> Running `rm -rf env/volume/mysql` you will remove all databases of the project

### Manual CLI Import/Export (Makefile)
Use these commands for daily development tasks like importing dumps, creating backups, or creating new database.

| Command                                          | Description                                                |
|:-------------------------------------------------|:-----------------------------------------------------------|
| `make create-database db=db_name`                | creates a new database if it doesn't exist                 |
| `make drop-database db=db_name`                  | delete database                                            |
| `make import-database db=db_name file=dump.sql`  | imports a file from `env/dumps/import/` into a specific DB |
| `make dump-database db=db_name`                  | exports a compressed `.sql.zip` to `env/dumps/export/`     |

---

### 📂 Database Folder Purposes

| Folder Path         | Usage         | Behavior                                                     |
|:--------------------|:--------------|:-------------------------------------------------------------|
| `env/dumps/seed/`   | **automatic** | scripts run on **DEVSTACK** env **first-boot**               |
| `env/dumps/import/` | **manual**    | place external dumps here to use with `make import-database` |
| `env/dumps/export/` | **manual**    | destination for dumps created via `make dump-database`       |

---
## 🌐 Accessing the DEVSTACK

Once the containers are running, you can access the various parts of the environment using the URLs below.

### 🛍 Storefronts & Backend
| Service                  | Local URL                      | Note                              |
|:-------------------------|:-------------------------------|:----------------------------------|
| **Monolith Frontend**    | http://dev-env.localhost/      | Default Adobe Commerce storefront |
| **Adobe Commerce Admin** | http://dev-env.localhost/<key> | Use your custom admin url         |
| **Vue Storefront**       | http://localhost:3000/         | Default Vue storefront            |
| **PWA Studio**           | http://0.0.0.0:3000/           | Default PWA storefront            |


### 🛠 DEVSTACK Service Dashboard
| Service                 | Local URL                                                                  |
|:------------------------|:---------------------------------------------------------------------------|
| **Service Dashboard**   | [https://dev-env.localhost/devstack/](https://dev-env.localhost/devstack/) |

> [!TIP]
> **The Service Dashboard** contains direct links to all active service GUIs

**The Service Dashboard** view:

<div align="center">
  <img src="docs/github/media/service_dashboard.png" width="45%" alt="Service Dashboard"/>
  <img src="docs/github/media/service_credentials.png" width="45%" alt="Service Credentials"/>
</div>

---

## 🔐 Default Credentials

Use the following credentials to access the administrative panels of the included services.

| Service         | Username | Password | Note                    |
|:----------------|:---------|:---------|:------------------------|
| **Grafana**     | `admin`  | `admin`  | Telemetry & Metrics     |
| **phpMyAdmin**  | `root`   | `root`   | Database Management     |
| **RabbitMQ**    | `guest`  | `guest`  | Message Queue GUI       |
| **cAdvisor**    | *None*   | *None*   | Direct container stats  |
| **OpenSearch**  | `admin`  | `admin`  | Search Engine Dashboard |
| **SFTP Server** | `test`   | `12345`  | Port `22222`            |

> [!IMPORTANT]
>
> **Database Access:** For external tools  the MySql port is `3309`

---

## Debugging & Performance
### Xdebug Configuration

### Varnish Cache Tricks

---

## 📂 Project Structure

```shell
├── docs/                       # Knowledge folder: put here project-related files you would like to store
├── env/                        # GUI logic, .env file, and Docker templates
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
├── Powermake                   # Extended command boilerplate
└── README.md
└── ROADMAP.md
└── LICENSE
└── .editiorconfig
└── .gitignore
```
## 📄 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

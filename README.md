# DEVSTACK

![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)
![Version](https://img.shields.io/badge/version-1.0.0--beta-orange.svg)
![Environment: Local Only](https://img.shields.io/badge/Environment-local%20only-red.svg)
![Docker: >20](https://img.shields.io/badge/Docker-%3E20-blue?logo=docker&logoColor=white)
![Compose: V2](https://img.shields.io/badge/Compose-V2-blue?logo=docker&logoColor=white)
![OS: Linux Only](https://img.shields.io/badge/OS-Linux%20Only-yellow?logo=linux&logoColor=white)
![Build: Makefile](https://img.shields.io/badge/Build-Makefile-4EAA25?logo=gnuterminal&logoColor=white)


**A modular, GUI-driven Docker devstack for Adobe Commerce, designed to orchestrate monolithic or headless environments (Vue, PWA, Hyvä) on Linux with built-in telemetry and simplified service management.**

## 📖 Table of Contents
- [About](#about)
- [Key Features](#key-features)
- [Available Services](#available-services)
- [The Two-Tier Makefile Strategy](#-the-two-tier-makefile-strategy)
- [Getting Started](#-getting-started)
    - [Prerequisites](#prerequisites)
    - [Infrastructure Installation](#infrastructure-installation)
    - [Adobe Commerce Installation](#adobe-commerce-installation)
- [Usage](#-usage)
- [Database Import/Export](#-database-importexport)
- [Accessing the DevStack](#-accessing-the-devstack)
- [Default Credentials](#-default-credentials)
- [Project Structure](#-project-structure)
- [License](#-license)

---

## About
This DEVSTACK is a bash-powered orchestration tool designed specifically for Adobe Commerce developers. Instead of a "one-size-fits-all" approach, this tool uses an interactive **Bash GUI** to help you build a dev environment tailored to your specific project needs.

It handles the complex networking and service dependencies required for modern Adobe Commerce development, including full support for headless frontends.

### Supported Adobe Commerce Versions
The devstack includes automated configuration presets for the following:
* **Adobe Commerce: 2.4.5, 2.4.6, 2.4.7, 2.4.8**


## Compatibility Matrix
For a full breakdown of which PHP, MySQL, OpenSearch, etc. versions are paired with each Adobe Commerce version, please refer to the: **[Service Compatibility Guide](COMPATIBILITY.md)**

## Key Features
* **Interactive GUI Configuration:** Built with Bash Dialog; select services (OpenSearch, RabbitMQ, Mailpit, etc.) and view a configuration summary before deployment
* **SSL (HTTP/HTTPS):** The devstack automatically generates local SSL certificates within the Docker environment. This allows you to test Adobe Commerce and Headless frontends over `https://` locally
* **Version-Specific Devstacks:** Automatically configures compatible versions of PHP, MySQL, OpenSearch, etc. based on targeted Adobe Commerce version
* **Headless Isolation:** PHP and Node.js environments are kept in separate containers (`php-app` and `web-app`) to prevent conflicts
* **Headless Configuration:** You can predefine which node js version to use. Also `web-app` container has installed `yarn` and `npm` toolset
* **On-Demand Nginx Modes:** Toggle between `developer` and `production` Adobe Commerce modes to test Varnish caching and debug production-only bugs
* **Telemetry & Monitoring:** Integrated Grafana, Prometheus, and cAdvisor for real-time container performance tracking. **These are OPTIONAL services** and are not installed by default. You will need to configure them in the service`s admin
* **Developer Utilities:**
    * **SFTP Server:** Local SFTP access to test Adobe Commerce crons and file synchronization via FileZilla. This is useful if you need to test third-party modules
    * **Centralized Logging:** Aggregate logs from all containers into a single searchable view
    * **Env-Init:** Resolves Linux permission mismatches between your host user and the Docker containers. It relates to `php-app` and `web-app` containers only
* **Service Dashboard:** A static HTML page is generated with direct links to all your active service GUIs (phpMyAdmin, Mailpit, etc.)

---

## Available Services
The DEVSTACK consists of over 15 services. While the core services are required, many components like monitoring and headless tools are optional.

 **Please, view the full service list available** **[here](docs/github/mds/SERVICES.md)**

---
> [!CAUTION]
> ### Development Limitations
> This devstack is created specifically for **local development and testing**. It contains configurations designed for debugging, performance monitoring, and are **not secure** for production or staging.
>
> ### Infrastructure vs. Application
> This tool builds the **"house"** (the services, etc). You are responsible for bringing the **"furniture"**. It means cloning your source code, managing `auth.json` credentials, and executing application-level installs like `composer install` or `yarn install`, and etc.

---

## ⚡ The Two-Tier Makefile Strategy
This tools provide two ways to manage your environment based on your workflow preference:

1.  **Makefile (Base):** Minimalist. Only contains core commands to build, start, stop, and enter containers
2.  **Powermake:** Extended Makefile. Includes dozens of "power" commands for Adobe Commerce and docker

> [!TIP]
> If you want more power, simply copy specific commands (or the whole file) from `Powermake` into your main `Makefile

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
2. **Configure Environment Variables** [``optional step``]

You can customize your devstack ``on-demand`` by editing the `env/.env`. See [details](docs/github/mds/ENVIRONMENT.md)

3. **Database Seed and/or Database Import** [``optional step``]

See [this](#-database-importexport) for more details

5. **Launch the DEVSTACK GUI**
    ```bash
   make magma-build 
   ```
> [!NOTE]
> Once the environment build is complete, you will see that several new files and folders [have been added](#-project-structure)

---

## Adobe Commerce Installation

The DEVSTACK provides the ``environment``, but you need to populate project's source itself.

1. **Backend**
    - get into the PHP container
    ```bash
    make php-app
   ```
    - clone your project repository **inside** the container and run composer
   ```bash
    composer install
    ```
> [!IMPORTANT]
>
> Your **pub** folder must be located **directly in the php-app** directory

2. **Frontend (Default / Monolith)**
    - default Adobe Commerce frontend is located in the ``php-app`` folder
    - only ``headless`` frontend has separate ``web-app`` container


3. **Frontend (Headless)**
    
    - enter the ``web-app`` container
    ```bash
    make web-app 
   ```
   
    - ``clone`` the web project and run ``npm install`` or ``yarn install``

---

### ``node`` version upgrade/downgrade

The ``web-app`` **headless** container is packed with the ``node v.20``.  If you need to ``upgrade/downgrade`` version run this command:
```shell
# major node version like 16, 18, 20, etc.
make node-set version=NODE_TAG_VERSION
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
> Check ``Powermake`` for extended list of cli commands to manage magento instance, docker, metrics, project root, and access. It has more commands to use the base makefile. See [Two-Tier Makefile Strategy](#-the-two-tier-makefile-strategy) section to gain more understanding
---
## 🗄️ Database Import/Export

The DEVSTACK provides a robust system for handling Adobe Commerce data, split between **Automated Initialization** and **Manual CLI Import/Export**. All SQL files are managed within the `env/dumps/` directory.

### Automated Seeds (Initialization)
SQL files placed in the `env/dumps/seed` folder are handled by the native Docker-entrypoint logic. The logic behind is similar to the ``laravel seeds``.
These sql ONLY run if the MySQL data directory (``volume/mysql``) is empty. If the database already exists (from a previous ``make up``), files in this folder will be **IGNORED**.
It is good to use for the ``quick local deployment`` strategy or if you deploy the project for ``the first time``

* **Location:** `env/dumps/seed/`
* **Behavior:** files (`.sql`, `.sql.gz`, or `.sh`) are executed **ONLY** when the database container is created for the very first time (i.e., when the `env/volume/mysql` directory is empty)
* **Usage:** perfect for **fresh install** data
* **Resetting:** to re-run these scripts located in seed folder, you must delete your local database volume:
    1. `rm -rf env/volume/mysql`
    2. `make up`
> [!WARNING]
> Running `rm -rf env/volume/mysql` you will remove all databases of the project

### Manual Import/Export (Makefile)
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
| `env/dumps/seed/`   | **automatic** | scripts run on DEVSTACK env **first-boot**                   |
| `env/dumps/import/` | **manual**    | place external dumps here to use with `make import-database` |
| `env/dumps/export/` | **manual**    | destination for dumps created via `make dump-database`       |

---
## 🌐 Accessing the DEVSTACK

Once the containers are running, you can access the various parts of your environment using the URLs below.

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

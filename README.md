# DEVSTACK

![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)
![Version](https://img.shields.io/badge/version-1.0.0-green.svg)
![Environment: Local Only](https://img.shields.io/badge/Environment-Local%20Only-red.svg)

**A modular, GUI-driven Docker devstack for Adobe Commerce, designed to orchestrate monolithic or headless environments (Vue, PWA, Hyvä) on Linux with built-in telemetry and simplified service management.**

## 📖 Table of Contents
- [About](#about)
- [Key Features](#-key-features)
- [Important Limitations](#-important-limitations)
- [The Two-Tier Makefile Strategy](#-the-two-tier-makefile-strategy)
- [Getting Started](#-getting-started)
    - [Prerequisites](#prerequisites)
    - [Infrastructure Installation](#infrastructure-installation)
    - [Application Setup (User Task)](#application-setup--user-task-)
- [Usage](#-usage)
- [Accessing the DevStack](#-accessing-the-devstack)
- [Default Credentials](#-default-credentials)
- [Project Structure](#-project-structure)
- [License](#-license)

---

## About
This DevStack is a bash-powered orchestration tool designed specifically for Adobe Commerce developers. Instead of a "one-size-fits-all" approach, this tool uses an interactive **Bash GUI** to help you build a devstack tailored to your specific project needs.

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

## Important Limitations

> [!CAUTION]
> ### Development Areas
> This devstack is created specifically for **local development and testing**. It contains configurations designed for debugging, performance monitoring, and are **not secure** for production or staging.


> [!NOTE]
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

## Infrastructure Installation
1. **Clone the repository**
    ```bash
    git clone https://github.com/sandftae/devstack.git
   
    cd devstack
    
   # optional cleaning action, be sure you are deleting devstack`s git service files/folders,
   # and devstack`s *.md files  
   rm -rf *.md LICENSE .editorconfig .git .gitigonre
    ```
2. **Configure Environment Variables by .env**

Before running the devstack builder, you can customize your devstack by editing the `env/.env`. It is optional step.

> [!NOTE]
> 
> If you do not modify these, the devstack will use predefined values. Changing this after the env is built requires you
> to run ``make rebuild-project`` command. It will recreate images/containers, without changing compose file


| Variable                         | Allowed Values                                                                           | Description / Note                                                                                                                                                                                                                                                                                                                                                                                                                                                          |
|----------------------------------|:-----------------------------------------------------------------------------------------|:----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `ADOBE_COMMERCE_MODE`            | `developer`,<br/>  `production`                                                          | Sets the Adobe Commerce mode. If changed manually, you must rebuild Nginx.<br/>  Use: <br/> - `make mode-developer` to set ``developer mode`` <br/> - `make mode-production` to set ``production mode``<br/><br/>  Both command will automatically recreate ``nginx`` service, so no needs to do extra work                                                                                                                                                                 |
| `DEVELOPER_MODE_BYPASS_VARNISH`  | `"true"`, <br/> `"false"`                                                                | **``"true"``**: varnish ``is "bypassed"`` (direct upstream to ``nginx`` service) <br>  **``"false"``** : varnish ``is not "bypassed"`` and the is taken from cache<br/><br/>  You can set it for both Adobe Commerce modes ``production`` and ``developer``,<br/>  but keep in mind it will lead you to very strange cache results for ``developer mode``.<br/><br/> **Please, use it only with the**  ``production mode`` **to test cache results and cache-related bugs** |
| `NODE_VERSION`                   | `16-alpine`,<br/> `17-alpine`,<br/> `18-alpine`,<br/>  `20-alpine`,<br/> `{N}-alpine`    | Defines the ``node.js`` version for the `web-app` container                                                                                                                                                                                                                                                                                                                                                                                                                 |
| `NODE_OPTIONS_OPEN_SSL`          | `--openssl-legacy-provider`<br/>  or *empty*, means just<br/> ``NODE_OPTIONS_OPEN_SSL=`` | **REQUIRED** for ``node >= 17`` (currently, it is default settings).  Keep empty if you downgrade to ``node < 17``                                                                                                                                                                                                                                                                                                                                                          |
| `XDEBUG_ENABLED`                 | `true`, `false`                                                                          | Enables or disables the Xdebug extension in the `php-app` container. It is enabled by default.                                                                                                                                                                                                                                                                                                                                                                              |


3. **Launch the DEVSTACK GUI**
    ```bash
   make magma-build 
   ```
> [!NOTE]
>
> Follow the Bash Dialog prompts to select your Adobe Commerce version and services. The devstack will build and start automatically

## Application Setup (User Task)
The DevStack provides the environment, but you must manually populate the source folders inside the containers.

1. **Backend (Adobe Commerce)**
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
> No extra sub-folders! Your **pub** folder must be located **directly in the php-app** directory


2. **Frontend (Default / Monolith)**
    - default Adobe Commerce frontend is located in the ``php-app`` folder
    - only ``headless`` frontend has separate ``web-app`` container


3. **Frontend (Headless / PWA)**
    - enter the ``node`` container
    ```bash
    make web-app 
   ```
    - clone the web project
    - run ``npm install`` or ``yarn install``

4. **Node.js version upgrade/downgrade**

By default, ``web-app headless`` container is packed with the ``node v.20``.  If you need to ``upgrade/downgrade`` version then:
- go to ``env/.env`` file
- find ``NODE_VERSION`` variable
- change it from this ``NODE_VERSION=20-alpine`` to this ``NODE_VERSION=[16 or 17 or etc]-alpine``
- for ``node version >= 17`` set this variable
```
NODE_OPTIONS_OPEN_SSL=--openssl-legacy-provider
```
- for ``node version < 17`` set this variable empty
```
NODE_OPTIONS_OPEN_SSL=
```
- run
```bash
  make down && make up
  ```

> [!NOTE]
>
> Depending on the use case you may need to delete the ``web-app`` image for the corresponding node.js version and rebuild it.
> This is worth doing if a ``web-app`` image for the corresponding node.js version has already been built.

## 🛠 Usage
| Base commands        | Description                                        |
|----------------------|----------------------------------------------------|
| ``make up``          | Start the docker environment                       |
| ``make down``        | Stop and shutdown the environment                  |
| ``make php-app``     | Enter PHP-app container (Interactive Shell)        |
| ``make web-app``     | Enter Web-app (Node) container (Interactive Shell) |
| ``make magma-build`` | Run/Re-run the GUI configuration builder           |

> [!TIP]
>
> Check ``Powermake`` for extended list of cli commands to manage magento instance, docker, metrics, project root, and access

## 🌐 Accessing the DEVSTACK

Once the containers are running, you can access the various parts of your environment using the URLs below.

### 🛍 Storefronts & Backend
| Service                  | Local URL                                         | Note                              |
|:-------------------------|:--------------------------------------------------|:----------------------------------|
| **Monolith Frontend**    | http://dev-env.localhost/                         | Default Adobe Commerce storefront |
| **Adobe Commerce Admin** | http://dev-env.localhost/<your-admin-secret-url>  | Use your custom admin url         |
| **Vue Storefront**       | http://localhost:3000/                            | Default Vue storefront            |
| **PWA Studio**           | http://0.0.0.0:3000/                              | Default PWA storefront            |


### 🛠 DEVSTACK Service Dashboard
| Service                 | Local URL                                                                  |
|:------------------------|:---------------------------------------------------------------------------|
| **Service Dashboard**   | [https://dev-env.localhost/devstack/](https://dev-env.localhost/devstack/) |

> [!TIP]
> **The Service Dashboard** contains direct links to all active service GUIs

**The Service Dashboard** view:

<img src="docs/github/media/service_dashboard.png" width="250" height="125" alt="Service Dashboard"/>
<img src="docs/github/media/service_credentials.png" width="250" height="125" alt="Service Credentials"/>

---

## 🔐 Default Credentials

Use the following credentials to access the administrative panels of the included services.

| Service         | Username    | Password | Note                    |
|:----------------|:------------|:---------|:------------------------|
| **Grafana**     | `admin`     | `admin`  | Telemetry & Metrics     |
| **phpMyAdmin**  | `root`      | `root`   | Database Management     |
| **RabbitMQ**    | `guest`     | `guest`  | Message Queue GUI       |
| **cAdvisor**    | *None*      | *None*   | Direct container stats  |
| **OpenSearch**  | `admin`     | `admin`  | Search Engine Dashboard |
| **SFTP Server** | `sftp_test` | `12345`  | Port `22222`            |

> [!IMPORTANT]
>
> **Database Access:** For external tools like Sequel Ace or TablePlus, the MySql port is usually `3309`

## 📂 Project Structure

```shell
├── docs/                       # knowledge folder: put here project-related files you would like to store
├── env/                        # GUI logic, .env file, and etc.
│   ├── .env                    # env configuration file. It is created after magma-build cmnd
│   ├── compose.common.yml      # common services. It is created after magma-build cmnd
│   ├── compose.env-build.yml   # devstack environment builder configuration. Do not remove
│   ├── compose.php.yml         # php service only. It is created after magma-build cmnd
│   ├── compose.yml             # Actually, services the user created.
                                # It is created after magma-build cmnd
├── logs/                       # nginx, web-app, php-fpm logs. It is created after magma-build cmnd
├── src/
│   ├── php-app/                # Adobe Commerce Source Code (PHP)
│   └── web-app/                # headless Source Code (Node.js)
├── Makefile                    # minimal Base commands
├── Powermake                   # extended command boilerplate
└── README.md
└── ROADMAP.md
└── LICENSE
└── .editiorconfig
└── .gitignore
```
## 📄 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

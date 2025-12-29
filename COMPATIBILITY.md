# 🛠 Adobe Commerce & Service Compatibility Matrix

This document outlines the software versions automatically provisioned by the **DevStack** GUI based on your selected Adobe Commerce version.

## 📊 Core Stack Mapping

| Adobe Commerce Version | PHP Version  | MySQL/MariaDB  | OpenSearch   | Elasticsearch* |
|:-----------------------|:-------------|:---------------|:-------------|:---------------|
| **2.4.5**              | 8.1          | 10.6 (MariaDB) | 1.2          | 7.17           |
| **2.4.6**              | 8.1 / 8.2    | 8.0 (MySQL)    | 2.5          | 7.17           |
| **2.4.7**              | 8.2 / 8.3    | 8.0 (MySQL)    | 2.11         | N/A            |
| **2.4.8**              | 8.3          | 8.0 (MySQL)    | 2.12+        | N/A            |

> [!NOTE]
> Elasticsearch support is being phased out in newer DevStack presets in favor of OpenSearch.

---

## 🏗 Infrastructure Details

### PHP-FPM
The PHP containers are built on **Alpine Linux** to keep the footprint small. They include critical Adobe Commerce extensions pre-installed:
* `bcmath`, `gd`, `intl`, `mysqli`, `pdo_mysql`, `soap`, `xsl`, `zip`, `sockets`, etc.
* **Xdebug 3** is included and enabled by default. It can be toggled via the `.env` file:
  * set ``XDEBUG_ENABLED=false``
  * run:
```shell
make rebuild-image name=php-app
```

### Search Engines
* **OpenSearch:** Selected as the default search engine for all 2.4.x installs.
* **Dashboards:** If selected in the GUI, the OpenSearch Dashboard will be accessible via the Service Dashboard.

### Cache & Session
All supported versions use a unified caching strategy:
* **Redis/ValKey:** Used for both Session storage and Backend Cache.
* **Varnish:** Configured for Full Page Cache (FPC). Use the `make mode-production` command in **Powermake** to test Varnish effectively.

---

## 🌐 Frontend Compatibility

| Frontend Tech          | Node.js Version         | Recommended For          |
|:-----------------------|:------------------------|:-------------------------|
| **PWA Studio**         | 18 / 20                 | Headless Adobe Commerce  |
| **Vue Storefront**     | 16 / 18                 | Headless Adobe Commerce  |
| **Hyvä Themes**        | depends on Hyvä version | Headless Adobe Commerce  |
| **Default / Monolith** | N/A (PHP based)         | Default OOTB Monolith    |

> [!TIP]
> 
> You can specify node version on the `env/.env` file.
> See details [here](docs/github/mds/ENVIRONMENT.md)

---

[Back to README.md](README.md)

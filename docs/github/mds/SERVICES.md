# DEVSTACK Services Matrix

This document provides a comprehensive list of all services available within the **DEVSTACK** orchestration. You can enable or disable optional services during the `make magma-build` process.

| Service             | Type          | Short Description (Purpose)                                                                                              |
|:--------------------|:--------------|:-------------------------------------------------------------------------------------------------------------------------|
| **Nginx**           | `Required`    | web server acting as the primary entry point for the application                                                         |
| **SSL Proxy**       | `Required`    | reverse proxy handling local SSL termination for secure HTTPS development                                                |
| **PHP-FPM**         | `Required`    | the `php-app` container running version-specific PHP and `monolith` frontend                                             |
| **MySQL**           | `Required`    | database engine                                                                                                          |
| **OpenSearch**      | `Required`    | primary search engine required for Adobe Commerce                                                                        |
| **Varnish**         | `Required`    | HTTP accelerator for full-page caching                                                                                   |
| **SFTP Server**     | `Required`    | secure file transfer service for testing custom crons and third-party file synchronizations                              |
| **Redis**           | `Recommended` | data store used for session management and backend caching                                                               |
| **RabbitMQ**        | `Recommended` | message broker for asynchronous message queues                                                                           |
| **phpMyAdmin**      | `Recommended` | web-based interface for MySQL database                                                                                   |
| **Mailpit**         | `Recommended` | email testing tool that catches outgoing mail for local debugging and inspection                                         |
| **VPN**             | `Recommended` | testing based on a specific IP address (country, continent)                                                              |
| **Web-App**         | `Optional`    | node/yarn/npm container for headless frontend                                                                            |
| **Valkey**          | `Optional`    | alternative to Redis                                                                                                     |
| **OpenSearch Dash** | `Optional`    | visual GUI for exploring OpenSearch data, indexes, and cluster health status <br/> `(good for playground purposes)`      |
| **Grafana**         | `Optional`    | analytics and visualization tool for monitoring container performance and telemetry<br/>`(good for playground purposes)` |
| **Prometheus**      | `Optional`    | database that collects and stores real-time metrics from the stack<br/>`(good for playground purposes)`                  |
| **cAdvisor**        | `Optional`    | resource usage analyzer providing real-time data on container CPU and memory<br/>`(good for playground purposes)`        |

---
> [!NOTE]
> Service availability and specific versions are determined by the Adobe Commerce version selected during build

[Back to README.md](../../../README.md)

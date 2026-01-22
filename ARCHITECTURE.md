# Infrastructure & Architecture

This document describes the internal structure of **DEVSTACK** and how services communicate.

---

## Infrastructure Map

![Infrastructure Diagram](/docs/github/media/infra/devstack_ifrastructure.jpg)

---

## Service Stack
* **Gateway**: `SSL Proxy` + `Varnish Cache`
* **PHP App**: `PHP` v. x.x (commerce version specific)
* **Node App**: `Nodejs` v. 20.0 OOTB
* **Storage**: `MySQL 8.0`, `Redis/ValKey`, `OpenSearch`
* **Dev Tools**: `Mailpit`, `phpMyAdmin`, and `SFTP` for `ERP/integrations` simulation

---

## Networking
The stack uses `isolated` Docker networks:

1. **base_network**:
    - used for core communication (`WEB <-> PHP <-> DBs <-> etc`)
    - used for `recomended services`
2. **monitoring_network**:
    - dedicated segment for `optional awervices`

---

## Design Decisions
- **No MariaDB**: only MySQL 8.0 is supported at this stage
- **PHP Dependency**: PHP versions are strictly mapped to Commerce versions to prevent environment mismatches

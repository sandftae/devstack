# 🗺️ Project Roadmap

This document outlines the planned features, upcoming framework support, and technical milestones for the Magento 2 DevStack.

## 🚀 High Priority (Coming Soon)
- [ ] **Core Migration (Bash → Go):** Rewriting the orchestration logic in **Golang** for better performance, faster execution, and a more user-friendly interface
- [ ] **Framework Expansion:** 
    - [ ] **Laravel** support (optimized PHP-FPM and Nginx profiles)
    - [ ] **Symfony** support (pre-configured services for Symfony)
- [ ] **VPN:** Add free and secure VPN service(s) to ensure seamless testing with IP restrictions. 

## 📅 Future Milestones
- [ ] **Multi-Platform E-commerce Support:**
    - [ ] **Shopware 6** 
    - [ ] **Sylius** (maybe ?)
- [ ] **Expanded Service Catalog:**
    - [ ] Support for **Meilisearch** as an alternative to OpenSearch
- [ ] **Headless Enhancements:** Testing **Adobe App Builder**

## ✅ Completed Milestones
- [x] **Interactive Bash GUI** for custom stack selection
- [x] **Automated SSL (HTTP/HTTPS)** certificate generation for local domains
- [x] **Telemetry Stack** (Grafana, Prometheus, cAdvisor)
- [x] **Env-Init Permission System** for seamless Linux host-to-container file sharing

---
*Note: This roadmap is subject to change based on community feedback and developer availability.*

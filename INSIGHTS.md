
### 🧠 DEVSTACK INSIGHTS
#### 📌 Project Philosophy

The DEVSTACK ecosystem is built on two core pillars:

 - `zero-friction onboarding:` designed so a tech lead can simply provide a repository link and a database dump, allowing a
new developer to be **"ready to code"** in minutes. It effectively bridges the gap between complex enterprise infrastructure and developer ease-of-use

 - `production simulation lab:` beyond simple development, this tool serves as a `sandbox` for `real-world scenarios`. It allows teams
to simulate and test high-stakes production environments locally specifically ERP/CRM, data synchronizations before they ever touch a live server

---

### Architectural Decisions

#### Modularity & Headless Support

**DEVSTACK** environment is built for the modern web:

 - `monolith` vs. `headless`: supports traditional Adobe Commerce rendering or a `PWA/Headless` frontend

 - `Varnish Silencing`: the ability to toggle/silence Varnish allows developers to debug cache issues without restarting the entire stack

#### The SSL Reverse Proxy

 - **Bi-Protocol Support**: handles both `http` and `https` seamlessly

 - **Real-World Simulation**: developers can test SSL-specific features (like secure cookies or payment gateways) locally

#### Integrated SFTP Server

To simulate real-world enterprise syncs, tool includes a dedicated SFTP container.

 - **CRM/ERP mocking**: perfect for testing cases where a `CRM` or `third-party system` *"drops"* a file (CSV/XML) on a remote server for Adobe Commerce to pick up

 - **tool compatibility**: devs can use `FileZilla` to connect locally, mimicking exactly how they would interact with a client's production server

 - **file processing**: allows testing of custom logic that fetches, parses, and imports data into `Adobe Commerce` (syncs, migrations, notifications)

---

### Performance & DX (Developer Experience)

#### Environment Monitoring

DEVSTACK has integrated tools to track the environment state whether it is **idle** or **actively working** (during syncs, cron runs, etc.). This helps:
- monitor system health in real-time
- identify which services consume the most resources (essential for production-parity planning)

> [!NOTE]
> For container monitoring, `ctop` is used

#### The "Seeds" (Quick Start)

Setting up a database should not take hours.

 - **seed logic**: integrated commands to pull/inject pre-configured "seeds" (database snapshots and media assets) to get a functional store running immediately

#### Observability

 - **unified logging**: every container pipes logs into a centralized dashboard
 - **visual dashboard**: an intuitive UI that provides an "at-a-glance" status of the entire ecosystem

#### Maintenance & Scaling

- **pain point status**: currently, the stack is optimized for stability

#### RabbitMQ & Message Brokering

To support high-concurrency and asynchronous processing, **DEVSTACK** includes RabbitMQ service (`optional service`). This allows developers to:

 - `queue testing`: test message queues locally to ensure background tasks are properly dispatched and handled

 - `broker validation`: directly test that your PHP classes are correctly interacting with the exchange and processing payloads as expected

 - `dead letter monitoring`: analyze how the system handles failures by inspecting **dead letter exchanges** (DLX)

#### Target Audience

 - **newbies/trainees**: provides a safe, ``hard-to-break`` environment to learn Adobe Commerce
 - **tech leads**: a reliable, standardized tool to ensure the entire team is running the exact same configuration.
 - **for the business**: faster onboarding. New developers become `run-ready-devs` in hours

---

### Pro-Tip for Integration Lab

When testing a `push/pull sync` over Adobe Commerce Cron/SFTP Server:

 - use `FileZilla` to drop a sample file into the SFTP container

 - run your custom cron: `bin/magento cron:run --group=your_custom_group`

 - check the SFTP directory via `FileZilla` again to see if the file was processed


> [!IMPORTANT]
> 
> When connection with `SFTP/FileZilla` ensure you are using port `22222`

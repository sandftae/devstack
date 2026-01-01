
### 🧠 DEVSTACK INSIGHTS
#### 📌 Project Philosophy

The **DEVSTACK** tool is built on two core pillars:

 - `zero-friction onboarding:` designed so a tech lead can simply provide a repository link and a database dump, allowing a
new developer to be **"ready to code"** in minutes. It effectively bridges the gap between complex enterprise infrastructure and developer ease-of-use

 - `production simulation lab:` beyond simple development, this tool serves as a `sandbox` for `real-world scenarios`. It allows teams
to simulate and test production environments locally for any kind of ERP/CRM, data  synchronizations

---

### Architectural Decisions

#### Modularity & Headless Support

The **DEVSTACK** environment is built for the modern web:

 - `monolith` vs. `headless`: supports traditional Adobe Commerce rendering or a `PWA/headless` frontend

 - `varnish silencing`: the ability to toggle/silence Varnish allows developers to debug cache issues without restarting the entire stack

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

**DEVSTACK** has integrated tools to track the environment state whether it is **idle** or **actively working** (during syncs, cron runs, etc.). This helps:
- monitor system health in real-time
- identify which services consume the most resources

> [!NOTE]
>  - for container monitoring `ctop` is used
>  - `"environment monitoring"` is functionality that is good to use to gain understanding how your code or sync functionality consumes resource. For better understanding this must be tested on real 
> `development` or `staging` environment, but to get `first understanding` it is good to have monitoring on local env. It helps to prevent any unexpected results

#### The "Seeds" (Quick Start)

Setting up a database should not take hours.

 - **seed logic**: integrated commands to pull/inject pre-configured "seeds" (database snapshots) to get a functional store running immediately

#### RabbitMQ & Message Brokering

To support high-concurrency and asynchronous processing, **DEVSTACK** includes RabbitMQ service (`optional one`). This allows developers to:

 - `queue testing`: test message queues locally to ensure background tasks are properly dispatched and handled

 - `broker validation`: directly test that your PHP code is correctly interacting with the exchange and processing payloads as expected

 - `dead letter monitoring`: analyze how the system handles failures by inspecting **dead letter exchanges** (DLX)

#### Observability

- **unified logging**: every container pipes logs into a centralized dashboard

#### Maintenance & Scaling

- **pain point status**: currently, the stack is optimized for stability

--- 

### Target Audience

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
>  - hen connection with `SFTP/FileZilla` ensure you are using port `22222`
>  - see [SHOWCASES](SHOWCASES.md) to get visual showcase of how to test it

---
### MYSQL INITIALIZATION FOLDER / DATABASE SEEDS

---
#### PURPOSE
This folder is for initialization scripts. Any `.sql`, `.sql.gz`, or `.sh`
files placed here are executed `AUTOMATICALLY` by Docker when the
container is created for the very first time.

---
#### USAGE
 - place your base schema or "start-up" data files here
 - run `make up`
 - scripts run in alphabetical order during the first boot

> [!IMPORTANT]
> 
> **THE "SILENT" SEEDING PROCESS**
> 
> The official MySQL Docker image do NOT provide a real-time progress bar
> or UI notifications.
> This may be confusing because once you run env the mysql container is
> up and no database import progress bar is shown.
> So, once you're seeding the database you need to track the process itself.
> Just check db size once in minute to see db size actually increasing.

---

#### WANT MORE CONTROL?
If you need control over importing then just do it manually.

#### FORCE RE-SEED:
If the `database already exists`, scripts here are `IGNORED`. To reset:
 - run ```make down```
 - remove `volume/mysql` folder (**WARNING**: this deletes all data!)
 - RUN ``make up``
 - wait some time until the seeds are finished
 - use ```make list-database``` from-time-to-time to understand dies the db
   seeding is done or not

---

### SOURCES

See this official MySQL image [docs](https://hub.docker.com/_/mysql#initializing-a-fresh-instance)
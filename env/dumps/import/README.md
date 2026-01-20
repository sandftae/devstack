---
### DATABASE IMPORTS (Manual)


This folder is the **waiting room** for SQL files that you intend to
manually import into an existing database using the Makefile.

---

### USAGE

 -  place your `.sql` or` .sql.gz` files here
 -  run the command:

```shell
 make import-database db=<your_db_name> file=<filename>
```

> [!NOTE]
>
> Files in this folder `ARE NOT` automatically executed by Docker on startup.
> They are only processed when you trigger the manual Makefile command.

---

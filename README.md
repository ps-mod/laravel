# About PS-Mod: Laravel
This is a helper function collection for Laravel and Lumen frameworks

# Configuration
This package uses the `lumen.env` file for configuration. It resides in the package folder. (`C:\tools\ps-mod\Laravel` by default) You can access it with the command `lumen conf`.
> Note: When configuring SQL_ADMIN you can also specify executable location
---
# Commands
## admin
Opens the default database admin GUI

### Usage
```ps
lumen admin
```
---
## conf
Opens the configuration file for the script collection.

### Usage
```ps
lumen conf
```
---
## compose
Runs the following commands:
- composer install
- yarn
- php artisan migrate:fresh --seed
- yarn run development

Usefull when you start developing for the day.

### Usage
```ps
lumen compose
```
---
## db:fresh
Drops all migration and reruns all. Equivalent to `php artisan migrate:fresh`

### Usage
```ps
lumen db:fresh
```
---
## db:refresh / db
Drops all migration, reruns all, then runs DatabaseSeeder. Equivalent to `php artisan migrate:fresh --seed`

### Usage
```ps
lumen db:refresh
# or:
lumen db
```
---
## compile / c
Recompiles scss, sass and js files. Equivalent to `yarn run development`

### Usage
```ps
lumen compile
# or:
lumen c
```
---
## coverage
Opens test coverage report

### Usage
```ps
lumen coverage
```
---
## vhosts
Opens apache `httpd-vhosts.conf` file.

### Usage
```ps
lumen vhosts
```
---
## vhosts register / vhosts reg
Registers the current app as a vhost

### Usage
```ps
lumen vhosts register
# or:
lumen vhosts reg
```
---
## hosts
Opens the `C:\Windows\System32\drivers\etc\hosts` file.

### Usage
```ps
lumen hosts
```
---
## hosts register / hosts reg
Registers the current app as a DNS address

### Usage
```ps
lumen hosts register
# or:
lumen hosts reg
```
---
## test
Runs php Unit and Feature tests.

### Usage
```ps
lumen test
```
---
## test cover / test c
Runs PHP Unit and Feature tests and creates a coverage report in html format.

### Usage
```ps
lumen test cover
# or:
lumen test c
```
---
## test include
Includes a specific file or directory in test coverage report

### Syntax
```
lumen test include <Path>
```

### Usage
```ps
lumen test include MyDirectory
lumen test include MyFile
```
---
## test ignore
Excludes a specific file or directory from test coverage report

### Syntax
```
lumen test ignore <Path>
```

### Usage
```ps
lumen test ignore MyDirectory
lumen test ignore MyFile
```
Choose your own Adventure!
==========================

There are lots of frontends and lots of backends out there.

Mix and match to choose your own adventure to explore the LDS API!

Zero-Config Test Drive
----------------------

```bash
curl -fsSL https://bit.ly/lds-api-adventure -o adventure.bash
bash ./adventure.bash node angular
```

Examples
--------

Get the script:

```bash
curl -fsSL https://bit.ly/lds-api-adventure -o adventure.bash
```

Combine ruby + sinatra + jquery:

```bash
bash ./adventure.bash ruby jquery
```

Combine node + express + angular:

```bash
bash ./adventure.bash node angular
```

Combine FirefoxOS + jquery:

```bash
bash ./adventure.bash fxos jquery
```

What are my Choices?
------------------

### Available Frontends

* (jquery) jQuery + Bootstrap
* (angular) AngularJS + Bootstrap

### Available Backends

**Note**: You don't actually need a backend to access the API. The Implicit Grant (Browser) Strategy of OAuth2 / OAuth3 allows for frontend-only tokens.

* (nobackend) static file server only
* (node) node.js + expressjs
* (ruby) ruby + sinatra
* (fxos) Firefox OS v2.x

Choose your own Adventure!
==========================

There are lots of frontends and lots of backends out there.

Mix and match to choose your own adventure to explore the LDS API!

Zero-Config Test Drive
----------------------

```bash
curl -fsSL https://bit.ly/lds-api-adventure -o adventure.bash
bash ./adventure.bash nobackend angular
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

* (jquery) [jQuery + Bootstrap](https://github.com/LDSorg/frontend-oauth2-jquery-example)
* (angular) [AngularJS + Bootstrap](https://github.com/LDSorg/frontend-oauth2-angular-example)

### Available Backends

**Note**: You don't actually need a backend to access the API. The Implicit Grant (Browser) Strategy of OAuth2 / OAuth3 allows for frontend-only tokens.

* (nobackend) [static file server only](https://github.com/LDSorg/backend-oauth2-node-passport-example)
* (node) [node.js + expressjs](https://github.com/LDSorg/backend-oauth2-node-passport-example)
* (ruby) [ruby + sinatra](https://github.com/LDSorg/backend-oauth2-ruby-sinatra-example)
* (fxos) [Firefox OS v2.x (jquery)](https://github.com/LDSorg/fxos-oauth2-jquery-demo)
* (fxos) [Firefox OS v2.x (angular)](https://github.com/LDSorg/fxos-oauth2-angular-demo)

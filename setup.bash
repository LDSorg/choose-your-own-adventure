BACKEND=$1
BACKEND_REPO=""
FRONTEND=$2
FRONTEND_REPO=""

if [ -z "$BACKEND" ]; then
  echo "defaulting to static file server (nobackend)"
  BACKEND="node"
fi

case $BACKEND in
  "nobackend"|"node"|"nodejs"|"node.js")
    BACKEND="node"
    ;;
  "ruby"|"rb")
    BACKEND="ruby"
    ;;
  "fxos"|"FxOS"|"firefoxos")
    BACKEND="fxos"
    ;;
  *)
    echo "Uknown / Unsupported backend: ${BACKEND}"
    ;;
esac

if [ -z "$FRONTEND" ]; then
  echo "defaulting to jQuery (jquery) frontend"
  FRONTEND="jquery"
fi

sleep 2

case $FRONTEND in
  "jquery"|"jQuery")
    FRONTEND="jquery"
    ;;
  "angular"|"angularjs"|"angular.js")
    FRONTEND="angular"
    ;;
  *)
    echo "Uknown / Unsupported frontend: ${FRONTEND}"
    ;;
esac

echo "Checking for (and installing) development tools"
if [ -n "$(which curl)" ]; then
  echo $(curl -fsSL https://iojs.org/dist/index.tab | head -2 | tail -1 | cut -f 1) > /tmp/IOJS_VER
  curl -fsSL bit.ly/iojs-dev -o /tmp/iojs-dev.sh; bash /tmp/iojs-dev.sh
elif [ -n "$(which wget)" ]; then
  echo $(wget --quiet https://iojs.org/dist/index.tab -O - | grep v1 | head -1 | cut -f 1) > /tmp/IOJS_VER
  wget --quiet bit.ly/iojs-dev -O /tmp/iojs-dev.sh; bash /tmp/iojs-dev.sh
else
  echo "Found neither 'curl' nor 'wget'. Can't Continue."
  exit 1
fi

if [ -z "$(which bower)" ]; then
  # if this fails its likely bad permissions on /usr/local
  # sudo chown -R $(whoami):$(whoami) /usr/local
  npm install -g bower
fi

case $BACKEND in
  "nobackend"|"node")
    BACKEND_REPO="https://github.com/LDSorg/backend-oauth2-node-passport-example.git"
    git clone "${BACKEND_REPO}" "backend-oauth2-${BACKEND}"
    pushd "backend-oauth2-${BACKEND}"
    npm install
    ;;
  "ruby")
    BACKEND_REPO="https://github.com/LDSorg/backend-oauth2-ruby-sinatra-example.git"
    git clone "${BACKEND_REPO}" "backend-oauth2-${BACKEND}"
    pushd "backend-oauth2-${BACKEND}"
    if [ -z $(which bundler) ]; then
      echo "sudo gem install bundler"
      sudo gem install bundler
    fi
    bundle install
    ;;
  "fxos")
    FRONTEND="fxos-${FRONTEND}"
    ;;
  *)
    echo "Uknown / Unsupported backend: ${BACKEND}"
    ;;
esac

case $FRONTEND in
  "jquery")
    FRONTEND_REPO="https://github.com/LDSorg/frontend-oauth2-jquery-example.git"
    git clone "${FRONTEND_REPO}" "frontend-oauth2-${FRONTEND}"
    rm -f public
    ln -s "frontend-oauth2-${FRONTEND}" public
    pushd "frontend-oauth2-${FRONTEND}"
    bower install
    ;;
  "angular")
    FRONTEND_REPO="https://github.com/LDSorg/frontend-oauth2-angular-example.git"
    git clone "${FRONTEND_REPO}" "frontend-oauth2-${FRONTEND}"
    rm -f public
    ln -s "frontend-oauth2-${FRONTEND}/app" public
    pushd "frontend-oauth2-${FRONTEND}"
    bower install
    ;;
  "fxos-jquery")
    FRONTEND_REPO="https://github.com/LDSorg/fxos-oauth2-jquery-example.git"
    git clone "${FRONTEND_REPO}" "fxos-oauth2-jquery"
    pushd "fxos-oauth2-jquery"
    bower install
    ;;
  "fxos-angular")
    FRONTEND_REPO="https://github.com/LDSorg/fxos-oauth2-angular-example.git"
    git clone "${FRONTEND_REPO}" "fxos-oauth2-angular"
    pushd "fxos-oauth2-angular"
    bower install
    ;;
  *)
    echo "Uknown / Unsupported frontend: ${FRONTEND}"
    ;;
esac

BACKEND=$1
BACKEND_REPO=""
FRONTEND=$2
FRONTEND_REPO=""

if [ -z "$BACKEND" ]; then
  echo "defaulting to node.js (node) backend"
  BACKEND="node"
fi

if [ -z "$FRONTEND" ]; then
  echo "defaulting to jQuery (jquery) frontend"
  FRONTEND="jquery"
fi

echo "Checking for (and installing) development tools"
echo $(curl -fsSL https://iojs.org/dist/index.tab | head -2 | tail -1 | cut -f 1) > /tmp/IOJS_VER
#echo $(curl -fsSL https://iojs.org/dist/index.tab | grep v1 | head -1 | cut -f 1) > /tmp/IOJS_VER

if [ -n "$(which curl)" ]; then
  curl -fsSL bit.ly/iojs-dev -o /tmp/iojs-dev.sh; bash /tmp/iojs-dev.sh
elif [ -n "$(which wget)" ]; then
  curl --quiet bit.ly/iojs-dev -O /tmp/iojs-dev.sh; bash /tmp/iojs-dev.sh
else
  echo "Found neither 'curl' nor 'wget'. Can't Continue."
  exit 1
fi

if [ -z "$(which bower)" ]; then
  npm install -g bower
fi

case $BACKEND in
  "nobackend"|"node"|"nodejs"|"node.js")
    BACKEND="node"
    BACKEND_REPO="https://github.com/LDSorg/backend-oauth2-node-passport-example.git"
    git clone "${BACKEND_REPO}" "backend-oauth2-${BACKEND}"
    pushd "backend-oauth2-${BACKEND}"
    npm install
    ;;
  "ruby"|"rb")
    BACKEND="ruby"
    BACKEND_REPO="https://github.com/LDSorg/backend-oauth2-ruby-sinatra-example.git"
    git clone "${BACKEND_REPO}" "backend-oauth2-${BACKEND}"
    pushd "backend-oauth2-${BACKEND}"
    if [ -z $(which bundler) ]; then
      echo "sudo gem install bundler"
      sudo gem install bundler
    fi
    bundle install
    ;;
  *)
    echo "Uknown / Unsupported backend: ${BACKEND}"
    ;;
esac

case $FRONTEND in
  "jquery"|"jQuery")
    FRONTEND="jquery"
    FRONTEND_REPO="https://github.com/LDSorg/frontend-oauth2-jquery-example.git"
    git clone "${FRONTEND_REPO}" "frontend-oauth2-${FRONTEND}"
    rm -f public
    ln -s "frontend-oauth2-${FRONTEND}" public
    pushd "frontend-oauth2-${FRONTEND}"
    bower install
    ;;
  "angular"|"angularjs"|"angular.js")
    FRONTEND="angular"
    FRONTEND_REPO="https://github.com/LDSorg/frontend-oauth2-angular-example.git"
    git clone "${FRONTEND_REPO}" "frontend-oauth2-${FRONTEND}"
    rm -f public
    ln -s "frontend-oauth2-${FRONTEND}/app" public
    pushd "frontend-oauth2-${FRONTEND}"
    bower install
    ;;
  *)
    echo "Uknown / Unsupported frontend: ${FRONTEND}"
    ;;
esac

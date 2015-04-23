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
if [ -z "$(which git)" ] || [ -z "$(which node)" ] || [ -z "$(which gcc)" ]; then
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
    START_CMD="node ./serve.js"
    ;;
  "ruby")
    BACKEND_REPO="https://github.com/LDSorg/backend-oauth2-ruby-sinatra-example.git"
    git clone "${BACKEND_REPO}" "backend-oauth2-${BACKEND}"
    pushd "backend-oauth2-${BACKEND}"
    if [ -z $(which bundler) ]; then
      echo "sudo gem install bundler"
      sudo gem install bundler
    fi
    rsync -a db.sample.json db.json
    bundle install
    START_CMD="ruby ./app.rb"
    ;;
  "fxos")
    FRONTEND="fxos-${FRONTEND}"
    ;;
  *)
    echo "Uknown / Unsupported backend: ${BACKEND}"
    ;;
esac

FC_BACKEND_DIR=$(pwd)

case $BACKEND in
  "fxos")
    # ignore
    ;;
  *)
    git clone https://github.com/LDSorg/local.ldsconnect.org-certificates.git ./certs
    tree -I .git ./certs
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
    ln -s "frontend-oauth2-${FRONTEND}" public
    pushd "frontend-oauth2-${FRONTEND}"
    bower install
    ;;
  "ldsio")
    FRONTEND_REPO="https://github.com/LDSorg/lds.io-frontend.git"
    git clone "${FRONTEND_REPO}" "lds.io-frontend"
    rm -f public
    ln -s "lds.io-frontend/app" public
    pushd "lds.io-frontend"
    bower install
    ;;
  "ldsconnect")
    FRONTEND_REPO="https://github.com/LDSorg/ldsconnect.org-frontend.git"
    git clone "${FRONTEND_REPO}" "ldsconnect.org-frontend"
    rm -f public
    ln -s "ldsconnect.org-frontend/app" public
    pushd "ldsconnect.org-frontend"
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

FC_FRONTEND_DIR=$(pwd)

echo ""
echo ""
echo "###############################################"
echo "#                                             #"
echo "#   READY! Here's what you need to do next:   #"
echo "#                                             #"
echo "###############################################"
echo ""

case $FRONTEND in
  # TODO if [ -f "${FC_BACKEND_DIR}/POST-INSTALL" ]; then cat "${FC_BACKEND_DIR}/POST-INSTALL" fi
  # TODO if [ -f "${FC_FRONTEND_DIR}/POST-INSTALL" ]; then cat "${FC_FRONTEND_DIR}/POST-INSTALL" fi
  "jquery"|"angular")
    echo "1. Open up a new tab and run the server like so:"
    echo ""
    echo "    pushd" "${FC_BACKEND_DIR}"
    echo "    ${START_CMD}"
    echo ""
    echo ""

    echo "2. Open up yet another new tab and take a look at the frontend:"
    echo ""
    echo "    pushd" "${FC_FRONTEND_DIR}"
    echo "    tree ./ -I bower_components"
    echo ""
    echo "  This is where you can edit files to your heart's content"
    echo ""

    echo "3. Open up your web browser and fire it up to the project:"
    echo ""
    echo "    https://local.ldsconnect.org:8043"
    echo ""
    echo ""
    ;;

  "fxos")
    echo "1. Open a new tab and take a look at the frontend:"
    echo ""
    echo "    pushd" "${FC_FRONTEND_DIR}"
    echo "    tree ./ -I bower_components"
    echo ""
    echo "  This is where you can edit files to your heart's content"
    echo ""

    echo "2. Install Firefox Developer Edition and the FxOS App Manager Suite"
    echo ""
    echo "    http://developer.android.com/sdk/installing/index.html?pkg=tools"
    echo "    https://www.mozilla.org/en-US/firefox/developer"
    echo "    http://ftp.mozilla.org/pub/mozilla.org/labs/fxos-simulator/"
    echo ""
    echo "    Tools => Web Developer => WebIDE (Shift + Fn + F8)"
    echo ""
    echo ""


    echo "3. Install to your device:"
    echo ""
    echo "    Plug in your phone via USB"
    echo "    Unlock the home screen"
    echo "    Settings => Developer => Debugging via USB => ADB and DevTools"
    echo "    run 'adb devices' to make sure your phone is present"
    echo ""
    echo "    WebIDE => Select a Runtime => Flame (or whatever your phone is)"
    echo "    Accept the Connection on the Home Screen"
    echo "    Click the 'Play' Icon"
    echo ""
    echo ""

    echo "Need Help?"
    echo ""
    echo "    Need to install ADB?"
    echo "    Need to upgrade your phone?"
    echo ""
    echo "    See https://coolaj86.com/articles/how-to-upgrade-the-flame-from-fxos-1-x-to-2-x.html"
    echo ""
    echo ""
    ;;
esac

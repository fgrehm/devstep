needs_resolution() {
  local semver=$1
  if ! [[ "$semver" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    return 0
  else
    return 1
  fi
}

install_nodejs() {
  local version="$1"
  local dir="$2"
  local cache_dir="$3"

  if needs_resolution "$version"; then
    echo "Resolving node version ${version:-(latest stable)} via semver.io..."
    # local version=$(curl --silent --get --data-urlencode "range=${version}" https://semver.herokuapp.com/node/resolve)
    local version=$(curl --silent --get --data-urlencode "range=${version}" https://semver.herokuapp.com/node/resolve)
  fi

  local tarball="node-v$version-$os-$cpu.tar.gz"
  # local download_url="http://s3pository.heroku.com/node/v$version/node-v$version-$os-$cpu.tar.gz"
  local download_url="http://s3pository.heroku.com/node/v$version/$tarball"
  # curl "$download_url" -s -o - | tar xzf - -C /tmp

  local tarball_path="$cache_dir/$tarball"
  if [ -f $tarball_path ]; then
    status "Using cached node $version tarball"
  else
    echo "Downloading and installing node $version..."
    curl -L $download_url > $tarball_path
  fi
  mkdir -p $dir
  tar xzf $tarball_path -C $dir --strip-components=1

  # mv /tmp/node-v$version-$os-$cpu/* $dir
  chmod +x $dir/bin/*
}

install_iojs() {
  local version="$1"
  local dir="$2"
  local cache_dir="$3"

  if needs_resolution "$version"; then
    echo "Resolving iojs version ${version:-(latest stable)} via semver.io..."
    version=$(curl --silent --get --data-urlencode "range=${version}" https://semver.herokuapp.com/iojs/resolve)
  fi

  echo "Downloading and installing iojs $version..."
  local tarball="iojs-v$version-$os-$cpu.tar.gz"
  # local download_url="https://iojs.org/dist/v$version/iojs-v$version-$os-$cpu.tar.gz"
  local download_url="https://iojs.org/dist/v$version/$tarball"
  # curl $download_url -s -o - | tar xzf - -C /tmp

  local tarball_path="$cache_dir/$tarball"
  if [ -f $tarball_path ]; then
    status "Using cached iojs $version tarball"
  else
    curl -L $download_url > $tarball_path
  fi
  mkdir -p $dir
  tar xzf $tarball_path -C $dir --strip-components=1

  # mv /tmp/iojs-v$version-$os-$cpu/* $dir
  chmod +x $dir/bin/*
}

install_npm() {
  local version="$1"
  local cache_dir="$3"

  if [ "$version" == "" ]; then
    echo "Using default npm version: `npm --version`"
  else
    if needs_resolution "$version"; then
      echo "Resolving npm version ${version} via semver.io..."
      version=$(curl --silent --get --data-urlencode "range=${version}" https://semver.herokuapp.com/npm/resolve)
    fi
    if [[ `npm --version` == "$version" ]]; then
      echo "npm `npm --version` already installed with node"
    else
      echo "Downloading and installing npm $version (replacing version `npm --version`)..."
      npm install --unsafe-perm --quiet -g npm@$version 2>&1 >/dev/null
    fi
  fi
}

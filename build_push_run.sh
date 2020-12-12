#!/usr/bin/env zsh

version="$1"
host="root@remarkable.local"
arch="armv7-unknown-linux-musleabihf"
#arch="armv7-unknown-linux-gnueabihf"

echo "Compiling..."
if [ "$version" = "release" ]; then
  cross build --target "$arch" --release
else
  cross build --target "$arch"
fi
echo "Done"

# shellcheck disable=SC2181
if [ $? -eq 0 ]; then
  echo "Killing last process..."
  ssh $host "killall pipes-and-rust"
  echo "Done"
  echo "Copying to device..."
  scp "./target/$arch/$version/pipes-and-rust" "$host:/opt/pipes-and-rust" && echo "Done" && ssh "$host" "/opt/pipes-and-rust"
fi

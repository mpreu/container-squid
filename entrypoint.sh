#!/bin/sh
set -e

squid_executable=$(which squid)
squid_config="/etc/squid/squid.conf"

# Parse extra arguments
case $1 in 
  # Test for flags
  -*) 
    EXTRA_ARGS="$@"
    set --
    ;;
esac

echo "Create log directory"
mkdir -p $SQUID_LOG_DIR
chmod -R 755 $SQUID_LOG_DIR
chown -R $SQUID_USER:$SQUID_USER $SQUID_LOG_DIR

echo "Create cache directory"  
mkdir -p $SQUID_CACHE_DIR
chown -R $SQUID_USER:$SQUID_USER $SQUID_CACHE_DIR

# Run squid
if [[ -z $1 ]]; then
  if [[ ! -d $SQUID_CACHE_DIR/00 ]]; then
    echo "Initializing cache directories..."
    $squid_executable -N -f $squid_config -z
  fi
  echo "Starting squid..."
  exec $squid_executable -f $squid_config -NYCd 1 $EXTRA_ARGS
else
  exec "$@"
fi
#! /usr/bin/env bash
BUILD_PATH=$(cd "build" && pwd)
BASE_PATH=$(pwd)

deploy() {
  echo
  echo "Strartig Deploy spring-petclinic-data-jdbc ."

  echo "--[01] Build Java File---"
  gradle build -b $BASE_PATH/build.gradle

  echo "--[02] Build Docker File---"
  #cd $BUILD_PATH
  #version=`cat dockerBuildVersion.txt`
  docker build -f DockerfilePetClinic -t petclinic .
  docker-compose -f docker-compose.yml up -d
  #docker container exec nginx nginx -s reload
  echo
  echo " All Container Deploy Complieted!"
  docker ps 
}

case "$1" in
  start)
    start
    ;;
  stop)
    stop
    ;;
  restart)
    restart
    ;;
  status)
    status
    ;;
  deploy)
    deploy
    ;;
*)
  echo "Usage: $0 {start | stop | restart | status | deploy}"
esac
exit 0
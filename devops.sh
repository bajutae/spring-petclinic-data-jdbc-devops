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

k8s_deploy() {
  echo
  echo "## Strartig k8s yaml . ##"
  echo "## install ingress nginx controller## "
  kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/cloud/deploy.yaml
  kubectl apply -f ./k8s
  echo
  echo "## k8s apply Complieted! ##"
}

k8s_delete() {
  echo
  echo "## Delete k8s yaml . ##"
  echo
  kubectl delete svc,deploy petclinic
  kubectl delete svc,deploy,configmap mysql
  kubectl delete namespace ingress-nginx
  echo
  echo "## k8s Delete Complieted! ##"
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
  k8s_deploy)
    k8s_deploy
    ;;
  k8s_delete)
    k8s_delete
    ;;
*)
  echo "Usage: $0 {start | stop | restart | status | deploy | k8s_deploy | k8s_delete}"
esac
exit 0
#! /usr/bin/env bash
BUILD_PATH=$(cd "build" && pwd)
BASE_PATH=$(pwd)

build() {
  echo
  echo "Strartig Deploy spring-petclinic-data-jdbc ."

  echo "--[01] Build Java File---"
  gradle build -b $BASE_PATH/build.gradle

  echo "--[02] Build Docker File---"
  #cd $BUILD_PATH
  #version=`cat dockerBuildVersion.txt`
  docker build -f DockerfilePetClinic -t petclinic .

  ## not this test k8s deploy
  #docker-compose -f docker-compose.yml up -d
  #docker container exec nginx nginx -s reload
  echo
  echo " All Container Deploy Complieted!"
}

k8s_deploy() {
  echo
  echo "## Init petclinic k8s yaml . ##"
  kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/cloud/deploy.yaml
  kubectl apply -f ./k8s/init
  echo
  echo "## k8s Completed! ##"
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

petclinic_deploy() {
  echo
  echo "## Deploy petclinic v2 ##"
  echo
  kubectl delete svc,deploy petclinic
  kubectl delete svc,deploy,configmap mysql
  kubectl delete namespace ingress-nginx
  echo
  echo "## k8s Delete Complieted! ##"
}

case "$1" in

  build)
    build
    ;;
  k8s_deploy)
    k8s_deploy
    ;;
  k8s_delete)
    k8s_delete
    ;;
*)
  echo "Usage: $0 {build | k8s_deploy | k8s_delete}"
esac
exit 0
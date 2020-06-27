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
  echo
  echo "## k8s Delete Completed! ##"
}

petclinic_deploy() {
  echo
  echo "## Deploy petclinic v2 ##"
  kubectl apply -f ./k8s/petclinic_new.yaml
  echo
  echo
  echo "## k8s Deploy Completed! ##"
}

petclinic_scale_in() {
  echo
  echo "## Scale-in petclinic ##"
  kubectl scale deploy petclinic --replicas=1
  kubectl get deploy petclinic
  echo
  echo "## Completed Scale-in petclinic ##"
}

petclinic_scale_out() {
  echo
  echo "## Scale-out petclinic ##"
  kubectl scale deploy petclinic --replicas=3
  kubectl get deploy petclinic
  echo
  echo "## Completed Scale-out petclinic ##"
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
  petclinic_deploy)
    petclinic_deploy
    ;;
  petclinic_scale_in)
    petclinic_scale_in
    ;;
  petclinic_scale_out)
    petclinic_scale_out
    ;;

*)
  echo "Usage: $0 {build | k8s_deploy | k8s_delete | petclinic_deploy | petclinic_scale_in | petclinic_scale_out}"
esac
exit 0
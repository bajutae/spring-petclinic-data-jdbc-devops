# Devops 프로젝트
--
## 과제 내용
웹 어플리케이션 spring-petclinic-data-jdbc 을 kubernetes 환경에서 실행하고자 합니다.
- 다음의 요구 사항에 부합하도록 빌드 스크립트, 어플리케이션 코드 등을
작성하십시오.
- kubernetes에 배포하기 위한 manifest 파일을 작성하십시오.

## 테스트 환경
- Mac OS Catalina
- git version 2.24.3 (Apple Git-128)
- Gradle 6.5
- Docker desktop Community Mac
  -  Version: 19.03.8
- java
  - openjdk version "12.0.1" 2019-04-16
  - OpenJDK Runtime Environment (build 12.0.1+12)
  - OpenJDK 64-Bit Server VM (build 12.0.1+12, mixed mode, sharing)
- kubernetes - Docker desktop Community Mac
  - 1.16.5
- vscode 
- docker repository: docker hub - 빌드된 거 두가지 버전으로 업로드
  - bajutae/petclinic:1.0
  - bajutae/petclinic:1.1

## 실행 방법
---
## 소스코드 다운로드 및 Docker Build

- 소스 코드 다운로드

```shell
$ git clone https://github.com/bajutae/spring-petclinic-data-jdbc-devops.git
```

- Docker Build & 이미지 만들기

```shell
$ cd spring-petclinic-data-jdbc-devops
$ ./devops.sh build
```

## Kubernetes 자원 deploy

- 최초 petclinic 어플리케이션 배포 및 기타 자원 배포

```shell
$ ./devops.sh k8s_deploy
```

- petclinic 어플리케이션 v2 배포

```shell
$ ./devops.sh petclinic_deploy
```

- petclinic 어플리케이션 Scale-in & out 방법

```shell
# scale in
$ ./devops.sh petclinic_scale_in

# scale out
$ ./devops.sh petclinic_scale_out
```

## 요구사항 세부 설명 
- [x] gradle을 사용하여 어플리케이션과 도커이미지를 빌드한다.
  - maven -> gradle 변환
  
  ```shell
  gradle init --type pom
  ```

  - [build.gradle](https://github.com/bajutae/spring-petclinic-data-jdbc-devops/blob/master/build.gradle) 빌드 실패하지 않게 수정 작업

- [x] 어플리케이션의 log는 host의 /logs 디렉토리에 적재되도록 한다.
  - [application.property](https://github.com/bajutae/spring-petclinic-data-jdbc-devops/blob/master/src/main/resources/application.properties)에 다음 항목 추가 logging.file.path=/logs
  - Dockerfile 에 **VOLUME ["/logs"]** 추가
  - log 확인

```shell
  MacBook-Pro-2:spring-petclinic-data-jdbc-devops jtpark$ k get po
NAME                         READY   STATUS    RESTARTS   AGE
mysql-dccdc87c4-dlphk        1/1     Running   0          3m44s
petclinic-6d847db9b7-bghx5   1/1     Running   0          3m44s
MacBook-Pro-2:spring-petclinic-data-jdbc-devops jtpark$ k exec -it petclinic-6d847db9b7-bghx5 sh
/ # ls
app.jar  dev      home     logs     mnt      proc     run      srv      tmp      var
bin      etc      lib      media    opt      root     sbin     sys      usr
/ # cd logs/
/logs # ls
spring.log
/logs # tail -f spring.log 
2020-06-27 03:09:58.382  INFO [,,,] 1 --- [main] o.f.core.internal.command.DbValidate     : Successfully validated 2 migrations (execution time 00:00.128s)
2020-06-27 03:09:58.399  INFO [,,,] 1 --- [main] o.f.core.internal.command.DbMigrate      : Current version of schema `petclinic`: 002
2020-06-27 03:09:58.401  INFO [,,,] 1 --- [main] o.f.core.internal.command.DbMigrate      : Schema `petclinic` is up to date. No migration necessary.
2020-06-27 03:10:01.668  INFO [,,,] 1 --- [main] o.s.s.concurrent.ThreadPoolTaskExecutor  : Initializing ExecutorService 'applicationTaskExecutor'
2020-06-27 03:10:05.646  INFO [,,,] 1 --- [main] o.s.b.a.e.web.EndpointLinksResolver      : Exposing 18 endpoint(s) beneath base path '/manage'
2020-06-27 03:10:05.893  INFO [,,,] 1 --- [main] o.s.b.w.embedded.tomcat.TomcatWebServer  : Tomcat started on port(s): 8080 (http) with context path ''
2020-06-27 03:10:05.936  INFO [,,,] 1 --- [main] o.s.s.petclinic.PetClinicApplication     : Started PetClinicApplication in 29.397 seconds (JVM running for 30.984)
2020-06-27 03:12:31.005  INFO [,,,] 1 --- [http-nio-8080-exec-1] o.a.c.c.C.[Tomcat].[localhost].[/]       : Initializing Spring DispatcherServlet 'dispatcherServlet'
2020-06-27 03:12:31.007  INFO [,,,] 1 --- [http-nio-8080-exec-1] o.s.web.servlet.DispatcherServlet        : Initializing Servlet 'dispatcherServlet'
2020-06-27 03:12:31.062  INFO [,,,] 1 --- [http-nio-8080-exec-1] o.s.web.servlet.DispatcherServlet        : Completed initialization in 54 ms
```

- [ ] 정상 동작 여부를 반환하는 api를 구현하며, 10초에 한번 체크하도록 한다. 3번 연속 체크에 실패하 면 어플리케이션은 restart 된다.
  - 정상 동작 여부 반환 API는 구현못함
  - 컨테이너 설정에서 liveness를 설정한다. 스프링부트의 api를 이용한다. 
  - [petclinic.yaml](https://github.com/bajutae/spring-petclinic-data-jdbc-devops/blob/master/k8s/init/petclinic.yaml) 에 설정
  - liveness는 헬스체크가 되지 않으면 POD를 재부팅한다. 

```shell
livenessProbe:
          httpGet:
            path: /actuator/liveness
            port: 80
          initialDelaySeconds: 130
          periodSeconds: 10
          failureThreshold: 3
```

- [X] 종료 시 30초 이내에 프로세스가 종료되지 않으면 SIGKILL로 강제 종료 시킨다.
  - [petclinic.yaml](https://github.com/bajutae/spring-petclinic-data-jdbc-devops/blob/master/k8s/init/petclinic.yaml) 에 **terminationGracePeriodSeconds: 30** 30초 후에 강제로 삭제된다. 
- [X] 배포 시와 scale in/out 시 유실되는 트래픽이 없어야 한다.
  - 배포시 Roling update와 블루/그린 배포로 트래픽 유실없이 실행
- [X] 어플리케이션 프로세스는 root 계정이 아닌 uid:1000으로 실행한다.
  - [petclinic.yaml](https://github.com/bajutae/spring-petclinic-data-jdbc-devops/blob/master/k8s/init/petclinic.yaml) 파일에 **securityContext runAsUser: 1000** 추가
  - 확인

```shell
MacBook-Pro-2:init jtpark$ k get pod
NAME                        READY   STATUS    RESTARTS   AGE
mysql-dccdc87c4-q4mj5       1/1     Running   0          2m8s
petclinic-c66db4749-6kvpz   1/1     Running   0          12s
petclinic-c66db4749-6ncbb   1/1     Running   0          12s
petclinic-c66db4749-hdbh7   1/1     Running   0          12s
MacBook-Pro-2:init jtpark$ k exec -it petclinic-c66db4749-6kvpz sh
/ $ 
/ $ 
/ $ id
uid=1000 gid=0(root)
```

- [X] DB도 kubernetes에서 실행하며 재 실행 시에도 변경된 데이터는 유실되지 않도록 설정한다. 어플리케이션과 DB는 cluster domain을 이용하여 통신한다.
  - [mysql_statefulset.yaml](https://github.com/bajutae/spring-petclinic-data-jdbc-devops/blob/master/k8s/init/mysql_statefulset.yaml) statefulset 으로 처리하여 데이터 유실 방지
- [x] nginx-ingress-controller를 통해 어플리케이션에 접속이 가능하다.
  - nginx-ingress-controller 설치

```
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/static/provider/cloud/deploy.yaml
```
  - [ingress.yaml](https://github.com/bajutae/spring-petclinic-data-jdbc-devops/blob/master/k8s/init/ingress.yaml)을 이용해 서비스 패스를 설정한다. 
- [x] namespace는 default를 사용한다.
  - ingress nginx controller를 제외한 생성한 자원 default
```shell
  k get all -n default
NAME                             READY   STATUS    RESTARTS   AGE
pod/mysql-0                      2/2     Running   0          21m
pod/mysql-1                      0/2     Pending   0          20m
pod/petclinic-69d75fc57c-njdz9   1/1     Running   6          21m
pod/petclinic-69d75fc57c-xnb6h   1/1     Running   6          21m

NAME                 TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)          AGE
service/kubernetes   ClusterIP   10.96.0.1       <none>        443/TCP          38d
service/petclinic    NodePort    10.101.40.183   <none>        8080:32300/TCP   21m

NAME                        READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/petclinic   2/2     2            2           21m

NAME                                   DESIRED   CURRENT   READY   AGE
replicaset.apps/petclinic-69d75fc57c   2         2         2       21m

NAME                     READY   AGE
statefulset.apps/mysql   1/2     21m
  ```

- [X] README.md 파일에 실행 방법을 기술한다.

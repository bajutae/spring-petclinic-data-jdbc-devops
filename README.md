# Devops 프로젝트
--
## 과제 내용
웹 어플리케이션 spring-petclinic-data-jdbc 을 kubernetes 환경에서 실행하고자 합니다.
- 다음의 요구 사항에 부합하도록 빌드 스크립트, 어플리케이션 코드 등을
작성하십시오.
- kubernetes에 배포하기 위한 manifest 파일을 작성하십시오.

## 테스트 환경
---
- Mac OS Catalina
- git version 2.24.3 (Apple Git-128)
- Gradle 6.5
- java
  - openjdk version "12.0.1" 2019-04-16
  - OpenJDK Runtime Environment (build 12.0.1+12)
  - OpenJDK 64-Bit Server VM (build 12.0.1+12, mixed mode, sharing)
- kubernetes
  - Client Version: version.Info{Major:"1", Minor:"16", GitVersion:"v1.16.0", GitCommit:"2bd9643cee5b3b3a5ecbd3af49d09018f0773c77", GitTreeState:"clean", BuildDate:"2019-09-18T14:36:53Z", GoVersion:"go1.12.9", Compiler:"gc", Platform:"darwin/amd64"}
Server Version: version.Info{Major:"1", Minor:"16+", GitVersion:"v1.16.6-beta.0", GitCommit:"e7f962ba86f4ce7033828210ca3556393c377bcc", GitTreeState:"clean", BuildDate:"2020-01-15T08:18:29Z", GoVersion:"go1.13.5", Compiler:"gc", Platform:"linux/amd64"}
- vscode 
---

## 요구사항
- [x] gradle을 사용하여 어플리케이션과 도커이미지를 빌드한다.
  - maven -> gradle 변환
  ```
  gradle init --type pom
  ```
  - build.gradle 빌드 실패하지 않게 수정 작업
- [x] 어플리케이션의 log는 host의 /logs 디렉토리에 적재되도록 한다.
  - application.property에 다음 항목 추가 logging.file.path=/logs
  - Dockerfile 에 **VOLUME ["/logs"]** 추가
  - log 확인

```
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

- [x] 정상 동작 여부를 반환하는 api를 구현하며, 10초에 한번 체크하도록 한다. 3번 연속 체크에 실패하 면 어플리케이션은 restart 된다.
  - 컨테이너 설정에서 liveness를 설정한다. 스프링부트의 api를 이용한다. 

```
livenessProbe:
          httpGet:
            path: /actuator/liveness
            port: 80
          initialDelaySeconds: 130
          periodSeconds: 10
          failureThreshold: 3
```

- [X] 종료 시 30초 이내에 프로세스가 종료되지 않으면 SIGKILL로 강제 종료 시킨다.
  - **terminationGracePeriodSeconds: 30** 30초 후에 강제로 삭제된다. 
- [ ] 배포 시와 scale in/out 시 유실되는 트래픽이 없어야 한다.
  - 블루/그린 ? 아니면 그냥 롤링 업데이트 ?
- [X] 어플리케이션 프로세스는 root 계정이 아닌 uid:1000으로 실행한다.
  - petclinic.yaml 파일에 securityContext runAsUser: 1000 추가
  - 다음으로 확인

```
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

- [ ] DB도 kubernetes에서 실행하며 재 실행 시에도 변경된 데이터는 유실되지 않도록 설정한다. 어플리케이션과 DB는 cluster domain을 이용하여 통신한다.
  - statefulset으로 처리
  - cluster domain 처리가 안됨
- [x] nginx-ingress-controller를 통해 어플리케이션에 접속이 가능하다.
  - nginx-ingress-controller 설치
- [x] namespace는 default를 사용한다.
- [ ] README.md 파일에 실행 방법을 기술한다.
  - 파일 실행방법을 자세하게 한다. 

## 그 외 개인적인 문제점 
- [ ] docker 에러남

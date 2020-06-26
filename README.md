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
- [ ] 어플리케이션의 log는 host의 /logs 디렉토리에 적재되도록 한다.
- [ ] 정상 동작 여부를 반환하는 api를 구현하며, 10초에 한번 체크하도록 한다. 3번 연속 체크에 실패하 면 어플리케이션은 restart 된다.
- [ ] 종료 시 30초 이내에 프로세스가 종료되지 않으면 SIGKILL로 강제 종료 시킨다.
- [ ] 배포 시와 scale in/out 시 유실되는 트래픽이 없어야 한다.
- [ ] 어플리케이션 프로세스는 root 계정이 아닌 uid:1000으로 실행한다.
- [ ] DB도 kubernetes에서 실행하며 재 실행 시에도 변경된 데이터는 유실되지 않도록 설정한다. 어플리케이션과 DB는 cluster domain을 이용하여 통신한다.
  - statefulset으로 처리
- [x] nginx-ingress-controller를 통해 어플리케이션에 접속이 가능하다.
  - nginx-ingress-controller 설치
- [x] namespace는 default를 사용한다.
- [ ] README.md 파일에 실행 방법을 기술한다.
@rem
@rem Copyright 2015 the original author or authors.
@rem
@rem Licensed under the Apache License, Version 2.0 (the "License");
@rem you may not use this file except in compliance with the License.
@rem You may obtain a copy of the License at
@rem
@rem      https://www.apache.org/licenses/LICENSE-2.0
@rem
@rem Unless required by applicable law or agreed to in writing, software
@rem distributed under the License is distributed on an "AS IS" BASIS,
@rem WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
@rem See the License for the specific language governing permissions and
@rem limitations under the License.
@rem

@if "%DEBUG%" == "" @echo off
@rem ##########################################################################
@rem
@rem  spring-petclinic-data-jdbc startup script for Windows
@rem
@rem ##########################################################################

@rem Set local scope for the variables with windows NT shell
if "%OS%"=="Windows_NT" setlocal

set DIRNAME=%~dp0
if "%DIRNAME%" == "" set DIRNAME=.
set APP_BASE_NAME=%~n0
set APP_HOME=%DIRNAME%..

@rem Resolve any "." and ".." in APP_HOME to make it shorter.
for %%i in ("%APP_HOME%") do set APP_HOME=%%~fi

@rem Add default JVM options here. You can also use JAVA_OPTS and SPRING_PETCLINIC_DATA_JDBC_OPTS to pass JVM options to this script.
set DEFAULT_JVM_OPTS=

@rem Find java.exe
if defined JAVA_HOME goto findJavaFromJavaHome

set JAVA_EXE=java.exe
%JAVA_EXE% -version >NUL 2>&1
if "%ERRORLEVEL%" == "0" goto init

echo.
echo ERROR: JAVA_HOME is not set and no 'java' command could be found in your PATH.
echo.
echo Please set the JAVA_HOME variable in your environment to match the
echo location of your Java installation.

goto fail

:findJavaFromJavaHome
set JAVA_HOME=%JAVA_HOME:"=%
set JAVA_EXE=%JAVA_HOME%/bin/java.exe

if exist "%JAVA_EXE%" goto init

echo.
echo ERROR: JAVA_HOME is set to an invalid directory: %JAVA_HOME%
echo.
echo Please set the JAVA_HOME variable in your environment to match the
echo location of your Java installation.

goto fail

:init
@rem Get command-line arguments, handling Windows variants

if not "%OS%" == "Windows_NT" goto win9xME_args

:win9xME_args
@rem Slurp the command line arguments.
set CMD_LINE_ARGS=
set _SKIP=2

:win9xME_args_slurp
if "x%~1" == "x" goto execute

set CMD_LINE_ARGS=%*

:execute
@rem Setup the command line

set CLASSPATH=%APP_HOME%\lib\spring-petclinic-data-jdbc-2.1.0.BUILD-SNAPSHOT.jar;%APP_HOME%\lib\wavefront-spring-boot-starter-2.0.0-RC1.jar;%APP_HOME%\lib\spring-boot-starter-validation-2.3.0.RC1.jar;%APP_HOME%\lib\spring-boot-starter-cache-2.3.0.RC1.jar;%APP_HOME%\lib\spring-boot-starter-web-2.3.0.RC1.jar;%APP_HOME%\lib\spring-boot-starter-thymeleaf-2.3.0.RC1.jar;%APP_HOME%\lib\spring-boot-starter-data-jdbc-2.3.0.RC1.jar;%APP_HOME%\lib\spring-boot-starter-jdbc-2.3.0.RELEASE.jar;%APP_HOME%\lib\spring-boot-starter-json-2.3.0.RELEASE.jar;%APP_HOME%\lib\spring-cloud-starter-sleuth-2.2.2.RELEASE.jar;%APP_HOME%\lib\spring-cloud-starter-2.2.2.RELEASE.jar;%APP_HOME%\lib\spring-boot-starter-aop-2.3.0.RELEASE.jar;%APP_HOME%\lib\spring-boot-starter-2.3.0.RELEASE.jar;%APP_HOME%\lib\wavefront-spring-boot-2.0.0-RC1.jar;%APP_HOME%\lib\spring-boot-actuator-autoconfigure-2.3.0.RELEASE.jar;%APP_HOME%\lib\spring-boot-starter-tomcat-2.3.0.RELEASE.jar;%APP_HOME%\lib\spring-boot-devtools-2.3.0.RC1.jar;%APP_HOME%\lib\spring-boot-autoconfigure-2.3.0.RELEASE.jar;%APP_HOME%\lib\spring-boot-actuator-2.3.0.RELEASE.jar;%APP_HOME%\lib\spring-boot-2.3.0.RELEASE.jar;%APP_HOME%\lib\spring-boot-starter-logging-2.3.0.RELEASE.jar;%APP_HOME%\lib\spring-boot-starter-actuator-2.3.0.RC1.jar;%APP_HOME%\lib\flyway-core-6.4.1.jar;%APP_HOME%\lib\caffeine-2.8.2.jar;%APP_HOME%\lib\webjars-locator-core-0.45.jar;%APP_HOME%\lib\jquery-ui-1.11.4.jar;%APP_HOME%\lib\bootstrap-3.3.6.jar;%APP_HOME%\lib\jquery-2.2.4.jar;%APP_HOME%\lib\mysql-connector-java-8.0.20.jar;%APP_HOME%\lib\micrometer-registry-wavefront-1.5.1.jar;%APP_HOME%\lib\micrometer-core-1.5.1.jar;%APP_HOME%\lib\jakarta.el-3.0.3.jar;%APP_HOME%\lib\hibernate-validator-6.1.5.Final.jar;%APP_HOME%\lib\spring-context-support-5.2.6.RELEASE.jar;%APP_HOME%\lib\spring-data-jdbc-2.0.0.RELEASE.jar;%APP_HOME%\lib\spring-webmvc-5.2.6.RELEASE.jar;%APP_HOME%\lib\spring-web-5.2.6.RELEASE.jar;%APP_HOME%\lib\thymeleaf-spring5-3.0.11.RELEASE.jar;%APP_HOME%\lib\thymeleaf-extras-java8time-3.0.4.RELEASE.jar;%APP_HOME%\lib\checker-qual-3.3.0.jar;%APP_HOME%\lib\error_prone_annotations-2.3.4.jar;%APP_HOME%\lib\spring-cloud-sleuth-core-2.2.2.RELEASE.jar;%APP_HOME%\lib\wavefront-opentracing-sdk-java-1.16.jar;%APP_HOME%\lib\HikariCP-3.4.5.jar;%APP_HOME%\lib\spring-data-relational-2.0.0.RELEASE.jar;%APP_HOME%\lib\spring-data-commons-2.3.0.RELEASE.jar;%APP_HOME%\lib\thymeleaf-3.0.11.RELEASE.jar;%APP_HOME%\lib\logback-classic-1.2.3.jar;%APP_HOME%\lib\log4j-to-slf4j-2.13.2.jar;%APP_HOME%\lib\jul-to-slf4j-1.7.30.jar;%APP_HOME%\lib\slf4j-api-1.7.30.jar;%APP_HOME%\lib\classgraph-4.8.69.jar;%APP_HOME%\lib\jackson-datatype-jsr310-2.11.0.jar;%APP_HOME%\lib\jackson-datatype-jdk8-2.11.0.jar;%APP_HOME%\lib\jackson-module-parameter-names-2.11.0.jar;%APP_HOME%\lib\wavefront-runtime-sdk-jvm-0.9.10.jar;%APP_HOME%\lib\wavefront-internal-reporter-java-1.3.jar;%APP_HOME%\lib\wavefront-sdk-java-2.3.jar;%APP_HOME%\lib\jackson-dataformat-yaml-2.11.0.jar;%APP_HOME%\lib\jackson-databind-2.11.0.jar;%APP_HOME%\lib\jackson-core-2.11.0.jar;%APP_HOME%\lib\jakarta.annotation-api-1.3.5.jar;%APP_HOME%\lib\spring-context-5.2.6.RELEASE.jar;%APP_HOME%\lib\spring-jdbc-5.2.6.RELEASE.jar;%APP_HOME%\lib\spring-tx-5.2.6.RELEASE.jar;%APP_HOME%\lib\spring-aop-5.2.6.RELEASE.jar;%APP_HOME%\lib\spring-beans-5.2.6.RELEASE.jar;%APP_HOME%\lib\spring-expression-5.2.6.RELEASE.jar;%APP_HOME%\lib\spring-core-5.2.6.RELEASE.jar;%APP_HOME%\lib\snakeyaml-1.26.jar;%APP_HOME%\lib\HdrHistogram-2.1.12.jar;%APP_HOME%\lib\LatencyUtils-2.0.3.jar;%APP_HOME%\lib\jakarta.validation-api-2.0.2.jar;%APP_HOME%\lib\jboss-logging-3.4.1.Final.jar;%APP_HOME%\lib\classmate-1.5.1.jar;%APP_HOME%\lib\tomcat-embed-websocket-9.0.35.jar;%APP_HOME%\lib\tomcat-embed-core-9.0.35.jar;%APP_HOME%\lib\spring-cloud-context-2.2.2.RELEASE.jar;%APP_HOME%\lib\spring-cloud-commons-2.2.2.RELEASE.jar;%APP_HOME%\lib\spring-security-rsa-1.0.9.RELEASE.jar;%APP_HOME%\lib\aspectjweaver-1.9.5.jar;%APP_HOME%\lib\aspectjrt-1.9.5.jar;%APP_HOME%\lib\brave-context-log4j2-5.10.1.jar;%APP_HOME%\lib\brave-instrumentation-spring-rabbit-5.10.1.jar;%APP_HOME%\lib\brave-instrumentation-kafka-streams-5.10.1.jar;%APP_HOME%\lib\brave-instrumentation-kafka-clients-5.10.1.jar;%APP_HOME%\lib\brave-instrumentation-jms-5.10.1.jar;%APP_HOME%\lib\brave-instrumentation-messaging-5.10.1.jar;%APP_HOME%\lib\brave-instrumentation-rpc-5.10.1.jar;%APP_HOME%\lib\brave-instrumentation-spring-web-5.10.1.jar;%APP_HOME%\lib\brave-instrumentation-httpclient-5.10.1.jar;%APP_HOME%\lib\brave-instrumentation-httpasyncclient-5.10.1.jar;%APP_HOME%\lib\brave-instrumentation-spring-webmvc-5.10.1.jar;%APP_HOME%\lib\brave-instrumentation-servlet-5.10.1.jar;%APP_HOME%\lib\brave-instrumentation-http-5.10.1.jar;%APP_HOME%\lib\brave-5.10.1.jar;%APP_HOME%\lib\zipkin-reporter-metrics-micrometer-2.12.1.jar;%APP_HOME%\lib\opentracing-util-0.33.0.jar;%APP_HOME%\lib\opentracing-noop-0.33.0.jar;%APP_HOME%\lib\opentracing-api-0.33.0.jar;%APP_HOME%\lib\jsr305-3.0.2.jar;%APP_HOME%\lib\jackson-annotations-2.11.0.jar;%APP_HOME%\lib\log4j-api-2.13.2.jar;%APP_HOME%\lib\spring-jcl-5.2.6.RELEASE.jar;%APP_HOME%\lib\spring-security-crypto-5.3.2.RELEASE.jar;%APP_HOME%\lib\logback-core-1.2.3.jar;%APP_HOME%\lib\attoparser-2.0.5.RELEASE.jar;%APP_HOME%\lib\unbescape-1.1.6.RELEASE.jar;%APP_HOME%\lib\bcpkix-jdk15on-1.64.jar;%APP_HOME%\lib\zipkin-reporter-2.12.1.jar;%APP_HOME%\lib\zipkin-2.19.3.jar;%APP_HOME%\lib\bcprov-jdk15on-1.64.jar


@rem Execute spring-petclinic-data-jdbc
"%JAVA_EXE%" %DEFAULT_JVM_OPTS% %JAVA_OPTS% %SPRING_PETCLINIC_DATA_JDBC_OPTS%  -classpath "%CLASSPATH%"  %CMD_LINE_ARGS%

:end
@rem End local scope for the variables with windows NT shell
if "%ERRORLEVEL%"=="0" goto mainEnd

:fail
rem Set variable SPRING_PETCLINIC_DATA_JDBC_EXIT_CONSOLE if you need the _script_ return code instead of
rem the _cmd.exe /c_ return code!
if  not "" == "%SPRING_PETCLINIC_DATA_JDBC_EXIT_CONSOLE%" exit 1
exit /b 1

:mainEnd
if "%OS%"=="Windows_NT" endlocal

:omega

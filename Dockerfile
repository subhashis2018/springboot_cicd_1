
FROM eclipse-temurin:17-jdk
RUN  useradd -m -u 1000 -s /bin/bash/jenkin
RUN  yum install openssh-clients -y

FROM openjdk:17-jdk-alpine
COPY target/springboot_cicd_1-1.0.0-SNAPSHOT.jar springboot_cicd_1-1.0.0.jar
ENTRYPOINT ["java","-jar","/springboot_cicd_1-1.0.0.jar"]

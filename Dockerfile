FROM maven:3.5-jdk-8 as proxy-service-build

WORKDIR /app
ADD pom.xml pom.xml
RUN mvn clean dependency:go-offline

ADD src src
RUN mvn -o package

# running stage
FROM openjdk:8u171-jre-alpine
WORKDIR /app

## copy jarfile from proxy-service-build stage
COPY --from=proxy-service-build /app/target/*.jar .

EXPOSE 8060
ENTRYPOINT ["sh", "-c"]
CMD ["exec java -jar *.jar"]

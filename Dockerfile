
# Etapa 1: Compilar el proyecto con Maven y Java 21
FROM maven:3.9-eclipse-temurin-21 AS build

WORKDIR /build

COPY . .

RUN mvn -B -DskipTests package

# Etapa 2: Preparar WildFly 40 con Java 21
FROM quay.io/wildfly/wildfly:40.0.0.Final-jdk21

# Copiar el WAR generado por Maven a WildFly
COPY --from=build /build/target/Hola-1.0-SNAPSHOT.war /opt/jboss/wildfly/standalone/deployments/

# Puerto HTTP de Render
EXPOSE 10000

# Iniciar WildFly escuchando en todas las interfaces
CMD ["/bin/sh", "-c", "/opt/jboss/wildfly/bin/standalone.sh -b 0.0.0.0 -Djboss.http.port=${PORT:-10000}"]

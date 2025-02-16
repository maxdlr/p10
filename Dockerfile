FROM node:latest AS frontend-build
WORKDIR /usr/local/app
COPY ./front/ /usr/local/app/
RUN yarn
RUN npm run build

FROM maven:3.6.3-jdk-11-slim AS backend-build
WORKDIR /workspace
COPY ./back/pom.xml /workspace
COPY ./back/src /workspace/src
RUN mvn -B -f pom.xml clean package -DskipTests

FROM nginx:latest
RUN apt update && \
    apt install -y openjdk-17-jre-headless && \
    apt clean && \
    rm -rf /var/lib/apt/lists/*

COPY --from=frontend-build /usr/local/app/dist/bobapp /usr/share/nginx/html
COPY ./front/nginx.conf /etc/nginx/conf.d/default.conf

COPY --from=backend-build /workspace/target/*.jar /app/app.jar

RUN echo '#!/bin/bash\n\
java -jar /app/app.jar &\n\
nginx -g "daemon off;"\n' > /start.sh && \
chmod +x /start.sh

EXPOSE 80 8080
CMD ["/start.sh"]
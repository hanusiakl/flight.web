# Stage 1
FROM trion/ng-cli:12.2.7 as build-step
ARG ENVIRONMENT=''

RUN mkdir -p /app
WORKDIR /app
COPY package.json /app
RUN npm install
COPY . /app
RUN npm run build.${ENVIRONMENT}

# Stage 2
FROM nginx:1.17.1-alpine
COPY --from=build-step /app/dist/flight-web-app /usr/share/nginx/html
COPY ./nginx.conf /etc/nginx/conf.d/default.conf

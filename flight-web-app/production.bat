docker build -t flight-web-production-app --build-arg ENVIRONMENT=production .

docker tag flight-web-production-app lehudocker/flight-web-production-app

docker push lehudocker/flight-web-production-app

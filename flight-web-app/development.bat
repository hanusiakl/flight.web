docker build -t flight-web-development-app --build-arg ENVIRONMENT=development .

docker tag flight-web-development-app lehudocker/flight-web-development-app

docker push lehudocker/flight-web-development-app

docker build -t flight-web-staging-app --build-arg ENVIRONMENT=staging .

docker tag flight-web-staging-app lehudocker/flight-web-staging-app

docker push lehudocker/flight-web-staging-app

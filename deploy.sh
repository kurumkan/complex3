# make build and tag the images with hash
# commit hash comes as env variable from travis.yml
docker build -t joomrise/multi-client:latest -t joomrise/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t joomrise/multi-server:latest -t joomrise/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t joomrise/multi-worker:latest -t joomrise/multi-worker:$SHA -f ./worker/Dockerfile ./worker

# this versions will be pulled on initial build
docker push joomrise/multi-client:latest
docker push joomrise/multi-server:latest
docker push joomrise/multi-worker:latest

# push tagged images with hash - to make kubectl to use the newest images
docker push joomrise/multi-client:$SHA
docker push joomrise/multi-server:$SHA
docker push joomrise/multi-worker:$SHA

kubectl apply -f k8s

# set newest (tagged) image versions for k8s deployments
kubectl set image deployments/server-deployment server=joomrise/multi-server:$SHA
kubectl set image deployments/client-deployment client=joomrise/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=joomrise/multi-worker:$SHA

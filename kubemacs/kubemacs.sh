# kubemacs.sh
ENV_FILE=kubemacs.env
. $ENV_FILE
docker run \
       --env-file $ENV_FILE \
       --name kubemacs-docker-init \
       --user root \
       --privileged \
       --network host \
       --rm \
       -it \
       -v "/c/Users/$USER/.kube:/tmp/.kube" \
       -v /var/run/docker.sock:/var/run/docker.sock \
       $KUBEMACS_IMAGE \
       docker-init.sh

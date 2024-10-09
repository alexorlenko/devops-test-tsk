First, you should run a docker container to work with the concourse.
I have a docker-compose.yml file for this. 
So, run the command 
  docker-compose up
After this in port 8080, you can see a concourse interface. 
After that you should run commands 
  fly -t tutorial set-pipeline -p hello-world -c hello-world.yml
# pipelines are paused when first created
  fly -t tutorial unpause-pipeline -p hello-world
# trigger the job and watch it run to completion
  fly -t tutorial trigger-job --job hello-world/hello-world-job --watch 
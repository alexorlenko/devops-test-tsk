Before starting with Helm you should have a Kubernetes cluster, you should add it to your kube-config 
    aws eks update-kubeconfig --name my-eks-cluster.
Next step add helm to cluster
    helm install my-release ./mychart
After that you can forward the port to you local port 8080 for example:
    export POD_NAME=your-pod-name
    kubectl get pod $POD_NAME --namespace default -o jsonpath="{.spec.containers[0].ports[0].containerPort}"
If you see a port 80
    kubectl --namespace default port-forward $POD_NAME 8080:80
And after this, you will see in you localhost:8080 nginx server.
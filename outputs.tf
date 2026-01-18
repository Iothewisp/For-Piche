output "info" {
  value = <<-EOT

  
  
PUSH f5


   kubectl get pods -n test-nginx
   kubectl describe svc nginx-service -n test-nginx | findstr Endpoints

  # kubectl port-forward svc/nginx-service 8080:80 -n test-nginx
  # minikube tunnel    (admin mb  )
  EOT
}

resource "kubernetes_ingress_v1" "nginx" {
  metadata {
    name      = "nginx-ingress"
    namespace = kubernetes_namespace.nginx.metadata[0].name
    annotations = {
      # ( ͡° ͜ʖ ͡°)  fake annotation
      # task "Add the annotation nginx.ingress.kubernetes.io/load-balance: round_robin to enable request distribution."
      # P.S. There is no such annotation for round-robin in nginx-ingress
      # Load balancing between different services requires a different approach
      "nginx.ingress.kubernetes.io/load-balance" = "round_robin"
      # "nginx.ingress.kubernetes.io/affinity" = "none"
    }
  }
  spec {
    ingress_class_name = "nginx"
    rule {
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = kubernetes_service.nginx.metadata[0].name
              port {
                # sorry for 80 port )"
                number = 80
              }
            }
          }
        }
      }
    }
  }
}
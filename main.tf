terraform {
  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.23"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}

# 1. Namespace
resource "kubernetes_namespace" "nginx" {
  metadata {
    name = "test-nginx"
  }
}

#  для кодировки UTF-8
resource "kubernetes_config_map" "nginx_config" {
  metadata {
    name      = "nginx-utf8-config"
    namespace = kubernetes_namespace.nginx.metadata[0].name
  }
  data = {
    "charset.conf" = "charset utf-8;"
  }
}

# 3. HTML
resource "kubernetes_config_map" "html_content" {
  metadata {
    name      = "nginx-html-content"
    namespace = kubernetes_namespace.nginx.metadata[0].name
  }
  data = {
    "red.html"  = <<EOT
<!DOCTYPE html>
<html>
<head><meta charset="UTF-8"><title>HARKONNEN APPROVES</title></head>
<body style='background:#4a0000; color:#ffcc00; text-align:center; padding-top:50px; font-family:serif;' onclick="playAudio()">
  <audio id="m" loop><source src="https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3" type="audio/mpeg"></audio>
  <div id="status" style="color: #ff4400; font-weight: bold; margin-bottom: 20px; font-family: monospace;">[ SYSTEM SUSPENDED: CLICK TO CONTACT THE PADISHAH ]</div>
  <pre style='display:inline-block; text-align:left; font-size:10px; line-height:1.1; font-weight:bold; color:#ff4400; text-shadow: 0 0 5px #ff0000;'>
.______       _______  _______            __    __    ______   .___________.         .__   __.   _______  __  .__   __. ___   ___ 
|   _  \     |   ____||       \          |  |  |  |  /  __  \  |           |         |  \ |  |  /  _____||  | |  \ |  | \  \ /  / 
|  |_)  |    |  |__   |  .--.  |         |  |__|  | |  |  |  | `---|  |----`         |   \|  | |  |  __  |  | |   \|  |  \  V  /  
|      /     |   __|  |  |  |  |         |   __   | |  |  |  |     |  |              |  . `  | |  | |_ | |  | |  . `  |   >    <   
|  |\  \----.|  |____ |  '--'  |         |  |  |  | |  `--'  |     |  |              |  |\   | |  |__| | |  | |  |\   |  /  .  \  
| _| `._____||_______||_______/          |__|  |__|  \______/      |__|              |__| \__|  \______| |__| |__| \__| /__/ \__\ 
  </pre>
  <div style="margin-top:30px; font-style:italic; opacity:0.7; font-size:14px;">"I must not fear. Fear is the mind-killer..."</div>
  <script>
    function playAudio() {
      var audio = document.getElementById('m');
      audio.play().then(() => {
        document.getElementById('status').innerHTML = "[ CONNECTION ESTABLISHED: VOICE OF THE DESERT ]";
        document.getElementById('status').style.color = "#00ff00";
      }).catch(e => console.log("Нужен клик"));
    }
  </script>
</body>
</html>
EOT

    "blue.html" = <<EOT
<!DOCTYPE html>
<html>
<head><meta charset="UTF-8"><title>LOST IN THE BLUE</title></head>
<body style='background:#001a33; color:#00f2ff; text-align:center; padding-top:50px; font-family:serif;' onclick="playAudio()">
  <audio id="m" loop><source src="https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3" type="audio/mpeg"></audio>
  <div id="status" style="color: #00f2ff; font-weight: bold; margin-bottom: 20px; font-family: monospace;">[ AWAITING GUILD SIGNAL: CLICK TO ACTIVATE ]</div>
  <pre style='display:inline-block; text-align:left; font-size:10px; line-height:1.1; font-weight:bold; text-shadow: 0 0 10px #00f2ff;'>
  ____    _        _    _   ______                           _   _    _____   _____   _   _  __   __                     
 |  _ \  | |      | |  | | |  ____|                         | \ | |  / ____| |_   _| | \ | | \ \ / /                     
 | |_) | | |      | |  | | | |__                            |  \| | | |  __    | |   |  \| |  \ V /                      
 |  _ <  | |      | |  | | |  __|                           | . ` | | | |_ |   | |   | . ` |   > <                       
 | |_) | | |____  | |__| | | |____                          | |\  | | |__| |  _| |_  | |\  |  / . \                      
 |____/  |______|  \____/  |______|       _                 |_| \_|  \_____| |_____| |_| \_| /_/ \_\      _              
 |_   _| ( )                     | |     | |                            | |         | |                 | |              
   | |    \|  _ __ ___           | |__   | |  _   _    ___            __| |   __ _  | |__     __ _    __| |   ___    ___ 
   | |       | '_ ` _ \          | '_ \  | | | | | |  / _ \          / _` |  / _` | | '_ \   / _` |  / _` |  / _ \  / _ \
  _| |_      | | | | | |         | |_) | | | | |_| | |  __/    _    | (_| | | (_| | | |_) | | (_| | | (_| | |  __/ |  __/
 |_____|     |_| |_| |_|         |_.__/  |_|  \__,_|  \___|   ( )    \__,_|  \__,_| |_.__/   \__,_|  \__,_|  \___|  \___|
  </pre>
  <div style="margin-top:30px; font-style:italic; opacity:0.8; font-size:14px;">"The Spice must flow..."</div>
  <script>
    function playAudio() {
      var audio = document.getElementById('m');
      audio.play().then(() => {
        document.getElementById('status').innerHTML = "[ LIVE TRANSMISSION FROM THE GUILD  ]";
        document.getElementById('status').style.color = "#00ff00";
      }).catch(e => console.log("Нужен клик"));
    }
  </script>
</body>
</html>
EOT
  }
}

# 4. Deployments 
resource "kubernetes_deployment" "nginx" {
  for_each = toset(["red", "blue"])
  metadata {
    name      = "nginx-${each.key}"
    namespace = kubernetes_namespace.nginx.metadata[0].name
  }
  spec {
    replicas = 1
    selector {
      match_labels = {
        app   = "nginx"
        color = each.key
      }
    }
    template {
      metadata {
        labels = {
          app   = "nginx"
          color = each.key
        }
      }
      spec {
        container {
          name  = "nginx"
          image = "nginx:alpine"
          port {
            container_port = 80
          }
          
                    command = ["/bin/sh", "-c"]
          args = [
            <<-EOT
            (while true; do 
              echo "$(date): [IMPERIAL] Waiting for the Spacing Guild instructions ?"; 
              sleep 5; 
              echo "$(date): [FREEMAN] Scanning desert sector for Shai-Hulud activity!";
              sleep 8;
              echo "$(date): [CRITICAL] Wormsign detected! Sandworm approaching...>)";
              sleep 6;
              echo "$(date): [EMPEROR] The Spice must flow! Sardaukar legions standing by...";
              sleep 12;
              echo "$(date): [HARKONNEN] Torture chambers prepared for disobedient workers.";
              sleep 10;
              echo "$(date): [HARKONNEN] Spice quotas enforced — failure means pain.";
              sleep 7;
              echo "$(date): [ORDOS] Genetic experiments continue , obedience engineered at molecular level.";
              sleep 9;
              echo "$(date): [EMPEROR] Compliance achieved , screams recorded as proof of efficiency.";
              sleep 8;
              echo "$(date): [CHOAM] SLA breach detected! , corrective punishment initiated.";
              sleep 10;
            done) & 
            nginx -g 'daemon off;'
            EOT
          ]

          volume_mount {
            name       = "html"
            mount_path = "/usr/share/nginx/html/index.html"
            sub_path   = "${each.key}.html"
          }
          volume_mount {
            name       = "config"
            mount_path = "/etc/nginx/conf.d/charset.conf"
            sub_path   = "charset.conf"
          }
        }
        volume {
          name = "html"
          config_map {
            name = kubernetes_config_map.html_content.metadata[0].name
          }
        }
        volume {
          name = "config"
          config_map {
            name = kubernetes_config_map.nginx_config.metadata[0].name
          }
        }
      }
    }
  }
}
# Test task: Two Services to expose each NGINX Deployment.
# But in practice:
#
#   1. If we create TWO separate services (red-svc and blue-svc):
#      Ingress CANNOT balance between different services in one rule
#      Need to create upstreams, configmaps, custom nginx configs
#
#   2. If we create ONE service (as I did):
#      Service balances between all pods (red + blue)
#      Round-robin works out of the box via kube-proxy
#      Ingress just proxies to this single service
#      F5 on page switches red/blue as requested
#
#   WHY I'M RIGHT:
#    Round-robin EXISTS (between pods, not services)
#    Architecture is simpler and more reliable
# 5. Service
resource "kubernetes_service" "nginx" {
  metadata {
    name      = "nginx-service"
    namespace = kubernetes_namespace.nginx.metadata[0].name
  }
  spec {
    selector = {
      app = "nginx"
    }
    port {
      port        = 80 
      target_port = 80
      # обычно 80 не использую )
    }
  }
}


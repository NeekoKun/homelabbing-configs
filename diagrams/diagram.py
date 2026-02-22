from diagrams import Diagram, Cluster, Edge
from diagrams.onprem.logging import Loki
from diagrams.onprem.monitoring import Grafana, Prometheus
from diagrams.onprem.network import Nginx, Internet
from diagrams.onprem.compute import Server
from diagrams.onprem.inmemory import Redis
from diagrams.c4 import Person, System, Container
from diagrams.custom import Custom



# Homelabbing Infrastructure Diagram
with Diagram("Homelabbing Infrastructure", show=False, direction="TB"):
    internet = Internet("Internet")
    cloudflare = Custom("Cloudflare\nDNS", "./assets/Cloudflare.png")

    with Cluster("192.168.2.0/24 - Local Network"):
        with Cluster("Istanbul (192.168.2.1)\nGateway/Router"):
            suricata = Custom("Suricata", "./assets/Suricata.png")
            nginx = Nginx("Nginx\nReverse Proxy")
            vector_istanbul = Custom("Log Forwarder", "./assets/Vector.png")
        
        with Cluster("Rome (192.168.2.2)\nMonitoring Hub"):
            aggregators = [Prometheus("Prometheus\nMetrics (9696)"), Loki("Loki\nLogs (3100)")]
            grafana = Grafana("Grafana (TCP/2342)")
            vector_rome = Custom("Log Aggregator", "./assets/Vector.png")
        
        with Cluster("Babylon (192.168.2.3)\nMatrix Server"):
            matrix = Custom("Matrix Synapse (TCP/8008)", "./assets/Matrix.png")
            vector_babylon = Custom("Log Forwarder", "./assets/Vector.png")

        with Cluster("Thebes (192.168.2.4)\nMedia Server"):
            navidrome = Custom("Navidrome (TCP/4533)", "./assets/Navidrome.png")
            vector_thebes = Custom("Log Forwarder", "./assets/Vector.png")
        
    # Connections
    internet >> nginx
    
    # Applications
    nginx >> [grafana, matrix, navidrome]
    [vector_thebes, vector_babylon, vector_istanbul] >> vector_rome
    vector_rome >> aggregators
    aggregators >> grafana
    suricata >> nginx >> suricata
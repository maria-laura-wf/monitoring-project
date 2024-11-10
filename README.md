
# Monitoring Stack: Prometheus, Grafana, and Nginx

## Introduction

This project deploys a monitoring stack comprising Prometheus, Grafana, and Nginx. Each component plays a crucial role:

- **Prometheus**: An open-source monitoring system focused on gathering time-series data. It scrapes metrics from configured targets, storing them efficiently and enabling powerful queries through PromQL (Prometheus Query Language).
  
- **Grafana**: A widely used platform for data visualization. It connects to data sources, like Prometheus, and allows users to build interactive dashboards for monitoring, analysis, and alerting.
  
- **Nginx**: A high-performance web server and reverse proxy server. In this project, it serves as a target for Prometheus to monitor HTTP request metrics, enabling a demonstration of how to track web server performance.

## Project Structure

```plaintext
monitoring-project/
├── docker-compose.yml       # Docker Compose setup for Prometheus, Grafana, and Nginx
├── load_generator.sh        # Load generator script using wget for load testing
├── prometheus.yml           # Prometheus configuration for scraping metrics
└── README.md                # Project documentation
```

## Project Setup

This project uses Docker and Docker Compose for easy deployment. By following the steps below, you’ll deploy Prometheus to monitor Nginx and Grafana to visualize the metrics collected by Prometheus.

## Project Structure and Configuration

This project is organized using Docker and Docker Compose, enabling easy deployment and configuration of Prometheus, Grafana, and Nginx. Each service has specific roles and configurations to achieve a functional monitoring stack.

### Project Files

Below is an overview of the files in this project and how each one contributes to the setup:

1. **`docker-compose.yml`**
   
   This file defines the Docker Compose configuration, which orchestrates the deployment of Prometheus, Grafana, and Nginx services. Each service has a designated container and configured ports, facilitating interaction between them.

   - **Prometheus**:
     - **Image**: Uses the official Prometheus image.
     - **Port**: Exposes Prometheus on `localhost:9090`.
     - **Volume**: Mounts `prometheus.yml` to configure Prometheus targets, including Nginx for metric scraping.
   
   - **Grafana**:
     - **Image**: Uses the latest Grafana image.
     - **Port**: Exposes Grafana on `localhost:3000`.
     - **Environment**: Sets the default Grafana admin password for easy access.
     - **Dependency**: Configured to start only after Prometheus is running.
   
   - **Nginx**:
     - **Image**: Uses the Nginx web server image.
     - **Port**: Exposes Nginx on `localhost:8080`.
     - **Purpose**: Acts as the target for Prometheus, simulating a web server that Prometheus will monitor.

2. **`prometheus.yml`**

   The `prometheus.yml` file configures Prometheus with scrape settings. It defines how frequently Prometheus collects metrics and specifies Nginx as a scrape target.

3. **Load Generator Script (`load_generator.sh`)**

   This script simulates a consistent load on the Nginx server by repeatedly sending HTTP requests.

### How the Components Interact

1. **Starting the Stack**: Run `docker-compose up -d` to start all services.

2. **Prometheus Scraping Nginx**: Prometheus scrapes metrics from Nginx as per `prometheus.yml`.

3. **Grafana Visualizing Prometheus Metrics**: Access Grafana and configure Prometheus as a data source.

## Metrics Overview

### Popular Metrics in Prometheus

1. **HTTP Request Rate**: Useful for analyzing load trends.
2. **Error Rate**: Tracks the rate of 4xx or 5xx HTTP status codes.
3. **Response Time**: Indicates server performance issues.

### Nginx-Specific Metrics

- **Active Connections**: Current connections being processed.
- **Handled Connections**: Indicator of server throughput.
- **Requests per Second**: Useful to understand server load.

## PromQL (Prometheus Query Language)

PromQL (Prometheus Query Language) enables the creation of advanced and powerful queries to gain detailed insights into system performance. Below are some useful and popular queries with detailed explanations.

### Structure of PromQL

- **Instant Vectors**: Single value at a timestamp.
- **Range Vectors**: Set of values over a time range.


**CPU Usage**

- CPU Usage Rate by Mode (e.g., user, system):

    This query calculates the CPU usage rate in user mode over the last 5 minutes. The rate() function is used to calculate the average for counters, such as CPU usage.

```promql
rate(node_cpu_seconds_total{mode="user"}[5m])
```

**Memory Usage**

- Available Memory (%):

    Calculates the percentage of available memory in relation to the total.

```promql
(node_memory_MemAvailable_bytes / node_memory_MemTotal_bytes) * 100
```

- Used Memory (%):

    Shows the percentage of used memory.


```promql
((node_memory_MemTotal_bytes - node_memory_MemAvailable_bytes) / 
node_memory_MemTotal_bytes) * 100
```

**Network Metrics**

- Network Incoming Data Rate:

    Calculates the incoming data rate on the network in bytes per second over the last 5 minutes.

```promql
rate(node_network_receive_bytes_total[5m])
```

- Network Outgoing Data Rate:

    Calculates the outgoing data rate on the network in bytes per second.

```promql
rate(node_network_transmit_bytes_total[5m])
```

**Disk Usage**

- Available Disk Space:

    Percentage of available space in the file system.


```promql
node_filesystem_avail_bytes / node_filesystem_size_bytes * 100
```

- Used Disk Space:

    Calculates the percentage of disk space used.

```promql
(node_filesystem_size_bytes - node_filesystem_avail_bytes) / 
node_filesystem_size_bytes * 100
```

**Application Latency (example using Histograms)**

*If your application exposes a latency metric, such as http_request_duration_seconds, you can use histogram_quantile to calculate percentiles.*

- 95th Percentile Latency:

    This query calculates the latency of HTTP requests at the 95th percentile, which is useful for monitoring performance.

```promql
histogram_quantile(0.95, sum(rate(http_request_duration_seconds_bucket[5m])) by (le))
```

## Testing the Project

Follow these steps to test and verify that the monitoring stack is working as expected:

1. **Start the Docker Containers**:
   - Run `docker-compose up -d` to start Prometheus, Grafana, and Nginx in detached mode.
   - Verify that each container is running by using `docker ps`.

2. **Generate Load on Nginx**:
   - Execute the load generator script by running `./load_generator.sh` in a terminal. This script will repeatedly send requests to Nginx to simulate real traffic.

3. **Access Prometheus**:
   - Open your browser and go to `http://localhost:9090` to access Prometheus.
   - Use the "Status > Targets" page in Prometheus to confirm that the Nginx endpoint is being scraped correctly.

4. **Access Grafana**:
   - Open your browser and go to `http://localhost:3000` to access Grafana.
   - Log in with `admin` as both username and password (or the password you set in `docker-compose.yml`).
   - Add Prometheus as a data source using the URL `http://prometheus:9090`.

5. **Create Grafana Dashboards**:
   - Create a new dashboard in Grafana.
   - Add panels using PromQL queries, such as `rate(http_requests_total[5m])` to see the HTTP request rate.

6. **Observe and Monitor Metrics**:
   - Watch the live data coming from Nginx, displayed on your Grafana dashboard.
   - Check for metrics like HTTP request rate, error rates, and response times to ensure that the monitoring stack is working as expected.

These steps should help you confirm that Prometheus is successfully scraping Nginx metrics and Grafana is visualizing them properly.

## Testing Steps

To verify that the monitoring stack is working correctly, follow these steps:

1. **Start the Services**: Run the following command to start all services defined in the `docker-compose.yml` file.
   ```bash
   docker-compose up -d
   ```

2. **Verify Nginx is Running**: Open a web browser or use `curl` to access the Nginx server at `http://localhost:8080`. 
   You should see the default Nginx welcome page.

   ```bash
   curl http://localhost:8080
   ```

3. **Simulate Load on Nginx**: Run the `load_generator.sh` script to generate consistent traffic for Nginx.
   ```bash
   ./load_generator.sh
   ```

4. **Access Prometheus**: Go to `http://localhost:9090` in a web browser to access the Prometheus interface. 
   Verify that Prometheus is scraping metrics from Nginx by checking the `Status > Targets` section.

5. **Configure Grafana**: Open Grafana by visiting `http://localhost:3000`. 
   - Log in with the default credentials (admin/admin) or those you specified.
   - Add Prometheus as a data source (`URL: http://prometheus:9090`).
   - Create a new dashboard with panels to visualize metrics like HTTP request rates and error rates.

6. **Monitor Metrics**: In Grafana, use the PromQL queries provided in the documentation to create panels and observe the metrics collected from Nginx. 
   You should see data that reflects the load generated by the `load_generator.sh` script.

These steps should help you confirm that the monitoring stack is properly set up and working as expected.

## Contribution
Contributions are welcome! If you'd like to add new scripts, improvements, or support for other Ubuntu versions, please feel free to open a Pull Request.

**Fork the repository.**
1. Create a new branch:
```bash
git checkout -b feature-new-functionality
```
2. Commit your changes:
```bash
git commit -m "Add new functionality"
```
3. Push to the branch:
```bash
git push origin feature-new-functionality
```
4. Open a Pull Request.

## Notices and Considerations

- **Testing Notice**: The scripts have been tested on Ubuntu 24.04.1 LTS; functionality on other distributions or versions has not been validated.
- **Superuser Permissions**: Some scripts require superuser privileges for installation.
- **Beta Components**: We recommend consulting the official documentation of tools for beta versions or experimental features.

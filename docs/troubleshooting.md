---

# Technical Troubleshooting Runbook

### 1. Pod is in CrashLoopBackOff. What do you check?

* Run `kubectl logs <pod-name> --previous` to view application runtime errors or unhandled exceptions from the failed container.
* Run `kubectl describe pod <pod-name>` to check for failing liveness/readiness probes, incorrect environment variables, broken configmaps, or container entrypoint typos.

### 2. Deployment is successful, but app is not reachable. What do you check?

* Verify the underlying Pods are actually healthy and in a running state (`kubectl get pods`).
* Check if the Service selectors match the exact labels defined on your Deployment pods (`kubectl get svc -o wide`).
* Inspect Ingress configurations and cross-check that the target service name and port match perfectly.

### 3. Difference between readiness and liveness probe?

* **Liveness Probe:** Tells Kubernetes if a container is dead. If it fails, Kubernetes kills the container and starts a new one to recover.
* **Readiness Probe:** Tells Kubernetes if a container is ready to accept network traffic. If it fails, the pod is temporarily hidden from the Service load balancer so users don't hit a broken page.

### 4. Docker build works locally but fails in pipeline. Why?

* **Architecture Mismatch:** Your local machine might be running ARM64 (like an Apple M-chip Mac) while the pipeline agent runs AMD64 (Linux).
* **Missing Context/Credentials:** Environment tokens, environment files, or `.dockerignore` rules might be blocking mandatory build dependencies inside the remote agent.

### 5. Pipeline fails during Docker build. What do you check?

* Review the runner execution logs to catch broken dependencies, package download failures, or syntax typos in the `Dockerfile`.
* Ensure the runner machine hasn't run out of disk space or hit Docker Hub pull rate-limits.

### 6. Certificate renewal failed. What do you check?

* Verify that DNS propagation is working and pointing to the proper Load Balancer ingress target.
* Check Cert-Manager controller logs (`kubectl logs -n cert-manager -l app=cert-manager`) and inspect the `Challenge` resource status.

### 7. Ingress returns 502 or 504. What do you check?

* **502 Bad Gateway:** The ingress controller cannot talk to the upstream service. Check if the backend pods are crashed or misconfigured.
* **504 Gateway Timeout:** The backend took too long to respond. Check for downstream database locks, slow api queries, or network bottlenecks.

### 8. Vendor SFTP connection to port 22 times out. What do you check?

* Check the egress rules of your Security Groups or Firewalls to ensure outbound traffic to that specific external IP on port 22 is explicitly allowed.
* Verify network routing tables (NAT Gateway) and confirm if the vendor needs to white-list your public NAT IP on their side.

### 9. Terraform plan wants to recreate the cluster. What do you check?

* Look for properties marked with `# forces replacement` in the plan output.
* Ensure critical immutable fields like region, subnet configurations, or cluster names were not accidentally updated in your variables.

### 10. How would you upgrade EKS/AKS safely?

* Upgrade the control plane software versions incrementally (one minor version at a time), followed by sequential rolling updates of your managed node pools using canary or blue-green cordoning mechanisms.

### 11. Frontend loads, but backend API calls fail. What do you check?

* Open Browser DevTools (Network tab) to check for CORS (Cross-Origin Resource Sharing) blockages or broken relative API endpoints.
* Confirm the external load balancer ingress routes requests properly onto the target backend ClusterIP service.

### 12. Backend pod is running, but database connection times out. What do you check?

* Inspect the Database Security Group to verify it allows inbound connections on the database port strictly from the backend pod's security group identifier.
* Check if the database host string injected into the backend application pod is correct.

### 13. Private DNS is not resolving database hostname. What do you check?

* Confirm that the Private DNS Zone is accurately linked to the target application VPC.
* Check if DNS Resolution and DNS Hostnames settings are turned on in your core VPC cluster settings.

### 14. How would you rotate database credentials safely?

* Update credentials inside the cloud secret manager (like AWS Secrets Manager), keeping both old and new keys active momentarily.
* Update the Kubernetes secret and trigger a rolling restart (`kubectl rollout restart`) on the deployment pods to fetch the fresh credentials smoothly.

### 15. Secrets were accidentally committed to GitHub. What do you do?

* **Revoke Immediately:** Change the compromised password, string, or key immediately on the infrastructure level.
* **Purge History:** Use tools like `git-filter-repo` or BFG Repo-Cleaner to permanently scrub the secret from all historic git commits, then force-push back to main.

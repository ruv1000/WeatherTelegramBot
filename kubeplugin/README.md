# kubeplugin

This plugin retrieves resource usage statistics for a specific resource type in a given namespace from a Kubernetes cluster.

## Installing

1. Ensure you have `kubectl` installed on your machine.
2. Download the script:

   ```zsh
   wget https://raw.githubusercontent.com/ruv1000/kubeplugin/main/scripts/kubeplugin
   ```

3. Make the script executable:

   ```zsh
   chmod +x scripts/kubeplugin
   ```

4. Place it anywhere in your `PATH`
   ```zsh
   sudo mv ./scripts/kubeplugin /usr/local/bin/kubectl-kubeplugin
   ```

## Usage

```zsh
kubectl kubeplugin <resource_type> <namespace>
```

- `<resource_type>`: The type of Kubernetes resource you want to retrieve statistics for (e.g., pod, deployment).
- `<namespace>`: The namespace in which the resource is located.

## Example

```zsh
k kubeplugin pod kube-system
```

## Output

The plugin will output resource usage statistics in the following format:

```zsh
Resource, Namespace, Name, CPU, Memory
pod, kube-system, coredns-77ccd57875-tj2hd, 2m, 27Mi
pod, kube-system, local-path-provisioner-957fdf8bc-fgq2w, 1m, 19Mi
pod, kube-system, metrics-server-648b5df564-8rbdl, 4m, 31Mi
pod, kube-system, svclb-hello-world-3ec62f3b-kfppm, 0m, 1Mi
pod, kube-system, svclb-traefik-55d19014-8pm89, 0m, 1Mi
pod, kube-system, traefik-64f55bb67d-bmm77, 1m, 48Mi
```

## Note

- Ensure that kubectl is properly configured to access your Kubernetes cluster.
- The script assumes a proper functioning Kubernetes cluster.

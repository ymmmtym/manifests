# manifests

My manifests

## Initial Setup

1. rook-ceph
   1. common, crd, operation(are not managed by argocd)
   2. CephCluster, StorageClass
2. metallb
3. ingress-nginx
4. argocd

```bash
export ARGOCD_PASSWORD=<password for admin user (default: admin)>
./setup.sh
```

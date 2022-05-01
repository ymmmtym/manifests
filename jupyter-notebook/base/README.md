# jupyter-notebook

## Usage

### docker-compose

```bash
docker-compose up -d
```

### kubernetes

fix StorageClassName

```yml:pvc.yaml
spec:
  storageClassName: rook-cephfs # Fix Me
```

deploy

```bash
kubectl apply -k ./
```

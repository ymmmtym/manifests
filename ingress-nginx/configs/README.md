These are here because if you exclusively use the
nginx remote resource, you'll clobber any 
changes that you make to the configmap afterward.

To use the services configmaps, add a `data` 
section that maps "port" to "namespace/service:port":

```
apiVersion: v1
kind: ConfigMap
metadata:
  labels:
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/part-of: ingress-nginx
  name: tcp-services
  namespace: ingress-nginx
data:
  "514": infrastructure/logstash:514
  "1883": automation/mqtt:1883
```

To use the `nginx.conf` configmap, add key/value
pairs for the corresponding configuration option:

```
apiVersion: v1
kind: ConfigMap
metadata:
  labels:
    app.kubernetes.io/name: ingress-nginx
    app.kubernetes.io/part-of: ingress-nginx
  name: nginx-configuration
  namespace: ingress-nginx
data:
  proxy-connect-timeout: "10"
  proxy-read-timeout: "120"
```

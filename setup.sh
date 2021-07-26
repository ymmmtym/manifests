#/usr/bin/env bash

install_rook-ceph_via_helm(){
    helm repo add rook-release https://charts.rook.io/release
    kubectl create namespace rook-ceph
    helm install --namespace rook-ceph rook-ceph rook-release/rook-ceph
    kubectl wait -n rook-ceph --for=condition=available deployment --all --timeout=300s
    kubectl apply -f rook-ceph/cluster.yaml
}

install_metallb(){
    kubectl apply -k metallb
    kubectl wait -n metallb-system --for=condition=available deployment --all --timeout=300s
}

install_ingress-nginx(){
    kubectl apply -k ingress-nginx
    kubectl wait -n ingress-nginx --for=condition=available deployment --all --timeout=300s
}

install_argocd(){
    kubectl create namespace argocd
    kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
    kubectl wait -n argocd --for=condition=available deployment --all --timeout=300s
    kubectl patch svc argocd-server -n argocd -p '{"spec": {"type": "LoadBalancer"}}'
}

get_argocd_server(){
    ARGOCD_SERVER=$(kubectl -n argocd get svc argocd-server -o jsonpath="{.status.loadBalancer.ingress[].ip}")
    while [ -z "$ARGOCD_SERVER" ] ; do
        sleep 5
        ARGOCD_SERVER=$(kubectl -n argocd get svc argocd-server -o jsonpath="{.status.loadBalancer.ingress[].ip}")
    done
    echo "$ARGOCD_SERVER"
}

get_argocd_initial_password(){
    ARGOCD_INITIAL_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
    while [ -z "$ARGOCD_INITIAL_PASSWORD" ] ; do
        sleep 5
        ARGOCD_INITIAL_PASSWORD=$(kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d)
    done
    echo "$ARGOCD_INITIAL_PASSWORD"
}

log_in_to_argocd(){
    argocd login $1:443 --username admin --password $2 --insecure
    argocd account update-password --account admin --current-password $2 --new-password $3 --insecure
}

initial_setup(){
    install_rook-ceph_via_helm
    install_metallb
    install_ingress-nginx
    install_argocd

    ARGOCD_SERVER=$(get_argocd_server)
    ARGOCD_INITIAL_PASSWORD=$(get_argocd_initial_password)

    log_in_to_argocd "$ARGOCD_SERVER" "$ARGOCD_INITIAL_PASSWORD" "${ARGOCD_PASSWORD:-admin}"
}

initial_setup

kubectl wait -A --for=condition=available deployment --all --timeout=300s
kubectl apply -k argocd

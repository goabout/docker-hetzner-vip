[keepalived-vip](https://github.com/kubernetes-retired/contrib/tree/master/keepalived-vip) adapted for [Hetzner Cloud](https://www.hetzner.com/cloud).


## Usage

Example:

    ---
    apiVersion: v1
    kind: ConfigMap
    metadata:
      name: kube-keepalived-vip-services-configmap
    data:
      <IP_ADDRESS>: ""  # keep in sync with DaemonSet
    ---
    apiVersion: v1
    kind: Secret
    data:
      HCLOUD_TOKEN: <BASE64_ENCODED_TOKEN>
    metadata:
      name: kube-keepalived-vip-secrets
    ---
    apiVersion: apps/v1
    kind: DaemonSet
    metadata:
      name: keepalived-vip
    spec:
      template:
        metadata:
          name: keepalived-vip
        spec:
          hostNetwork: true
          containers:
            - name: keepalived-vip
              image: goabout/hetzner-vip
              imagePullPolicy: Always
              securityContext:
                privileged: true
              args:
                - --services-configmap=$(POD_NAMESPACE)/keepalived-vip-services
                - --watch-all-namespaces=true
                - --use-unicast=true
                - --logtostderr=true
              envFrom:
                - secretRef:
                    name: keepalived-vip-secrets
              env:
                - name: POD_NAME
                  valueFrom:
                    fieldRef:
                      fieldPath: metadata.name
                - name: POD_NAMESPACE
                  valueFrom:
                    fieldRef:
                      fieldPath: metadata.namespace
                - name: NODE_NAME
                  valueFrom:
                    fieldRef:
                      fieldPath: spec.nodeName
                - name: FLOATING_IP
                  value: <IP_ADDRESS>  # keep in sync with ConfigMap
              volumeMounts:
                - name: modules
                  mountPath: /lib/modules
                  readOnly: true
                - name: dev
                  mountPath: /dev
          volumes:
            - name: modules
              hostPath:
                path: /lib/modules
            - name: dev
              hostPath:
                path: /dev

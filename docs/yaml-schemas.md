# YAML Schema Modeline Reference

Copy-paste reference for `yaml-language-server` schema modelines used across
this repo. Pin one schema per file to get autocomplete, hover docs, and
field validation in editors that speak the LSP (Neovim, VSCode, Helix, Zed).

## How to use

Add a single comment line at the **very top** of any YAML manifest:

```yaml
# yaml-language-server: $schema=<URL>
apiVersion: v1
kind: Secret
...
```

Pick the URL from the tables below by matching `apiVersion` + `kind` to a
row. Reload the buffer; the LSP will fetch and apply that schema only.

### Why bother

Without a pinned schema, `yamlls` (with `kubernetesCRDStore.enable = true`)
falls back to yannh's `all.json` — a giant `oneOf` over every Kubernetes
kind. Some manifests (notably `Secret`) trigger a known false-positive:
*"Matches multiple schemas when only one must validate."* Pinning fixes it
and gives you a more precise schema anyway.

### Cluster version mapping

This file is pinned to **`v1.33.9`** to match **OCP 4.20.18** (current
cluster as of writing). Each OpenShift minor release locks you to a
specific upstream Kubernetes minor version:

| OpenShift | Kubernetes | yannh tag |
|---|---|---|
| 4.21 | 1.34 | `v1.34.0-standalone` |
| **4.20** | **1.33** | **`v1.33.9-standalone`** ← current |
| 4.19 | 1.32 | `v1.32.0-standalone` |
| 4.18 | 1.31 | `v1.31.0-standalone` |
| 4.17 | 1.30 | `v1.30.0-standalone` |
| 4.16 | 1.29 | `v1.29.14-standalone` |
| 4.15 | 1.28 | `v1.28.0-standalone` |

Verify your cluster version with `oc version` (look at `Server Version`
and `Kubernetes Version`).

To bump after a cluster upgrade: find/replace `v1.33.9-standalone` with
the new tag throughout this file. Tags live at
<https://github.com/yannh/kubernetes-json-schema/tags> — pick the closest
patch version, or fall back to `vX.Y.0-standalone` (always exists). Use
`master-standalone` to always track tip.

### Strict vs non-strict (we use non-strict)

yannh publishes two flavors of every schema:

- `…-standalone-strict/…` — rejects unknown fields. Catches typos but
  false-positives on OpenShift's added annotations (e.g.,
  `openshift.io/sa.scc.uid-range`, `image.openshift.io/triggers`,
  route admission fields, SCC-injected pod fields).
- `…-standalone/…` — same shape, allows unknown fields. **This is what we
  use** because OpenShift adds enough fields that strict becomes noisy.

If you want strict on a specific file (e.g., a vanilla `Deployment` with
no OCP annotations), just swap `-standalone` → `-standalone-strict` in
that file's modeline.

---

## Table of contents

- [Core Kubernetes](#core-kubernetes) — Pods, Deployments, Services, Secrets, etc.
- [Workloads & batch](#workloads--batch)
- [Networking](#networking)
- [Storage](#storage)
- [RBAC & policy](#rbac--policy)
- [Autoscaling](#autoscaling)
- [Cluster admin](#cluster-admin)
- [OpenShift native](#openshift-native) — Routes, BuildConfigs, ImageStreams
- [OpenShift cluster operators](#openshift-cluster-operators) — Image Registry, Ingress, Console, etc.
  *(both from garethahealy/openshift-json-schema, v4.19.0)*
- [OpenShift operators](#openshift-operators) — OLM, Subscriptions
- [Confluent for Kubernetes](#confluent-for-kubernetes) — KafkaTopic, Connector, etc.
- [HashiCorp Vault Secrets Operator](#hashicorp-vault-secrets-operator)
- [cert-manager](#cert-manager)
- [External Secrets Operator](#external-secrets-operator)
- [ArgoCD](#argocd)
- [Tekton Pipelines](#tekton-pipelines)
- [Helm chart values](#helm-chart-values) — trust-manager, etc.
- [Fallbacks & generating your own](#fallbacks--generating-your-own)

---

## Core Kubernetes

Source: <https://github.com/yannh/kubernetes-json-schema>
Pattern: `https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.33.9-standalone/<kind>-<group>.json`

### Pod & config

| Kind | apiVersion | Modeline |
|---|---|---|
| Pod | `v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.33.9-standalone/pod-v1.json` |
| Secret | `v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.33.9-standalone/secret-v1.json` |
| ConfigMap | `v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.33.9-standalone/configmap-v1.json` |
| ServiceAccount | `v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.33.9-standalone/serviceaccount-v1.json` |
| Namespace | `v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.33.9-standalone/namespace-v1.json` |
| ResourceQuota | `v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.33.9-standalone/resourcequota-v1.json` |
| LimitRange | `v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.33.9-standalone/limitrange-v1.json` |

## Workloads & batch

| Kind | apiVersion | Modeline |
|---|---|---|
| Deployment | `apps/v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.33.9-standalone/deployment-apps-v1.json` |
| StatefulSet | `apps/v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.33.9-standalone/statefulset-apps-v1.json` |
| DaemonSet | `apps/v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.33.9-standalone/daemonset-apps-v1.json` |
| ReplicaSet | `apps/v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.33.9-standalone/replicaset-apps-v1.json` |
| Job | `batch/v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.33.9-standalone/job-batch-v1.json` |
| CronJob | `batch/v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.33.9-standalone/cronjob-batch-v1.json` |

## Networking

| Kind | apiVersion | Modeline |
|---|---|---|
| Service | `v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.33.9-standalone/service-v1.json` |
| Endpoints | `v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.33.9-standalone/endpoints-v1.json` |
| EndpointSlice | `discovery.k8s.io/v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.33.9-standalone/endpointslice-discovery-v1.json` |
| Ingress | `networking.k8s.io/v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.33.9-standalone/ingress-networking-v1.json` |
| IngressClass | `networking.k8s.io/v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.33.9-standalone/ingressclass-networking-v1.json` |
| NetworkPolicy | `networking.k8s.io/v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.33.9-standalone/networkpolicy-networking-v1.json` |

## Storage

| Kind | apiVersion | Modeline |
|---|---|---|
| PersistentVolume | `v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.33.9-standalone/persistentvolume-v1.json` |
| PersistentVolumeClaim | `v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.33.9-standalone/persistentvolumeclaim-v1.json` |
| StorageClass | `storage.k8s.io/v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.33.9-standalone/storageclass-storage-v1.json` |
| VolumeAttachment | `storage.k8s.io/v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.33.9-standalone/volumeattachment-storage-v1.json` |
| CSIDriver | `storage.k8s.io/v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.33.9-standalone/csidriver-storage-v1.json` |

## RBAC & policy

| Kind | apiVersion | Modeline |
|---|---|---|
| Role | `rbac.authorization.k8s.io/v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.33.9-standalone/role-rbac-v1.json` |
| RoleBinding | `rbac.authorization.k8s.io/v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.33.9-standalone/rolebinding-rbac-v1.json` |
| ClusterRole | `rbac.authorization.k8s.io/v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.33.9-standalone/clusterrole-rbac-v1.json` |
| ClusterRoleBinding | `rbac.authorization.k8s.io/v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.33.9-standalone/clusterrolebinding-rbac-v1.json` |
| PodDisruptionBudget | `policy/v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.33.9-standalone/poddisruptionbudget-policy-v1.json` |

## Autoscaling

| Kind | apiVersion | Modeline |
|---|---|---|
| HorizontalPodAutoscaler | `autoscaling/v2` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.33.9-standalone/horizontalpodautoscaler-autoscaling-v2.json` |
| HorizontalPodAutoscaler | `autoscaling/v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.33.9-standalone/horizontalpodautoscaler-autoscaling-v1.json` |

## Cluster admin

| Kind | apiVersion | Modeline |
|---|---|---|
| CustomResourceDefinition | `apiextensions.k8s.io/v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.33.9-standalone/customresourcedefinition-apiextensions-v1.json` |
| MutatingWebhookConfiguration | `admissionregistration.k8s.io/v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.33.9-standalone/mutatingwebhookconfiguration-admissionregistration-v1.json` |
| ValidatingWebhookConfiguration | `admissionregistration.k8s.io/v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.33.9-standalone/validatingwebhookconfiguration-admissionregistration-v1.json` |
| APIService | `apiregistration.k8s.io/v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.33.9-standalone/apiservice-apiregistration-v1.json` |
| Lease | `coordination.k8s.io/v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.33.9-standalone/lease-coordination-v1.json` |

> Browse the full list (~700 kinds): <https://github.com/yannh/kubernetes-json-schema/tree/master/v1.33.9-standalone>
> If that 404s, fall back to <https://github.com/yannh/kubernetes-json-schema/tree/master/v1.29.0-standalone> (the `.0` patch always exists).

---

## OpenShift native

Source: <https://github.com/garethahealy/openshift-json-schema>
Pattern: `https://raw.githubusercontent.com/garethahealy/openshift-json-schema/main/v4.19.0/schemas/<kind>-<group>-<version>.json`

> Actively maintained repo (covers OCP 4.13–4.19). Naming convention:
> `<kind-lowercase>-<api-group-first-segment>-<version>.json`
> No v4.20 yet — v4.19 schemas are accurate for v4.20 in practice.

### Routing & networking

| Kind | apiVersion | Modeline |
|---|---|---|
| Route | `route.openshift.io/v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/garethahealy/openshift-json-schema/main/v4.19.0/schemas/route-route-v1.json` |

### Builds & images

| Kind | apiVersion | Modeline |
|---|---|---|
| ImageStream | `image.openshift.io/v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/garethahealy/openshift-json-schema/main/v4.19.0/schemas/imagestream-image-v1.json` |
| ImageStreamTag | `image.openshift.io/v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/garethahealy/openshift-json-schema/main/v4.19.0/schemas/imagestreamtag-image-v1.json` |
| BuildConfig | `build.openshift.io/v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/garethahealy/openshift-json-schema/main/v4.19.0/schemas/buildconfig-build-v1.json` |
| Build | `build.openshift.io/v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/garethahealy/openshift-json-schema/main/v4.19.0/schemas/build-build-v1.json` |

### Apps & deploys

| Kind | apiVersion | Modeline |
|---|---|---|
| DeploymentConfig | `apps.openshift.io/v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/garethahealy/openshift-json-schema/main/v4.19.0/schemas/deploymentconfig-apps-v1.json` |

### Projects & users

| Kind | apiVersion | Modeline |
|---|---|---|
| Project | `project.openshift.io/v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/garethahealy/openshift-json-schema/main/v4.19.0/schemas/project-project-v1.json` |
| ProjectRequest | `project.openshift.io/v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/garethahealy/openshift-json-schema/main/v4.19.0/schemas/projectrequest-project-v1.json` |

### Security context constraints

| Kind | apiVersion | Modeline |
|---|---|---|
| SecurityContextConstraints | `security.openshift.io/v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/garethahealy/openshift-json-schema/main/v4.19.0/schemas/securitycontextconstraints-security-v1.json` |

---

## OpenShift cluster operators

Cluster-scoped operator configs that govern OCP itself (image registry,
ingress controller, console, OAuth, etc.).

Source: <https://github.com/garethahealy/openshift-json-schema>
Pattern: `https://raw.githubusercontent.com/garethahealy/openshift-json-schema/main/v4.19.0/schemas/<kind>-<group>-<version>.json`

### Image registry

| Kind | apiVersion | Modeline |
|---|---|---|
| Config | `imageregistry.operator.openshift.io/v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/garethahealy/openshift-json-schema/main/v4.19.0/schemas/config-imageregistry-v1.json` |
| ImagePruner | `imageregistry.operator.openshift.io/v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/garethahealy/openshift-json-schema/main/v4.19.0/schemas/imagepruner-imageregistry-v1.json` |

### Networking & ingress

| Kind | apiVersion | Modeline |
|---|---|---|
| IngressController | `operator.openshift.io/v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/garethahealy/openshift-json-schema/main/v4.19.0/schemas/ingresscontroller-operator-v1.json` |
| Network | `operator.openshift.io/v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/garethahealy/openshift-json-schema/main/v4.19.0/schemas/network-operator-v1.json` |
| DNS | `operator.openshift.io/v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/garethahealy/openshift-json-schema/main/v4.19.0/schemas/dns-operator-v1.json` |
| EgressRouter | `network.operator.openshift.io/v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/garethahealy/openshift-json-schema/main/v4.19.0/schemas/egressrouter-network-v1.json` |

### Control plane operators

| Kind | apiVersion | Modeline |
|---|---|---|
| Authentication | `operator.openshift.io/v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/garethahealy/openshift-json-schema/main/v4.19.0/schemas/authentication-operator-v1.json` |
| Console | `operator.openshift.io/v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/garethahealy/openshift-json-schema/main/v4.19.0/schemas/console-operator-v1.json` |
| KubeAPIServer | `operator.openshift.io/v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/garethahealy/openshift-json-schema/main/v4.19.0/schemas/kubeapiserver-operator-v1.json` |
| KubeControllerManager | `operator.openshift.io/v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/garethahealy/openshift-json-schema/main/v4.19.0/schemas/kubecontrollermanager-operator-v1.json` |
| KubeScheduler | `operator.openshift.io/v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/garethahealy/openshift-json-schema/main/v4.19.0/schemas/kubescheduler-operator-v1.json` |
| OpenShiftAPIServer | `operator.openshift.io/v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/garethahealy/openshift-json-schema/main/v4.19.0/schemas/openshiftapiserver-operator-v1.json` |
| Etcd | `operator.openshift.io/v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/garethahealy/openshift-json-schema/main/v4.19.0/schemas/etcd-operator-v1.json` |

### Storage & misc

| Kind | apiVersion | Modeline |
|---|---|---|
| Storage | `operator.openshift.io/v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/garethahealy/openshift-json-schema/main/v4.19.0/schemas/storage-operator-v1.json` |
| ClusterCSIDriver | `operator.openshift.io/v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/garethahealy/openshift-json-schema/main/v4.19.0/schemas/clustercsidriver-operator-v1.json` |
| CSISnapshotController | `operator.openshift.io/v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/garethahealy/openshift-json-schema/main/v4.19.0/schemas/csisnapshotcontroller-operator-v1.json` |
| CloudCredential | `operator.openshift.io/v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/garethahealy/openshift-json-schema/main/v4.19.0/schemas/cloudcredential-operator-v1.json` |
| MachineConfiguration | `operator.openshift.io/v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/garethahealy/openshift-json-schema/main/v4.19.0/schemas/machineconfiguration-operator-v1.json` |
| ServiceCA | `operator.openshift.io/v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/garethahealy/openshift-json-schema/main/v4.19.0/schemas/serviceca-operator-v1.json` |
| ImageContentSourcePolicy | `operator.openshift.io/v1alpha1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/garethahealy/openshift-json-schema/main/v4.19.0/schemas/imagecontentsourcepolicy-operator-v1alpha1.json` |

### Finding one not listed here

```bash
curl -s "https://api.github.com/repos/garethahealy/openshift-json-schema/git/trees/main?recursive=1" \
  | jq -r '.tree[].path' | grep "^v4.19.0/schemas/" | sed 's|v4.19.0/schemas/||'
```

Naming convention: `<kind-lowercase>-<api-group-first-segment>-<version>.json`.

---

## OpenShift operators

OLM (Operator Lifecycle Manager) types — used to install operators from
OperatorHub on OCP.

| Kind | apiVersion | Modeline |
|---|---|---|
| Subscription | `operators.coreos.com/v1alpha1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/operators.coreos.com/subscription_v1alpha1.json` |
| OperatorGroup | `operators.coreos.com/v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/operators.coreos.com/operatorgroup_v1.json` |
| ClusterServiceVersion | `operators.coreos.com/v1alpha1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/operators.coreos.com/clusterserviceversion_v1alpha1.json` |
| InstallPlan | `operators.coreos.com/v1alpha1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/operators.coreos.com/installplan_v1alpha1.json` |
| CatalogSource | `operators.coreos.com/v1alpha1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/operators.coreos.com/catalogsource_v1alpha1.json` |

---

## Confluent for Kubernetes

Source: <https://github.com/datreeio/CRDs-catalog/tree/main/platform.confluent.io>

### Core Kafka

| Kind | apiVersion | Modeline |
|---|---|---|
| Kafka | `platform.confluent.io/v1beta1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/platform.confluent.io/kafka_v1beta1.json` |
| KafkaTopic | `platform.confluent.io/v1beta1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/platform.confluent.io/kafkatopic_v1beta1.json` |
| KafkaRestClass | `platform.confluent.io/v1beta1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/platform.confluent.io/kafkarestclass_v1beta1.json` |
| KafkaRestProxy | `platform.confluent.io/v1beta1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/platform.confluent.io/kafkarestproxy_v1beta1.json` |
| ClusterLink | `platform.confluent.io/v1beta1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/platform.confluent.io/clusterlink_v1beta1.json` |
| KRaftController | `platform.confluent.io/v1beta1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/platform.confluent.io/kraftcontroller_v1beta1.json` |

### Connect & Schema Registry

| Kind | apiVersion | Modeline |
|---|---|---|
| Connect | `platform.confluent.io/v1beta1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/platform.confluent.io/connect_v1beta1.json` |
| Connector | `platform.confluent.io/v1beta1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/platform.confluent.io/connector_v1beta1.json` |
| SchemaRegistry | `platform.confluent.io/v1beta1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/platform.confluent.io/schemaregistry_v1beta1.json` |
| Schema | `platform.confluent.io/v1beta1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/platform.confluent.io/schema_v1beta1.json` |
| SchemaExporter | `platform.confluent.io/v1beta1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/platform.confluent.io/schemaexporter_v1beta1.json` |

### ksqlDB, Flink, Control Center

| Kind | apiVersion | Modeline |
|---|---|---|
| KsqlDB | `platform.confluent.io/v1beta1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/platform.confluent.io/ksqldb_v1beta1.json` |
| ControlCenter | `platform.confluent.io/v1beta1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/platform.confluent.io/controlcenter_v1beta1.json` |
| FlinkApplication | `platform.confluent.io/v1beta1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/platform.confluent.io/flinkapplication_v1beta1.json` |
| FlinkEnvironment | `platform.confluent.io/v1beta1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/platform.confluent.io/flinkenvironment_v1beta1.json` |

### RBAC & misc

| Kind | apiVersion | Modeline |
|---|---|---|
| ConfluentRolebinding | `platform.confluent.io/v1beta1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/platform.confluent.io/confluentrolebinding_v1beta1.json` |
| Gateway | `platform.confluent.io/v1beta1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/platform.confluent.io/gateway_v1beta1.json` |
| ReferenceGrant | `platform.confluent.io/v1beta1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/platform.confluent.io/referencegrant_v1beta1.json` |
| CMFRestClass | `platform.confluent.io/v1beta1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/platform.confluent.io/cmfrestclass_v1beta1.json` |
| KRaftMigrationJob | `platform.confluent.io/v1beta1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/platform.confluent.io/kraftmigrationjob_v1beta1.json` |

> Browse the full Confluent CRD list: <https://github.com/datreeio/CRDs-catalog/tree/main/platform.confluent.io>
>
> If you need a Confluent CRD that's not in the catalog (e.g., a private/internal one), see [Fallbacks & generating your own](#fallbacks--generating-your-own) to pull the schema from the live cluster.

---

## HashiCorp Vault Secrets Operator

For the official Vault Secrets Operator (VSO) on OCP. If you're using the
older `vault-k8s` injector pattern (annotations on Pods), no schema is
needed — those are just Pod annotations.

| Kind | apiVersion | Modeline |
|---|---|---|
| VaultConnection | `secrets.hashicorp.com/v1beta1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/secrets.hashicorp.com/vaultconnection_v1beta1.json` |
| VaultAuth | `secrets.hashicorp.com/v1beta1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/secrets.hashicorp.com/vaultauth_v1beta1.json` |
| VaultStaticSecret | `secrets.hashicorp.com/v1beta1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/secrets.hashicorp.com/vaultstaticsecret_v1beta1.json` |
| VaultDynamicSecret | `secrets.hashicorp.com/v1beta1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/secrets.hashicorp.com/vaultdynamicsecret_v1beta1.json` |
| VaultPKISecret | `secrets.hashicorp.com/v1beta1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/secrets.hashicorp.com/vaultpkisecret_v1beta1.json` |

---

## cert-manager

| Kind | apiVersion | Modeline |
|---|---|---|
| Certificate | `cert-manager.io/v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/cert-manager.io/certificate_v1.json` |
| CertificateRequest | `cert-manager.io/v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/cert-manager.io/certificaterequest_v1.json` |
| Issuer | `cert-manager.io/v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/cert-manager.io/issuer_v1.json` |
| ClusterIssuer | `cert-manager.io/v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/cert-manager.io/clusterissuer_v1.json` |
| Order | `acme.cert-manager.io/v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/acme.cert-manager.io/order_v1.json` |
| Challenge | `acme.cert-manager.io/v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/acme.cert-manager.io/challenge_v1.json` |
| Bundle | `trust.cert-manager.io/v1alpha1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/trust.cert-manager.io/bundle_v1alpha1.json` |

### OCP cert-manager operator (trust-manager)

`TrustManager` is an OCP-native kind from `openshift/cert-manager-operator` —
no hosted JSON schema exists. Generate from your cluster:

```bash
oc get crd trustmanagers.operator.openshift.io -o json \
  | jq '.spec.versions[] | select(.name=="v1alpha1") | .schema.openAPIV3Schema' \
  > infrastructure/ocp/.schemas/trustmanager-operator-v1alpha1.json
```

Then reference relatively:

```yaml
# yaml-language-server: $schema=../../.schemas/trustmanager-operator-v1alpha1.json
apiVersion: operator.openshift.io/v1alpha1
kind: TrustManager
```

---

## External Secrets Operator

Alternative to VSO if you go that route — syncs from any secret backend
into k8s `Secret` objects.

| Kind | apiVersion | Modeline |
|---|---|---|
| ExternalSecret | `external-secrets.io/v1beta1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/external-secrets.io/externalsecret_v1beta1.json` |
| SecretStore | `external-secrets.io/v1beta1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/external-secrets.io/secretstore_v1beta1.json` |
| ClusterSecretStore | `external-secrets.io/v1beta1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/external-secrets.io/clustersecretstore_v1beta1.json` |
| ClusterExternalSecret | `external-secrets.io/v1beta1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/external-secrets.io/clusterexternalsecret_v1beta1.json` |
| PushSecret | `external-secrets.io/v1alpha1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/external-secrets.io/pushsecret_v1alpha1.json` |

---

## ArgoCD

For GitOps deploys to OCP. Skip if you're not using Argo.

| Kind | apiVersion | Modeline |
|---|---|---|
| Application | `argoproj.io/v1alpha1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/application_v1alpha1.json` |
| ApplicationSet | `argoproj.io/v1alpha1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/applicationset_v1alpha1.json` |
| AppProject | `argoproj.io/v1alpha1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/appproject_v1alpha1.json` |

---

## Tekton Pipelines

For OCP Pipelines (Tekton-based) if you go down that road.

| Kind | apiVersion | Modeline |
|---|---|---|
| Pipeline | `tekton.dev/v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/tekton.dev/pipeline_v1.json` |
| PipelineRun | `tekton.dev/v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/tekton.dev/pipelinerun_v1.json` |
| Task | `tekton.dev/v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/tekton.dev/task_v1.json` |
| TaskRun | `tekton.dev/v1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/tekton.dev/taskrun_v1.json` |
| EventListener | `triggers.tekton.dev/v1beta1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/triggers.tekton.dev/eventlistener_v1beta1.json` |

---

## Helm chart values

These are schemas for `values.yaml` files, not Kubernetes manifests. Pin to a
release tag so your editor validates against the version you actually deployed.

| Chart | Modeline |
|---|---|
| trust-manager `v0.22.1` | `# yaml-language-server: $schema=https://raw.githubusercontent.com/cert-manager/trust-manager/v0.22.1/deploy/charts/trust-manager/values.schema.json` |

> To bump: replace the tag in the URL. `main` also works if you don't need pinning:
> `https://raw.githubusercontent.com/cert-manager/trust-manager/main/deploy/charts/trust-manager/values.schema.json`

---

## Fallbacks & generating your own

When neither yannh nor datreeio has what you need (looking at you, Confluent
for Kubernetes and most internal CRDs), generate the schema from the live
cluster.

### Step 1: Find the CRD

```bash
oc get crd | grep -i <thing>
```

### Step 2: Extract the OpenAPI v3 schema

```bash
mkdir -p infrastructure/ocp/.schemas

oc get crd kafkatopics.platform.confluent.io -o json \
  | jq '.spec.versions[] | select(.name=="v1beta1") | .schema.openAPIV3Schema' \
  > infrastructure/ocp/.schemas/kafkatopic-v1beta1.json
```

If the CRD has multiple versions, run the command per version (change the
`select(.name==...)` filter and output filename).

### Step 3: Reference it from your manifest

Use a relative path from the manifest's location to `.schemas/`:

```yaml
# yaml-language-server: $schema=../../.schemas/kafkatopic-v1beta1.json
apiVersion: platform.confluent.io/v1beta1
kind: KafkaTopic
...
```

### Step 4 (optional): Commit the schemas

`infrastructure/ocp/.schemas/` is small and self-contained. Committing it
means teammates get autocomplete out-of-the-box without running `oc`. Add
to `.gitignore` if you'd rather everyone generate locally.

### Browsing what's already in the catalogs

- Core k8s: <https://github.com/yannh/kubernetes-json-schema/tree/master/v1.33.9-standalone> (or `v1.29.0-standalone` as a guaranteed fallback)
- CRDs: <https://github.com/datreeio/CRDs-catalog> — top-level dirs are API groups (e.g., `argoproj.io/`, `cert-manager.io/`, `route.openshift.io/`)

The datreeio catalog file naming convention is **always**
`<kind-lowercase>_<version>.json`. So once you know the API group and kind,
you can construct the URL without browsing.

---

## Quick reference card

For copy-paste into a scratch buffer when you need it fast:

```yaml
# Core k8s (yannh) — pin matches OCP 4.16 → k8s 1.29
# yaml-language-server: $schema=https://raw.githubusercontent.com/yannh/kubernetes-json-schema/master/v1.33.9-standalone/<KIND>-<GROUP>.json

# OCP-native kinds (garethahealy) — v4.19.0 is latest available
# yaml-language-server: $schema=https://raw.githubusercontent.com/garethahealy/openshift-json-schema/main/v4.19.0/schemas/<kind>-<group>-<version>.json

# Other CRDs (datreeio)
# yaml-language-server: $schema=https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/<API-GROUP>/<kind>_<version>.json

# Local generated
# yaml-language-server: $schema=../path/to/.schemas/<name>.json
```

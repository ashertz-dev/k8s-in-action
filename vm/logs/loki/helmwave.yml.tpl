{{- $env := requiredEnv "ENV" -}}

project: "loki"
version: "0.35.2"

.options: &options
  # if set, upgrade process rolls back changes made in case of failed upgrade. 
  atomic: true
  # the wait will be set automatically if atomic is true
  wait: true
  # time to wait for any individual Kubernetes operation .
  timeout: 300s
  # limit the maximum number of revisions saved per release.
  max_history: 3
  # create the release namespace if not present.
  namespace: vm
  create_namespace: true
  pending_release_strategy: rollback

releases:
- name: loki
  tags: [loki]
  <<: *options
  chart:
    name: ./charts/loki
  values:
  - ./values/_loki.yml
  - ./values/{{ $env }}.yml

- name: promtail
  tags: [promtail]
  <<: *options
  chart:
    name: ./charts/promtail
  values:
  - ./values/_promtail.yml
  - ./values/{{ $env }}.yml

- name: event
  tags: [event]
  <<: *options
  chart:
    name: ./charts/kubernetes-event-exporter
  values:
  - ./values/_event.yml

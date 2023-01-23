{{/*
Before trying to contribute this file to upstream, please read below.
This helpers file contains Giant Swarm specific overrides to helpers defined
in the original upstream _helpers.tpl file.
*/}}

{{/*
Value used for app.kubernetes.io/name label on resources.
Needs to be stable as Giant Swarm is using it for monitoring.
*/}}
{{- define "kong.chart-name" -}}
{{- .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "kong.metaLabels" -}}
app.kubernetes.io/name: {{ include "kong.chart-name" . | quote }}
helm.sh/chart: {{ template "kong.chart" . }}
app.kubernetes.io/instance: "{{ .Release.Name }}"
app.kubernetes.io/managed-by: "{{ .Release.Service }}"
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
giantswarm.io/service-type: "managed"
giantswarm.io/monitoring_basic_sli: "true"
application.giantswarm.io/team: {{ index .Chart.Annotations "application.giantswarm.io/team" | quote }}
application.giantswarm.io/container-images-hash: {{ include "kong.imagesHash" . | quote }}
{{- range $key, $value := .Values.extraLabels }}
{{ $key }}: {{ $value | quote }}
{{- end }}
{{- end -}}

{{- define "kong.getRepoTag" -}}
{{- if .unifiedRepoTag }}
{{- .unifiedRepoTag }}
{{- else if .repository }}
{{- if .registry }}
{{- .registry }}/{{ .repository }}:{{ .tag }}
{{- else }}
{{- .repository }}:{{ .tag }}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "kong.imagesHash" -}}
{{- printf "%s-%s" (include "kong.getRepoTag" .Values.image) (include "kong.getRepoTag" .Values.ingressController.image) | sha256sum | trunc 63 -}}
{{- end -}}

{{- define "kong.selectorLabels" -}}
app.kubernetes.io/name: {{ include "kong.chart-name" . | quote }}
app.kubernetes.io/component: app
app.kubernetes.io/instance: "{{ .Release.Name }}"
{{- end -}}

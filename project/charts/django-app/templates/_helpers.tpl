{{/*
Return the fully qualified app name
*/}}
{{- define "django-app.fullname" -}}
{{- printf "%s-%s" .Release.Name .Chart.Name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the service name
*/}}
{{- define "django-app.serviceName" -}}
{{- printf "%s-svc" (include "django-app.fullname" .) -}}
{{- end -}}

{{/*
Return labels common to all resources
*/}}
{{- define "django-app.labels" -}}
app.kubernetes.io/name: {{ .Chart.Name }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

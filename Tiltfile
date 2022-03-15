k8s_yaml(['deployment-web.yml', 'deployment-sidekiq.yml'])

docker_build('apmiller108/kubetest', '.')

k8s_resource('kubetest-web', port_forwards='3000')
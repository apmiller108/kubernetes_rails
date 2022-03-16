k8s_yaml(['deployment-rails-app.yml', 'deployment-sidekiq.yml'])

docker_build('apmiller108/kubetest', '.')

k8s_resource('rails-app', port_forwards='3000')
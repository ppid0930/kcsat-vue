podTemplate(label: 'docker-build',
  containers: [
    containerTemplate(
      name: 'docker',
      image: 'docker',
      command: 'cat',
      ttyEnabled: true
    ),
    containerTemplate(
      name: 'argo',
      image: 'argoproj/argo-cd-ci-builder:latest',
      command: 'cat',
      ttyEnabled: true
    ),
  ],
  volumes: [
    hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock'),
  ]
) {
    node('docker-build') {
        def dockerHubCred = "DockerHub"
        def appImage

        stage('Checkout'){
            container('argo'){
                checkout scm
            }
        }

        stage('Build'){
            container('docker'){
                script {
                    appImage = docker.build("leeju0912/kcsat-vue")
                }
            }
        }

        stage('Push'){
            container('docker'){
                script {
                    docker.withRegistry('https://registry.hub.docker.com', dockerHubCred){
                        appImage.push("${env.BUILD_NUMBER}")
                        appImage.push("latest")
                    }
                }
            }
        }

        stage('Deploy'){
            container('argo'){
                checkout([$class: 'GitSCM',
                        branches: [[name: '*/main' ]],
                        extensions: scm.extensions,
                        userRemoteConfigs: [[
                            url: 'git@github.com:LeeJU0912/kcsat-helm-repo.git',
                            credentialsId: 'jenkins-ssh-private',
                        ]]
                ])
                sshagent(credentials: ['jenkins-ssh-private']){
                    sh("""
                        #!/usr/bin/env bash
                        set +x
                        export GIT_SSH_COMMAND="ssh -oStrictHostKeyChecking=no"
                        git config --global user.email "thirdspirit@naver.com"
                        git checkout main
                        cd kcsat-vue-chart/templates && kustomize edit set image leeju0912/kcsat-vue:${BUILD_NUMBER}
                        git commit -a -m "updated the image tag"
                        git push
                    """)
                }
            }
        }
    }
}
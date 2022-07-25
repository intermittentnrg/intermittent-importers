env.TAG = "${env.BRANCH_NAME}-${env.BUILD_NUMBER}"

properties([
  buildDiscarder(logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '', numToKeepStr: '50'))
])

stage('kaniko') {
  podTemplate(yaml: '''
kind: Pod
spec:
  containers:
    - name: kaniko
      image: gcr.io/kaniko-project/executor:v1.6.0-debug
      command: ['/busybox/cat']
      tty: true
      securityContext:
        runAsUser: 0
        privileged: true
      resources:
        requests:
          memory: "3Gi"
          cpu: "1"
        limits:
          # memory: "3Gi"
          # cpu: "2.5"
'''
  ) {
    node(POD_LABEL) {
      checkout scm
      container('kaniko') {
        sh "/kaniko/executor -f Dockerfile -c . --cache=true --insecure --destination=docker-registry.docker-registry:5000/intermittency:${env.TAG} --destination=docker-registry.docker-registry:5000/intermittency:latest"
      }
    }
  }
}

stage('test app') {
  podTemplate(yaml: """
kind: Pod
spec:
  containers:
    - name: app
      image: docker-registry:5000/intermittency:${env.TAG}
      command: ['/bin/cat']
      tty: true
      envFrom:
        - secretRef:
            name: intermittency-${env.BRANCH_NAME}
      resources:
        requests:
          cpu: "1"
          memory: "0.5Gi"
"""
  ) {
    node(POD_LABEL) {
      container('app') {
        sh 'cd /app ; rspec spec -f d --format RspecJunitFormatter --out ${WORKSPACE}/rspec.xml'
        junit allowEmptyResults: true, testResults: 'rspec.xml'

        if (env.BRANCH_NAME == "master" || env.BRANCH_NAME == "production") {
          sh "RAILS_ENV=development cd /app && rake db:migrate"
          sh "cp /app/jobdsl.groovy ."
          jobDsl(targets: 'jobdsl.groovy',
                 additionalParameters: [
                     TAG: env.TAG,
                     BRANCH_NAME: env.BRANCH_NAME
                 ],
                 removedJobAction: 'DELETE'
          )
          build wait: false, job: "intermittency-${env.BRANCH_NAME}-refresh"
        }
      }
    }
  }
}

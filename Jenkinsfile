env.TAG = "${env.BRANCH_NAME}-${env.BUILD_NUMBER}"

properties([
  disableConcurrentBuilds(),
  buildDiscarder(logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '', numToKeepStr: '50')),
  [
    $class         : 'BuildBlockerProperty',
    blockingJobs   : "intermittency-${env.BRANCH_NAME}/.*",
    blockLevel     : 'GLOBAL',
    scanQueueFor   : 'BUILDABLE',
    useBuildBlocker: true
  ]
])

stage('kaniko') {
  podTemplate(yaml: '''
kind: Pod
spec:
  containers:
    - name: kaniko
      image: gcr.io/kaniko-project/executor:v1.15.0-debug
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
            name: intermittency-${env.BRANCH_NAME == 'production' ? 'production' : 'master'}
      resources:
        requests:
          cpu: "1"
          memory: "0.5Gi"
"""
) {
  node(POD_LABEL) {
    container('app') {
      stage('test app') {
        timeout(time: 10, unit: 'MINUTES') {
          sh 'cd /app ; RAILS_ENV=test rake db:migrate'
          try {
            sh "cd /app ; rspec spec -f d --format RspecJunitFormatter --out ${env.WORKSPACE}/rspec.xml"
            sh "cd /app ; cp -rv coverage app lib spec ${env.WORKSPACE}"
          } finally {
            junit allowEmptyResults: true, testResults: 'rspec.xml'
            recordCoverage(tools: [[parser: 'COBERTURA', pattern: 'coverage/coverage.xml']])
          }
        }
      }
      stage('deploy') {
        if (env.BRANCH_NAME == "master" || env.BRANCH_NAME == "production") {
          sh "RAILS_ENV=development cd /app && rake db:migrate"
        }

        sh "cp /app/jobdsl.groovy ."
        jobDsl(targets: 'jobdsl.groovy',
               additionalParameters: [
                   TAG: env.TAG,
                   BRANCH_NAME: env.BRANCH_NAME
               ],
               removedJobAction: 'DELETE'
        )
        if (env.BRANCH_NAME == "master" || env.BRANCH_NAME == "production") {
          build wait: false, job: "intermittency-${env.BRANCH_NAME}/refresh"
        }
      }
    }
  }
}

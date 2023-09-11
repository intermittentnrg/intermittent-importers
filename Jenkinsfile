env.TAG = "${env.BRANCH_NAME}-${env.BUILD_NUMBER}"

properties([
  buildDiscarder(logRotator(artifactDaysToKeepStr: '', artifactNumToKeepStr: '', daysToKeepStr: '', numToKeepStr: '50')),
  [
    $class         : 'BuildBlockerProperty',
    blockingJobs   : "intermittency-${env.BRANCH_NAME}/.*",
    blockLevel     : 'GLOBAL',
    scanQueueFor   : 'ALL',
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
          try {
            sh 'cd /app ; rspec spec -f d --format RspecJunitFormatter --out ${WORKSPACE}/rspec.xml'
            sh "cp -rv /app ${env.WORKSPACE}"
          } finally {
            junit allowEmptyResults: true, testResults: 'rspec.xml'
	    cobertura autoUpdateHealth: false, autoUpdateStability: false, coberturaReportFile: 'app/coverage/coverage.xml', conditionalCoverageTargets: '70, 0, 0', failUnhealthy: false, failUnstable: false, lineCoverageTargets: '80, 0, 0', maxNumberOfBuilds: 0, methodCoverageTargets: '80, 0, 0', onlyStable: false, sourceEncoding: 'ASCII', zoomCoverageChart: false
          }
        }
      }
      stage('deploy') {
        sh "cp /app/jobdsl.groovy ."
        jobDsl(targets: 'jobdsl.groovy',
               additionalParameters: [
                   TAG: env.TAG,
                   BRANCH_NAME: env.BRANCH_NAME
               ],
               removedJobAction: 'DELETE'
        )
        if (env.BRANCH_NAME == "master" || env.BRANCH_NAME == "production") {
          sh "RAILS_ENV=development cd /app && rake db:migrate"
          sh "RAILS_ENV=development cd /app && scripts/validate-constraints.rb"
          build wait: false, job: "intermittency-${env.BRANCH_NAME}/refresh"
        }
      }
    }
  }
}

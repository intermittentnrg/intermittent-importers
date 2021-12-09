env.ENV = env.ENV ?: 'nonprod'
env.TAG = "${env.BRANCH_NAME}-${env.BUILD_NUMBER}"

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
      resources:
        requests:
          cpu: "1"
          memory: "0.5Gi"
"""
  ) {
    node(POD_LABEL) {
      container('app') {
        sh 'cd /app ; rspec spec -f d --format RspecJunitFormatter --out ${WORKSPACE}/rspec.xml'
        junit 'rspec.xml'

        sh "cp /app/jobdsl.groovy ."
        jobDsl(targets: 'jobdsl.groovy',
               additionalParameters: [
                   TAG: env.TAG,
                   BRANCH_NAME: env.BRANCH_NAME
               ],
               removedJobAction: 'DELETE'
        )
      }
    }
  }
}

// stage('helm') {
//   podTemplate(yaml: '''
// apiVersion: v1
// kind: Pod
// metadata:
//   annotations:
//     iam.amazonaws.com/role: k8s-jenkins-admin
// spec:
//   containers:
//     - name: helmfile
//       image: quay.io/roboll/helmfile:helm3-v0.139.6
//       imagePullPolicy: Always
//       command: ['cat']
//       tty: true
// '''
//     ) {
//       node(POD_LABEL) {
//      checkout scm
//      container('helmfile') {
//        sh "cd kubernetes && helmfile ${env.BRANCH_NAME == "main" ? 'apply' : 'diff'}"
//      }
//       }
//     }
//   }
// }

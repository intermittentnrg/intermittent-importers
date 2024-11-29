folder("intermittency-${BRANCH_NAME}")

pipelineJob("intermittency-${BRANCH_NAME}/refresh") {
  previousNames("intermittency-${BRANCH_NAME}-refresh")
  blockOn("intermittency/${BRANCH_NAME}") {
    blockLevel('GLOBAL')
    scanQueueFor('ALL')
  }
  properties {
    disableConcurrentBuilds()
    if (BRANCH_NAME == "master" || BRANCH_NAME == "production") {
      pipelineTriggers {
        triggers {
          cron {
            spec('H * * * *')
          }
        }
      }
    }
    logRotator {
      numToKeep(50)
    }
  }
  environmentVariables(TAG: TAG, BRANCH_NAME: BRANCH_NAME)
  definition {
    cpsScm {
      scm {
        git {
          remote {
            url('git@git-server:intermittency.git')
            credentials('gitolite-jenkins')
          }
          branches(BRANCH_NAME)
          scriptPath('Jenkinsfile.refresh')
        }
      }
    }
  }
}

pipelineJob("intermittency-${BRANCH_NAME}/manual") {
  previousNames("intermittency-${BRANCH_NAME}-manual")
  parameters {
    stringParam('CMD', '')
  }
  properties {
    disableConcurrentBuilds()
  }
  environmentVariables(TAG: TAG, BRANCH_NAME: BRANCH_NAME)
  definition {
    cpsScm {
      scm {
        git {
          remote {
            url('git@git-server:intermittency.git')
            credentials('gitolite-jenkins')
          }
          branches(BRANCH_NAME)
          scriptPath('Jenkinsfile.manual')
        }
      }
    }
  }
}

pipelineJob("intermittency-${BRANCH_NAME}/post-pricemap") {
  environmentVariables(TAG: TAG, BRANCH_NAME: BRANCH_NAME)
  properties {
  if (BRANCH_NAME == "master") {
      pipelineTriggers {
        triggers {
          cron {
            spec('''
	      30 14 * * *
	    ''')
          }
        }
      }
    }
  }
  definition {
    cpsScm {
      scm {
	git {
	  remote {
	    url('git@git-server:intermittency.git')
	    credentials('gitolite-jenkins')
	  }
	  branches(BRANCH_NAME)
	  scriptPath('Jenkinsfile.post-pricemap')
	}
      }
    }
  }
}

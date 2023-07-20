folder("intermittency-${BRANCH_NAME}")

if (BRANCH_NAME == "master") {
  pipelineJob("intermittency-copydb") {
    parameters {
      stringParam('DUMPARGS', '')
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
            scriptPath('Jenkinsfile.copydb')
          }
        }
      }
    }
  }
}

pipelineJob("intermittency-${BRANCH_NAME}/refresh") {
  previousNames("intermittency-${BRANCH_NAME}-refresh")
  if (BRANCH_NAME == "master" || BRANCH_NAME == "production") {
    properties {
      disableConcurrentBuilds()
      pipelineTriggers {
        triggers {
          cron {
            spec('H */2 * * *')
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

pipelineJob("intermittency-${BRANCH_NAME}/deep-refresh") {
  properties {
    disableConcurrentBuilds()
    pipelineTriggers {
      triggers {
	cron {
	  spec('H 3 * * *')
	}
      }
    }
  }
  logRotator {
    numToKeep(50)
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
          scriptPath('Jenkinsfile.deep-refresh')
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

pipelineJob("intermittency-${BRANCH_NAME}/tweet") {
  previousNames("intermittency-${BRANCH_NAME}-tweet")
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
          scriptPath('Jenkinsfile.tweet')
        }
      }
    }
  }
}

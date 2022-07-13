pipelineJob("intermittency-${BRANCH_NAME}-refresh") {
  properties {
    pipelineTriggers {
      triggers {
        cron {
          spec('H */2 * * *')
	}
      }
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

pipelineJob('intermittency-refresh') {
  properties {
    pipelineTriggers {
      triggers {
        cron {
          spec('45 */3 * * *')
	}
      }
    }
  }
  environmentVariables(TAG: TAG)
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

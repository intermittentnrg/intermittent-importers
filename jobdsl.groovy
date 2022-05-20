pipelineJob('intermittency-refresh') {
  triggers {
    cron('45 */3 * * *')
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

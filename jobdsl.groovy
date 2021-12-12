pipelineJob('intermittency-entsoe') {
  triggers {
    cron('45 */4 * * *')
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
	  scriptPath('Jenkinsfile.entsoe')
	}
      }
    }
  }
}

['intermittency-entsoe'].each { jobName ->
  pipelineJob(jobName) {
    //triggers {
    //  cron(opts.cron)
    //}
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
}

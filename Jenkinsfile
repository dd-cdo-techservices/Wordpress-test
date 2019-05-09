pipeline {
  
  agent any  
  
  stages {
    stage('checkout') {
      steps {
        checkout scm
  	    }
    	}
    
    
    stage('Deploy App') {
      steps {
	echo 'Deploying Wordpress Application on AWS Node'
	sh 'ansible all -i targethost.ini -m ping'
        sh 'ansible-playbook -i targethost.ini wordpress.yml'
        cleanWs()
      }
    }
  }
}

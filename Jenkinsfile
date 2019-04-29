#!/usr/bin/env groovy
pipeline {
    agent {
        node {
            label 'docker_ansible_only'
        }
    }
    stages {
        stage('Build') {
            steps {
                ansiColor('xterm') {
                    ansiblePlaybook( 
                        playbook: '${WORKSPACE}/nginx/tests/test.yml',
                        inventory: '${WORKSPACE}/nginx/tests/inventory',
                        colorized: true)
                }
            }
        }
    }
}
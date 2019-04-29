#!/usr/bin/env groovy
pipeline {
    agent {
        node {
            label 'docker_ansible_only'
        }
    }
    stages {
        stage('Checkout') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '**']], browser: [$class: 'GithubWeb', repoUrl: 'https://github.com/ChinChihFeng/nginx'], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'RelativeTargetDirectory', relativeTargetDir: 'nginx']], submoduleCfg: [], userRemoteConfigs: [[credentialsId: '58e4fd34-3f3d-446a-843e-12395d1e3c08', url: 'https://github.com/ChinChihFeng/nginx.git']]])
            }
        }
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
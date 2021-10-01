podTemplate(
    containers: [
        containerTemplate(
            name: 'node14', 
            image: 'node:14-alpine', 
            command: 'cat', 
            ttyEnabled: true, 
            resourceRequestCpu: '400m', 
            resourceLimitCpu: '700m', 
            resourceRequestMemory: '1000Mi',
            resourceLimitMemory: '1500Mi'),
        containerTemplate(
            name: 'docker', 
            image: 'docker', 
            command: 'cat', 
            ttyEnabled: true),
        containerTemplate(
            name: 'kubectl', 
            image: 'lachlanevenson/k8s-kubectl:v1.22.2',
            command: 'cat', 
            ttyEnabled: true)
    ],
    volumes: [
        hostPathVolume(mountPath: '/home/gradle/.gradle', hostPath: '/tmp/jenkins/.gradle'),
        hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock')
    ]
) 
{
    node(POD_LABEL) {
        stage('build: checkout files') {
            container('node14') {
                 git branch: "main",
                    url: "https://github.com/hanusiakl/flight.web.git"
            }
        }
        stage('build: install dependencies') {
            container('node14') {
                sh "cd flight-web-app && npm i"
            }
        }
        stage('build: service') {
            container('node14') {
                sh "cd flight-web-app && npm run build"
            }
        }
        stage('test: unit tests') {
        }

        stage('test: e2e tests') {
        }

		stage('docker image: create') {
			container('docker') {
				sh "cd flight-web-app && docker build -t flight-web-staging-app --build-arg ENVIRONMENT=staging ."
			}
		}
		stage('docker image: tag') {
			container('docker') {
				sh "cd flight-web-app && docker tag flight-web-staging-app lehudocker/flight-web-staging-app"
			}
		}
		stage('image: publish') {
		    container('docker') {
    		    withDockerRegistry(credentialsId: 'docker') {
                    try {
                        sh "cd flight-web-app && docker push lehudocker/flight-web-staging-app"
                    } catch(ex) {
                        currentBuild.result = 'ERROR'
                    }

                }
			}
		}
		stage('deployment') {
			container('kubectl') {
                try {
                    sh "cd infrastructure/kubernetes/staging && kubectl delete -f 03-deployment.yaml"
                } catch (ex) {
                    currentBuild.result = 'UNSTABLE'
                }
                try {
                   sh "cd infrastructure/kubernetes/staging && kubectl apply -f ."
                } catch (ex) {
                    currentBuild.result = 'ERROR'
                }
            }
		}
    }
}

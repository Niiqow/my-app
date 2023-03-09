pipeline {
    agent any
    environment {
        DOCKERHUB_CREDENTIALS = credentials('docker')
        DOCKERHUB_IMAGE = 'niiqow/taskdev'
        AZURE_MODEL = 'SOCIUSRGLAB-RG-MODELODEVOPS-PROD'
        AZURE_PLAN = 'Plan-SociusRGLABRGModeloDevOpsDockerProd'
        AZURE_NAME = 'sociuswebapptest002p'
        
    }
      parameters {
    string(name: 'container_name', defaultValue: 'taskdev', description: 'Nombre del contenedor de docker.')
    string(name: 'image_name', defaultValue: 'taskdev', description: 'Nombre de la imagene docker.')
   string(name: 'tag_image', defaultValue: "tag-${new Date().format('yyyyMMddHHmmss')}", description: 'Tag de la imagen de la página.')
    string(name: 'container_port', defaultValue: '80', description: 'Puerto que usa el contenedor')
  }
    stages {
     
      
    
        

        stage('Checkout Angular') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/Niiqow/my-app.git']]])
            }
        }
    

        stage('Build Image Proyect Angular'){
            steps{
         
            // sh "docker rm -f task"
              sh "docker build -t ${image_name}:${tag_image} --file Dockerfile ."
        
           
 
               
            }
               
        }



  stage('Push to DockerHUB Angular') {
      steps {
        sh "docker tag ${image_name}:${tag_image} ${DOCKERHUB_IMAGE}:${tag_image}"
        sh "docker push ${DOCKERHUB_IMAGE}:${tag_image}"
      }
    }
    

      stage('Deploy to Azure App Service Angular') {
      steps {
        withCredentials(bindings: [azureServicePrincipal('Azure-Service-Principal-Prod')]) {
          sh 'az login --service-principal -u ${AZURE_CLIENT_ID} -p ${AZURE_CLIENT_SECRET} --tenant ${AZURE_TENANT_ID}'
          sh "az webapp delete -g ${AZURE_MODEL} -n ${AZURE_NAME}"
          sh "az webapp create -g ${AZURE_MODEL} -p ${AZURE_PLAN} -n ${AZURE_NAME} -i ${DOCKERHUB_IMAGE}:${tag_image}"
        }

      }
    }
    
    }
}


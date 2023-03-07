pipeline {
    agent any
    environment {
        DOCKERHUB_CREDENTIALS = credentials('docker')
        DOCKERHUB_IMAGE = 'niiqow/task'
        AZURE_MODEL = 'SOCIUSRGLAB-RG-MODELODEVOPS-DEV'
        AZURE_PLAN = 'Plan-SociusRGLABRGModeloDevOpsDockerDev'
        AZURE_NAME = 'sociuswebapptest009'
        
    }
      parameters {
    string(name: 'container_name', defaultValue: 'task', description: 'Nombre del contenedor de docker.')
    string(name: 'image_name', defaultValue: 'task', description: 'Nombre de la imagene docker.')
   string(name: 'tag_image', defaultValue: "tag-${new Date().format('yyyyMMddHHmmss')}", description: 'Tag de la imagen de la página.')
    string(name: 'container_port', defaultValue: '4200', description: 'Puerto que usa el contenedor')
  }
    stages {
     
      
    
        

        stage('Checkout Angular') {
            steps {
                checkout([$class: 'GitSCM', branches: [[name: '*/develop']], doGenerateSubmoduleConfigurations: false, extensions: [], submoduleCfg: [], userRemoteConfigs: [[url: 'https://github.com/Niiqow/my-app.git']]])
            }
        }
        

        stage('Build Image Proyect Angular'){
            steps{
         
             sh "docker rm -f task"
              sh "docker build -t task:${tag_image} --file Dockerfile ."
              sh "docker create --name ${name_image} -p 4200:4200 task:${tag_image}" // Crea el contenedor
           
 
               
            }
               
        }

        


stage('Build Angular App') {
    steps {
     
       sh "docker start task"
      
      
    }
}
stage('Run Docker Container') {
    steps {
        sh "if ! docker ps -q -f name=${name_image} > /dev/null; then \
            docker run -d --name task -p 4200:4200 -v ${WORKSPACE}/dist:/usr/share/nginx/html:ro nginx:alpine; \
            fi"
    }
}

  stage('Push to DockerHUB Angular') {
      steps {
        sh "docker tag ${name_image}:${tag_image} ${DOCKERHUB_IMAGE}:${tag_image}"
        sh "docker push ${DOCKERHUB_IMAGE}:${tag_image}"
      }
    }
    
      stage('Deploy to Azure App Service Angular') {
      steps {
        withCredentials(bindings: [azureServicePrincipal('Azure-Service-Principal')]) {
          sh 'curl -sL https://aka.ms/InstallAzureCLIDeb | bash'
          sh 'az login --service-principal -u ${AZURE_CLIENT_ID} -p ${AZURE_CLIENT_SECRET} --tenant ${AZURE_TENANT_ID}'
          sh "az webapp delete -g ${AZURE_MODEL} -n ${AZURE_NAME}"
          sh "az webapp create -g ${AZURE_MODEL} -p ${AZURE_PLAN} -n ${AZURE_NAME} -i ${name_image}:${tag_image}"
        }

      }
    }
    
    }
}

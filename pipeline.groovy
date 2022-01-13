pipeline{
    agent any
    stages{
        stage("Git Checkout"){
            steps{
                git credentialsId: 'GithubAccount', url: 'https://github.com/Mirza-Mohammad-Hamza/mirzarepo'
            }
        }
        /*stage("Build Docker Image")
        {
            steps
            {
                sh "docker build -t imagefromgithub ."
                
            }
        }
        stage("Create Container")
        {
            steps
            {
                sh "docker run -itd --name FromJenkins imagefromgithub"
                
            }
        }*/
        stage("Build Image & Container")
        {
            steps
            {
                sh '/home/master/Desktop/Docker/container.sh'
            }
            
        }
    }
    
}

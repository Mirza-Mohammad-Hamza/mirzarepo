#! /bin/bash

#Get the Image name from the .txt File
ImageName=$( cat ./image.txt )

#it Will get the ContainerName from File
Cname=$( cat ./containername.txt )
                
#  This variable have the State of Container running or not  
RUNNING=$(docker inspect --format="{{.State.Running}}" $Cname 2> /dev/null)

if [ -f "Dockerfile" -a -f "image.txt" -a -f "containername.txt" ]
then
       echo "Files are exist"

       #Inspecting Image name Exist or Not
       docker image inspect $ImageName > /dev/null 2>&1
      if [ "$?" -eq 0 ]
      then
                ver=$( cat Dockerfile | grep ^FROM | awk '{print $2}')
                IFS=":" && Array=($ver)
                Doc=${Array[0]}
                echo ""
                echo "This Image $Doc already exist !!! "
                echo ""
                echo ""
                #docker pull $Doc
            # If the container is running
            
            if [ "$RUNNING" == "false" ]
             then
	                #if container is stop  or exited > it will remove the contaier
	               if [ "$(docker ps -aq -f status=exited  -f name=$Cname)" ] 
                    then
                        echo " This Container in Exited State "
                        echo " First removing this Container "
                        echo " "
                        docker rm $Cname
	                      echo " $Cname Container Succesfully Removed "
                        echo " "
                    fi
                                          
                  #This Portion create the new container with the same name as you pass in the Container name
                        echo "Creating your New Container with this Name $Cname"
                        docker container run -d -v /var/lib/jenkins/jobs/Pipeline/workspace/index.html:/var/www/html/index.html -p 8000:80 --name $Cname $ImageName

                  # This portion is ecxecuted when the Container is runnig.
            elif [ "$RUNNING" == "true" ]
            then
                        echo "          This Container is Already Running"
                        #Stopping running Container
                        echo "Stopping the Container"
                        docker stop $Cname
                        echo " $Cname Container Stoped Successfully"
                        echo " "
                        #Removing Stopped Container
                        if [ "$(docker ps -aq -f status=exited -f name=$Cname)" ]
                           then
                            echo " Removing Container "
                            docker rm $Cname
                            echo " $Cname Container Succesfully Removed "
                        fi

	                          echo "Creating your New Container with this Name $Cname"
                            docker container run -d -v /var/lib/jenkins/jobs/Pipeline/workspace/index.html:/var/www/html/index.html -p 8000:80 --name $Cname $ImageName

            else
	                      if [ "$(docker ps -aq -f status=exited -f name=$Cname)" ]
                         then
                              docker rm $Cname
                              echo " $Cname Container Succesfully Removed "
                        fi
                              echo "Creating  New Container"
	                            docker container run -d -v /var/lib/jenkins/jobs/Pipeline/workspace/index.html:/var/www/html/index.html -p 8000:80 --name $Cname $ImageName
                        fi

      else
          echo "This Image is Not Exist"
          echo ""
          echo "Building Images"
          docker build -t $ImageName .
          echo " "
          echo "Creating Container"
          docker container run -d -v /var/lib/jenkins/jobs/Pipeline/workspace/index.html:/var/www/html/index.html -p 8000:80 --name $Cname $ImageName
      fi   

             
else
    echo "files doesn't exist"
fi

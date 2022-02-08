# rstudio-shiny-server-one


Step 1: Clone the repo 

Step 2: docker build --rm -t <Name of the image> .
  
Step 3: docker run  -d -p 8787:8787 -p 3838:3838 --name <Name of the container> <Name of the Image>
  
Step 4: docker ps --> To check the container in running or exited.
  
Step 5: Go to browser and use localhost:8787 & localhost:3737 to check the site is open.
  
  
Simillar you launch it into EC2 with docker installed & and expose the port in security group.

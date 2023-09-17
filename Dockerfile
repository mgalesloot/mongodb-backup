# Set up ubuntu image 
FROM ubuntu:20.04

ENV DEBIAN_FRONTEND noninteractive

# install mongodb backup tools 
RUN apt-get update && apt-get install -y mongo-tools

#  install aws cli
RUN apt-get install -y s3cmd

# copy mongodb backup script to /
COPY ./mongo_backup.sh /mongo_backup.sh

RUN chmod +x /mongo_backup.sh

USER 1001 

# Run the command on container startup
CMD ["bash"]
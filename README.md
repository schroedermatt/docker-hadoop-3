# Hadoop 3.x Docker Image

Most of the work is coming from : http://bigdatums.net/2017/11/04/creating-hadoop-docker-image/

For some details about Hadoop 3 (such as new ports), see: https://fr.slideshare.net/HadoopSummit/hadoop-3-in-a-nutshell

> Please, read the content of Dockerfile, because it may be possible that you have to update it.
> See the comments about the tgz of hadoop3.

> After starting the container, you can access the web UI:
> * HDFS: http://localhost:9870
> * RM: http://localhost:8088

## Getting Started

* Build the image

  ```sh
  sudo docker build -t hadoop3 .
  ```

* Run the container

  ```sh
  docker run -d \
    --name hadoop3 --hostname=hadoop3 \
    -p 8042:8042 \
    -p 8088:8088 \
    -p 9000:9000 \
    -p 9864:9864 \
    -p 9866:9866 \
    -p 9867:9867 \
    -p 9870:9870 \
    -p 19888:19888 \
    hadoop3:latest
  ```

* Access the container

  ```sh
  docker exec -it hadoop3 bash

  # get status of dfs
  hdfs dfsadmin -report
  ```

* Test a job

  ```sh
  yarn jar $HADOOP_HOME/share/hadoop/mapreduce/hadoop-mapreduce-examples-3.1.2.jar pi 10 100
  ```

* Clean
  
  ```sh
  docker stop hadoop3 && docker rm hadoop3
  ``

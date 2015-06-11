# Mule MMC server

FROM tomcat:7-jre8
MAINTAINER Andrew Holbrook <andrew_holbrook@mckinsey.com>

#Initial dependencies
RUN apt-get update
RUN apt-get -y install curl

#Pull latest mmc 

#Get authentication token and parse from file
RUN curl -s -d '{"auth":{"RAX-KSKEY:apiKeyCredentials": {"username":"orglabcloud","apiKey":"a02e136740e84de19900771c76fc7468"}}}' -H 'Content-Type: application/json' 'https://identity.api.rackspacecloud.com/v2.0/tokens' > auth.json
RUN grep -Po '"id":.*?[^\\]","expires"' auth.json > pre.json
RUN printf "X-Auth-Token" > token.json
RUN grep -Po ':.*?[^\\]"' pre.json >> token.json
RUN sed -i 's/\"//g' token.json

RUN curl --remote-name 'https://storage101.iad3.clouddrive.com/v1/MossoCloudFS_923357/mule_test/mmc-console-3.6.2.war' -H "$(cat token.json)"
RUN mv mmc-console-3.6.2.war /usr/local/tomcat/webapps/mmc.war
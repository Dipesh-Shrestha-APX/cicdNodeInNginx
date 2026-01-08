#First section
FROM node:20-alpine AS temp_node

# Accept build-time variable i.e. receive it from the github->runner->here
ARG APP_VERSION
# Make it visible to Node (process.env) i.e. receive this arg to environment so that node app could access through process.env.APP_VERSION
ENV APP_VERSION=$APP_VERSION

WORKDIR /tempApp
#To use the caching on dependencies installation
#Copy and run is single layer
COPY package.json ./ 
RUN npm install
#Remaining on different batch
COPY . .
RUN ls -R src
RUN cat src/template.html
RUN npm run build

#Second section
FROM nginx:stable-alpine
# WORKDIR /nginxApp
# RUN cp /usr/share/nginx/html/index.html /usr/share/nginx/html/index_bkp.html 
COPY --from=temp_node /tempApp/dist/ /usr/share/nginx/html/



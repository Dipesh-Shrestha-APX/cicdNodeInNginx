#First section
FROM node:20-alpine AS temp_node
WORKDIR /tempApp
#To use the caching on dependencies installation
#Copy and run is single layer
COPY package.json ./ 
RUN npm install
#Remaining on different batch
COPY . .
RUN npm run build

#Second section
FROM nginx:stable-alpine
# WORKDIR /nginxApp
# RUN cp /usr/share/nginx/html/index.html /usr/share/nginx/html/index_bkp.html 
COPY --from=temp_node /tempApp/dist/ /usr/share/nginx/html/



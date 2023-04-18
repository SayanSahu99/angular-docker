# Build Stage
FROM node:12.18.3 as build
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm config set registry https://registry.npmjs.org/
RUN npm config set strict-ssl false
RUN npm install
COPY . .
RUN npm run build --prod

# Deploy Stage
FROM nginx:1.19.0-alpine
COPY --from=build /usr/src/app/dist/dialogManagementSystem /usr/share/nginx/html
# Copy the locations file for the nginx proxy
COPY ./nginx/nginx.conf /etc/nginx/conf.d/default.conf 
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

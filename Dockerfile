# Etapa 1: build Angular
FROM node:18 AS build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build -- --configuration production

# Etapa 2: servir com Nginx
FROM nginx:alpine
COPY --from=build /app/dist/<nome-do-projeto> /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

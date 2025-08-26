# ===========================
# Etapa 1: Build do Angular
# ===========================
FROM node:20 AS build

# Define diretório de trabalho
WORKDIR /app

# Copia package.json e package-lock.json para instalar dependências
COPY package*.json ./

# Instala dependências
RUN npm install

# Copia todo o código do projeto
COPY . .

# Build de produção do Angular
RUN ng build --configuration production

# ===========================
# Etapa 2: Servir com Nginx
# ===========================
FROM nginx:alpine

# Copia os arquivos buildados do Angular para o Nginx
COPY --from=build /app/dist/whisper-ui /usr/share/nginx/html

# Copia configuração do Nginx para habilitar proxy /api
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expõe a porta 80
EXPOSE 80

# Comando padrão para iniciar Nginx
CMD ["nginx", "-g", "daemon off;"]

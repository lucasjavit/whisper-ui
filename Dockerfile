# ===========================
# Etapa 1: Build do Angular
# ===========================
FROM node:20 AS build

# Define diretório de trabalho
WORKDIR /app

# Copia package.json e package-lock.json para instalar dependências
COPY package*.json ./

# Instala dependências do projeto
RUN npm install

# Copia todo o restante do código
COPY . .

# Build de produção usando CLI local com npx
RUN npx ng build --configuration production

# ===========================
# Etapa 2: Servir com Nginx
# ===========================
FROM nginx:alpine

# Copia os arquivos buildados do Angular para o Nginx
COPY --from=build /app/dist/whisper-ui/browser /usr/share/nginx/html

# Copia configuração do Nginx para habilitar proxy /api
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expõe a porta padrão do Nginx
EXPOSE 80

# Comando padrão para iniciar Nginx
CMD ["nginx", "-g", "daemon off;"]

# ===========================
# Etapa 1: Build do Angular
# ===========================
FROM node:20 AS build

# Define o diretório de trabalho
WORKDIR /app

# Copia package.json e package-lock.json para instalar dependências
COPY package*.json ./

# Instala dependências
RUN npm install

# Copia todo o restante do código
COPY . .

# Build da aplicação Angular para produção
RUN npm run build -- --configuration production

# ===========================
# Etapa 2: Servir com Nginx
# ===========================
FROM nginx:alpine

# Copia os arquivos gerados para o Nginx
COPY --from=build /app/dist/whisper-ui /usr/share/nginx/html

# Se quiser proxy /api para backend, crie nginx.conf e copie aqui:
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Expõe a porta 80
EXPOSE 80

# Inicia o Nginx
CMD ["nginx", "-g", "daemon off;"]

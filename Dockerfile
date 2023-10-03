FROM ubuntu:20.04

# Atualize os pacotes
RUN apt-get update

# Instale as dependências iniciais
RUN apt-get install -y \
    unzip \
    wget \
    libnss3 \
    curl \
&& rm -rf /var/lib/apt/lists/* \
&& echo "progress = dot:giga" | tee /etc/wgetrc \
&& mkdir -p /mnt /opt /data \
&& wget https://github.com/andmarios/duphard/releases/download/v1.0/duphard -O /bin/duphard \
&& chmod +x /bin/duphard

# Instale o Node.js
ENV NODE_VERSION=14.17.3
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
ENV NVM_DIR=/root/.nvm
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"
RUN node --version
RUN npm --version

# Instale as dependências do Puppeteer
RUN apt-get update \
    && apt-get install -y \
        gconf-service \
        libasound2 \
        libatk1.0-0 \
        libc6 \
        libcairo2 \
        libcups2 \
        libdbus-1-3 \
        libexpat1 \
        libfontconfig1 \
        libgcc1 \
        libgconf-2-4 \
        libgdk-pixbuf2.0-0 \
        libglib2.0-0 \
        libgtk-3-0 \
        libnspr4 \
        libpango-1.0-0 \
        libpangocairo-1.0-0 \
        libstdc++6 \
        libx11-6 \
        libx11-xcb1 \
        libxcb1 \
        libxcomposite1 \
        libxcursor1 \
        libxdamage1 \
        libxext6 \
        libxfixes3 \
        libxi6 \
        libxrandr2 \
        libxrender1 \
        libxss1 \
        libxtst6 \
        ca-certificates \
        fonts-liberation \
        libappindicator1 \
        libnss3 \
        lsb-release \
        xdg-utils \
        wget \
    && rm -rf /var/lib/apt/lists/*

# Defina o diretório de trabalho
WORKDIR /app

# Copie os arquivos de aplicação
COPY . .

# Instale as dependências da aplicação
COPY package*.json ./
RUN npm install --quiet --no-optional --no-fund --loglevel=error

# Exponha a porta
EXPOSE 8000

# Inicie a aplicação
CMD ["npm", "run", "start"]

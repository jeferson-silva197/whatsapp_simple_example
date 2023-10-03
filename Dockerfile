FROM ubuntu:20.04

# Set the working directory
WORKDIR /app
RUN apt-get update \
&& apt-get install -y \
   unzip \
   wget \
   libnss3 \
&& rm -rf /var/lib/apt/lists/* \
&& echo "progress = dot:giga" | tee /etc/wgetrc \
&& mkdir -p /mnt /opt /data \
&& wget https://github.com/andmarios/duphard/releases/download/v1.0/duphard -O /bin/duphard \
&& chmod +x /bin/duphard

ENV NODE_VERSION=14.17.3
RUN apt install -y curl
RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
ENV NVM_DIR=/root/.nvm
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use v${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default v${NODE_VERSION}
ENV PATH="/root/.nvm/versions/node/v${NODE_VERSION}/bin/:${PATH}"
RUN node --version
RUN npm --version

# Copy the application files
COPY . .
COPY package*.json ./

RUN npm install --quiet --no-optional --no-fund --loglevel=error
EXPOSE 8000
# Start the application
CMD ["npm", "run","start"]


 



 

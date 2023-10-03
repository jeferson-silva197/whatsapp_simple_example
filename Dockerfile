FROM ubuntu:20.04

# Set the working directory
WORKDIR /app

RUN apt-get update && apt-get install -y \
    nodejs=14.17.3 \
    libnss3-dev

# Copy the application files
COPY . .
COPY package*.json ./

RUN npm install --quiet --no-optional --no-fund --loglevel=error
EXPOSE 8000
# Start the application
CMD ["npm", "run","start"]


 



 

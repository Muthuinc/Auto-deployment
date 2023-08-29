# I Use the Node.js 14 base image for building the application
FROM node:14-alpine 


# Set the working directory inside the container
WORKDIR /muthu


# Copy package.json and package-lock.json to the working directory
COPY *.json .


# Install the application dependencies
RUN npm install

# Copying the rest of the application contents
COPY . ./

# Start the application
CMD ["npm", "start"]

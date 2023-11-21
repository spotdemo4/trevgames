# Pull node base image
FROM node:19-buster-slim

#Define environment variables
ARG TZ
ENV TZ $TZ

# Install node dependencies
WORKDIR /svelte
COPY ./package.json .
COPY ./svelte.config.js .
RUN npm install

# Move to container
COPY . .

# Build for production
RUN npm run build

# Launch app
CMD ["node", "build"]
EXPOSE 3000
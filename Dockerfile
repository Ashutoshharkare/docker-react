FROM node:16-alpine AS builder

WORKDIR '/app'

# No need for volumes here as we are dealing with production app.

COPY package.json .
RUN npm config set strict-ssl false
RUN npm install 
COPY . .
RUN npm run build

# Using multi stepimage build and two different base images to server react app and nginx.
# Only copying build directory from stage builder above mentioned as alias. Destination is default for nginx. Please refer nginx docs.

FROM nginx
COPY --from=builder /app/build /usr/share/nginx/html

# use docker run -p 8080:80 <image-id> to run image generated.
# Here 80 is the default port on ehich nginx server starts.
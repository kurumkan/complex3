# tag the phase, everything below will refer to "builder" phase
FROM node:alpine as builder
WORKDIR '/app'
COPY ./package.json ./
RUN npm install
COPY . .
RUN npm run build

# new phase
FROM nginx
EXPOSE 3000
# overwriting default conf
COPY ./nginx/default.conf /etc/nginx/conf.d/default.conf
# copying production build assets
COPY --from=builder /app/build /usr/share/nginx/html

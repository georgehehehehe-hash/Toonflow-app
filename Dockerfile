FROM node:24-bookworm-slim

WORKDIR /app

RUN npm config set registry https://registry.npmmirror.com/ && \
    yarn config set registry https://registry.npmmirror.com/

COPY . .

RUN node -e "const fs=require('fs');const pkg=JSON.parse(fs.readFileSync('package.json','utf8'));for(const section of ['dependencies','devDependencies']){if(!pkg[section]) continue;for(const name of ['custom-electron-titlebar','electron','electron-builder','electron-rebuild','electronmon']) delete pkg[section][name];}fs.writeFileSync('package.json', JSON.stringify(pkg, null, 2)+'\n');"

RUN yarn install --frozen-lockfile && \
    yarn cache clean

RUN yarn build

ENV NODE_ENV=prod
ENV HOST=0.0.0.0

EXPOSE 10588

CMD ["yarn", "start"]

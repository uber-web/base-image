FROM node:16.3.0-buster

RUN yarn global add yarn@1.19.1

# Add our xvfb script
RUN apt-get update && apt-get -y install jq libxi-dev libgl1-mesa-dev xvfb
ADD xvfb /etc/init.d/xvfb
RUN chmod a+x /etc/init.d/xvfb
ENV DISPLAY :99

# Install Chrome
RUN apt-get update && apt-get install -y wget --no-install-recommends \
  && wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
  && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
  && apt-get update \
  && apt-get install -y google-chrome-unstable \
  --no-install-recommends \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /src/*.deb \
  && npx node-gyp@4 install

# Install Firefox dependencies
RUN apt-get update && apt-get install -y libdbus-glib-1-2 libxt6 ffmpeg

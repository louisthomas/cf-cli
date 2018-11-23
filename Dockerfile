FROM emeraldsquad/alpine-scripting

ARG COMMIT="local-build"
ARG DATE="1970-01-01T00:00:00Z"
ARG URL="https://github.com/louisthomas/cf-cli"
ARG VERSION="dirty"

LABEL org.label-schema.schema-version="1.0" \
    org.label-schema.build-date=$DATE \
    org.label-schema.vendor="Louis-Thomas Lamontagne" \
    org.label-schema.name="ltlamontagne/cf-cli" \
    org.label-schema.description="Docker image with Cloud foundry CLI" \
    org.label-schema.version="$VERSION" \
    org.label-schema.vcs-url=$URL \
    org.label-schema.vcs-branch=$BRANCH \
    org.label-schema.vcs-ref=$COMMIT

ENV CF_CLI_VERSION=6.40.1
ENV PCF_SCHEDULER=scheduler-for-pcf-cliplugin-linux32-binary-1.1.0
ENV PCF_AUTOSCALER=autoscaler-for-pcf-cliplugin-linux32-binary-2.0.40

RUN wget -q -O - 'https://cli.run.pivotal.io/stable?release=linux64-binary&source=github&version='${CF_CLI_VERSION} \
        | tar -xzf - -C /usr/bin

ADD cf-plugins .

RUN cf install-plugin -f ${PCF_SCHEDULER} \
  && cf install-plugin -f ${PCF_AUTOSCALER} \
  && cf plugins \
  && rm -f ${PCF_SCHEDULER} \
  && rm -f ${PCF_AUTOSCALER}
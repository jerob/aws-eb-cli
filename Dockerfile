# Docker file to run AWS EB CLI tools
FROM alpine:3 AS compile-image

RUN apk --no-cache --update add \
        python3 \
        python3-dev \
        py3-pip \
        gcc \
        build-base \
        libffi-dev \
        groff \
        less \
        mailcap \
        openssl-dev

# if you install a package with pip’s --user option,
# all its files will be installed in the .local directory of the current user’s home directory.
# That means all the files will end up in a single place you can easily copy.
RUN pip install --user --upgrade pip \
        awscli \
        setuptools \
        colorama \
        wheel

RUN pip install --user awsebcli
# RUN apk -v --purge del py-pip && rm /var/cache/apk/*

FROM alpine:3 AS build-image

COPY --from=compile-image /root/.local /root/.local

RUN apk --no-cache --update add \
        python3 \
        py3-six \
        py3-urllib3

VOLUME /root/.aws
VOLUME /app

WORKDIR /app

ENV PATH=/root/.local/bin:$PATH

CMD ["eb"]

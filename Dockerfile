FROM alpine:3.7

### 2. Get Java via the package manager
RUN apk update \
&& apk upgrade \
&& apk add --no-cache bash \
&& apk add --no-cache --virtual=build-dependencies unzip \
&& apk add --no-cache curl \
&& apk add --no-cache openjdk8-jre

### 3. Get Python, PIP

RUN apk add --no-cache python3 \
&& python3 -m ensurepip \
&& pip3 install --upgrade pip setuptools \
&& rm -r /usr/lib/python*/ensurepip && \
if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
rm -r /root/.cache


ENV JAVA_HOME="/usr/lib/jvm/java-1.8-openjdk"

RUN pip install flask
RUN pip install gunicorn

WORKDIR /app

COPY templates /app/templates
COPY app.py /app

COPY asm-all-5.2.jar /app
COPY run.sh /app
RUN chmod +x /app/run.sh

EXPOSE 5000

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]
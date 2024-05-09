FROM alpine:3.7

### 2. Get Java via the package manager
RUN apk update \
&& apk upgrade \
&& apk add --no-cache bash \
&& apk add --no-cache --virtual=build-dependencies unzip \
&& apk add --no-cache curl \
&& apk add --no-cache openjdk8

### 3. Get Python, PIP

RUN apk add --no-cache python3 \
&& python3 -m ensurepip \
&& pip3 install --upgrade pip setuptools \
&& rm -r /usr/lib/python*/ensurepip && \
if [ ! -e /usr/bin/pip ]; then ln -s pip3 /usr/bin/pip ; fi && \
if [[ ! -e /usr/bin/python ]]; then ln -sf /usr/bin/python3 /usr/bin/python; fi && \
rm -r /root/.cache


ENV JAVA_HOME="/usr/lib/jvm/java-1.8-openjdk"
ENV PATH="$JAVA_HOME/bin:${PATH}"

RUN pip install flask
RUN pip install gunicorn

WORKDIR /app

COPY templates /app/templates
COPY jd-cli.jar /app
COPY app.py /app

RUN curl -O https://repo1.maven.org/maven2/org/ow2/asm/asm-all/5.2/asm-all-5.2.jar
COPY run.sh /app
RUN chmod +x run.sh

EXPOSE 5000

CMD ["gunicorn", "--bind", "0.0.0.0:5000", "app:app"]

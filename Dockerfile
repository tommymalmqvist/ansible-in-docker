FROM python:3.9.5-alpine3.13 as builder

ADD requirements.txt .

RUN apk add --update --no-cache  python3 python3-dev py-pip gcc g++ make libffi-dev openssl-dev cargo && \ 
    pip3 install --upgrade pip && \
    pip3 install -r requirements.txt && \
    apk del python3-dev gcc g++ make libffi-dev openssl-dev rust-stdlib cargo


FROM python:3-alpine
ENV ANSIBLE_HOST_KEY_CHECKING="False"
COPY --from=builder /root/.cache /root/.cache
COPY --from=builder requirements.txt .
RUN pip install -r requirements.txt && rm -rf /root/.cache
RUN apk add --update --no-cache git openssh-client
RUN mkdir /root/.ssh && chmod 700 /root/.ssh

WORKDIR /ansible

ENTRYPOINT [ "/ansible/run.sh" ]

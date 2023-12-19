FROM oraclelinux:7-slim as builder

RUN echo "proxy=http://www-proxy.us.oracle.com:80" >> /etc/yum.conf 

RUN set -eux; \
	yum install -y \
		gzip \
		tar \
	; \
	rm -rf /var/cache/yum

ENV LANG en_US.UTF-8

ENV JAVA_PKG=server-jre-8u251-linux-x64.tar.gz \
	JAVA_SHA256=af737e1315e2b211b88f24ee632d24c192e0b3a802625f367ae1b80a00fd4546 \
	JAVA_HOME=/usr/java/jdk-8

COPY $JAVA_PKG /tmp/jdk.tgz

RUN set -eux; \
	echo "$JAVA_SHA256 */tmp/jdk.tgz" | sha256sum -c -; \
	mkdir -p "$JAVA_HOME"; \
	tar --extract --file /tmp/jdk.tgz --directory "$JAVA_HOME" --strip-components 1; \
	rm /tmp/jdk.tgz 

COPY apacheds-2.0.0.AM26.tar.gz /tmp/apacheds.tgz

RUN set -eux; \
	mkdir -p "/tmp/apacheds"; \
	tar --extract --file /tmp/apacheds.tgz --directory "/tmp/apacheds" --strip-components 1; \ 
	rm /tmp/apacheds.tgz ; \
	mkdir -p "/tmp/apacheds/scripts"

FROM oraclelinux:7-slim

RUN echo "proxy=http://www-proxy.us.oracle.com:80" >> /etc/yum.conf

RUN set -eux; \
        yum install -y \
                openldap \
                openldap-clients \
		openldap-servers \
        ; \
        rm -rf /var/cache/yum

COPY --from=builder $JAVA_HOME $JAVA_HOME
COPY --from=builder "/tmp/apacheds" "/apacheds"
COPY scripts/* /apacheds/scripts/

ENV JAVA_VERSION=1.8.0_251 \
	JAVA_HOME=/usr/java/jdk-8 

ENV	PATH $JAVA_HOME/bin:$PATH

EXPOSE 10389

VERSION=1.0.0

default: build

build:
	./mvnw -DskipTests=true clean package

config:
	java -jar ./etc/jars/tscfg-0.8.0.jar --spec etc/config/config.conf --pn io.prometheus.common --cn ConfigVals --dd src/main/java/io/prometheus/common

clean:
	./mvnw -DskipTests=true clean

docker-build:
	docker build -f ./etc/docker/proxy.df -t=pambrose/prometheus-proxy:${VERSION} .
	docker build -f ./etc/docker/agent.df -t=pambrose/prometheus-agent:${VERSION} .

docker-push:
	docker push pambrose/prometheus-proxy:$VERSION
	docker push pambrose/prometheus-agent:$VERSION

build-coverage:
	./mvnw clean org.jacoco:jacoco-maven-plugin:prepare-agent package  jacoco:report

report-coverage:
	./mvnw -DrepoToken=${COVERALLS_TOKEN} clean package test jacoco:report coveralls:report

site:
	./mvnw site

tree:
	./mvnw dependency:tree

jarcheck:
	./mvnw versions:display-dependency-updates

plugincheck:
	./mvnw versions:display-plugin-updates

versioncheck: jarcheck plugincheck


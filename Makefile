JAR_VERSION = 2.0.21
JAR_URL = https://s3.amazonaws.com/athena-downloads/drivers/JDBC/SimbaAthenaJDBC-2.0.21.1000/AthenaJDBC42.jar # https://s3.amazonaws.com/athena-downloads/drivers/JDBC/SimbaAthenaJDBC_$(JAR_VERSION)/AthenaJDBC42_$(JAR_VERSION).jar

# Source: https://www.pgrs.net/2011/10/30/using-local-jars-with-leiningen/
download-jar:
	mkdir -p maven_repository/athena/athena-jdbc/$(JAR_VERSION)/
	cd maven_repository/athena/athena-jdbc/$(JAR_VERSION)/ \
		&& curl $(JAR_URL) --output athena-jdbc-${JAR_VERSION}.jar --silent --show-error --continue-at - \
		&& shasum athena-jdbc-$(JAR_VERSION).jar | cut -f "1" -d " " > athena-jdbc-$(JAR_VERSION).jar.sha1

build-custom-auth-jar:
	cd custom-auth && mvn clean install

build: download-jar build-custom-auth-jar
	DEBUG=1 LEIN_SNAPSHOTS_IN_RELEASE=true lein -U uberjar

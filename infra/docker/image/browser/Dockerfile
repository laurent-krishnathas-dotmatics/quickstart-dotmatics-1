FROM dotmatics-devops/tomcat:latest

WORKDIR $CATALINA_HOME

ENV BROWSER_PROP_FILE /config/browser.properties
ENV BROWSER_LICENSE_FILE /config/dotmatics.license.txt
ENV BROWSER_ZIP_FILE /config/browser-install*.zip

#HEALTHCHECK --interval=60s --timeout=60s --retries=4 CMD curl --fail http://127.0.0.1:8080/browser || exit 1
HEALTHCHECK --interval=1s --timeout=6s CMD goss -g /goss/healthcheck.yaml validate

COPY docker/image/browser/docker-entrypoint.bash /docker-entrypoint.bash
COPY docker/image/browser/goss /goss

CMD ["bash","-x","/docker-entrypoint.bash"]

#see https://medium.com/@aelsabbahy/docker-1-12-kubernetes-simplified-health-checks-and-container-ordering-with-goss-fa8debbe676c


FROM whf00gmk:5000/obdx_ohs/runit:1.0

MAINTAINER obdxdevops

COPY --chown=devops:devops Ohsimgdeploy.sh /home/devops/

WORKDIR /home/devops/obdx/

RUN sh +x /home/devops/Ohsimgdeploy.sh &&\
    chown -R devops:devops /home/devops/* &&\
    chown -R devops:devops /scratch/*

USER devops

ENTRYPOINT ["/home/devops/common_scripts/OHS_provision.sh"]

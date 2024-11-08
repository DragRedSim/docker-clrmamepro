FROM jlesage/baseimage-gui:ubuntu-24.04-v4
LABEL Name=docker-clrmamepro Version=0.0.1

RUN set -x && \
    add-pkg \
    ca-certificates \
    curl \
    p7zip-full \
    p7zip-rar \
    unzip \
    wine64 \
    zip
    #winbind
    # Find latest clrmamepro
ENV APP_VERSION=$( \
    curl https://mamedev.emulab.it/clrmamepro/ | \
    sed -n 's/.*href="\([^"]*\).*/\1/p' | \
    grep -i binaries | \
    grep -i cmp | \
    grep -i _64.zip | \
    sort -r | \
    head -1 \
    )
    # Document version
RUN echo $(basename --suffix=.zip $APP_VERSION | cut -d "_" -f 1) >> /VERSIONS && \
    # Install clrmamepro
    mkdir -p /opt/clrmamepro && \
    curl -o /tmp/cmp.zip "https://mamedev.emulab.it/clrmamepro/$APP_VERSION" && \
    unzip /tmp/cmp.zip -d /opt/clrmamepro/ 
    # Allow window decorations
    # Modifies the template which is implemented by cont-init.d/10-openbox.sh; is there a better way to modify this?
    #Added a "match" file at /etc/openbox/main-window-selection.xml to never match and maximise a window.
#RUN sed-patch '/<decor>no<\/decor>/d' /opt/base/etc/openbox/rc.xml.template
    # Clean up
RUN del-pkg curl

RUN apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/* /tmp/*

COPY rootfs/ /

RUN mkdir -p /config/clrmamepro && \
    mv -t /config/clrmamepro \
        /opt/clrmamepro/engine.cfg \
        /opt/clrmamepro/setformat.xml \
        /opt/clrmamepro/stats.ini \
        /opt/clrmamepro/urls.ini \
        /opt/clrmamepro/version64.ini \
        /opt/clrmamepro/whatsnew.txt \
        /opt/clrmamepro/backup \
        /opt/clrmamepro/buttons \
        /opt/clrmamepro/datfiles \
        /opt/clrmamepro/dir2dat \
        /opt/clrmamepro/downloads \
        /opt/clrmamepro/fastscans \
        /opt/clrmamepro/headers \
        /opt/clrmamepro/logs \
        /opt/clrmamepro/scans \
        /opt/clrmamepro/settings && \
    ln --symbolic -t /opt/clrmamepro \
        /config/clrmamepro/engine.cfg \
        /config/clrmamepro/setformat.xml \
        /config/clrmamepro/stats.ini \
        /config/clrmamepro/urls.ini \
        /config/clrmamepro/version64.ini \
        /config/clrmamepro/whatsnew.txt \
        /config/clrmamepro/backup \
        /config/clrmamepro/buttons \
        /config/clrmamepro/datfiles \
        /config/clrmamepro/dir2dat \
        /config/clrmamepro/downloads \
        /config/clrmamepro/fastscans \
        /config/clrmamepro/headers \
        /config/clrmamepro/logs \
        /config/clrmamepro/scans \
        /config/clrmamepro/settings 

ENV APP_NAME="CLRMamePro"
ENV DOCKER_IMAGE_VERSION=${IMAGE_VERSION}
VOLUME /config/clrmamepro
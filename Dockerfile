FROM jlesage/baseimage-gui:ubuntu-22.04-v4
LABEL Name=dockerclrmamepro Version=0.0.1

RUN set -x && \
    apt-get update && \
    add-pkg --virtual retrieve ca-certificates curl
RUN add-pkg \
    p7zip-full \
    p7zip-rar \
    unzip \
    wine64 \
    zip \
    winbind
    # Find latest clrmamepro
RUN CMP_LATEST_BINARY=$( \
    curl https://mamedev.emulab.it/clrmamepro/ | \
    sed -n 's/.*href="\([^"]*\).*/\1/p' | \
    grep -i binaries | \
    grep -i cmp | \
    grep -i _64.zip | \
    sort -r | \
    head -1 \
    ) && \
    # Document version
    echo $(basename --suffix=.zip $CMP_LATEST_BINARY | cut -d "_" -f 1) >> /VERSIONS && \
    # Install clrmamepro
    mkdir -p /opt/clrmamepro && \
    curl -o /tmp/cmp.zip "https://mamedev.emulab.it/clrmamepro/$CMP_LATEST_BINARY" && \
    unzip /tmp/cmp.zip -d /opt/clrmamepro/ 
    # Allow window decorations
    # Modifies the template which is implemented by cont-init.d/10-openbox.sh; is there a better way to modify this?
    #Added a "match" file at /etc/openbox/main-window-selection.xml to never match and maximise a window.
#RUN sed-patch '/<decor>no<\/decor>/d' /opt/base/etc/openbox/rc.xml.template
    # Clean up
RUN del-pkg retrieve

RUN apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/* /tmp/*

COPY startapp.sh /startapp.sh
COPY etc/ /etc/
COPY run_native_applications.reg /run_native_applications.reg

ENV APP_NAME="CLRMamePro"

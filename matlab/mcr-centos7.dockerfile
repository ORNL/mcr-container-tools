FROM centos:7

# Enable EPEL
RUN yum -y install epel-release 

# Install base tools
RUN yum -y install wget unzip

# Enable RPMFusion
RUN pushd `mktemp -d` && \
	wget -nv https://download1.rpmfusion.org/free/el/rpmfusion-free-release-7.noarch.rpm && \
	yum install -y rpmfusion-free-release-7.noarch.rpm
#	wget -nv https://download1.rpmfusion.org/nonfree/el/rpmfusion-nonfree-release-7.noarch.rpm && \
#	yum install -y rpmfusion-nonfree-release-7.noarch.rpm

ARG MCR_REL=R2016a
ARG MCR_VER=901
ARG MCR_DEPS='qt5-qtbase qt5-qtbase-gui qt5-qtsvg qt5-qtwebkit qt5-qtwebsockets qt5-qtx11extras libXcursor libXrandr libXt libXtst atk ffmpeg-compat GConf2 gtk2 python34-libs libsndfile'
RUN pushd `mktemp -d` && \
	wget -nv https://www.mathworks.com/supportfiles/downloads/${MCR_REL}/deployment_files/${MCR_REL}/installers/glnxa64/MCR_${MCR_REL}_glnxa64_installer.zip && \
	unzip MCR_${MCR_REL}_glnxa64_installer.zip && \
	chmod +x install && \
	./install -mode silent -agreeToLicense yes
RUN yum -y install ${MCR_DEPS}


# Do not add YUM commands after the cleanup line
RUN yum -y autoremove && yum -y clean all

# Setup user user
RUN useradd --create-home user

# Build environment variables
ENV MCR_ROOT=/usr/local/MATLAB/MATLAB_Runtime/v${MCR_VER}
ENV PATH=$PATH:${MCR_ROOT}/bin
ENV XAPPLRESDIR=${MCR_ROOT}/v${MCR_VER}/X11/app-defaults
ENV LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${MCR_ROOT}/runtime/glnxa64:${MCR_ROOT}/bin/glnxa64:${MCR_ROOT}/sys/os/glnxa64:${MCR_ROOT}/sys/opengl/lib/glnxa64


# Helper scripts
COPY uid_init.sh /usr/local/bin/
RUN chmod a+x /usr/local/bin/uid_init.sh


# Default user to root
ENV HOST_UID=0
ENV HOST_GID=0
WORKDIR /home/user
ENTRYPOINT ["/usr/local/bin/uid_init.sh"]

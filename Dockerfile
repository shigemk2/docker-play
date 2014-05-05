FROM centos
MAINTAINER shigemk2

ENV IP __IP__
ENV PW __PASSWORD__

RUN useradd play && echo "play:$PW" | chpasswd

RUN yum update -y
RUN yum install -y wget unzip tar

RUN wget http://rpms.famillecollet.com/enterprise/remi-release-6.rpm ;\
    wget http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm ;\
    wget http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm ;\
    rpm -ivh epel-release-6-8.noarch.rpm remi-release-6.rpm rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm
RUN yum --enablerepo=remi,epel install sudo openssh-server syslog monit java-1.7.0-openjdk java-1.7.0-openjdk-devel git -y

# play
ENV PLAY_VERSION 2.2.1
RUN wget http://downloads.typesafe.com/play/$PLAY_VERSION/play-$PLAY_VERSION.zip 

RUN unzip play-$PLAY_VERSION.zip -d /usr/local
RUN chown -R play.play /usr/local/play-$PLAY_VERSION 
RUN cd /usr/local/bin/ && ln -s /usr/local/play-$PLAY_VERSION/play

# play port
EXPOSE 9000 

# play debug port
EXPOSE 9999

# scala
ENV SCALA_VERSION 2.11.0
RUN wget http://downloads.typesafe.com/scala/$SCALA_VERSION/scala-$SCALA_VERSION.tgz
RUN tar xzvf scala-$SCALA_VERSION.tgz
RUN mv scala-$SCALA_VERSION /home/play/
RUN chown -R play.play /home/play/scala-$SCALA_VERSION

RUN echo "PATH=$PATH:/home/play/bin:/home/play/scala-$SCALA_VERSION/bin" >> /home/play/.bashrc
RUN source /home/play/.bashrc
RUN chown play.play /home/play/.bashrc

RUN echo 'play ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers.d/play

ADD monit.sshd /etc/monit.d/sshd
ADD monit.conf /etc/monit.conf
RUN chown -R root:root /etc/monit.d/ /etc/monit.conf
RUN chmod -R 600 /etc/monit.conf

RUN sed -ri "s/^UsePAM yes/#UsePAM yes/" /etc/ssh/sshd_config
RUN sed -ri "s/^#UsePAM no/UsePAM no/" /etc/ssh/sshd_config
RUN sed -ri "s/%%IPADDRESS%%/$IP/" /etc/monit.conf

RUN touch /etc/sysconfig/network

RUN mkdir -m 700 /root/.ssh
ADD authorized_keys /root/.ssh/authorized_keys
RUN chmod 600 /root/.ssh/authorized_keys && chown root:root /root/.ssh/authorized_keys


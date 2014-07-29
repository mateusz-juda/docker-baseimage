FROM phusion/baseimage:0.9.12
MAINTAINER Naftuli Tzvi Kay <rfkrocktk@gmail.com>

ENV LANG en_US.UTF-8
RUN locale-gen en_US.UTF-8

# Install init script to add SSH keys
ADD scripts/01_configure_authorized_keys.d.sh /etc/my_init.d/
ADD scripts/02_add_ssh_env_keys.sh /etc/my_init.d/
RUN chmod +x /etc/my_init.d/*.sh

# Install SSH daemon configuration
ADD conf/sshd/sshd_config /etc/ssh/sshd_config

# Use the runit init system.
CMD ["/sbin/my_init"]

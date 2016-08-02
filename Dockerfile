FROM phusion/baseimage:0.9.19
MAINTAINER Mateusz Juda <mateusz.juda@{gmail.com,ii.uj.edu.pl}>
# Based on rfkrocktk/baseimage

ENV LANG en_US.UTF-8
RUN locale-gen en_US.UTF-8

# Install init script to add SSH keys
ADD scripts/01_configure_authorized_keys.d.sh /etc/my_init.d/
ADD scripts/02_add_ssh_env_keys.sh /etc/my_init.d/
RUN chmod +x /etc/my_init.d/*.sh

# Install SSH daemon configuration
ADD conf/sshd/sshd_config /etc/ssh/sshd_config

RUN rm -f /etc/service/sshd/down

# Regenerate SSH host keys. baseimage-docker does not contain any, so you
# have to do that yourself. You may also comment out this instruction; the
# init system will auto-generate one during boot.
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh


# Use the runit init system.
CMD ["/sbin/my_init"]

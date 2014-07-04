FROM phusion/baseimage:0.9.11
MAINTAINER Naftuli Tzvi Kay <rfkrocktk@gmail.com>

ENV LANG en_US.UTF-8
RUN locale-gen en_US.UTF-8

# Enable public-key authentication/authorized keys file
RUN sed -i -e 's:^\#AuthorizedKeysFile.*$:AuthorizedKeysFile .ssh/authorized_keys:' \
    -e 's:^\#PubkeyAuthentication.*$:PubkeyAuthentication yes:' /etc/ssh/sshd_config

# Install init script to add SSH keys
ADD scripts/01_add_ssh_keys.sh /etc/my_init.d/
RUN chmod +x /etc/my_init.d/01_add_ssh_keys.sh

# Use the runit init system.
CMD ["/sbin/my_init"]

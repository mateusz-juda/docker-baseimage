docker-baseimage
================

Yet another [Docker](http://docker.io) base image to make it easier to connect to your
running Docker instances.

## With a Little Help from Phusion 

Based on Phusion's excellent [baseimage-docker](https://github.com/phusion/baseimage-docker),
this Docker base-image features all of the awesome features you've grown to love like
working CRON jobs, a SSH server, a lightweight working init system (that actually works!), 
and more.

## ...But Even Better 

Phusion's baseimage project is currently debating how best to allow users to connect
to running Docker instances. They provide the OpenSSH daemon but no real way to easily
add your own keys and connect once a Docker image has already been built.

In the interest of modularity, our Docker base-image provides two different ways to add
SSH keys to Docker instances _without any build-time tweaks_ and _without requiring external
tools like `nsenter`_. 

### Add SSH Keys with Environment Variables

The first option we provide is to specify SSH keys in an environment variable when starting
your Docker instance:

    sudo docker run -d -e SSH_KEYS="$(cat ~/.authorized_keys)" rfkrocktk/baseimage

On startup of the container, it will add each SSH key found in the `SSH_KEYS` 
environment variable to the `$HOME/.ssh/authorized_keys` file inside of the container. You'll
then be able to quickly and easily SSH into the Docker instance using your key. 

#### Supported Environment Variables

| Name | Required | Description |
| `SSH_KEYS` | No | A newline-delimited list of SSH keys in the `authorized_keys` file format. |
| `SSH_USER` | No (Defaults to `root`) | The user to set the SSH keys for, generally `root`. |

### Add SSH Keys with a Docker Volume 

This is an even easier way to maintain a Docker instance's `authorized_keys` file. In our base-image,
we've created a directory for each user called `$HOME/.ssh/authorized_keys.d/` which contains the `authorized_keys` file which is then symlinked back to `$HOME/.ssh/authorized_keys`. What this means
is that you can easily maintain the `authorized_keys` file _outside_ of the Docker instance by using 
a Docker volume:

    sudo docker run -d --name "dockerduck" -v /host/path/to/dockerduck-ssh-keys:/root/.ssh/authorized_keys.d \
        rfkrocktk/baseimage

Now, simply open `/host/path/to/dockerduck-ssh-keys/authorized_keys` and add your SSH public keys there:

    sudo cat ~/.ssh/authorized_keys > /host/path/to/dockerduck-ssh-keys/authorized_keys

Done! Now just connect to your Docker instance! 

Note: environment variables will _always_ overwrite `$HOME/.ssh/authorized_keys`, so don't mix and match. Use one or the other, not both.

## Connecting to Your Docker Instance

Now that you've added your keys to your Docker instance, you need to know its internal IP address to 
connect to it. You can use the following command to see your Docker instance IP addresses:

    sudo docker inspect -f "{{.NetworkSettings.IPAddress}}" dockerduck

In my case, the IP address is `172.17.0.31`, therefore:

    ssh root@172.17.0.31

Note, you probably have to enable agent-forwarding if you're connecting to a Docker instance 
hosted on a remote server, as your agent only runs on your local machine and is terminated on
your first hop. 
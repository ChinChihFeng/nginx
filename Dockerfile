FROM centos:7.5.1804

LABEL Component="nginx" \ 
      Name="customized nginx"

# Install packages before running script
RUN yum -y install epel-release ansible && \
    yum -y install git iproute sudo vim net-tools screen man && \
    yum -y update; yum clean all

# Disable requiretty
RUN sed -i -e 's/^\(Defaults\s*requiretty\)/#--- \1/'  /etc/sudoers

# Install Ansible and inventory file
RUN echo -e '[local]\nlocalhost ansible_connection=local' > /etc/ansible/hosts

# Start to compile nginx by Ansible
RUN git clone -b develop https://github.com/ChinChihFeng/nginx.git /etc/ansible/roles/nginx; \
    ansible-playbook /etc/ansible/roles/nginx/tests/test.yml --syntax-check; \
    ansible all -m setup -i /etc/ansible/roles/nginx/tests/inventory; \
    ansible-playbook /etc/ansible/roles/nginx/tests/test.yml

RUN ln -s /usr/local/nginx/conf.d/example.conf /usr/local/nginx/sites-enabled

RUN ln -sf /dev/stdout /usr/local/nginx/logs/access.log \
	&& ln -sf /dev/stderr /usr/local/nginx/logs/error.log

EXPOSE 80

STOPSIGNAL SIGTERM

CMD ["/usr/local/nginx/nginx", "-g", "daemon off;"]

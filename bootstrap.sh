echo -e "\nPurge man-db..." \
        "\n===============================================================================\n"
apt-get -y purge man-db

echo -e "\nUpdating package list..." \
        "\n===============================================================================\n"
apt-get update

echo -e "\nInstalling development dependencies, Ruby and essential tools..." \
        "\n===============================================================================\n"
apt-get -y install build-essential ruby1.9.1-dev libcurl4-openssl-dev libxml2-dev libxslt1-dev default-jre emacs23 vim curl git

echo -e "\nInstalling Rubygems..." \
        "\n===============================================================================\n"
apt-get -y install rubygems
gem install json --no-ri --no-rdoc

echo -e "\nInstalling and bootstrapping Chef..." \
        "\n===============================================================================\n"
test -d "/opt/chef" || curl -# -L http://www.opscode.com/chef/install.sh | sudo bash -s -- -v 11.6.0

mkdir -p /etc/chef/
mkdir -p /var/chef-solo/site-cookbooks
mkdir -p /var/chef-solo/cookbooks

if test -f ./tmp/solo.rb; then mv ./tmp/solo.rb /etc/chef/solo.rb; fi

echo -e "\nDownloading cookbooks..." \
        "\n===============================================================================\n"

test  -d /var/chef-solo/site-cookbooks/monit || git clone git://github.com/apsoto/monit.git /var/chef-solo/site-cookbooks/monit

test  -d /var/chef-solo/site-cookbooks/ark || git clone git://github.com/bryanwb/chef-ark.git /var/chef-solo/site-cookbooks/ark

test  -d /var/chef-solo/site-cookbooks/apt || git clone git://github.com/opscode-cookbooks/apt.git /var/chef-solo/site-cookbooks/apt

test  -d /var/chef-solo/cookbooks/elasticsearch || git clone git://github.com/octoly/cookbook-elasticsearch.git /var/chef-solo/cookbooks/elasticsearch


echo -e "\n*******************************************************************************\n" \
        "Bootstrap finished" \
        "\n*******************************************************************************\n"

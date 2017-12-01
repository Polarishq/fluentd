#!/bin/bash
# ${copyright}
# ------------------------------------------------------------------------------
# # Install collectd 5.7.0 and some dependencies for plugins used in collectd.conf
# Run this script as root

if [ -n "$SPLUNK_URL" ]; then
    splunk_url=$SPLUNK_URL
fi

if [ -n "$HEC_PORT" ]; then
    hec_port=$HEC_PORT
fi

if [ -n "$HEC_TOKEN" ]; then
    hec_token=$HEC_TOKEN
fi

if [ -n "$DIMENSIONS" ]; then
    dimension=$DIMENSIONS
fi

if [ ! $splunk_url ] || [ ! $hec_port ] || [ ! $hec_token ]; then
    printf "\033[31mMissing required arguments - SPLUNK_URL, HEC_PORT and HEC_TOKEN.\033[0m\n"
    exit 1;
fi

KNOWN_DISTRIBUTION="(Debian|Ubuntu|RedHat|CentOS)"
DISTRIBUTION=$(lsb_release -d 2>/dev/null | grep -Eo $KNOWN_DISTRIBUTION)

# Detect OS / Distribution
if [ -f /etc/debian_version -o "$DISTRIBUTION" == "Debian" -o "$DISTRIBUTION" == "Ubuntu" ]; then
    OS="Debian"
elif [ -f /etc/redhat-release -o "$DISTRIBUTION" == "RedHat" -o "$DISTRIBUTION" == "CentOS" ]; then
    OS="RedHat"
elif [[ -f /etc/os-release && $(grep "^NAME" /etc/os-release | grep -Eo '".*"' | tr -d \") == "Amazon Linux AMI" ]]; then
    OS="EC2"
else
    OS=$(uname -s)
fi

# Detect root user
if [ $(echo "$UID") = "0" ]; then
    _sudo=''
else
    _sudo='sudo'
fi

# Get dimension list
if [ -n "$dimension" ]; then
    IFS=',' read -a dimensions <<< "$dimension"
fi

function configure {
  echo -e "\033[32m\nStep:Configure agent...\n\033[0m"
  if [ $OS = "Darwin" ]; then
    update_conf_darwin
  else
    # configure requests module
    $_sudo tar -xzf requests-2.14.2.tar.gz
    $_sudo cp -rf requests-2.14.2/requests ./splunk/
    $_sudo rm -rf requests-2.14.2*
    update_conf
  fi
  # configure collectd
  $_sudo mkdir -p /etc/collectd/
  $_sudo cp -rf splunk /etc/collectd/
  # copy collectd.conf to collectd default configuration file location
  if [ $OS = "RedHat" -o $OS = "EC2" ]; then
    $_sudo cp collectd.conf /etc/
  elif [ $OS = "Darwin" ]; then
    collectd_version=$(brew info collectd | grep "collectd: " | grep -Eo "\d+(\.\d+)+")
    $_sudo cp collectd.conf /usr/local/Cellar/collectd/$collectd_version/etc/
  else
    $_sudo cp collectd.conf /etc/collectd/
  fi
  if [ $OS = "Darwin" ]; then
    $_sudo brew services restart collectd
  else
    $_sudo service collectd restart
  fi

}


function update_conf {
    # Add custom plugin to collectd.conf
    echo -e "##############################################################################" >> collectd.conf
    echo -e "# Customization for Splunk                                                   #" >> collectd.conf
    echo -e "#----------------------------------------------------------------------------#" >> collectd.conf
    echo -e "# This plugin sends all metrics data from other plugins to Splunk via HEC.   #" >> collectd.conf
    echo -e "##############################################################################" >> collectd.conf
    echo -e "\n<Plugin python>" >> collectd.conf
    echo -e "    ModulePath \"/etc/collectd/splunk\"" >> collectd.conf
    echo -e "    LogTraces true" >> collectd.conf
    echo -e "    Import \"write_splunk_hec\"" >> collectd.conf
    echo -e "    <Module write_splunk_hec>" >> collectd.conf
    echo -e "           Server \"$splunk_url\"" >> collectd.conf
    echo -e "           Port \"$hec_port\"" >> collectd.conf
    echo -e "           Token \"$hec_token\"" >> collectd.conf
    echo -e "           SSL True" >> collectd.conf
    echo -e "           VerifySSL False" >> collectd.conf
    for i in "${dimensions[@]}"
    do
        echo -e "           Dimension \"$i\"" >> collectd.conf
    done
    echo -e "    </Module>" >> collectd.conf
    echo -e "</Plugin>" >> collectd.conf
}

function update_conf_darwin {
    # Add custom plugin to collectd.conf
    echo -e "##############################################################################" >> collectd.conf
    echo -e "# Customization for Splunk                                                   #" >> collectd.conf
    echo -e "#----------------------------------------------------------------------------#" >> collectd.conf
    echo -e "# This plugin sends all metrics data from other plugins to Splunk via HEC.   #" >> collectd.conf
    echo -e "##############################################################################" >> collectd.conf
    echo -e "\n<Plugin python>" >> collectd.conf
    echo -e "    ModulePath \"/etc/collectd/splunk\"" >> collectd.conf
    echo -e "    LogTraces true" >> collectd.conf
    echo -e "    Import \"write_splunk_hec\"" >> collectd.conf
    echo -e "    <Module write_splunk_hec>" >> collectd.conf
    echo -e "           Server \"$splunk_url\"" >> collectd.conf
    echo -e "           Port \"$hec_port\"" >> collectd.conf
    echo -e "           Token \"$hec_token\"" >> collectd.conf
    echo -e "           SSL True" >> collectd.conf
    echo -e "           VerifySSL False" >> collectd.conf
    echo -e "           BatchSize 50" >> collectd.conf
    for i in "${dimensions[@]}"
    do
        echo -e "           Dimension \"$i\"" >> collectd.conf
    done
    echo -e "    </Module>" >> collectd.conf
    echo -e "</Plugin>" >> collectd.conf
    # Turn off FQDNLookup
    sed -i '' 's/#FQDNLookup   true/FQDNLookup   false/g' collectd.conf
}

function download_deps {
    echo -e "\033[32m\nStep:Downloading dependencies...\n\033[0m"
    if ! hash wget 2>/dev/null; then
      $_sudo apt-get install wget
    fi

    $_sudo wget --no-check-certificate --content-disposition https://github.com/kennethreitz/requests/archive/v2.14.2.tar.gz
}

function install_collectd_debian {
    # Download dependency
    download_deps
    echo -e "\033[32m\nStep:Installing collectd on Debian...\n\033[0m"
    # Enforce apt-get to install collected-5.7.*
    if ! grep -Fxq "deb http://pkg.ci.collectd.org/deb trusty collectd-5.7" /etc/apt/sources.list; then
        echo "deb http://pkg.ci.collectd.org/deb trusty collectd-5.7" >> /etc/apt/sources.list
        $_sudo apt-get update
    fi

    if which collectd &> /dev/null; then
        $_sudo service collectd stop
        $_sudo apt-get --yes --allow-unauthenticated upgrade collectd

        # Backup
        $_sudo mv /etc/collectd/collectd.conf "/etc/collectd/collectd.conf.old.$(date +'%Y%m%d-%H%M%S')"
    else
        # Install collectd
        $_sudo apt-get --yes --allow-unauthenticated install collectd

        # Install missing dependencies
        echo -e "\033[32m\nInstalling any missing dependency...\n\033[0m"
        $_sudo apt-get -f install
    fi
}

function install_collectd_redhat {
    RHEL_7_VERSION="^3.10.0(.)+"
    RHEL_6_VERSION="^2.6.32(.)+"
    # Download dependency
    download_deps
    echo -e "\033[32m\nStep:Installing collectd on Redhat...\n\033[0m"
    is_rhel_6=$(uname -r | grep -Eo "$RHEL_6_VERSION")
    is_rhel_7=$(uname -r | grep -Eo "$RHEL_7_VERSION")
    if [ "$is_rhel_6" ]; then
        # This install statement is taken from https://aws.amazon.com/premiumsupport/knowledge-center/ec2-enable-epel/
        $_sudo yum install –y https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm
    elif [ "$is_rhel_7" ]; then
        $_sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
    else
        $_sudo yum install epel-release
    fi

    # Install any missing dependency packages
    deps_pkg_arr=("$@")
    if [ ${#deps_pkg[@]} > 0 ]; then
      for i in "${deps_pkg_arr[@]}";
        do
            if ! yum list installed | grep $i &> /dev/null; then
              $_sudo yum -y install $i
            fi
        done
    fi

    if which collectd &> /dev/null; then
        $_sudo service collectd stop
        $_sudo yum update -y collectd

        # Backup
        $_sudo mv /etc/collectd/collectd.conf "/etc/collectd/collectd.conf.old.$(date +'%Y%m%d-%H%M%S')"
    else
        # Install collectd
        $_sudo yum -y --enablerepo=epel install collectd
    fi

}

function install_collectd_darwin {
    echo -e "\033[32m\nStep:Installing collectd on Darwin...\n\033[0m"
    current_working_dir=$(pwd)
    # Check if brew is installed
    which -s brew
    if [[ $? != 0 ]] ; then
      echo "\033[32m\nHomebrew is not installed. Start installing now...\n\033[0m"
      # Use alternative way to install homebrew to avoid dependency on CLT for Xcode.
      # And it's recommended to install homebrew in /usr/local directory
      # https://docs.brew.sh/Installation.html
      cd /usr/local
      $_sudo mkdir homebrew && curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C homebrew
    fi
    cd $current_working_dir
    # Check collectd version on homebrew
    current_version_on_brew=$(brew info collectd | grep "collectd: " | grep -Eo "\d+(\.\d+)+")
    required_version="5.7.0"
    if [ "$(printf "$required_version\n$current_version_on_brew" | sort | head -n1)" == "$current_version_on_brew" ] && [ "$current_version_on_brew" != "$required_version"]; then
      echo "\033[32m\nHomebrew formula: collectd version not met required version: 5.7.0. Updating brew...\n\033[0m"
      brew update
    fi
    # Check if collectd is installed
    if brew ls --versions collectd > /dev/null; then
        # Check if installed version meets requirements
        installed_version=$(brew ls --versions collectd | grep -Eo "\d+(\.\d+)+")
        if [ "$(printf "$required_version\n$installed_version" | sort | head -n1)" == "$installed_version" ] && [ "$installed_version" != "$required_version"]; then
          echo "\033[32m\n Old version of collectd detected. Upgrading to latest version...\n\033[0m"
          # Upgrade to latest version
          $_sudo brew services stop collectd
          brew upgrade collectd
        else
          # Backup
          $_sudo mv /usr/local/Cellar/collectd/$current_version_on_brew/etc/collectd.conf "/usr/local/Cellar/collectd/$current_version_on_brew/etc/collectd.conf.old.$(date +'%Y%m%d-%H%M%S')"
        fi
    else
        # Install collectd
        brew install collectd
    fi
}

if [ $OS = "Debian" ]; then
    echo -e "\033[32m\nInstalling Agents on Debian\n\033[0m"
    install_collectd_debian
    configure

elif [ $OS = "RedHat" ]; then
    echo -e "\033[32m\nInstalling Agents on RedHat\n\033[0m"
    install_collectd_redhat
    configure

elif [ $OS = "Darwin" ]; then
    echo -e "\033[32m\nInstalling Agents on Darwin\n\033[0m"
    install_collectd_darwin
    configure
elif [ $OS = "EC2" ]; then
    echo -e "\033[32m\nInstalling Agents on EC2 instance\n\033[0m"
    deps_pkg=("collectd-disk" "collectd-python")
    install_collectd_redhat "${deps_pkg[@]}"
    configure
else
    echo -e "\033[31m\nNot supported operating system: $OS. Nothing is installed.\n\033[0m"
fi

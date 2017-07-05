#!/bin/sh
# Author:wangxiaolei 王小雷
# Blog: http://blog.csdn.net/dream_an
# Github: https://github.com/wangxiaoleiai
# Date: 20170630
# Path: /whaleai/whale-bigdata/init.sh
# Organization: https://github.com/whaleai


# Basic environment variables.  Edit as necessary

HADOOP_VERSION=3.0.0
# HADOOP_HOME="/opt/hadoop-${HADOOP_VERSION}"
# NN_DATA_DIR=/var/data/hadoop/hdfs/nn
# SNN_DATA_DIR=/var/data/hadoop/hdfs/snn
# DN_DATA_DIR=/var/data/hadoop/hdfs/dn
# YARN_LOG_DIR=/var/log/hadoop/yarn
# HADOOP_LOG_DIR=/var/log/hadoop/hdfs
# HADOOP_MAPRED_LOG_DIR=/var/log/hadoop/mapred
# YARN_PID_DIR=/var/run/hadoop/yarn
# HADOOP_PID_DIR=/var/run/hadoop/hdfs
# HADOOP_MAPRED_PID_DIR=/var/run/hadoop/mapred
# HTTP_STATIC_USER=hdfs
# YARN_PROXY_PORT=8081
echo "测试"
JAVA_HOME=/opt/jdk1.8.0_131


install()
{
python - <<END
print ("hello")
END

create_config()
{
	local filename=

        case $1 in
            '')    echo $"$0: Usage: create_config --file"
                   return 1;;
            --file)
	           filename=$2
	           ;;
        esac

	python - <<END
from xml.etree import ElementTree
from xml.etree.ElementTree import Element
conf = Element('configuration')
conf_file = open("$filename",'w')
conf_file.write(ElementTree.tostring(conf))
conf_file.close()
END
	write_file $filename
  echo "write_file 成功"
}

put_config()
{
	local filename= property= value=

        while [ "$1" != "" ]; do
        case $1 in
            '')    echo $"$0: Usage: put_config --file --property --value"
                   return 1;;
            --file)
                   filename=$2
                   shift 2
                   ;;
            --property)
                   property=$2
                   shift 2
                   ;;
            --value)
                   value=$2
                   shift 2
                   ;;
        esac
        done

	python - <<END
from xml.etree import ElementTree
from xml.etree.ElementTree import Element
from xml.etree.ElementTree import SubElement
def putconfig(root, name, value):
	for existing_prop in root.getchildren():
		if existing_prop.find('name').text == name:
			root.remove(existing_prop)
			break

	property = SubElement(root, 'property')
	name_elem = SubElement(property, 'name')
	name_elem.text = name
	value_elem = SubElement(property, 'value')
	value_elem.text = value
path = ''
if "$installed" == 'true':
	path = "$HADOOP_CONF_DIR" + '/'
conf = ElementTree.parse(path + "$filename").getroot()
putconfig(root = conf, name = "$property", value = "$value")
conf_file = open("$filename",'w')
conf_file.write(ElementTree.tostring(conf))
conf_file.close()
END

	write_file $filename
}

write_file()
{
	local file=$1

	xmllint --format "$file" > "$file".pp && mv "$file".pp "$file"
  echo "转换成功"
}


create_config --file core-site.xml
create_config --file core-site1.xml

put_config --file core-site1.xml --property dfs.namenode.name.dir --value "ce"

echo "安装install"

installed=false
echo "installed"

  if [ -f /etc/profile.d/hadoop.sh ]; then
      source /etc/profile.d/hadoop.sh
      source $HADOOP_HOME/etc/hadoop/hadoop-env.sh
      installed=true
  fi
echo $installed

Author="#!/bin/sh
# Author:wangxiaolei 王小雷
# Blog: http://blog.csdn.net/dream_an
# Github: https://github.com/wangxiaoleiai
# Date: 20170729
# Path: /etc/profile.d/
# Organization: https://github.com/whaleai
"
#Configuring Environment of Hadoop Daemons
HadoopEnv="
export HADOOP_HOME=/opt/hadoop-$HADOOP_VERSION
export PATH=\$HADOOP_HOME/bin:\$PATH
export HADOOP_CONF_DIR=\$HADOOP_HOME/etc/hadoop
export YARN_CONF_DIR=\$HADOOP_HOME/etc/hadoop
"
echo "${Author} ${HadoopProfile}" > hadoop-3.0.0.sh
echo "hadoop3完成"

}
echo "玩"

file()
{
	echo "file 玩"
}

help()
{
cat << EOF
install-hadoop2.sh

This script installs Hadoop 3 with basic data, log, and pid directories.

USAGE:  install-hadoop3.sh [options]

OPTIONS:
   -i, --install      		Hadoop3伪分布式安装

   -r, --remove           Hadoop3卸载

   -h, --help             Show this message.

EXAMPLES:
   hadoop3 install:
		 install-hadoop2.sh -i
		 或者
		 install-hadoop2.sh --install

   hadoop3 remove:
		 whaleai-hadoop３.sh -r
		 或者
		 install-hadoop3.sh --remove

EOF
}

while true;
do
  case "$1" in

    -i|--install)
      install
			break
      ;;
    -r|--uninstall)
      uninstall
			break
      ;;
    *)
			help
      break
      ;;
  esac
done
echo "wan "

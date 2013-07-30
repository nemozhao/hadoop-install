echo "format namenode"

rm -rf /hadoop/dfs/name /hadoop/dfs/data /hadoop/dfs/namesecondary

mkdir -p /hadoop/dfs/name
chown -R hdfs:hdfs /hadoop/dfs/name
chmod 700 /hadoop/dfs/name

mkdir -p /hadoop/dfs/data
chown -R hdfs:hdfs /hadoop/dfs/data
chmod 700 /hadoop/dfs/data

mkdir -p /hadoop/dfs/namesecondary
chown -R hdfs:hdfs /hadoop/dfs/namesecondary
chmod 700 /hadoop/dfs/namesecondary

sh start.sh stop
rm -rf /hadoop/dfs/name/current
su -s /bin/bash hdfs -c 'yes Y | hadoop namenode -format >> /tmp/nn.format.log 2>&1'

service hadoop-hdfs-namenode start

sleep 5

su -s /bin/bash hdfs -c "hadoop fs -chmod a+rw /"
while read dir user group perm
do
   su -s /bin/bash hdfs -c "hadoop fs -mkdir $dir && hadoop fs -chmod $perm $dir && hadoop fs -chown $user:$group $dir"
     echo "[IM_CONFIG_INFO]: ."
done << EOF
/tmp hdfs hadoop 1777 
/user hdfs hadoop 777
/user/history yarn hadoop 1777
/user/history/done yarn hadoop 777
/user/root root hadoop 755
/user/hive hive hadoop 755 
/user/hive/warehouse hive hadoop 777
/yarn yarn mapred 755
EOF

echo "start hadoop"
sh start.sh start


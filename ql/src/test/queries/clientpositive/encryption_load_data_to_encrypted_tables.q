DROP TABLE IF EXISTS encrypted_table;

CREATE TABLE encrypted_table (key STRING, value STRING) LOCATION '${hiveconf:hive.metastore.warehouse.dir}/encrypted_table';

-- Create encryption key and zone;
crypto create_key --keyName key1;
crypto create_zone --keyName key1 --path ${hiveconf:hive.metastore.warehouse.dir}/encrypted_table;

-- Test loading data from the local filesystem;
LOAD DATA LOCAL INPATH '../../data/files/kv1.txt' OVERWRITE INTO TABLE encrypted_table;
SELECT * FROM encrypted_table;

-- Test loading data from the hdfs filesystem;
dfs -copyFromLocal ../../data/files/kv1.txt hdfs:///tmp/kv1.txt;
LOAD DATA INPATH '/tmp/kv1.txt' OVERWRITE INTO TABLE encrypted_table;
SELECT * FROM encrypted_table;

DROP TABLE encrypted_table;

crypto delete_key --keyName key1;
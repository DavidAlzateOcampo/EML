import tensorflow as tf
from tensorflow.examples.tutorials.mnist import input_data

def _float_feature(value):
        return tf.train.Feature(float_list=tf.train.FloatList(value=value))

from hdbcli import dbapi

conn = dbapi.connect(address='0.0.0.0',databasename='HXE',port=39013,user='EMLUSER',password='...')

cursor = conn.cursor()
cursor.execute('CREATE TABLE "MNIST" ("Label" INTEGER, "Image" BLOB)')
cursor.close()
conn.commit()

mnist = input_data.read_data_sets("/tmp/MNIST/", one_hot=False)
for i in range(5):
	features = mnist.test.images[i]
	example = tf.train.Example(
		features = tf.train.Features(
			feature = {'x': _float_feature(features),
	}))
	sql = 'INSERT INTO "MNIST" ("Label","Image") VALUES (?,?)'
	cursor = conn.cursor()
	cursor.execute(sql, (int(mnist.test.labels[i]), example.SerializeToString()))
	cursor.close()
	conn.commit()

conn.close()

# -*- coding: utf-8 -*-
import os, sys
import tensorflow as tf
from tensorflow.python.platform import gfile
import random
import numpy as np

os.environ['TF_CPP_MIN_LOG_LEVEL'] = '2'

# change this as you see fit
#image_path = sys.argv[1]

# Read in the image_data

#image_data = tf.gfile.FastGFile('example/44_2.jpg', 'rb').read()

# Loads label file, strips off carriage return
label_lines = [line.rstrip() for line 
                   in tf.gfile.GFile("tmp/output_labels.txt")]
example_dir='example/'    #用训练集以外的数据预测
train_dir='rockdata/20'   #用训练集中的数据预测
final_test='final_test/48'
def get_examples(sess,rootdir):
    examples_files=[]
    example_image_data=[]
    for parent,dirnames,filenames in os.walk(rootdir):
        for filename in filenames:
            examples_files.append(os.path.join(parent,filename))
  
    for i in range(len(examples_files)):
        with gfile.FastGFile(examples_files[i], 'rb') as ff:
            example_image_data.append(ff.read())
    return example_image_data
    
# Unpersists graph from file
with tf.gfile.FastGFile("tmp/output_graph.pb", 'rb') as f:
    graph_def = tf.GraphDef()
    graph_def.ParseFromString(f.read())
    tf.import_graph_def(graph_def, name='')

with tf.Session() as sess:
    print('================================================================')
    # Feed the image_data as input to the graph and get first prediction
    softmax_tensor = sess.graph.get_tensor_by_name('final_result:0')
    train_image_data=get_examples(sess,example_dir)
    finalscores=[]
    finalscores_with_bias=[]
    for times in range(10):
        example_image_data=[]
        for ones in range(12):
            tmp_image_data=train_image_data[random.randint(0,len(train_image_data)-1)]           
            example_image_data.append(tmp_image_data)
            
        finalscore=0
        for i in range(len(example_image_data)):
         #   print('第',i+1,'张')
            result=0
            predictions = sess.run(softmax_tensor, \
                     {'DecodeJpeg/contents:0': example_image_data[i]})
     
            # Sort to show labels of first prediction in order of confidence
            top_k = predictions[0].argsort()[-len(predictions[0]):][::-1]
    
            for node_id in top_k:
                human_string = label_lines[node_id]
                score = predictions[0][node_id]
           #     print('%s (score = %.5f)' % (human_string, score))
                result=result+int(human_string)*score
        #    print('====预测值',i+1,'：',result)
            finalscore=finalscore+result
        finalscore=finalscore/len(example_image_data)
        
        print('=================','平均预测值：',round(finalscore,2),', ',end='')
        finalscores.append(finalscore)
        
        bias=-4.751*(10**-5)*finalscore**3+0.00872*finalscore**2-0.432*finalscore+5.257
        finalscores_with_bias.append(finalscore+bias)
        print('修正预测值：',round(finalscore+bias,2),'=================')
    print('=================finalscore:',round(np.average(np.array(finalscore)),2),', ',end='')
    print('finalscore+bias：',round(np.average(np.array(finalscores_with_bias)),2),'=================')
    print('=================std: ',round( np.std( np.array(finalscores_with_bias) ) ,2))

        

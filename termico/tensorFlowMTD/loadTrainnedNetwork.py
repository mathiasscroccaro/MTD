import os
import numpy as np
from skimage import data
import tensorflow as tf
import matplotlib.pyplot as plt
import random

# Evaluate the current working directory
ROOT_PATH = os.getcwd()

################################################################################

# Function that organize and catch the data from image database and classify them
def load_data(data_directory):
    directories = [d for d in os.listdir(data_directory)
                   if os.path.isdir(os.path.join(data_directory, d))]
    labels = []
    images = []
    for d in directories:
        label_directory = os.path.join(data_directory, d)
        file_names = [os.path.join(label_directory, f)
                      for f in os.listdir(label_directory)
                      if f.endswith(".ppm")]
        for f in file_names:
            images.append(data.imread(f))
            labels.append(int(d))
    return images, labels

################################################################################

# Initializing de session and importing the trainned model
sess = tf.Session()
saver = tf.train.import_meta_graph("modelo.meta")
saver.restore(sess,tf.train.latest_checkpoint("./"))

graph = tf.get_default_graph()

x = graph.get_tensor_by_name("x:0")
correct_pred = graph.get_tensor_by_name("prediction:0")

# Getting the testing image data
test_data_directory = os.path.join(ROOT_PATH, "Testing")
images, labels = load_data(test_data_directory)
images = np.array(images);

# Pick 14 random images
sample_indexes = random.sample(range(len(images)), 14)
sample_images = [images[i] for i in sample_indexes]
sample_labels = [labels[i] for i in sample_indexes]

# Run the "correct_pred" operation
predicted = sess.run([correct_pred], feed_dict={x: sample_images})[0]

# Print the real and predicted labels
print(sample_labels)
print(predicted)

# Display the predictions and the ground truth visually.
fig = plt.figure(figsize=(10, 10))
for i in range(len(sample_images)):
    truth = sample_labels[i]
    prediction = predicted[i]
    plt.subplot(2, 7,1+i)
    plt.axis('off')
    color='green' if truth == prediction else 'red'
    plt.text(40, 10, "Truth:        {0}\nPrediction: {1}".format(truth, prediction),
             fontsize=12, color=color)
    plt.imshow(sample_images[i],  cmap="gray")

plt.show()

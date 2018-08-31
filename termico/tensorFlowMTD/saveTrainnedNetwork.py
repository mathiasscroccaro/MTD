import os
import numpy as np
from skimage import data
import random
import tensorflow as tf
import pickle
import dill
import matplotlib.pyplot as plt


# Root directory where files are contained
ROOT_PATH = os.getcwd()
# Number of network outputs
NUMBER_OF_OUTPUTS = 62

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

# Loading training image data
train_data_directory = os.path.join(ROOT_PATH, "Training")
images, labels = load_data(train_data_directory)
images = np.array(images);

# Initialize placeholders
x = tf.placeholder(dtype = tf.float32, shape = [None, 60, 80],name="x")
y = tf.placeholder(dtype = tf.int32, shape = [None],name="y")

# Flatten the input data
images_flat = tf.contrib.layers.flatten(x)

# Fully connected layer
logits = tf.contrib.layers.fully_connected(images_flat, NUMBER_OF_OUTPUTS, tf.nn.relu)

# Define a loss function
loss = tf.reduce_mean(tf.nn.sparse_softmax_cross_entropy_with_logits(labels = y,
                                                                    logits = logits))
# Define an optimizer
train_op = tf.train.AdamOptimizer(learning_rate=0.001).minimize(loss)

# Convert logits to label indexes
correct_pred = tf.argmax(logits, 1,name="prediction")

# Define an accuracy metric
accuracy = tf.reduce_mean(tf.cast(correct_pred, tf.float32))

# Initializing TensorFlow session with a random number
tf.set_random_seed(1234)
sess = tf.Session()

# Initializing variables
sess.run(tf.global_variables_initializer())

# Training iterations
for i in range(201):
        print('EPOCH', i)
        _, accuracy_val = sess.run([train_op, accuracy], feed_dict={x: images, y: labels})
        if i % 10 == 0:
            print("Loss: ", loss)
        print('DONE WITH EPOCH')

saver = tf.train.Saver()
saver.save(sess, os.path.join(ROOT_PATH,"modelo"))

################################################################################
## Testing block for the trainned network
################################################################################

test_data_directory = os.path.join(ROOT_PATH, "Testing")
images, labels = load_data(test_data_directory)
images = np.array(images);

# Pick 10 random images
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

################################################################################

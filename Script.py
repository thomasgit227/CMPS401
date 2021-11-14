# _                         _
#| |                       | |
#| |__   __ _ _ __ ___  ___| |_ ___ _ __
#| '_ \ / _` | '_ ` _ \/ __| __/ _ \ '__|
#| | | | (_| | | | | | \__ \ ||  __/ |
#|_| |_|\__,_|_| |_| |_|___/\__\___|_|
#
#                     _          _      _
#                    | |        (_)    | |
# ___  __ _ _ __   __| |_      ___  ___| |__
#/ __|/ _` | '_ \ / _` \ \ /\ / / |/ __| '_ \
#\__ \ (_| | | | | (_| |\ V  V /| | (__| | | |
#|___/\__,_|_| |_|\__,_| \_/\_/ |_|\___|_| |_|



# import libraries to handle images + numpy for the math
#Get the VGG16 pretrained image classifier model with the imagenet weights
import numpy as np
import csv, os.path, re
from tensorflow.keras.preprocessing import image
from keras.applications.mobilenet_v2 import MobileNetV2
from keras.applications.mobilenet_v2 import preprocess_input
from keras.layers import Dense
from keras import Model
from skimage.transform import resize

def createModel():
    # Load the original model into the program
    model = MobileNetV2(weights="imagenet")

    #Create an array to hold our images for training
    data = np.empty( (120, 224, 224, 3) )

    for i in range(60):
        print('hamster/h' + str(i+1) + ".jpg")
        img_path = "hamster/h" + str(i+1) + ".jpg"
        im = image.load_img(img_path, color_mode = 'rgb', target_size = (224, 224, 1) )
        im = image.img_to_array(im)
        im.shape
        im = preprocess_input(im)
        im = resize( im, output_shape=(224, 224, 3 ) )
        data[i] = im

    for i in range(60):
        print('sandwich/s' + str(i+1) + ".jpg")
        img_path = "sandwich/s" + str(i+1) + ".jpg"
        im = image.load_img(img_path, color_mode = 'rgb', target_size = (224, 224, 1) )
        im = image.img_to_array(im)
        im.shape
        im = preprocess_input(im)
        im = resize( im, output_shape=(224, 224, 3 ) )
        data[i + 60] = im

    # Label our data
    labels = np.empty(120, dtype=int)
    labels[:60] = 0
    labels[60:] = 1

    # Adjust our default model to prepare it for retraining
    hamsam_output = Dense(2, activation = 'softmax')
    hamsam_output = hamsam_output(model.layers[-2].output)

    hamsam_input = model.input
    hamsam_model = Model(inputs = hamsam_input, outputs = hamsam_output)

    for layer in hamsam_model.layers[:-1]:
        layer.trainable = False

    # Compile the model
    hamsam_model.compile(
    loss = 'sparse_categorical_crossentropy',
    optimizer = 'adam',
    metrics = ['accuracy']
    )

    # Train the model for 20 epochs
    test_data = np.empty( (40, 224, 224, 3) )

    for i in range(20):
        print('hamsterValid/h' + str(i+1) + ".jpg" )
        img_path = "hamster/h" + str(i+1) + ".jpg"
        im = image.load_img(img_path, color_mode = 'rgb', target_size = (224, 224, 1) )
        im = image.img_to_array(im)
        im.shape
        im = preprocess_input(im)
        im = resize( im, output_shape=(224, 224 ) )
        test_data[i] = im

    for i in range(20):
        print( 'sandwichValid/s' + str(i+1) + ".jpg"  )
        img_path = "sandwich/s" + str(i+1) + ".jpg"
        im = image.load_img(img_path, color_mode = 'rgb', target_size = (224, 224, 1) )
        im = image.img_to_array(im)
        im.shape
        im = preprocess_input(im)
        im = resize( im, output_shape=(224, 224 ) )
        test_data[i + 20 ] = im

    test_labels = np.empty(40)
    test_labels[:20] = 0
    test_labels[20:] = 1

    hamsam_model.fit(
        x = data,
        y = labels,
        epochs = 20,
        verbose = 2,
        validation_data = (test_data, test_labels)
    )

    # Return our trained model
    return hamsam_model


# A function for classifying an image
# It requires a Model to be passed in, likely the return of createModel(),
# and the path of an image to be classified
def classify( Model, imagePath ):
    hamsam_test = np.empty( (1, 224, 224, 3) )

    im = image.load_img(imagePath, color_mode = 'rgb', target_size = (224, 224, 1) )
    im = image.img_to_array(im)
    im.shape
    im = preprocess_input(im)
    im = resize( im, output_shape=(224, 224, 3 ) )
    hamsam_test[0] = im

    predictions = Model.predict(hamsam_test)

    return predictions

#########################################################################################
#####################################   MAIN    #########################################
#####################################  PROGRAM  #########################################
#########################################################################################

imagePath = os.getcwd()
ourModel = createModel()

with open("results.csv", "w") as csvFile:
  csvOut = csv.writer(csvFile)
  csvOut.writerow(["Hamster", "Sandwich"])

  for entry in os.scandir(imagePath):
    printToCsv = []

    if entry.path.endswith(".jpg") and entry.is_file():
      fileName = re.search("[\w-]+\.jpg", os.path.join(entry)).group()
      results = classify(ourModel, fileName)

      # write results to csv
      printToCsv.append(results[0,0])
      printToCsv.append(results[0,1])
      csvOut.writerow(printToCsv)

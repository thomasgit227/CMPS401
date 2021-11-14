# import libraries to handle images + numpy for the math
#Get the VGG16 pretrained image classifier model with the imagenet weights
import numpy as np
from posixpath import dirname
import csv, os.path, re
from tensorflow.keras.preprocessing import image
from keras.applications.mobilenet_v2 import MobileNetV2
from keras.applications.mobilenet_v2 import preprocess_input
from keras.applications.mobilenet_v2 import decode_predictions
from keras.layers import Dense
from keras import Model
from skimage.transform import resize

def processImage(fileName):
  model = VGG16( weights = 'imagenet' )
  #print( model.summary() )

  img_path = model = VGG16( weights = 'imagenet' )
  print( model.summary() )

  img_path = fileName

  # load the image with color data and as a specific size then display it
  img = image.load_img(img_path, color_mode = 'rgb', target_size = (224, 224) )
  # maybe do a thing to print the current image????

  # Convert the image to a 3D numpy array, 1 dimension for width, 1 for height, 1 for color
  x = image.img_to_array(img)
  x.shape

  # Add a fourth dimension to the array to account for the number of images
  x = np.expand_dims(x, axis = 0 )

  x = preprocess_input(x)
  features = model.predict(x)
  results = decode_predictions(features)

  print(results)

  csvOpenMode = "a"
  if os.path.exists("results.csv"):
    csvOpenMode = "w"

  # CSV columns are "hamster" then "sandwich"
  with open("results.csv", csvOpenMode) as csvFile:
    csvOut = csv.writer(csvFile)

    for currImage in results:
      # this list will be written to the csv as a row on every loop
      imgList = []

      # append 'hamster' probability or 0
      for tup in currImage:
        if "hamster" in tup[1]:
          imgList.append(tup[2])

      if len(imgList) == 0:
        imgList.append(0.0)

      # append 'sandwich' probability or 0
      for tup in currImage:
        if "sandwich" in tup[1]:
          imgList.append(tup[2])

      if len(imgList) == 1:
        imgList.append(0.0)

      csvOut.writerow(imgList)

    # load the image with color data and as a specific size then display it
    img = image.load_img(img_path, color_mode = 'rgb', target_size = (224, 224) )

    # Convert the image to a 3D numpy array, 1 dimension for width, 1 for height, 1 for color
    x = image.img_to_array(img)
    x.shape

    # Add a fourth dimension to the array to account for the number of images
    x = np.expand_dims(x, axis = 0 )

    x = preprocess_input(x)
    features = model.predict(x)
    results = decode_predictions(features)

    with open("results.csv", "w") as csvFile:
      csvOut = csv.writer(csvFile)
      csvOut.writerow(["Hamster", "Sandwich"])

      for currImage in results:
        # this list will be written to the csv as a row on every loop
        imgList = []

        # append 'hamster' probability or 0
        for tup in currImage:
          if "hamster" in tup[1]:
            imgList.append(tup[2])

        if len(imgList) == 0:
          imgList.append(0.0)

        # append 'sandwich' probability or 0
        for tup in currImage:
          if "sandwich" in tup[1]:
            imgList.append(tup[2])

        if len(imgList) == 1:
          imgList.append(0.0)

        # write row for image
        csvOut.writerow(imgList)

def createModel():

    # Load the original model into the program
    model = MobileNetV2(weights="imagenet")

    #Create an array to hold our images for training
    data = np.empty( (120, 224, 224, 3) )

    for i in range(60):

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
# It requires a Model to be passed in, (likely the return of createModel(),
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



imagePath = os.getcwd()
ourModel = createModel()

for entry in os.scandir(imagePath):
  if entry.path.endswith(".jpg") and entry.is_file():
    fileName = re.search("[\w-]+\.jpg", os.path.join(entry)).group()
    results = classify(ourModel, fileName)
    print(results)
  elif entry.path.endswith(".png") and entry.is_file():
    fileName = re.search("[\w-]+\.png", os.path.join(entry)).group()
    results = classify(ourModel, fileName)
    print(results)

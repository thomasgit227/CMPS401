library(reticulate)
# # import libraries to handle images + numpy for the math
# #Get the VGG16 pretrained image classifier model with the imagenet weights
py_install(packages = c("numpy","pandas","tensorflow","keras","pillow"))
py_run_string('from keras.applications.vgg16 import VGG16')
py_run_string('from tensorflow.keras.preprocessing import image')
py_run_string('from tensorflow.keras.applications.vgg16 import preprocess_input,decode_predictions')
py_run_string('import pandas')

source_python("RunRTest.py")
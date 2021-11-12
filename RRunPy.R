library(reticulate)

#Import and Install Libraries via Python
py_install(packages = c("numpy","pandas","tensorflow","keras","seaborn", "seaborn"))
py_run_string('from keras.applications.vgg16 import VGG16')
py_run_string('from tensorflow.keras.preprocessing import image')
py_run_string('from tensorflow.keras.applications.vgg16 import preprocess_input,decode_predictions')
py_run_string('import pandas')
py_run_string('import csv')


#Run Python Script for Image Recognition
source_python("Script.py")
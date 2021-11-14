library(reticulate)
library(readxl)

#Import and Install Libraries via Python
py_install(packages = c("numpy","pandas","tensorflow","keras","seaborn","matplotlib"))
py_run_string('from posixpath import dirname')
py_run_string('import csv, os.path, re')
py_run_string('from tensorflow.keras.preprocessing import image')
py_run_string('from keras.applications.mobilenet_v2 import MobileNetV2')
py_run_string('from keras.applications.mobilenet_v2 import preprocess_input')
py_run_string('from keras.applications.mobilenet_v2 import decode_predictions')
py_run_string('from keras.layers import Dense')
py_run_string('from keras import Model')
py_run_string('from skimage.transform import resize')

#Run Python Script for Image Recognition
source_python("Script.py")

#Grab .xlsx Data
#data <- read_excel("")
#hamsterProb <- unlist(data[1])
#SandwichProb <- unlist(data[2])
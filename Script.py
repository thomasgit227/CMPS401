import numpy as np

def main():

    model = VGG16( weights = 'imagenet' )
    print( model.summary() )

    img_path = 'h1.jpg'

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
    

#This Makes it do the Thing - Thomas from the past
if __name__ == "__main__":
    main();
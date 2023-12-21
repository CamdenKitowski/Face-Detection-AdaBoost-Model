# Face-Detection + Sliding Window

## Overview
Built and trained face detection Adaboost model using Haar features described in the Viola-Jones Algorithm. Developed a sliding window classification approach to dected different face sizes using the already trained Adaboost model on each window. 


### Training + Testing
Built training and test set on cropped faces from entire images. Used face ellipse annotations of each face and converted each ellipse to a rectangle. Cropped and downsized each face to a 32x32 pixel face image to be used as a positive example in the test and training sets. Obtained negative examples by randomly selecting non-face 32x32 patches of the images. The negative patches must not intersect with a positive face patch given a certain threshold. On these examples, Haar features were created based upon the Viola-Jones paper. These sets of weak classifiers were combined into a strong classifier using the Adaboost model. My implementation achieved an accuracy of **90.30%**. The model is trained using the first 8 folds in the FDDB dataset. The model is tested using folds 9 and 10.

To perform the face detection on any given image, I used a sliding window approach on the whole image. I used the trained Adaboost model above for each window in a loop. In order to detect all the faces, the window size and stride needs to have varying sizes. There are multiple different window sizes to account for varying face sizes. The detections were chosen based on the confidence score from the model and using non-maximum suppression.

#  
1. Original set of images

The original set of images can be downloaded from 
http://tamaraberg.com/faceDataset/originalPics.tar.gz
Uncompressing this file organizes the images as
originalPics/year/month/day/big/*.jpg

#  
2. Face annotations

Uncompressing the "FDDB-folds.tgz" file creates a directory
"FDDB-folds", which contains files with names:
FDDB-fold-xx.txt and FDDB-fold-xx-ellipseList.txt,
where xx = {01, 02, ..., 10} represents the fold-index.

Each line in the "FDDB-fold-xx.txt" file specifies a path 
to an image in the above-mentioned data set. For instance, 
the entry "2002/07/19/big/img_130" corresponds to 
"originalPics/2002/07/19/big/img_130.jpg."

The corresponding annotations are included in the file 
"FDDB-fold-xx-ellipseList.txt" in the following 
format:


**image name i**

**number of faces in this image =im**

**face i**

**face i2**
...

**face im**


Here, each face is denoted by:
<major_axis_radius minor_axis_radius angle center_x center_y 1>.

#  
3. Detection output
  
To be recognized by the evaluation code, the detection
output is expected in the following format:


**image name i**

**number of faces in this image =im**

**face i1**

**face i2**
...

**face im**

where the representation of a face depends on the specifics
of the shape of the hypothesized image region. The evaluation
code supports the following shapes:
  
  4 a. Rectangular regions
       Each face region is represented as:
       <left_x top_y width height detection_score> 
  
  4 b. Elliptical regions
       Each face region is represented as:
       <major_axis_radius minor_axis_radius angle center_x center_y detection_score>.

Also, the order of images in the output file is expected to be 
the same as the order in the file annotatedList.txt.
#

### Data Download
Data can be downloaded from the following website: https://vis-www.cs.umass.edu/fddb/

(Description of the annotations and images were taken from the original README of the website above) 

### Sample Results
![sportsImage](https://github.com/CamdenKitowski/Face-Detection-AdaBoost-Model/assets/64344676/ee933d9f-d521-4444-8b01-46d32bae36a7)
![speakerImage](https://github.com/CamdenKitowski/Face-Detection-AdaBoost-Model/assets/64344676/3d84e74e-928c-4f23-8fa8-f026c4624431)

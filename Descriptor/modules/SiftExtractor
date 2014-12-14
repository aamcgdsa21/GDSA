import os
import cv2
import pickle

class SiftExtractor:
    """ Extracts the SIFT features from an image or collection of images and, if desired,
    it saves them to disk """
    
    def __init__(self, flagSaveInMemory=False, flagVerbose=False):
        
        # Init the OpenCV class that extracts SIFT descriptors
        self.sift = cv2.SIFT()
        
        # Array to save descriptors
        self.descriptors = []
        
        self.flagSaveInMemory = flagSaveInMemory
        self.flagVerbose = flagVerbose
    
    def processDir( self, pathDirImages, pathDirSifts=None ):
        
        # For each image in the directoy
        for fileImage in os.listdir(pathDirImages):
            
            # Load the image in memory
            pathFileImage = os.path.join( pathDirImages, fileImage )
            
            # If this is a file...
            if os.path.isfile(fileImage):
                
                # Extract the basename from the filename
                imageId = os.path.splitext( pathFileImage )[0]
                
                # Process the image
                self.processImage( self, imageId, pathFileImage, pathDirSifts )
        
        
    def processTxtFile( self, pathTxtFile, pathDirImages, fileImageExtension, pathDirSifts=None):
        
        print 'Reading images from ' + pathTxtFile + "..."
        
        # Read the file containing the image IDs
        fileDataset = open( pathTxtFile, 'r')
        
        # Read lines from the text file, stripping the end of line character
        imageIds = [line.strip() for line in fileDataset ]
        
        # Close file
        fileDataset.close()
        
        self.processCollectionFilesImage( self, imageIds, pathDirImages, fileImageExtension, pathDirSifts )
                
    def processCollectionFilesImage( self, imageIds, pathDirImages, fileImageExtension, pathDirSifts=None ):
        
        # For each image ID listed in the text file...
        for imageId in imageIds:
        
            # Build the path of the filename containing the image
            basename = imageId + '.' + fileImageExtension
            #basename = imageId
            if self.flagVerbose==True:
                print basename
                
            pathFileImage = os.path.join( pathDirImages, basename )
            
            # Process the image
            keypoints, descriptor = self.processImage( pathFileImage )
            
            # If requested, keep in memory
            if( self.flagSaveInMemory == True):
                self.descriptors.append(descriptor)
            
            # If requested, save to disk
            if( pathDirSifts != None ):
                self.saveToDisk( descriptor, pathDirSifts, imageId )
            
    def processImage( self, pathFileImage ):
        """ Detect the keypoints and etxract the SIFT descriptor from an image
        stored in disk """
        
        if not os.path.exists( pathFileImage ):
            print 'File not found ' + pathFileImage
            return
                
        # Read image to memory
        img  =  cv2.imread ( pathFileImage )

        # Convert the image to gray
        gray = cv2.cvtColor (img, cv2.COLOR_BGR2GRAY)
        
        # Detect the keypoints and extract the SIFT descriptor from each of them
        keypoints,descriptors = self.sift.detectAndCompute(gray, None)
        
        if descriptors==None:
            descriptors=[]
            for i in range(64):
                descriptors.append(0)
                
                
                    
        print descriptors
        return keypoints, descriptors
        
    def saveToDisk(self, descriptors, pathDirSifts, imageId):
        
        # Create a file to disk with the descriptor of the current image
        pathSift = os.path.join( pathDirSifts, imageId + '.p' )

        # Save SIFT descriptor to disk            
        # np.savetxt( pathSift, des ) 
            
        # Save SIFT descriptor to disk using Pickle
        pickle.dump( descriptors, open( pathSift, "wb" ) )           
        
    def getDescriptors(self):
        return self.descriptors
    
# Main
if __name__ == "__main__":
    
    pathHome = os.path.expanduser('~')
    pathWork = os.path.join( pathHome, 'Desktop/ProyectoGDSA')
    
#    pathWork = os.path.join( pathHome, 'work/mediaeval/2013-sed/classification' )
    
#    pathDirImages = os.path.join( pathWork, '1_images/train' )
    pathDirImages = os.path.join( pathWork, '1_images' )

    pathFileImage = os.path.join(pathDirImages, '320426234853745400_249212839.jpg')

#    pathFileImage = os.path.join(pathDirImages, '321223103189010824_189558761.jpg')

    pathFileDatasetTrain = os.path.join(pathWork, '2_datasets/train.txt')
    pathDirSifts = os.path.join(pathWork, '3_features/debug')
    if not os.path.exists(pathDirSifts):
        os.makedirs(pathDirSifts)
    
    # Init the SIFT extractor
    siftExtractor = SiftExtractor()
    
    siftExtractor.processTxtFile( pathFileDatasetTrain, pathDirImages,'jpg', pathDirSifts)
    
    #siftExtractor.processImage('320426234853745400_249212839', pathFileImage, pathDirSifts )
    
    
    

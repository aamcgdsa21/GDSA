import os
import cv2
import pickle

class SurfExtractor:
    """ Extracts the SURFfeatures from an image or collection of images and, if desired,
    it saves them to disk """
    
    def __init__(self, flagSaveInMemory=False, flagVerbose=False):
        
        # Init the OpenCV class that extracts SURFdescriptors
        self.surf= cv2.SURF()
        
        # Array to save descriptors
        self.descriptors = []
        
        self.flagSaveInMemory = flagSaveInMemory
        self.flagVerbose = flagVerbose
    
    def processDir( self, pathDirImages, pathDirSurfs=None ):
        
        # For each image in the directoy
        for fileImage in os.listdir(pathDirImages):
            
            # Load the image in memory
            pathFileImage = os.path.join( pathDirImages, fileImage )
            
            # If this is a file...
            if os.path.isfile(fileImage):
                
                # Extract the basename from the filename
                imageId = os.path.splitext( pathFileImage )[0]
                
                # Process the image
                self.processImage( self, imageId, pathFileImage, pathDirSurfs )
        
        
    def processTxtFile( self, pathTxtFile, pathDirImages, fileImageExtension, pathDirSurfs=None):
        
        print 'Reading images from ' + pathTxtFile + "..."
        
        # Read the file containing the image IDs
        fileDataset = open( pathTxtFile, 'r')
        
        # Read lines from the text file, stripping the end of line character
        imageIds = [line.strip() for line in fileDataset ]
        
        # Close file
        fileDataset.close()
        
        self.processCollectionFilesImage( self, imageIds, pathDirImages, fileImageExtension, pathDirSurfs )
                
    def processCollectionFilesImage( self, imageIds, pathDirImages, fileImageExtension, pathDirSurfs=None ):
        
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
            if( pathDirSurfs != None ):
                self.saveToDisk( descriptor, pathDirSurfs, imageId )
            
    def processImage( self, pathFileImage ):
        """ Detect the keypoints and etxract the SURFdescriptor from an image
        stored in disk """
        
        if not os.path.exists( pathFileImage ):
            print 'File not found ' + pathFileImage
            return
                
        # Read image to memory
        img  =  cv2.imread ( pathFileImage )

        # Convert the image to gray
        gray = cv2.cvtColor (img, cv2.COLOR_BGR2GRAY)
#        surf = cv2.SURF()
        # Detect the keypoints and extract the SURFdescriptor from each of them
        keypoints,descriptors = self.surf.detectAndCompute(gray, None)
        
        if descriptors==None:
            descriptors=[]
            for i in range(64):
                descriptors.append(0)
                
                
                    
#        print descriptors
        return keypoints, descriptors
        
    def saveToDisk(self, descriptors, pathDirSurfs, imageId):
        
        # Create a file to disk with the descriptor of the current image
        pathSurf= os.path.join( pathDirSurfs, imageId + '.p' )

        # Save SURFdescriptor to disk            
        # np.savetxt( pathSurf, des ) 
            
        # Save SURFdescriptor to disk using Pickle
        pickle.dump( descriptors, open( pathSurf, "wb" ) )           
        
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
    pathDirSurfs = os.path.join(pathWork, '3_features/debug')
    if not os.path.exists(pathDirSurfs):
        os.makedirs(pathDirSurfs)
    
    # Init the SURFextractor
    SurfExtractor = SurfExtractor()
    
    SurfExtractor.processTxtFile( pathFileDatasetTrain, pathDirImages,'jpg', pathDirSurfs)
    
    #surfExtractor.processImage('320426234853745400_249212839', pathFileImage, pathDirSurfs )
    
    
    

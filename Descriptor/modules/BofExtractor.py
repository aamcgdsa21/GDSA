import numpy as np
import os
import pickle  
import getopt
import sys
import scipy.io as io

from modules.computation.Dataset import Dataset            
from modules.features.SurfExtractor import SurfExtractor
from modules.features.VisualVocabulary import VisualVocabulary

class BofExtractor:
    """ Extracts the Bag of SURF Features (BoF) from an image or collection of images and, if desired,
    it saves them to disk """
    
    def __init__(self, pathVisualVocabulary, 
                         flagSaveInMemory=False, 
                         flagVerbose=False,
                         flagRunOnServer=False):
        
        # Init the OpenCV class that extracts SURF descriptors
        self.surfExtractor = SurfExtractor(False, False)
        
        # Init the visual vocabulary
        self.visualVocabulary = VisualVocabulary(pathVisualVocabulary)
        
        # Dictionary to save Bags of Features
        self.bofs = {}
        
        self.flagSaveInMemory = flagSaveInMemory
        self.flagVerbose = flagVerbose
        self.flagRunOnServer = flagRunOnServer
    
    def processDir( self, pathDirImages, pathDirBoFs=None ):
        
        # For each image in the directoy
        for fileImage in os.listdir(pathDirImages):
            
            # Load the image in memory
            pathFileImage = os.path.join( pathDirImages, fileImage )
            
            # If this is a file...
            if os.path.isfile(fileImage):
                
                # Extract the basename from the filename
                imageId = os.path.splitext( pathFileImage )[0]
                
                # Process the image
                self.processImage( self, imageId, pathFileImage, pathDirBoFs )
        
        
    def processTxtFile( self, pathTxtFile, pathDirImages, fileImageExtension, pathDirBoFs=None):
        
        if self.flagVerbose:
            print 'Reading images from ' + pathTxtFile + "..."
            
        dataset = Dataset( pathTxtFile )

        rootNames = dataset.getRootNames()
                
        # Process the collection of image IDs
        self.processCollectionFilesImage( rootNames, pathDirImages, fileImageExtension, pathDirBoFs )
                
                
    def processCollectionFilesImage( self, imageIds, pathDirImages, fileImageExtension, pathDirBoFs=None ):
        
        # Define a dictiornary to contain the pairs of ImageIDs and BoF feature vectors
        bofs = {}
        
        # For each provided image ID...
        for imageId in imageIds:
        
            # Build the path of the filename containing the image
            basename = imageId + '.' + fileImageExtension
            #basename = imageId
            if self.flagVerbose==True:
                print basename
                
            pathFileImage = os.path.join( pathDirImages, basename )
            
            # Process the image
            signature = self.processImage( pathFileImage )
            
            # If requested, keep in memory
            if( self.flagSaveInMemory == True):
                #print np.array(signature)
                bofs[ 'i' + imageId ] = np.array(signature)
            
        # If requested, save to disk
        if( pathDirBoFs != None ):
            
            # Save the dictionary to disk in a Matlab file
            # pathFileBof = os.path.join( pathDirBoFs, imageId + '.p' )
            pathFileBof = os.path.join( pathDirBoFs, 'bofs.mat' ) 
            # self.saveToDisk( dict, pathFileBof )
            
            # Save all BoF features to disk in Matlab format
            
            #bofs_copy = self.bofs.copy()
            io.savemat( pathFileBof, {'bofs':bofs} ) 
            
            
    def processImage( self, pathFileImage ):
        """ Detect the keypoints and etxract the SURF descriptor from an image
        stored in disk """
        
        if not os.path.exists( pathFileImage ):
            print 'File not found ' + pathFileImage
            return
        
        # Extract the SURF descriptor
        keypoints,descriptors = self.surfExtractor.processImage( pathFileImage )
        
        # Compute the signature with the visual vocabulary
        histogram = self.visualVocabulary.quantizeVector( descriptors )
        
        # Create a numpy array from the histogram
        return histogram[0]
        
        
    def saveToDisk(self, signature, pathFileBof ):
        
        # Save BoF descriptor to disk    
        #pathBof = os.path.join( pathDirBoFs, imageId + '.txt' )        
        #np.savetxt( pathBof, signature ) 
            
        # Save BoF descriptor to disk using Pickle
        pickle.dump( signature, open( pathFileBof, "wb" ) )               
        
    def getBofs(self):
        return self.bofs

# Script usage        
def usage():
    print "This script will extract the visual signature of an image referred to a visual vocabulary."

    
# Main
def main(argv):
    
    # Define default parameters    
    pathHome = os.path.expanduser('~')
#    pathWork = os.path.join( pathHome, 'work/mediaeval/2013-sed/classification' )
    pathWork = os.path.join( pathHome, 'Desktop/ProyectoGDSA')

    pathDirImages = os.path.join( pathWork, '1_images/test' )
    rootName= '322420827344467756_45285892'
    pathFileImage = os.path.join(pathDirImages, rootName + '.jpg')
    pathFileVocabulary = os.path.join(pathWork, '3_vocabulary/vocabulary.p')
    pathDirBoFs = os.path.join(pathWork, '4_bof/debug')
    if not os.path.exists(pathDirBoFs):
        os.makedirs(pathDirBoFs)    
    pathFileBoF = os.path.join( pathDirBoFs, rootName + '.p')
    
    _flagVerbose = False
    _flagRunOnServer=False

    
    # Parse the provided arguments (if any)
    # Details: http://www.diveintopython.net/scripts_and_streams/command_line_arguments.html
    try:                                
        opts, args = getopt.getopt(argv, 
                                   "i:c:o:h:v", 
                                   ["in=", "codebook=", "out=", "help","verbose"]) 
    except getopt.GetoptError:           
        usage()                          
        sys.exit(2)
    
    # Initialise the variables with the provided arguments (if any)
    #print opts
    for opt, arg in opts:                
        if opt in ("-i", "--in"):      
            pathFileImage = arg         
        elif opt in ('-c', "--codebook"):                
            pathFileVocabulary = arg                 
        elif opt in ("-o", "--out"): 
            pathFileBoF = arg
        elif opt in ("-h", "--help"):      
            usage()                     
            sys.exit()
        elif opt in ("-v", "--verbose"):      
            _flagVerbose = True
        elif opt in ("-s", "--srun"):      
            _flagRunOnServer=True 


                
    # Init the Bag of Features extractor with the precomputed vocabulary
    bofExtractor = BofExtractor( pathFileVocabulary, 
                                 flagSaveInMemory=False, 
                                 flagVerbose=_flagVerbose,
                                 flagRunOnServer = _flagRunOnServer )
    
    # Extract the visual feature
    signature = bofExtractor.processImage( pathFileImage )
    
    # Save the signature to disk
    bofExtractor.saveToDisk( signature, pathFileBoF )
    
if __name__ == "__main__":
    main(sys.argv[1:])

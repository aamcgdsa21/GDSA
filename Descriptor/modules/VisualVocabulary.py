import getopt
import numpy  as  np 
import pickle
import os
import random
import sys   
            
from modules.features.SurfExtractor import SurfExtractor
from sklearn.cluster import MiniBatchKMeans
from sklearn.cluster import Ward

class VisualVocabulary:
    """ Creates a visual vocabulary and quantises visual features """
    
    def __init__(self, pathFile=None, flagVerbose=False ):
        
        self.mbk = None
        self.ward = None
        
        # If a path file is provided...
        if pathFile !=None:
            # ...read from disk
            self.loadFromDisk( pathFile)
            
        if flagVerbose == True:
            self.flagVerbose = 1
        else:
            self.flagVerbose = 0

        
        
    def readImageIdsFromTxtFile( self, pathTxtFile ):
        """ Read the image IDs contained in a text file """
        print pathTxtFile
        if not os.path.exists(pathTxtFile):
            print 'File not found ' + pathTxtFile
            return []
            
         # Read the file containing the image IDs
        fileDataset = open( pathTxtFile, 'r')
        
        # Read lines from the text file, stripping the end of line character
        imageIds = [line.strip() for line in fileDataset ]
        
        # Close file
        fileDataset.close()
        
        return imageIds
        

    def buildFromImageCollection(   self, 
                                     pathTxtFile, 
                                     pathDirImages, 
                                     fileImageExtension, 
                                     vocabularySize=4096, 
                                     maxNumImages=sys.maxint ):

        # Read the image IDs
        imageIds = self.readImageIdsFromTxtFile( pathTxtFile )
        
        # If there are more images than the considered ones...
        if( len(imageIds) > maxNumImages ):
            imageIds = random.sample( imageIds, maxNumImages )
        
        # Extract the SURF descriptors from a collection of images and save in dictionary
        surfExtractor = SurfExtractor( True, True )
        surfExtractor.processCollectionFilesImage( imageIds, pathDirImages, fileImageExtension )
        
        # Create a numpy array from the descriptors
        descriptors=surfExtractor.getDescriptors()
        arr_descriptor = np.vstack(tuple(descriptors))
        
#        if( self.flagRunOnServer == True):
#            # K-means: The amount of clusters is specified with 'k' in the sci-kit version
#            # in the GPI computation service	
#            self.mbk = MiniBatchKMeans(init='k-means++', 
#                                        k=vocabularySize,
#                                        init_size=3*vocabularySize, 
#                                        max_no_improvement=10, 
#                                        verbose=1)
#        else:
        # K-means: The amount of clusters is specified in 'n_clusters' in latest scikit-learn version
        self.mbk = MiniBatchKMeans( init='k-means++', 
                                   n_clusters=vocabularySize,
                                   init_size=3*vocabularySize, 
                                   max_no_improvement=10, 
                                   verbose=self.flagVerbose)                                                                                
        
        self.mbk.fit( arr_descriptor )

    def buildFromImageCollectionWard( self, pathTxtFile, pathDirImages, fileImageExtension, vocabularySize, maxNumImages=sys.maxint ):
        # vocabularySize could be 4096
        # Read the image IDs
        imageIds = self.readImageIdsFromTxtFile( pathTxtFile )
        
        # If there are more images than the considered ones...
        if( len(imageIds) > maxNumImages ):
            imageIds = random.sample( imageIds, maxNumImages )
        
        # Extract the SURF descriptors from a collection of images and save in dictionary
        surfExtractor = SurfExtractor( True )
        surfExtractor.processCollectionFilesImage( imageIds, pathDirImages, fileImageExtension )
        
        # Create a numpy array from the descriptors
        descriptors=surfExtractor.getDescriptors()
        arr_descriptor = np.vstack(tuple(descriptors))
        
        #self.mbk = MiniBatchKMeans(init='k-means++', 
        #                                k=vocabularySize,
        #                                n_init=10, 
        #                                max_no_improvement=10, 
        #                                verbose=0)
        self.ward = Ward( n_clusters=vocabularySize )
        
        self.ward.fit( arr_descriptor )
        
    def loadFromDisk(self, pathFile):
        
        if not os.path.exists( pathFile):
            print "File not found " + pathFile
            return
            
        self.mbk = pickle.load( open( pathFile, "rb" ) )        
 
              
    def saveToDisk(self, pathFile):
        
        # Save mini batch K-Means to disk using Pickle
        pickle.dump( self.mbk, open( pathFile, "wb" ) )
                    
    def quantizeVector( self, descriptors ):
        
#        if len(descriptors)<128:
#            descriptors
        
        # Vector quantization with the visual vocabulary
        quant = self.mbk.predict(descriptors)
        
        # Build Histogram
        histogram = np.histogram(quant, bins=self.mbk.n_clusters)
#        histogram = np.histogram(quant, bins=self.mbk.k)

        
        return histogram
        


def usage():
    print "This script will generate a visual vocabulary."


def main(argv):
    
    # Define the default values for the options
    pathHome = os.path.expanduser('~')

    pathWork = os.path.join( pathHome,'Desktop','ProyectoGDSA')
    pathDirImages = os.path.join( pathWork, '1_images' )
    fileImageExtension = 'jpg'
    pathFileDatasetTrain = os.path.join(pathWork, '2_datasets', 'test.txt')
    pathVocabulary = os.path.join(pathWork, '3_vocabulary', 'vocabulary.p')

    _flagVerbose=False
    
    vocabularySize=1000                  # Amount of visual words
    maxNumImages=10                     # Maximum amount of images to consider

      
    # Parse the provided arguments (if any)
    # Details: http://www.diveintopython.net/scripts_and_streams/command_line_arguments.html
    try:                                
        opts, args = getopt.getopt(argv, 
                                   "i:v:e:m:s:o:h:v", 
                                   ["in=", "visual=", "ext=", "max=", "size=", "out=", "help","verbose"]) 
    except getopt.GetoptError:           
        usage()                          
        sys.exit(2)
    
    # Initialise the variables with the provided arguments (if any)
    for opt, arg in opts:                
        if opt in ("-i", "--in"):      
            pathFileDatasetTrain = arg  
        elif opt in ("-v", "--visual"): 
            pathDirImages = arg 
        elif opt in ("-e", "--ext"): 
            fileImageExtension = arg             
        elif opt in ("-m", "--max"):
            maxNumImages = int(arg) 
            if maxNumImages == 0:
                print 'Invalid maximum amount of images ' + arg
                sys.exit(2)            
        elif opt in ("-s", "--size"):
            vocabularySize = int(arg)  
            if vocabularySize == 0:
                print 'Invalid vocabulary size ' + arg
                sys.exit(2)
        elif opt in ("-o", "--out"): 
            pathVocabulary = arg
        elif opt in ("-h", "--help"):      
            usage()                     
            sys.exit()
        elif opt in ("-v", "--verbose"):      
            _flagVerbose = True
    
    # Init the Visual Vocabulary
    visualVocabulary = VisualVocabulary(flagVerbose=_flagVerbose)
    
    
    visualVocabulary.buildFromImageCollection(    pathFileDatasetTrain, 
                                                  pathDirImages, 
                                                  fileImageExtension, 
                                                  vocabularySize, 
                                                  maxNumImages )
    
    visualVocabulary.saveToDisk( pathVocabulary )


if __name__ == "__main__":
    main(sys.argv[1:])

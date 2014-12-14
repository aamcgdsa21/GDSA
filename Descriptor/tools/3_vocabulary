import os
import sys

from modules.features.VisualVocabulary import VisualVocabulary

def usage():
    print "This script will generate a visual vocabulary."

def main(argv):
    
    # Define the default values for the options
    pathHome = os.path.expanduser('~')
    pathWork = os.path.join( pathHome, 'Desktop/ProyectoGDSA')
    pathDirImages = os.path.join(pathWork,'1_images','train')
    pathFileDatasetTrain = os.path.join(pathWork, '2_datasets', 'train.txt')
    pathVocabulary = os.path.join(pathWork, '3_vocabulary', 'vocabulary.p')

    _flagVerbose=False
    
    vocabularySize=1000                  # Amount of visual words
    maxNumImages=10                     # Maximum amount of images to consider

    # Init the Visual Vocabulary
    visualVocabulary = VisualVocabulary(flagVerbose=_flagVerbose)
        
    visualVocabulary.buildFromImageCollection( pathFileDatasetTrain, 
                                              pathDirImages, 
                                              'jpg', 
                                              vocabularySize, 
                                              maxNumImages )
    
    visualVocabulary.saveToDisk( pathVocabulary )

if __name__ == "__main__":
    main(sys.argv[1:])
    
def run(argv):
    main()

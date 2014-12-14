import os

from modules.computation.Dataset import Dataset

def _main():
    
    # Define the default values for the options
    pathHome = os.path.expanduser('~')
    pathWork = os.path.join( pathHome, 'Desktop/ProyectoGDSA')
    pathImages = os.path.join(pathWork,'1_images')
    pathDatasets = os.path.join( pathWork, '2_datasets' )    

    # For each data partition (train & test)
    for partition in os.listdir(pathImages):
        
        # If it is a directory 
        dirPartition = os.path.join( pathImages, partition )
        if os.path.isdir(dirPartition):
        
            # Define the filename to contain the list of images to process
            filenameOut = os.path.join( pathDatasets, partition + '.txt')
            
            dataset = Dataset( filenameOut, 
                            flagSaveInMemory=False, 
                            flagVerbose=True)
    
            dataset.build( dirPartition, '.jpg' )

#def run():
_main()

import os

class Dataset:
    """ This class load or creates a text file with all the file rootnames
    contained in a directory. This is useful for large datasets when the
    listing operation can be slow. I also allows manually modifying a larger
    list to work with a reduced amount of data """
        
    def __init__(self, pathTxtFile, flagSaveInMemory=False, flagVerbose=False):
    
        self.pathTxtFile = pathTxtFile    
        self.rootNames = []
        self.flagSaveInMemory = flagSaveInMemory
        self.flagVerbose = flagVerbose

        if flagSaveInMemory is True and pathTxtFile is not None:
            # Read the images from the text file
            self.rootNames = self.readRootNamesFromTxtFile( pathTxtFile )

    def readRootNamesFromTxtFile( self, pathTxtFile ):

        if self.flagVerbose:
            print 'Reading images from ' + pathTxtFile + "..."
        
        # Read the file containing the image IDs
        fileDataset = open( pathTxtFile, 'r') #r= només lectura de l'arxiu
        
        # Read lines from the text file, stripping the end of line character
        rootNames = [line.strip() for line in fileDataset ]
        
        # Close file
        fileDataset.close()
        
        return rootNames
        
    def build( self, dirFiles, fileExtension ):
                
        # If it is a directory 
        if os.path.isdir(dirFiles) == False:
            print dirFiles + ' is not a directory'
            return
                
        rootNames = []

        # For each file matching the provided file extension image
        for fileImage in os.listdir( dirFiles ): 
            
            if fileImage.endswith(fileExtension):
                
                # Extract the basename from the filename
                baseName = os.path.basename( fileImage )
                rootName = os.path.splitext( baseName )[0]
    
                # Append the filename to the list
                rootNames.append( rootName )
                
                if self.flagVerbose:
                    # DEBUG: display filename in console
                    print rootName
                    
        # Save to disk
        self.saveToDisk( self.pathTxtFile, rootNames )                    
                            
        if self.flagSaveInMemory:
            self.rootNames = rootNames
                
    def saveToDisk( self, pathTxtFile, rootNames ):
        
        if self.rootNames.__sizeof__ == 0:     
            print 'No rootnames defined in the dataset'
            return
        
        # Open the file for writing
        outfile = open( pathTxtFile, 'w')

        # For each rootname
        for rootname in rootNames: 
            
            # Add the filename to the output list of files
            outfile.write ( rootname + '\n' )
                
        # Close output file
        outfile.close()        
        
        self.pathTxtFile = pathTxtFile
        
    def getRootNames( self ):
        
        print self.rootNames.__sizeof__
        
        # Return rootnames if already in memory
        if self.rootNames:
            return self.rootNames
            
        # Read rootnames if stored in a file
        return self.readRootNamesFromTxtFile( self.pathTxtFile )

/** ------------------------------------------------------------------------
    File        : IDataContainerEvents
    Purpose     : events fired by a IDataContainer
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Mon Jun 20 16:34:48 EDT 2011
    Notes       : * These events are separated out since we may add the IDataContainer
                    interface as a facade (see DataContainerEntity).
  ---------------------------------------------------------------------- */
using OpenEdge.Core.DataContainer.DataContainerActionEventArgs.
using OpenEdge.Core.DataContainer.DataContainerErrorEventArgs.
using Progress.Lang.Object.
  
interface OpenEdge.Core.DataContainer.IDataContainerEvents:
      
    /** Fired after a record has been added to the DataContainer.
    
        @param IComponent The DataContainer sending the event
        @param EventArgs Arguments pertinent to the event   */
    define public event DataAdd signature void (input poSender as Object, input poEventArgs as DataContainerActionEventArgs).

    /** This event fires when an error occurs when data is added to the DataContainer. 
    
        @param IComponent The DataContainer sending the events.  
        @param DataContainerErrorEventArgs Arguments containing the detail of the error.    */        
    define public event DataAddError signature void (input poSender as Object, input poEventArgs as DataContainerErrorEventArgs).
    
    /** Fired after a record has been removed
    
        @param IComponent The DataContainer sending the event
        @param EventArgs Arguments pertinent to the event   */
    define public event DataDelete signature void (input poSender as Object, input poEventArgs as DataContainerActionEventArgs).

    /** This event fires when an error occurs when data is deleted from the DataContainer
    
        @param IComponent The DataContainer sending the events.  
        @param DataContainerErrorEventArgs Arguments containing the detail of the error.    */    
    define public event DataDeleteError signature void (input poSender as Object, input poEventArgs as DataContainerErrorEventArgs).

    /** Fired after a record has been saved to the DataContainer (local save, not a commit).
        
        @param IComponent The DataContainer sending the event
        @param EventArgs Arguments pertinent to the event   */
    define public event DataSave signature void (input poSender as Object, input poEventArgs as DataContainerActionEventArgs).

    /** This event fires when an error occurs when data is saved locally
    
        @param IComponent The DataContainer sending the events.  
        @param DataContainerErrorEventArgs Arguments containing the detail of the error.    */    
    define public event DataSaveError signature void (input poSender as Object, input poEventArgs as DataContainerErrorEventArgs).

end interface.
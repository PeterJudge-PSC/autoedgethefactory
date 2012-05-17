/** ------------------------------------------------------------------------
    File        : IDataContainerEventHandler
    Purpose     : General interface for Event handlers for events in the DataContainer.
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Mon Oct 25 16:43:05 EDT 2010
    Notes       : * Typical implementers include Presenters, BusinessTasks, DataContainerQueries; 
                    can be others too.
  ----------------------------------------------------------------------*/
using OpenEdge.Core.DataContainer.IDataContainerEventHandler.
using OpenEdge.Core.DataContainer.DataContainerActionEventArgs.
using OpenEdge.Core.DataContainer.DataContainerErrorEventArgs.
using Progress.Lang.Object.

interface OpenEdge.Core.DataContainer.IDataContainerEventHandler:
          
    /** Fired after a record has been added to the DataContainer.
    
        @param IComponent The DataContainer sending the event
        @param DataContainerErrorEventArgs Arguments pertinent to the event   */
    method public void DataAddHandler(input poSender as Object, input poEventArgs as DataContainerActionEventArgs).

    /** This event fires when an error occurs when data is added to the DataContainer. 
    
        @param IComponent The DataContainer sending the events.  
        @param DataContainerErrorEventArgs Arguments containing the detail of the error.    */        
    method public void DataAddErrorHandler(input poSender as Object, input poEventArgs as DataContainerErrorEventArgs).
    
    /** Fired after a record has been removed
    
        @param IComponent The DataContainer sending the event
        @param DataContainerErrorEventArgs Arguments pertinent to the event   */
    method public void DataDeleteHandler(input poSender as Object, input poEventArgs as DataContainerActionEventArgs).

    /** This event fires when an error occurs when data is deleted from the DataContainer
    
        @param IComponent The DataContainer sending the events.  
        @param DataContainerErrorEventArgs Arguments containing the detail of the error.    */    
    method public void DataDeleteErrorHandler(input poSender as Object, input poEventArgs as DataContainerErrorEventArgs).

    /** Fired after a record has been saved to the DataContainer (local save, 
        not a commit).
        
        @param IComponent The DataContainer sending the event
        @param DataContainerErrorEventArgs Arguments pertinent to the event   */
    method public void DataSaveHandler(input poSender as Object, input poEventArgs as DataContainerActionEventArgs).

    /** This event fires when an error occurs when data is saved locally
    
        @param IComponent The DataContainer sending the events.  
        @param DataContainerErrorEventArgs Arguments containing the detail of the error.    */    
    method public void DataSaveErrorHandler(input poSender as Object, input poEventArgs as DataContainerErrorEventArgs).
    
end interface.
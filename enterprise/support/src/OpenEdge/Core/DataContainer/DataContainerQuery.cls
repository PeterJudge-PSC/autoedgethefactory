/** ------------------------------------------------------------------------
    File        : DataContainerQuery
    Purpose     : Specialisation of Query class for DataContainer
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Jun 17 11:54:19 EDT 2011
    Notes       : 
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Core.DataContainer.IDataContainerQuery.
using OpenEdge.Core.DataContainer.IDataContainerEventHandler.
using OpenEdge.Core.DataContainer.IDataContainer.
using OpenEdge.Core.DataContainer.DataContainerActionEventArgs.
using OpenEdge.Core.DataContainer.DataContainerErrorEventArgs.

using OpenEdge.Core.System.IQueryDefinition.
using OpenEdge.Core.System.ITableOwner.
using OpenEdge.Core.System.Query.
using OpenEdge.Core.System.EventArgs.
using OpenEdge.Lang.Assert.
using Progress.Lang.Object.

class OpenEdge.Core.DataContainer.DataContainerQuery inherits Query
        implements IDataContainerQuery, IDataContainerEventHandler:
    
    /** (mandatory) The DataContainer on which this query operates. */
    define public property DataContainer as IDataContainer no-undo get. protected set.
     
    /** (mandatory) A user-friendly name of the query */
    define public property QueryName as character no-undo
        get():
            if (QueryName eq ? or QueryName eq '') then
                QueryName = string(QueryHandle).
            
            return QueryName.
        end get.
        protected set.
    
    @todo(task="implement", action="replace with SelectedRowCollection").
    define public property NumSelectedRows as integer no-undo get. protected set. 
    
    /** Does this query object require a Reopen() call? A query might be flagged as such 
        by a DataContainer when new data is added from a busines entity (or even locally) in 
        batch/bundle mode. */
    define public property RequiresReopen  as logical no-undo get. set.
    
    define private variable mhBaseQueryHandle as handle no-undo. 
    
    /* In some cases we use this object to store prebuilt queries, such as a 
       ProDataSet's top-nav-query; in this case, we have a query handle already 
       and this is considereed prebuilt. We can change and (re)open the query,
       but the handle stays the same, and cannot be changed, nor can the buffers 
       in the query.
       
       The Query object does not support the changing of the QueryHandle. */
    constructor public DataContainerQuery(input poDataContainer as IDataContainer,
                                          input pcName as character,
                                          input phQueryHandle as handle,
                                          input poQueryDefinition as IQueryDefinition):
        /* A DataContainer is always a TableOwner */
        super(cast(poDataContainer, ITableOwner), poQueryDefinition).
        
        if valid-handle(phQueryHandle) then
            QueryHandle = phQueryHandle.
        
        /* At this point, at worst, the QueryHandle should equal the argument.
           Just double-checking that it's set to a decent value. */
        Assert:ArgumentNotNull(QueryHandle, 'Query Handle').
        
        assign DataContainer = poDataContainer
               mhBaseQueryHandle = QueryHandle
               QueryName = pcName 
               
               /* If the passed-in handle is valid, we already have a working query
                  and so don't need to build the query. */
               NeedsPrepare = not valid-handle(phQueryHandle).
    end constructor.
    
    constructor public DataContainerQuery(input poDataContainer as IDataContainer,
                                      input pcName as character,
                                      input poQueryDefinition as IQueryDefinition):
        this-object(poDataContainer,pcName,?,poQueryDefinition).  
    end constructor.
    
    /* parameter is number of row selection, not query ordinal */
    method public char extent GetSelectedRowKey(piRow as int):
    end method.
        
    method public void ClearSelection():
    end method.
            
    method public void SelectRow(pcRowKey as char extent).
    end method.
    
    method public void SelectCurrentRow().    
    end method.
    
    method public void DeselectRow(pcRowKey as char extent).
    end method.
    
    method public void DeselectCurrentRow().
    end method.
    
    /** Allows the DatasetDataContainer to use the queries created by
       the ProBindingSource if it needs to. DatasetDataContainer:CreateDefaultQUeries()
       creates a bunch of queries based on the relations; the PBS uses the same
       queries (the PDS' relation queries) as a basis for its' own 'smaller'/individual
       queries when its working in a heirachical grid like the UlraControls' UltraGrid.
       
       The query definitions will stay the same for all queries on a relation - so you won't be able
       to sort customer 1's orders differently from customer 2's in the same grid - but we're
       going to use that single query def for all the individual queries, and will do so by pushing 
       the actual query in use in to this object.
       
       @param handle An ABL query handle        */
    method public void SetQueryHandle(phQuery as handle):
        QueryHandle = phQuery.
    end method.
    
    method public void ResetQueryHandle():
        QueryHandle = mhBaseQueryHandle.
    end method.

    /* Event handlers for events in the DataContainer, so that the DataContainerQuery can listen to local (create, update, delete) or
       service (fetch, commit) events and reopen. The DataContainer will in all likelihood perform any subscriptions, although
       the DataContainerQuery class may do this too.    */    

    /** Fired after a record has been created in the DataContainer (local)
    
        @param IComponent The DataContainer sending the event
        @param EventArgs Arguments pertinent to the event   */
    method public void DataAddHandler(input poSender as Object, input poEventArgs as DataContainerActionEventArgs):
        RequiresReopen = QueryRequiresReopen(poEventArgs:TableName).
    end method.
    
    /** Fired after a record has been removed (local)
    
        @param IComponent The DataContainer sending the event
        @param EventArgs Arguments pertinent to the event   */
    method public void DataDeleteHandler(input poSender as Object, input poEventArgs as DataContainerActionEventArgs):
        RequiresReopen = QueryRequiresReopen(poEventArgs:TableName).
    end method.

    /** Fired after a record has been saved to the DataContainer (local save, 
        not a commit).
        
        @param IComponent The DataContainer sending the event
        @param EventArgs Arguments pertinent to the event   */
    method public void DataSaveHandler(input poSender as Object, input poEventArgs as DataContainerActionEventArgs):
        RequiresReopen = QueryRequiresReopen(poEventArgs:TableName).
    end method.
    
    /** Event fired after the DataContainer received its response from a FetchData() 
        service request. 
    
        @param IComponent The DataContainer sending the event
        @param EventArgs Arguments pertinent to the event   */        
    method public void DataCommitHandler(input poSender as Object, input poEventArgs as DataContainerActionEventArgs):
        RequiresReopen = QueryRequiresReopen(poEventArgs:TableName).
    end method.
    
    /** Event fired after the DataContainer received its response from a SaveData() 
        service request. 
        
        @param IComponent The DataContainer sending the event
        @param EventArgs Arguments pertinent to the event   */
    method public void DataFillHandler(input poSender as Object, input poEventArgs as DataContainerActionEventArgs):
        RequiresReopen = QueryRequiresReopen(poEventArgs:TableName).
    end method.
    
    method override protected void Open( input phQuery as handle ):
        super:Open(phQuery).
        RequiresReopen = false.
    end method.
    
    /** Assume query requries a reopen if any of the tables in the DataContainer Action are in the
        query itself. 
        
        @param character An array of tables being checked
        @return logical Whether the query needs to be reopened.    */
    method protected logical QueryRequiresReopen (input pcActionTables as character extent):
        define variable cQueryTables as character extent no-undo.
        define variable iLoop as integer no-undo.
        define variable iLoop2 as integer no-undo.
        define variable iMax as integer no-undo.
        define variable iMax2 as integer no-undo.
        define variable lContainsTable as logical no-undo.
        define variable lReopen as logical no-undo.
        
        /* If we already require a reopen, then go no further. */
        lReopen = RequiresReopen.
        if not lReopen then
        do:
            cQueryTables = Definition:GetBufferList().
            lContainsTable = false.
            
            iMax = extent(pcActionTables).
            iMax2 = extent(cQueryTables).
            do iLoop = 1 to iMax while not lContainsTable:
                do iLoop2 = 1 to iMax2 while not lContainsTable:
                    lContainsTable = cQueryTables[iLoop2] eq pcActionTables[iLoop]. 
                end.
            end.
            lReopen = IsOpen and lContainsTable.
        end.
        
        return lReopen.
    end method.

    method public void DataAddErrorHandler( input poSender as Object, input poEventArgs as DataContainerErrorEventArgs ):
        undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").
    end method.

    method public void DataDeleteErrorHandler( input poSender as Object, input poEventArgs as DataContainerErrorEventArgs ):
        undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").
    end method.

    method public void DataSaveErrorHandler( input poSender as Object, input poEventArgs as DataContainerErrorEventArgs ):
        undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").
    end method.
    
    method public void DataCommitErrorHandler( input poSender as Object, input poEventArgs as DataContainerErrorEventArgs ):
        undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").
    end method.

    method public void DataFillErrorHandler( input poSender as Object, input poEventArgs as DataContainerErrorEventArgs ):
        undo, throw new Progress.Lang.AppError("METHOD NOT IMPLEMENTED").
    end method.
    
end class.
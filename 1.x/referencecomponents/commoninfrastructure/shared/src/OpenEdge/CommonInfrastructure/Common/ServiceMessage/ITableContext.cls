/** ------------------------------------------------------------------------
    File        : ITableContext
    Purpose     : Interface for table context   
    Syntax      : 
    Description : 
    @author hdaniels
    Created     : Tue Feb 09 18:28:13 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */

interface OpenEdge.CommonInfrastructure.Common.ServiceMessage.ITableContext:
    
    /** protected set - not changeable - provide with constructor  */  
    define public property TableName as character no-undo get.
    
    /** The buffer/table handle corresponding to the tableName */
    define public property TableHandle as handle no-undo get. set.
    
    /** Num rows in resultset (on server if paging). If this is set to -1,
        all data is retrieved */
    define public property PageSize as integer no-undo get. set.

    /** Indicates whether the PageSize property is accurate or not. For instance, if the
        underlying query used PRESELECT we can be fairly sure it's accurate. Otherwise, not 
        so much. */
    define public property FuzzyPageSize as logical no-undo get. set.
    
    /** The number of remaining pages to retrieve. If this is zero, then
        all data has been retrieved. If it is negative, then we haven't yet
        retrieved any pages and don't know how many there are. */
    define public property NumRemainingPages as integer no-undo get. set.
    
    /** Context info/key for where to start appending next page */
    define public property NextPosition as character extent no-undo get. set.
    
    /** context info/key for where to start appending next page */
    define public property PrevPosition as character extent no-undo get. set.
    
    /** The last time that a request was serviced (ie on response) for the table
        to be updated (either fetched or saved). */
    define public property LastUpdateAt as datetime-tz no-undo get. set.
    
end interface.
/** ------------------------------------------------------------------------
    File        : ITableContext
    Purpose     : Interface for table context   
    Syntax      : 
    Description : 
    @author hdaniels
    Created     : Tue Feb 09 18:28:13 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */

interface OpenEdge.CommonInfrastructure.ServiceMessage.ITableContext:
    /** protected set - not changeable - provide with constructor  */  
    define property TableName as char no-undo get. 
    
    /** num rows in resultset (on server if paging) */
    define property NumRows as integer no-undo get. set.
    
    /** context info/key for where to start appending next page */
    define property NextPosition as char extent no-undo get. set.
    /** context info/key for where to start appending next page */
    define property PrevPosition as char extent no-undo get. set.
    
end interface.
/*------------------------------------------------------------------------
    File        : ITableInfo
    Purpose     : Interface for table info (context)  
    Syntax      : 
    Description : 
    Author(s)   : hdaniels
    Created     : Tue Feb 09 18:28:13 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/

interface OpenEdge.PresentationLayer.Model.ITableInfo: /* inherits ITableContext, IQueryDefinition */
    /* aka batch size */
    define property PageSize as integer no-undo get. set.
    
end interface.
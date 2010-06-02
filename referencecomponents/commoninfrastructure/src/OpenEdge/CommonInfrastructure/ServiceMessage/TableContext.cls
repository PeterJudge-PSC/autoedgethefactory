/*------------------------------------------------------------------------
    File        : TableContext
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue Apr 27 15:01:35 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.ServiceMessage.TableContext.
using OpenEdge.CommonInfrastructure.ServiceMessage.ITableContext.

class OpenEdge.CommonInfrastructure.ServiceMessage.TableContext
        implements ITableContext: 
    
    define public property TableName as character no-undo get. private set. 
    define public property NumRows as integer no-undo get. set. 
    define public property NextPosition as character extent no-undo get. set. 
    define public property PrevPosition as character extent no-undo get. set.
    
    constructor public TableContext(pcTableName as character):
        TableName = pcTableName.
    end constructor. 
    
end class.
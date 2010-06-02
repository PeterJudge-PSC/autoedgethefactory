/*------------------------------------------------------------------------
    File        : TableRequest
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Tue Apr 27 14:42:27 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.ServiceMessage.TableRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.ITableRequest.
using OpenEdge.Core.System.QueryDefinition.
using OpenEdge.Lang.EnumMember.

class OpenEdge.CommonInfrastructure.ServiceMessage.TableRequest inherits QueryDefinition
        implements ITableRequest: 
    
    define public property TableName as character no-undo get. private set. 
    define public property PageSize as integer no-undo get. set. 
    define public property FullPage as logical no-undo get. set.
    define public property TableRequestType as EnumMember no-undo get. set. 
    define public property SearchType as EnumMember no-undo get. set.
    define public property PageContext as character extent no-undo get. set. 
    define public property RowKey as character extent no-undo get. set. 
    
    constructor public TableRequest(pcTableName as character):
        TableName = pcTableName.
    end constructor.
    
    method public void AddSearch(pcBufferName as character,
                                 pcFieldName as character,
                                 poOperator as EnumMember,
                                 pcFieldValue as character,
                                 poFieldType as EnumMember,
                                 poJoinType as EnumMember):
        @todo(task="implement", action="").
    end method.

    method public void GetSearch(pcBufferName as character,
                                 output pcFieldName as character extent,
                                 output poOperator as EnumMember extent,
                                 output pcFieldValue as character extent,
                                 output poFieldType as EnumMember extent,
                                 output poJoinType as EnumMember extent):
        @todo(task="implement", action="").
    end method.

    method public character BuildSearchString(  ):
        @todo(task="implement", action="").
    end method.
    
end class.
/*------------------------------------------------------------------------
    File        : TableRequest
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Apr 27 14:42:27 EDT 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.ServiceMessage.TableRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.ITableRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.TableRequestTypeEnum.

using OpenEdge.Core.System.QueryDefinition.

using OpenEdge.Lang.FindTypeEnum.
using OpenEdge.Lang.OperatorEnum.
using OpenEdge.Lang.DataTypeEnum.
using OpenEdge.Lang.JoinEnum.

class OpenEdge.CommonInfrastructure.ServiceMessage.TableRequest inherits QueryDefinition
        implements ITableRequest: 
    
    define public property TableName as character no-undo get. private set. 
    define public property PageSize as integer no-undo get. set. 
    define public property FullPage as logical no-undo get. set.
    define public property TableRequestType as TableRequestTypeEnum no-undo get. set. 
    define public property SearchType as FindTypeEnum no-undo get. set.
    define public property PageContext as character extent no-undo get. set. 
    define public property RowKey as character extent no-undo get. set. 
    
    constructor public TableRequest(pcTableName as character):
        TableName = pcTableName.
    end constructor.
    
    method public void AddSearch(pcBufferName as character,
                                 pcFieldName as character,
                                 poOperator as OperatorEnum,
                                 pcFieldValue as character,
                                 poFieldType as DataTypeEnum,
                                 poJoinType as JoinEnum):
        @todo(task="implement", action="").
    end method.

    method public void GetSearch(pcBufferName as character,
                                 output pcFieldName as character extent,
                                 output poOperator as OperatorEnum extent,
                                 output pcFieldValue as character extent,
                                 output poFieldType as DataTypeEnum extent,
                                 output poJoinType as JoinEnum extent):
        @todo(task="implement", action="").
    end method.

    method public character BuildSearchString(  ):
        @todo(task="implement", action="").
    end method.
    
end class.
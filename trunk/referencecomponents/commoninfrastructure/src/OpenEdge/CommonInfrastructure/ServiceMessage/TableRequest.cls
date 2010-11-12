/** ------------------------------------------------------------------------
    File        : TableRequest
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Tue Apr 27 14:42:27 EDT 2010
    Notes       : 
  ---------------------------------------------------------------------- */
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
    
    /** protected set - not changeable - provide with constructor  */  
    define property TableName as char no-undo get. private set.
    
    /** The number of records to return per page or batch */
    define property PageSize as integer no-undo get. set.
    
    /** Retrieve full page when page position is at beginning or end of result-set */
    define property FullPage as logical no-undo get. set.

    /** The number of remaining pages to retrieve. If this is zero, then
        all data has been retrieved. */
    define public property NumRemainingPages as integer no-undo get. set.
    
    define property TableRequestType as TableRequestTypeEnum no-undo get. set.
    
    /** context info/key for where to start appending page begin or end */
    define property PageContext as char extent no-undo get. set.
    
    /** Return page positioned to this key (i.e. resort request/ reopen ) 
        Typically used with TableRequestTypeEnum:Position */ 
    define property RowKey as char extent no-undo get. set.
    
    constructor public TableRequest(pcTableName as character):
        super().
        TableName = pcTableName.
    end constructor.
    
    /** Add search expression  (need to be kept separate from filter.). 
       - Allthough this in theory could be any complex expression it normally 
         only makes sense when the field(s) correspond(s) to the sort.    
       - AddSearch can be refactored to have type-specific signatures, removing the need to pass a
         DataTypeEnum. */
    method public void AddSearch(pcBufferName as character,
                                 pcFieldName as character,
                                 poOperator as OperatorEnum,
                                 pcFieldValue as character,
                                 poFieldType as DataTypeEnum,
                                 poJoinType as JoinEnum):
        this-object:AddFilter(pcBufferName,
                              pcFieldName,
                              poOperator,
                              pcFieldValue,
                              poFieldType,
                              poJoinType).
    end method.
    
    method public void GetSearch(pcBufferName as character,
                                 output pcFieldName as character extent,
                                 output poOperator as OperatorEnum extent,
                                 output pcFieldValue as character extent,
                                 output poFieldType as DataTypeEnum extent,
                                 output poJoinType as JoinEnum extent):
        @todo(task="implement", action="").
    end method.
    
    method public character BuildSearchString():
        return GetQueryString().
    end method.
    
end class.
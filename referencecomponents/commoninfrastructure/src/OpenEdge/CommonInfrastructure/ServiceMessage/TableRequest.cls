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
using OpenEdge.Core.System.QueryFilter.
using OpenEdge.Core.Util.IExternalizable.
using OpenEdge.Core.Util.ObjectOutputStream.
using OpenEdge.Core.Util.ObjectInputStream.

using OpenEdge.Lang.Collections.IMap.
using OpenEdge.Lang.Collections.IIterator.
using OpenEdge.Lang.Collections.ICollection.
using OpenEdge.Lang.Collections.Map.

using OpenEdge.Lang.FindTypeEnum.
using OpenEdge.Lang.OperatorEnum.
using OpenEdge.Lang.DataTypeEnum.
using OpenEdge.Lang.JoinEnum.
using OpenEdge.Lang.String.

class OpenEdge.CommonInfrastructure.ServiceMessage.TableRequest inherits QueryDefinition
        implements ITableRequest, IExternalizable: 
    
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
    
    define protected property QuerySearch as IMap no-undo get. private set.
    
    /* default ctor required for serialization */
    constructor public TableRequest():
        super().
    end constructor.
    
    constructor public TableRequest(pcTableName as character):
        this-object().
        
        QuerySearch = new Map().
        TableName = pcTableName.
        AddBuffer(TableName).
    end constructor.
    
    /** Add search expression  (need to be kept separate from filter.). 
       - Allthough this in theory could be any complex expression it normally 
         only makes sense when the field(s) correspond(s) to the sort.    
       - AddSearch can be refactored to have type-specific signatures, removing the need to pass a
         DataTypeEnum. */
    method public void AddSearch(pcBufferName as character,
                                 pcFieldName as character,
                                 poOperator as OperatorEnum,
                                 poFieldValue as String,
                                 poFieldType as DataTypeEnum,
                                 poJoinType as JoinEnum):
        QuerySearch:Put(
            new QueryFilter(pcBufferName,
                        pcFieldName,
                        poOperator,
                        poFieldValue,
                        poFieldType,
                        poJoinType),
            new String(pcBufferName)).
    end method.
    
    method public void GetSearch(pcBufferName as character,
                                 output pcFieldName as character extent,
                                 output poOperator as OperatorEnum extent,
                                 output poFieldValue as String extent,
                                 output poFieldType as DataTypeEnum extent,
                                 output poJoinType as JoinEnum extent):
                            
        @todo(task="implement", action="").
    end method.
    
    method public longchar BuildSearchString():
        return GetQueryString().
    end method.

/** IExternalizable **/
    method override public void WriteObject(po as ObjectOutputStream):
        super:WriteObject(po).
        
        po:WriteChar(TableName).
        po:WriteInt(PageSize).
        po:WriteLogical(FullPage).
        po:WriteInt(NumRemainingPages).
        po:WriteEnum(TableRequestType).
        po:WriteCharArray(PageContext).
        po:WriteCharArray(RowKey).
        
        po:WriteObjectArray(QuerySearch:KeySet:ToArray()).
        po:WriteObjectArray(QuerySearch:Values:ToArray()).
    end method.
    
    method override public void ReadObject(po as ObjectInputStream):
        super:ReadObject(po).
        
        TableName = po:ReadChar().
        PageSize = po:ReadInt().
        FullPage = po:ReadLogical().
        NumRemainingPages = po:ReadInt().
        TableRequestType = cast(po:ReadEnum(), TableRequestTypeEnum).
        PageContext = po:ReadCharArray().
        RowKey = po:ReadCharArray().
        
        cast(QuerySearch:KeySet, ICollection):AddArray(po:ReadObjectArray()).
        QuerySearch:Values:AddArray(po:ReadObjectArray()).
    end method.
    
end class.
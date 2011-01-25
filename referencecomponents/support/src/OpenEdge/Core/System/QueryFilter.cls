/** ------------------------------------------------------------------------
    File        : QueryFilter
    Purpose     : Parameter object for query filter clauses, used in IQueryDefinition 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Dec 10 10:16:46 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
{routinelevel.i}

using OpenEdge.Core.System.QueryFilter.
using OpenEdge.Core.Util.IExternalizable.
using OpenEdge.Core.Util.IObjectOutput.
using OpenEdge.Core.Util.IObjectInput.
using OpenEdge.Lang.JoinEnum.
using OpenEdge.Lang.DataTypeEnum.
using OpenEdge.Lang.OperatorEnum.
using OpenEdge.Lang.String.
using OpenEdge.Lang.Assert.
using Progress.Lang.Object.

class OpenEdge.Core.System.QueryFilter
        implements IExternalizable:

    define public property BufferName as character no-undo get. set.
    define public property FieldName as character no-undo get. set.
    define public property Operator as OperatorEnum no-undo get. set.
    /* FieldValue can be refactored into individual abl primitives, and so remove the
       need for FieldType */
    define public property FieldValue as String no-undo get. set.
    define public property FieldType as DataTypeEnum no-undo get. set.
    define public property JoinType as JoinEnum no-undo get. set.
    
    constructor public QueryFilter(input pcBufferName as character,
                                   input pcFieldName as character,
                                   input poOperator as OperatorEnum,
                                   input pcFieldValue as String,
                                   input poFieldType as DataTypeEnum,
                                   input poJoinType as JoinEnum):
        
        Assert:ArgumentNotNullOrEmpty(pcBufferName, 'Buffer Name').
        Assert:ArgumentNotNullOrEmpty(pcFieldName, 'Field Name').
        Assert:ArgumentNotNull(poOperator, 'Operator').
        Assert:ArgumentNotNull(poJoinType, 'Join type').
        Assert:ArgumentNotNull(poFieldType, 'Field datatype').
        /* field value can be null */
        
        assign BufferName = pcBufferName
               FieldName = pcFieldName
               Operator = poOperator
               FieldValue = pcFieldValue
               FieldType = poFieldType
               JoinType = poJoinType.
    end constructor.
    
    method override public logical Equals(input p0 as Object):
        define variable lEquals as logical no-undo.
        define variable oQB as QueryFilter no-undo.
                
        lEquals = super:Equals(input p0).
        
        if not lEquals and type-of(p0, QueryFilter) then
            assign oQB = cast(p0, QueryFilter)
                   lEquals = oQB:BufferName eq this-object:BufferName
                         and oQB:FieldName eq this-object:FieldName                    
                         and oQB:Operator:Equals(this-object:Operator)
                         and oQB:FieldType:Equals(this-object:FieldType)
                         and oQB:JoinType:Equals(this-object:JoinType)
                         and oQB:FieldValue:Equals(this-object:FieldValue).
        
        return lEquals.
    end method.
    
    method public void WriteObject( input poStream as IObjectOutput):
        poStream:WriteChar(BufferName).
        poStream:WriteChar(FieldName).
        poStream:WriteEnum(Operator).
        poStream:WriteEnum(FieldType).
        poStream:WriteEnum(JoinType).
        poStream:WriteObject(FieldValue).
    end method.

    method public void ReadObject( input poStream as IObjectInput ):
        assign BufferName = poStream:ReadChar()
               FieldName = poStream:ReadChar()
               Operator = cast(poStream:ReadEnum(), OperatorEnum)
               FieldType =  cast(poStream:ReadEnum(), DataTypeEnum)
               JoinType =  cast(poStream:ReadEnum(), JoinEnum)
               FieldValue = cast(poStream:ReadObject(), String).
    end method.
    
    method override public character ToString():
        define variable cWhereClause as character no-undo.
        define variable cValue as character no-undo.
        
        assign cWhereClause = ' ' + JoinType:ToString() + ' '
               cValue = string(FieldValue:Value).
        
        if FieldType:Equals(DataTypeEnum:Rowid) then
            cWhereClause = cWhereClause 
                         + 'rowid(' + quoter(BufferName) + ')' 
                         + Operator:ToString() + ' '
                         + 'to-rowid(' + quoter(cValue) + ')'.
        else                         
        if FieldType:Equals(DataTypeEnum:Handle) then
            cWhereClause = cWhereClause 
                         + BufferName + '.' + FieldName + ' ' 
                         + Operator:ToString() + ' '
                         + 'widget-handle(' + quoter(cValue) + ')'.
        else
            cWhereClause = cWhereClause
                         + BufferName + '.' + FieldName + ' ' 
                         + Operator:ToString() + ' '
                         + quoter(cValue).
        
        return cWhereClause.
    end method.
        
end class.
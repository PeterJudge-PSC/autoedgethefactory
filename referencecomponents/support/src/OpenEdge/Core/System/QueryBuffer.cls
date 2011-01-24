/** ------------------------------------------------------------------------
    File        : QueryBuffer
    Purpose     : Parameter object for query buffers, used in IQueryDefinition 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Dec 10 10:16:46 EST 2010
    Notes       : 
  ---------------------------------------------------------------------- */
{routinelevel.i}

using OpenEdge.Core.System.QueryBuffer.
using OpenEdge.Core.Util.IExternalizable.
using OpenEdge.Core.Util.ObjectOutputStream.
using OpenEdge.Core.Util.ObjectInputStream.
using OpenEdge.Lang.LockModeEnum.
using OpenEdge.Lang.QueryTypeEnum.
using OpenEdge.Lang.Assert.
using Progress.Lang.Object.

class OpenEdge.Core.System.QueryBuffer
        implements IExternalizable:
    
    define public property Name as character no-undo get. set.
    define public property TableName as character no-undo get. set.
    define public property QueryType as QueryTypeEnum no-undo get. set.
    define public property LockMode as LockModeEnum no-undo get. set.
    
    @todo(task="implement", action="implement collection of sorts, filters, and joins ").
    
    constructor public QueryBuffer(input pcName as character):
        this-object(pcName, pcName, QueryTypeEnum:Default, LockModeEnum:Default). 
    end constructor. 

    constructor public QueryBuffer(input pcName as character,
                                   input pcTableName as character,
                                   input poQueryType as QueryTypeEnum,
                                   input poLockMode as LockModeEnum):
        Assert:ArgumentNotNullOrEmpty(pcName, 'Buffer name').
        Assert:ArgumentNotNullOrEmpty(pcTableName, 'Buffer table name').
        Assert:ArgumentNotNull(poQueryType, 'query type').
        Assert:ArgumentNotNull(poLockMode, 'lock mode').
        
        assign Name = pcName
               TableName = pcTableName
               QueryType = poQueryType
               LockMode = poLockMode.
    end constructor.
    
    constructor public QueryBuffer(input pcName as character,
                                   input pcTableName as character):
        this-object(pcName, pcTableName, QueryTypeEnum:Default, LockModeEnum:Default).                               
    end constructor.

    method override public logical Equals(input p0 as Object):
        define variable lEquals as logical no-undo.
        define variable oQB as QueryBuffer no-undo.
                
        lEquals = super:Equals(input p0).
        
        if not lEquals and type-of(p0, QueryBuffer) then
            assign oQB = cast(p0, QueryBuffer)
                   lEquals = oQB:Name eq this-object:Name
                         and oQB:TableName eq this-object:TableName                     
                         and oQB:QueryType:Equals(this-object:QueryType)
                         and oQB:LockMode:Equals(this-object:LockMode).
        
        return lEquals.
    end method.
    
    method public void WriteObject( input poStream as ObjectOutputStream):
        poStream:WriteChar(this-object:Name).
        poStream:WriteChar(TableName).
        poStream:WriteEnum(QueryType).
        poStream:WriteEnum(LockMode).
    end method.

    method public void ReadObject( input poStream as ObjectInputStream ):
        assign this-object:Name = poStream:ReadChar()
               TableName = poStream:ReadChar()
               QueryType = cast(poStream:ReadEnum(), QueryTypeEnum)
               LockMode =  cast(poStream:ReadEnum(), LockModeEnum).
    end method.
    
end class.
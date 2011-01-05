/** ------------------------------------------------------------------------
    File        : DataSourceQuery
    Purpose     : Specialised query for use with an ABL DATA-SOURCE 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Dec 29 14:39:34 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.System.IQueryDefinition.
using OpenEdge.Core.System.QueryDefinition.
using OpenEdge.Core.System.QueryFilter.
using OpenEdge.Core.System.Query.
using OpenEdge.Core.System.ITableOwner.

using OpenEdge.Lang.Collections.ICollection.
using OpenEdge.Lang.Collections.Collection.
using OpenEdge.Lang.Collections.IMap.
using OpenEdge.Lang.Collections.Map.
using OpenEdge.Lang.LockModeEnum.
using OpenEdge.Lang.QueryTypeEnum.
using OpenEdge.Lang.OperatorEnum.
using OpenEdge.Lang.JoinEnum.
using OpenEdge.Lang.DataTypeEnum.
using OpenEdge.Lang.String.

class OpenEdge.DataSource.DataSourceQuery inherits Query
        implements ITableOwner:
    
    /** The handle to the ABL DATA-SOURCE object that this query operates against.
        
        A case can be made for an OE.DataSource.ABLDatasource that contains
            the DataSourceQuery and a HANDLE property (ie not held here). */
    define public property ABLDataSource as handle no-undo get. private set.
    
    /** A collection of QueryFilter objects that act as tokens for the key fields
        in the datasource buffers.
        
        These filters are used when saving rows, where the values are used to identify the 
        DB rows uniquely. */
    define public property SourceKeyFilters as IMap no-undo get. set.
    
    define private temp-table ttBuffer no-undo
        field BufferName as character
        field Handle as handle
        index idx1 as primary unique BufferName.
    
	constructor public DataSourceQuery(input phDataSource as handle):
		super().
		
		assign ABLDataSource = phDataSource
		       TableOwner = this-object
		       SourceKeyFilters = new Map()
		       
		       Definition = ParseDataSource().
        
        /* 'fix' the definition */
        Rebase().		       
	end constructor.
	
	method protected IQueryDefinition ParseDataSource():
	    define variable oQD as IQueryDefinition no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable hBuffer as handle no-undo.

        assign oQD = new QueryDefinition()
               iMax = ABLDataSource:num-source-buffers.
        
        do iLoop = 1 to iMax:
            hBuffer = ABLDataSource:get-source-buffer(iLoop).
            RegisterBuffer(hBuffer).
            
            /* DataSource queries are effectively FIND FIRST's after the top-level buffer */
            case iLoop:
                when 1 then
                    oQD:AddBuffer(hBuffer:name,
                                  hBuffer:name,
                                  QueryTypeEnum:Each,
                                  LockModeEnum:NoLock).
                otherwise
                    oQD:AddBuffer(hBuffer:name,
                                  hBuffer:name,
                                  QueryTypeEnum:First,
                                  LockModeEnum:NoLock).
            end case.
            
            AddKeyFilters(hBuffer, ABLDataSource:keys(iLoop)).
        end.
        
        return oQD.
    end method.
    
    /** Creates and stores query filters for the datasource buffers' keys. */
    method protected void AddKeyFilters(input phBuffer as handle, 
                                        input pcKeys as character):
        define variable iNumKeys as integer no-undo.
        define variable iKeyLoop as integer no-undo.
        define variable hField as handle no-undo.
        define variable oFilters as ICollection no-undo.
        define variable hABLDataSource as handle no-undo.
        
        assign oFilters = new Collection()
               iNumKeys = num-entries(pcKeys).
        do iKeyLoop = 1 to iNumKeys:
            hField = phBuffer:buffer-field(entry(iKeyLoop, pcKeys)).
            oFilters:Add(new QueryFilter(phBuffer:name,
                              hField:name,
                              OperatorEnum:IsEqual,
                              new String('&1'),         /* for substitutions */
                              DataTypeEnum:EnumFromString(hField:data-type),
                              JoinEnum:And)).
        end.    /* key loop */
        SourceKeyFilters:Put(new String(phBuffer:name), oFilters).
    end method.
    
    method override protected handle GetQueryBuffer(input pcTableName as character,
                                                    input pcBufferName as character):
        define variable hBuffer as handle no-undo.
        define buffer lbBuffer for ttBuffer.
       
        find lbBuffer where lbBuffer.BufferName = pcTableName no-error.
        if available lbBuffer then
            hBuffer = lbBuffer.Handle.
        
        return hBuffer.
    end method.
        
	method public handle GetTableHandle( input pcTableName as character):
	    return GetQueryBuffer(pcTableName, pcTableName).
	end method.
	
	method protected void RegisterBuffer(input phBuffer as handle):
        define buffer lbBuffer for ttBuffer.
        
        create lbBuffer.
        assign lbBuffer.BufferName = phBuffer:name
               lbBuffer.Handle = phBuffer.
    end method.
    
end class.
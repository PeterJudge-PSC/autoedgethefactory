/** ------------------------------------------------------------------------
    File        : DataSourceQuery
    Purpose     : Specialised query for use with an ABL DATA-SOURCE 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Wed Dec 29 14:39:34 EST 2010
    Notes       : 
  ----------------------------------------------------------------------*/
{routinelevel.i}

using OpenEdge.CommonInfrastructure.Common.ServiceMessage.ServiceMessageActionEnum.

using OpenEdge.Core.System.IQueryDefinition.
using OpenEdge.Core.System.QueryDefinition.
using OpenEdge.Core.System.QueryFilter.
using OpenEdge.Core.System.QueryJoin.
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
using OpenEdge.Lang.Assert.

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
    define public property SourceKeyFilters as IMap no-undo
        get():
            if not valid-object(SourceKeyFilters) then
                SourceKeyFilters  = new Map().
            return SourceKeyFilters.
        end get.
        set.

    constructor public DataSourceQuery(input phDataSource as handle):
        super().
        
        Assert:ArgumentNotNull(phDataSource, 'ABL Data-Source').
        
        assign ABLDataSource = phDataSource
               TableOwner = this-object
               Definition = ParseDataSource().
    
        /* fix (as in finalise or baseline, not as in repair) the definition */
        Rebase().
        
        /* Always prepare this query. */
        BuildQuery = true.
        BuildQuery(QueryHandle).
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
            /* DataSource queries are effectively FIND FIRST's after the top-level buffer */
            case iLoop:
                when 1 then
                    oQD:AddBuffer(hBuffer:name,
                                  hBuffer:table,
                                  QueryTypeEnum:Each,
                                  LockModeEnum:NoLock).
                otherwise
                    oQD:AddBuffer(hBuffer:name,
                                  hBuffer:table,
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
        define variable cFieldName as character no-undo.
        define variable oDataType as DataTypeEnum no-undo.
        define variable hField as handle no-undo.
        define variable oFilters as ICollection no-undo.
        define variable hABLDataSource as handle no-undo.
        
        assign oFilters = new Collection()
               iNumKeys = num-entries(pcKeys).
               
        do iKeyLoop = 1 to iNumKeys:
            cFieldName = entry(iKeyLoop, pcKeys).
            if cFieldName eq 'rowid' then
                oDataType = DataTypeEnum:Rowid.
            else            
                assign hField = phBuffer:buffer-field(cFieldName)
                       oDataType = DataTypeEnum:EnumFromString(hField:data-type).
            
            oFilters:Add(new QueryFilter(phBuffer:name,
                              cFieldName,
                              OperatorEnum:IsEqual,
                              new String('&1'),         /* for substitutions */
                              oDataType,
                              JoinEnum:And)).
        end.    /* key loop */
        SourceKeyFilters:Put(new String(phBuffer:name), oFilters).
    end method.
    
    method override protected handle GetQueryBuffer(input pcTableName as character,
                                                    input pcBufferName as character):
        return GetTableHandle(pcTableName).                                                        
    end method.

    /* ITableOwner implementation */        
    method public handle GetTableHandle(input pcTableName as character):
        return GetTableBuffer(pcTableName).
    end method.
    
    method public handle GetTableBuffer(input pcTableName as character):
        define variable hBuffer as handle no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        
        /* We could use a temp-table for storing the table-name/buffer-name/handle values,
           but that would probably be overkill, given that the number of DB buffers per ABL
           data-source is (I assume) small, and so the loop is probably cheaper all round. */                
        iMax = ABLDataSource:num-source-buffers.
        hBuffer = ABLDataSource:get-source-buffer(1).
        do iLoop = 2 to iMax while hBuffer:table ne pcTableName:
            hBuffer = ABLDataSource:get-source-buffer(iLoop).
        end.
        
        if hBuffer:table ne pcTableName then
            hBuffer = ?.
        
        return hBuffer.
    end method.

    method override public character GetBufferTableName(input pcBufferName as character):
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable hBuffer as handle no-undo.
        
        /* We could use a temp-table for storing the table-name/buffer-name/handle values,
           but that would probably be overkill, given that the number of DB buffers per ABL
           data-source is (I assume) small, and so the loop is probably cheaper all round. */                
        iMax = ABLDataSource:num-source-buffers.
        hBuffer = ABLDataSource:get-source-buffer(1).
        do iLoop = 2 to iMax while hBuffer:name ne pcBufferName:
            hBuffer = ABLDataSource:get-source-buffer(iLoop).
        end.
        
        if hBuffer:name ne pcBufferName then
            hBuffer = ?.
        
        return hBuffer:table.
    end method.

	method public void Prepare(input poAction as ServiceMessageActionEnum):
	    define variable cWhereString as longchar no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable oJoin as QueryJoin no-undo.
        define variable cClause as character no-undo.
        define variable cLHS as character no-undo.
        define variable cRHS as character no-undo.
        
        case poAction:
            when ServiceMessageActionEnum:FetchData then cWhereString = ABLDataSource:fill-where-string.
            when ServiceMessageActionEnum:SaveData then cWhereString = ABLDataSource:save-where-string.
            otherwise cWhereString = ?.
        end case.
        
        Definition:AllowExternalJoins = not (cWhereString eq ?).
        
        if Definition:AllowExternalJoins then
        do:
            /* WHERE ds_2849_2165_ItemOption.ItemId=eVehicle.ItemId */
            /* WHERE ItemOption_2839-2165.ItemId=eVehicle.ItemId and ItemOption_2839-2165.TenantId=eVehicle.TenantId */
            iMax = num-entries(cWhereString, ' ').
            
            /* loose the WHERE, as well as the 'AND' phrases (we'll add these) */
            do iLoop = 1 to iMax:
                cClause = entry(iLoop, cWhereString, ' ').
                if cClause eq '' or lookup(cClause, 'WHERE,AND') gt 0 then
                    next.
                
                /* ItemOption_2839-2165.ItemId=eVehicle.ItemId  */
                assign /* ItemOption_2839-2165.ItemId */  
                       cLHS = entry(1, cClause, '=')
                       /* eVehicle.ItemId */
                       cRHS = entry(2, cClause, '=').
                
                /* We'll have the buffer name; we want the table name even though we'll go back to
                   the table name later; we do this even entry(1, cLHS, '.') it's wasteful since we want a consistent approach */
                Definition:AddJoin(/*GetBufferTableName(entry(1, cLHS, '.')), entry(2, cLHS, '.'),*/
                                   entry(1, cLHS, '.'), entry(2, cLHS, '.'),
                                   OperatorEnum:IsEqual,
                                   /* These will (typically) be from the entity, and so we use them unchanged */
                                   entry(1, cRHS, '.'), entry(2, cRHS, '.'),
                                   JoinEnum:And).
            end.
        end.
        
        this-object:Prepare().
	end method.

end class.
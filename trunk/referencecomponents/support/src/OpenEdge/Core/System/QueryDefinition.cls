/*------------------------------------------------------------------------
    File        : QueryDefinition
    Purpose     : 
    Syntax      : 
    Description : 
    @author pjudge
    Created     : Fri Mar 27 16:02:48 EDT 2009
    Notes       : * needs to be IExternalizable because its derived class
                    ServerDataContext is.
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.Core.System.IQueryDefinition.
using OpenEdge.Core.System.QueryDefinition.
using OpenEdge.Core.Util.IExternalizable.
using OpenEdge.Core.System.QueryDefinitionEventArgs.
using OpenEdge.Core.Util.ObjectOutputStream.
using OpenEdge.Core.Util.ObjectInputStream.
using OpenEdge.Lang.QueryBlockTypeEnum.
using OpenEdge.Core.System.QueryDefinitionOperationEnum.
using OpenEdge.Core.System.QueryElementEnum.

using OpenEdge.Lang.ByteOrderEnum.
using OpenEdge.Lang.CompareStrengthEnum.
using OpenEdge.Lang.QueryTypeEnum.
using OpenEdge.Lang.OperatorEnum.
using OpenEdge.Lang.DataTypeEnum.
using OpenEdge.Lang.LockModeEnum.
using OpenEdge.Lang.JoinEnum.
using OpenEdge.Lang.SortDirectionEnum.
using OpenEdge.Lang.EnumMember.

using Progress.Lang.Object.


class OpenEdge.Core.System.QueryDefinition
        implements IQueryDefinition, IExternalizable :
    
    define public event QueryDefinitionChanged signature void (poQueryDefinition as IQueryDefinition,
                                                               poEventArgs as QueryDefinitionEventArgs).
    
    define public property QueryBlockType as QueryBlockTypeEnum no-undo
        get ():
            if not valid-object(QueryBlockType) then
                QueryBlockType = QueryBlockTypeEnum:Default.
                            
            return QueryBlockType.
        end get.
        set.

    /* Only ever set by AddBuffer(). */
    define public property NumBuffers as integer no-undo get. protected set.
        
    define private temp-table ttBuffer no-undo
        field BufferName as char
        field TableName as char
        field Order as int
        field QueryType as Object   /* OpenEdge.Lang.QueryTypeEnum */
        field LockMode as Object       /* OpenEdge.Lang.LockModeEnum */
        index idx1 as unique BufferName
        index idx2 as primary unique Order.
    
    define private temp-table ttFilter no-undo
        field BufferName as character
        field FieldName as char
        field Operator as Object           /* OpenEdge.Lang.OperatorEnum */
        field FieldValue as char
        field FieldType as Object          /* OpenEdge.Lang.DataTypeEnum */
        field JoinType as Object /* OpenEdge.Lang.JoinEnum */
        index idx1 as primary unique BufferName FieldName Operator FieldValue         
        .        
    define private temp-table ttJoin no-undo
        field BufferName as character
        field FieldName as char
        field Operator as Object   /* OpenEdge.Lang.OperatorEnum:EnumMember */
        field JoinBufferName as char
        field JoinFieldName as char
        field JoinType as Object       /* OpenEdge.Lang.JoinEnum:EnumMember */
        index idx1 as primary unique BufferName FieldName Operator JoinBufferName JoinFieldName
        index idx2 JoinBufferName
        index idx3 BufferName
        .
    
    define private temp-table ttSort no-undo
        field BufferName as char
        field FieldName as char
        field Direction as Object /* OpenEdge.Lang.SortDirectionEnum:EnumMember */
        field Order as int
        index idx1 as primary unique BufferName FieldName       
        .

    method public void AddFilter (pcBufferName as char,
                                  pcFieldName as char,
                                  poOperator as OperatorEnum,
                                  pcFieldValue as char,
                                  poFieldType as DataTypeEnum,
                                  poJoinType as JoinEnum):
        
        define buffer lbFilter for ttFilter.
        
        create lbFilter.
        assign lbFilter.BufferName = pcBufferName
               lbFilter.FieldName = pcFieldName
               lbFilter.Operator = poOperator
               lbFilter.FieldValue = pcFieldValue
               lbFilter.FieldType = poFieldType
               lbFilter.JoinType = poJoinType.
        
        OnQueryDefinitionChanged(new QueryDefinitionEventArgs(QueryElementEnum:Filter, QueryDefinitionOperationEnum:Create)).
    end method.
    
    method public void AddSort (pcBufferName as char,
                                pcFieldName as char,
                                poSortDirection as SortDirectionEnum):
        define variable iOrder as integer no-undo.

        define buffer lbSort for ttSort.
        define query qrySort for lbSort.
        
        open query qrySort 
            preselect each lbSort by lbSort.Order.
        
        iOrder = query qrySort:num-results + 1.
        
        AddSort(pcBufferName, pcFieldName, poSortDirection, iOrder).                                
    end method.
    
    method public void AddSort (pcBufferName as char,
                                pcFieldName as char,
                                poSortDirection as SortDirectionEnum,
                                piOrder as integer ):
        define buffer lbSort for ttSort.
        
        find lbSort where
             lbSort.BufferName = pcBufferName and
             lbSort.FieldName = pcFieldName
             no-error.
        if not available lbSort then
        do:
            create lbSort.
            assign lbSort.BufferName = pcBufferName
                   lbSort.FieldName = pcFieldName.
        end.
        
        assign lbSort.Direction = poSortDirection
               lbSort.Order     = piOrder.
        
        OnQueryDefinitionChanged(new QueryDefinitionEventArgs(QueryElementEnum:Sort, QueryDefinitionOperationEnum:Create)).
    end method.
    
    method public void ClearFilters():
        empty temp-table ttFilter.
        
        OnQueryDefinitionChanged(new QueryDefinitionEventArgs(QueryElementEnum:Sort, QueryDefinitionOperationEnum:Empty)).
    end method.
        
    method public void ClearSort():
        empty temp-table ttSort.
        
        OnQueryDefinitionChanged(new QueryDefinitionEventArgs(QueryElementEnum:Filter, QueryDefinitionOperationEnum:Empty)).
    end method.

    method public void ClearJoins():
        empty temp-table ttJoin.
        
        OnQueryDefinitionChanged(new QueryDefinitionEventArgs(QueryElementEnum:Join, QueryDefinitionOperationEnum:Empty)).
    end method.
    
    method public void ClearBuffers():
        empty temp-table ttBuffer.
        NumBuffers = 0.
        
        OnQueryDefinitionChanged(new QueryDefinitionEventArgs(QueryElementEnum:Buffer, QueryDefinitionOperationEnum:Empty)).
    end method.
    
    method public void ClearAll():
        this-object:QueryBlockType = ?.
        
        this-object:ClearBuffers().
        this-object:ClearFilters().
        this-object:ClearJoins().
        this-object:ClearSort().
    end method.
    
    method public character extent GetBufferList():
        define variable cTables as char extent no-undo.
        define variable oDummy as EnumMember extent no-undo.
        
        return GetBufferList(output cTables, output oDummy, output oDummy).
    end method.
    
    method public character extent GetBufferList(output pcTables as char extent,
                                                 output poQueryTypes as QueryTypeEnum extent,
                                                 output poLockModes as LockModeEnum extent):
        
        define variable cBuffer as character extent no-undo.
        define variable iExtentSize as integer no-undo.
        define variable iExtent as integer no-undo.
        
        define buffer lbBuffer for ttBuffer.
        define query qryBuffer for lbBuffer.
        
        open query qryBuffer preselect each lbBuffer.
        
        iExtentSize = max(1, query qryBuffer:num-results).
        
        extent(cBuffer) = iExtentSize.
        extent(pcTables) = iExtentSize.
        extent(poQueryTypes) = iExtentSize.
        extent(poLockModes) = iExtentSize.
         
        query qryBuffer:get-first().
        iExtent = 1.
        do while not query qryBuffer:query-off-end:
            assign cBuffer[iExtent] = lbBuffer.BufferName
                   pcTables[iExtent] = lbBuffer.TableName
                   poQueryTypes[iExtent] = cast(lbBuffer.QueryType, QueryTypeEnum)
                   poLockModes[iExtent] = cast(lbBuffer.LockMode, LockModeEnum)
                   iExtent = iExtent + 1.
            
            query qryBuffer:get-next().
        end.
        
        close query qryBuffer.
        
        return cBuffer.        
    end method.

    method public void AddBuffer(pcBuffer as character):
        AddBuffer(pcBuffer, pcBuffer).
    end method.
            
    method public void AddBuffer(pcBuffer as char, pcTable as char):        
        AddBuffer(pcBuffer,
                  pcTable,
                  QueryTypeEnum:Default,
                  LockModeEnum:Default).
    end method.
            
    method public void AddBuffer(pcBuffer as char,
                                 pcTable as char,
                                 poQueryType as QueryTypeEnum,
                                 poLockMode as LockModeEnum):
        define buffer lbBuffer for ttBuffer.
        
        create lbBuffer.
        assign lbBuffer.BufferName = pcBuffer
               lbBuffer.TableName = (if pcTable eq '' then pcBuffer else pcTable)
               NumBuffers = NumBuffers + 1 
               lbBuffer.Order = NumBuffers
               lbBuffer.LockMode = poLockMode
               lbBuffer.QueryType = poQueryType.
        
        OnQueryDefinitionChanged(new QueryDefinitionEventArgs(QueryElementEnum:Buffer, QueryDefinitionOperationEnum:Create)).
    end method.

    method public void SetBuffers(pcBuffer as char extent, pcTable as char extent):
        define variable iLoop as integer no-undo.
                       
        do iLoop = 1 to extent(pcBuffer):
            /* Let AddBuffer figure order out */
            AddBuffer(pcBuffer[iLoop], pcTable[iLoop]).
        end.
    end method.
            
    method public void SetBuffers(pcBuffer as char extent):
        SetBuffers(pcBuffer, pcBuffer).
    end method.
        
    method public void SetBufferTable(pcBuffer as char, pcTable as char):
        define buffer lbBuffer for ttBuffer.
        
        find lbBuffer where lbBuffer.BufferName = pcBuffer no-error.
        if not available lbBuffer then
            AddBuffer(pcBuffer, pcTable).
        else
            lbBuffer.TableName = pcTable.
        
        OnQueryDefinitionChanged(new QueryDefinitionEventArgs(QueryElementEnum:Buffer, QueryDefinitionOperationEnum:Update)).
    end method.
    
    method public void SetBufferLockMode(pcBuffer as char, poLockMode as LockModeEnum):
        define buffer lbBuffer for ttBuffer.
        
        find lbBuffer where lbBuffer.BufferName = pcBuffer no-error.
        if not available lbBuffer then
            AddBuffer(pcBuffer).
        else
            lbBuffer.LockMode = poLockMode.
            
        OnQueryDefinitionChanged(new QueryDefinitionEventArgs(QueryElementEnum:Buffer, QueryDefinitionOperationEnum:Update)).
    end method.
    
    method public void SetBufferQueryType(pcBuffer as char, poQueryType as QueryTypeEnum):
        define buffer lbBuffer for ttBuffer.
        
        find lbBuffer where lbBuffer.BufferName = pcBuffer no-error.
        if not available lbBuffer then
            AddBuffer(pcBuffer).
        else
            lbBuffer.QueryType = poQueryType.
        
        OnQueryDefinitionChanged(new QueryDefinitionEventArgs(QueryElementEnum:Buffer, QueryDefinitionOperationEnum:Update)).
    end method.
            
    method public QueryTypeEnum GetBufferQueryType(pcBuffer as char):
        define variable oType as QueryTypeEnum no-undo.
        define buffer lbBuffer for ttBuffer.
        
        find lbBuffer where lbBuffer.BufferName = pcBuffer no-error.        
        if available lbBuffer then 
            oType = cast(lbBuffer.QueryType, QueryTypeEnum).
        
        return oType.
    end method.
    
    method public LockModeEnum GetBufferLockMode(pcBuffer as char):
        define variable oMode as LockModeEnum no-undo.
        define buffer lbBuffer for ttBuffer.
        
        find lbBuffer where lbBuffer.BufferName = pcBuffer no-error.        
        if available lbBuffer then 
            oMode = cast(lbBuffer.LockMode, LockModeEnum).
        
        return oMode.
    end method.
    
    method public character GetBufferTable(pcBuffer as char):
        define variable cTable as char no-undo.
        define buffer lbBuffer for ttBuffer.
        
        find lbBuffer where lbBuffer.BufferName = pcBuffer no-error.        
        if available lbBuffer then 
            cTable = lbBuffer.TableName.
        
        return cTable.        
    end method.
    
    constructor public QueryDefinition():
        super ().
    end constructor.
    
    method public void AddJoin (pcBufferName as char,
                                pcFieldName as char,
                                poOperator as OperatorEnum,
                                pcJoinBufferName as char,
                                pcJoinFieldName as char,
                                poJoinType as JoinEnum):
        define buffer lbJoin for ttJoin.
        
        create lbJoin.
        assign lbJoin.BufferName = pcBufferName
               lbJoin.FieldName = pcFieldName
               lbJoin.Operator = poOperator
               lbJoin.JoinBufferName = pcJoinBufferName
               lbJoin.JoinFieldName = pcJoinFieldName
               lbJoin.JoinType = poJoinType.
        
        OnQueryDefinitionChanged(new QueryDefinitionEventArgs(QueryElementEnum:Join, QueryDefinitionOperationEnum:Create)).
    end method.
    
    method public logical Equals(poQuery as QueryDefinition):
        define variable lEquals as logical no-undo.
        define variable cThis as longchar no-undo.
        define variable cThat as longchar no-undo.
        define variable oOOS as ObjectOutputStream no-undo.
        
        if not valid-object(poQuery) then
            lEquals = false.            
        else
        /* if this is exactly the same object reference, then it's
           exactly the same object (ahem). */
        if int(poQuery) eq int(this-object) then
            lEquals = true.
        else
            lEquals = super:Equals(poQuery).
        
        /* the super call might do way more simple checks, but if we're not equal at that point, 
           we certainly won't pass this test. */
        if lEquals then
            lEquals = compare(this-object:GetMD5(),
                              OperatorEnum:IsEqual:ToString(),
                              poQuery:GetMD5(),
                              CompareStrengthEnum:Raw:ToString()).
        
        return lEquals.
    end method.
    
    method public char GetMD5():
        define variable oOOS as ObjectOutputStream no-undo.        
        def var mStream as memptr.
        
        oOOS = new ObjectOutputStream().
        oOOS:WriteObject(this-object).
        oOOS:Write(output mStream).
        
        return string(md5-digest(mStream)).
        
        finally:
            set-size(mStream) = 0.
        end finally.
    end method.
    
    method protected void OnQueryDefinitionChanged (poEventArgs as QueryDefinitionEventArgs):
        this-object:QueryDefinitionChanged:Publish(
                this-object,
                new QueryDefinitionEventArgs(QueryElementEnum:Join, QueryDefinitionOperationEnum:Create)).
    end method.
    
    method public void WriteObject(po as ObjectOutputStream):
        po:WriteObject(QueryBlockType).
        
        po:WriteTable(buffer ttBuffer:handle).
        po:WriteTable(buffer ttFilter:handle).
        po:WriteTable(buffer ttJoin:handle).
        po:WriteTable(buffer ttSort:handle).
    end method.
    
    method public void ReadObject(po as ObjectInputStream):
        QueryBlockType = cast(po:ReadObject(), QueryBlockTypeEnum).
        
        po:ReadTable(table ttBuffer by-reference).
        po:ReadTable(table ttFilter by-reference).
        po:ReadTable(table ttJoin by-reference).
        po:ReadTable(table ttSort by-reference).
    end method.
    
    method public override Object Clone():
        define variable oClone as IQueryDefinition no-undo.
        define variable oOOS as ObjectOutputStream no-undo.
        define variable oOIS as ObjectInputStream no-undo.
        define variable mStream as memptr no-undo.
        
        /* We know we can serialize this object, so use that. */
        set-byte-order(mStream) = ByteOrderEnum:BigEndian:Value.
        
        oOOS = new ObjectOutputStream().        
        oOOS:WriteObject(this-object).
        oOOS:Write(output mStream).
        
        oOIS = new ObjectInputStream().
        oOIS:Read(mStream).
        oClone = cast(oOIS:ReadObject(), IQueryDefinition).
        
        return oClone.
        
        /* no, we don't like memory leaks. */
        finally:
            set-size(mStream) = 0.
        end finally.
    end method.
   
    method public character GetQueryString():
        return GetQueryString(GetBufferList()). 
    end.
    
    method public character GetQueryString(pcBuffers as char extent):
        define variable cTables as character extent no-undo.
        define variable iExtent as integer no-undo.
        define variable cJoin as character no-undo.
        define variable cFilter as character no-undo.
        define variable cWhere as character no-undo.
        define variable cBufferName as character no-undo.
        define variable cQueryBufferList as character no-undo.
        
        define buffer lbBuffer for ttBuffer.  
        
        cWhere = this-object:QueryBlockType:ToString().
        do iExtent = 1 to extent(pcBuffers):
            cBufferName = pcBuffers[iExtent].
            find lbBuffer where lbBuffer.BufferName = cBufferName no-error.
            
            assign cQueryBufferList = cQueryBufferList + ',' + lbBuffer.BufferName 
                   cJoin = GetJoin(cQueryBufferList, cBufferName)
                   cFilter = GetFilter(cBufferName)
                   
                   /* Note: where string broken up for readability. */
                   cWhere = cWhere + ' ' 
                          + cast(lbBuffer.QueryType,EnumMember):ToString() + ' ' 
                          + lbBuffer.BufferName.
           
            
            if cJoin ne '' then
            do:
                cWhere = cWhere + ' where ' + cJoin.
                if cFilter ne '' then
                    cWhere = cWhere + JoinEnum:And:ToString() + ' (' + cFilter + ') '.
            end.
            else
            if cFilter ne '' then
                cWhere = cWhere + ' where ' + cFilter.
            
            /* lock status and terminate */
            cWhere = cWhere
                   + ' ' + cast(lbBuffer.LockMode,EnumMember):ToString() + ' '
                   + (if iExtent ne extent(pcBuffers) then ', ' else '').
        end.
        
        return cWhere + ' ' + GetSort(pcBuffers).
    end method.
    
    method public character GetSort():
        return GetSort(GetBufferList()).
    end method.
    
    method public character GetSort(pcBufferName as char extent):
        define variable cSort as character no-undo.
        define variable iLoop as integer no-undo.
        define variable iMax as integer no-undo.
        define variable oSortDirection as EnumMember no-undo.
        
        define buffer lbSort for ttSort.
        
        iMax = extent(pcBufferName).
        do iLoop = 1 to iMax:
            for each lbSort where
                     lbSort.BufferName = pcBufferName[iLoop]
                     by lbSort.Order:
                assign oSortDirection = cast(lbSort.Direction, EnumMember)
                       cSort = cSort + ' by '
                             + lbSort.BufferName 
                             + '.'
                             + lbSort.FieldName                      
                             + ' ' 
                             + (if oSortDirection:Equals(SortDirectionEnum:Ascending) then '' 
                                else oSortDirection:ToString() ).
            end.
        end.
        
        return cSort.
    end method.
    
    method public character GetFilter(pcBufferName as char):
        define variable cWhereClause as character no-undo.
        
        define buffer lbFilter for ttFilter.
        
        for each lbFilter where lbFilter.BufferName = pcBufferName:
            if cWhereClause <> ' ' then
                cWhereClause = cWhereClause + ' '
                              + cast(lbFilter.JoinType, EnumMember):ToString() + ' '.
            
            cWhereClause = cWhereClause + ' '
                          + lbFilter.BufferName + '.' + lbFilter.FieldName + ' ' 
                          + cast(lbFilter.Operator, EnumMember):ToString() + ' '
                          + quoter(lbFilter.FieldValue).
        end.
        
        return cWhereClause. 
    end method.
    
    method protected character GetJoin(pcBuffersInQuery as character, pcBufferName as character):
        define variable cWhereClause as character no-undo.
        
        define buffer lbJoin for ttJoin.

        define variable iExtentSize as integer no-undo.
        define variable iExtent as integer no-undo.
           
        for each lbJoin where 
                 lbJoin.BufferName = pcBufferName or
                 lbJoin.JoinBufferName = pcBufferName:
                
            if can-do(pcBuffersInQuery, lbJoin.BufferName) and 
               can-do(pcBuffersInQuery, lbJoin.JoinBufferName) then
            do:
                      
                if cWhereClause <> '' then
                    cWhereClause = cWhereClause + ' '
                                  + cast(lbJoin.JoinType, EnumMember):ToString() + ' '.
            
                cWhereClause = cWhereClause
                             + lbJoin.BufferName + '.' + lbJoin.FieldName + ' ' 
                             + cast(lbJoin.Operator, EnumMember):ToString() + ' '
                             + lbJoin.JoinBufferName + '.' + lbJoin.JoinFieldName.
            end.
        end.
        
        return cWhereClause. 
    end method.
    
end class.
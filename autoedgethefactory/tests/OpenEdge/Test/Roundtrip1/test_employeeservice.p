/*------------------------------------------------------------------------
    File        : test_employeeservice.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : pjudge
    Created     : Mon Nov 15 09:13:10 EST 2010
    Notes       :
  ----------------------------------------------------------------------*/
using OpenEdge.Test.Roundtrip1.BusinessComponents.EmployeeBE.
using OpenEdge.Test.Roundtrip1.BusinessComponents.EmployeeDA.
using OpenEdge.Test.Roundtrip1.BusinessComponents.EmployeeDS.
using OpenEdge.Test.Roundtrip1.BusinessComponents.DepartmentDS.
using OpenEdge.Test.Roundtrip1.BusinessComponents.FamilyDS.

using OpenEdge.BusinessComponent.Entity.IBusinessEntity.
using OpenEdge.DataAccess.IDataAccess.
using OpenEdge.DataSource.IDataSource.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceMessage.
using OpenEdge.CommonInfrastructure.Common.ComponentInfo.  
using OpenEdge.CommonInfrastructure.Common.IServiceManager.
using OpenEdge.CommonInfrastructure.Client.ServiceManager.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceProvider.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceResponse.  
using OpenEdge.CommonInfrastructure.ServiceMessage.IFetchRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IFetchResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.FetchRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.FetchResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.ISaveRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.SaveRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.IServiceMessage.

using OpenEdge.Core.System.ApplicationError.
using OpenEdge.Core.System.IQueryDefinition.
using OpenEdge.Lang.ABLSession.
using Progress.Lang.Class.
using OpenEdge.CommonInfrastructure.ServiceMessage.ITableContext.
using OpenEdge.CommonInfrastructure.ServiceMessage.TableContext.
using OpenEdge.CommonInfrastructure.ServiceMessage.ITableRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.TableRequest.
using OpenEdge.CommonInfrastructure.ServiceMessage.ServiceMessageActionEnum.
using OpenEdge.CommonInfrastructure.ServiceMessage.ISaveResponse.
using OpenEdge.CommonInfrastructure.ServiceMessage.ITableResponse.
using Openedge.Lang.String.


/** --  variables -- **/
def var oBE as IBusinessEntity.
def var oDA as IDataAccess.
def var oServiceManager as IServiceManager.
def var oFetchRequest as IFetchRequest.
def var oFetchResponse as IFetchResponse.
def var oSaveResponse as ISaveResponse.

def var MasterDataset as handle.

/** ------- function  defs  ------- **/
function BuildFetchRequest returns IFetchRequest (input poAction as ServiceMessageActionEnum):
    define variable oFetchRequest as IFetchRequest no-undo.
    define variable oTableContext as ITableContext no-undo.
    define variable oTableRequest as ITableRequest no-undo.
    define variable iMax as integer no-undo.
    define variable iLoop as integer no-undo. 
    define variable oTR as ITableRequest no-undo.
    def var cTable as char.
    
    oFetchRequest = new FetchRequest('EmployeeService', poAction).
    
    cTable = 'eEmployee'.
    oTR = new TableRequest(cTable).
    oFetchRequest:TableRequests:Put(cTable, oTR).
    cast(oTR, IQueryDefinition):AddFilter(cTable,
                                          'EmpNum',
                                          OpenEdge.Lang.OperatorEnum:LessEqual,
                                          '30',
                                          OpenEdge.Lang.DataTypeEnum:Integer,
                                          OpenEdge.Lang.JoinEnum:And).
    cTable = 'eDepartment'.
    oTR = new TableRequest(cTable).
    oFetchRequest:TableRequests:Put(cTable, oTR).
    
    cTable = 'eFamily'.
    oTR = new TableRequest(cTable).
    oFetchRequest:TableRequests:Put(cTable, oTR).
    
    return oFetchRequest. 
end.

function BuildSaveRequest returns ISaveRequest ():
    define variable oSaveRequest as ISaveRequest no-undo.
    def var cTable as char extent.
    define variable iLoop as integer no-undo.
    define variable iMax as integer no-undo.
    define variable hTransportDataset as handle no-undo.
    
    oSaveRequest = new SaveRequest('EmployeeService').
    
/*    
    cTable[1] = 'eEmployee'.
    oSaveRequest:TableNames = cTable.
*/
    
    /* Get the change data */
    create dataset hTransportDataset.
    hTransportDataset:create-like(MasterDataset).
    hTransportDataset:get-changes(MasterDataset).
        
    /* Put the PDS into the message */
    cast(oSaveRequest, IServiceMessage):SetMessageData(
            hTransportDataset,
            OpenEdge.CommonInfrastructure.ServiceMessage.DataFormatEnum:ProDataSet).
            
    extent(cTable) = MasterDataset:num-buffers.             
    
    def var hbuf as handle.
    /* We set the ISaveRequest:TableNames property, but we
        can probably also derive that from the dataset. */
    do iLoop = 1 to extent(ctable):
        hbuf = hTransportDataset:get-buffer-handle(iLoop).
        
        if hbuf:before-buffer:table-handle:has-records then
            assign cTable[iLoop] = hBuf:name
                   imax = imax + 1.
    end.
    
    if iMax eq 0 then
        return error.
    
    extent(oSaveRequest:TableNames) = imax.
    imax = 0.
    do iLoop = 1 to extent(ctable):         
        imax = imax + 1.
        if cTable[iloop] ne '' then
            oSaveRequest:TableNames[imax] = ctable[iloop].
    end.
    
    return oSaveRequest. 
end.

function EnableDatasetForUpdate returns logical (phDataset as handle):
        define variable iLoop   as integer no-undo.
        define variable hBuffer as handle  no-undo.
        
        do iLoop = 1 to phDataset:num-buffers:
            hBuffer = phDataset:get-buffer-handle(iLoop).
            hBuffer:table-handle:tracking-changes = true.
        end.
end function.
        
function DisableDatasetForUpdate returns logical (phDataset as handle):
        define variable iLoop   as integer no-undo.
        define variable hBuffer as handle  no-undo.
        
        do iLoop = 1 to phDataset:num-buffers:
            hBuffer = phDataset:get-buffer-handle(iLoop).
            hBuffer:table-handle:tracking-changes = no.
        end.
end function.

/** -------------- **/
oServiceManager = new ServiceManager(?).

oDA = new EmployeeDA().
oDA:DataSources:Put(new String('employee'), new EmployeeDS()).
oDA:DataSources:Put(new String('department'), new DepartmentDS()).
oDA:DataSources:Put(new String('family'), new FamilyDS()).

oBE = new EmployeeBE(
        oDA,
        oServiceManager,
        new ComponentInfo(Class:GetClass('OpenEdge.Test.Roundtrip1.BusinessComponents.EmployeeBE'))).

/*run test_1_fetchschema (output dataset-handle MasterDataset).
delete object MasterDataset.
*/
 
run test_2_fetchdata(output dataset-handle MasterDataset).

run display_data(MasterDataset).

run test_3_save(MasterDataset).


procedure test_1_fetchschema:
    def output param dataset-handle hDS.
           
    oFetchResponse = oBE:FetchSchema(BuildFetchRequest(ServiceMessageActionEnum:FetchSchema)).
    
    cast(oFetchResponse, IServiceMessage):GetMessageData(output hds).
    
    hds:write-json('file', session:temp-dir + 'EmployeeService_Schema.json', true).
end procedure.    

procedure test_2_fetchdata:
    def output param dataset-handle hDS.

    /** -- get data -- **/
    oBE:FetchData(BuildFetchRequest(ServiceMessageActionEnum:Fetch)).
    oFetchResponse = oBE:GetData().
    cast(oFetchResponse, IServiceMessage):GetMessageData(output hds).
    
    hds:write-json('file', session:temp-dir + 'EmployeeService_Data.json', true).
    
end procedure.

procedure display_data:
    def input param hDS as handle.
    
    /** -- display it -- **/
    def var hqry as handle.
    def var hbuf as handle.
    def var hfld-1 as handle.
    def var hfld-2 as handle.
    
    hbuf = hDS:get-buffer-handle(1).
    hfld-1 = hBuf:buffer-field(1).
    hfld-2 = hBuf:buffer-field(2).
     
    create query hqry.
    hqry:set-buffers(hbuf).
    hqry:query-prepare('for each ' + hbuf:name).
    hqry:query-open().
    
    hqry:get-last().
    do while hBuf:available:
        message
            hfld-1:name hfld-1:buffer-value skip
            hfld-2:name hfld-2:buffer-value skip    
        view-as alert-box error title '[PJ DEBUG]'.
        
        leave.
/*        hqry:get-next().*/
    end.
    
    hqry:query-close().
    delete object hqry.
end procedure.

procedure test_3_save:
    def input param hDS as handle.
    
    define variable hbuf as handle no-undo.
    def var hTransport as handle.
    def var i as int.
    def var oTR as ITableResponse.
    def var i2 as int.
    def var oKeys as String extent.
    def var oTexts as String extent.
    def var cStrVal1 as character.
    def var cStrVal2 as character.
    
    hbuf = MasterDataset:get-buffer-handle('eEmployee').

    EnableDatasetForUpdate(MasterDataset).
        
    /** -- add a row --  
    do transaction:
        hbuf:buffer-create().
        hbuf::EmpNum = 9999.
        hbuf::FirstName = 'Alan'.
        hBuf::LastName = 'O~'Malley'.
        hBuf::DeptCode = '100'.
        hbuf:buffer-release().
    end.
    */
        
    /** -- delete a row --  
    hBuf:find-first('where eEmployee.EmpNum = ' + quoter(9999)).
    do transaction:
        hbuf:buffer-delete().
        hbuf:buffer-release().
    end.
    */
    
    /* -- modify a row  -- */ 
    hBuf:find-first('where eEmployee.EmpNum = ' + quoter(9999)).
    do transaction:
                
        if hbuf::State eq 'MA' then
            hbuf::State = 'NH'.
        else
            hbuf::State = 'MA'.
            
        hbuf:buffer-release().
    end.
    /* */
    
    /** --  -- **/
    oSaveResponse = oBE:SaveData(BuildSaveRequest()).
    
    cast(oSaveResponse, IServiceMessage):GetMessageData(output htransport).
    
    htransport:write-json('file', session:temp-dir + 'EmployeeService_SaveTransport.json', true).

    if cast(oSaveResponse, IServiceResponse):HasError then
    do:
        do i = 1 to num-entries(cast(oSaveResponse, IServiceResponse):ErrorText, '|'):
            cstrval1 = entry(i, cast(oSaveResponse, IServiceResponse):ErrorText, '|').
            
            oTR  = cast(oSaveResponse:TableResponses:Get(new String(cstrval1)) , ITableResponse).
            
            okeys = cast(otr:ErrorText:KeySet:ToArray(), String).
            otexts = cast(otr:ErrorText:Values:ToArray(), String).
            
            do i2 = 1 to extent(okeys):
                cstrval1 = oKeys[i2]:Value.
                cstrval2 = oTexts[i2]:Value.
                
                message
                    'error in table ' oTR:TableName skip(2)
                    'key=' cstrval1 ' with text ' cstrval2 
                view-as alert-box error title '[ERROR]'.                                    
            end.
        end.
    end.    
    else
    do:
        DisableDatasetForUpdate(MasterDataset).
            
        hTransport:merge-changes(MasterDataset, true).
            
        EnableDatasetForUpdate(MasterDataset).
        
        run display_data(MasterDataset).
    end.
    
    hds:write-json('file', session:temp-dir + 'EmployeeService_Save.json', true).
    
end procedure.

/** ----------------- **/
catch oException as ApplicationError:
    oException:LogError().
    oException:ShowError().
end catch.

catch oError as Progress.Lang.Error:
    message
        oError:GetMessage(1)      skip
        '(' oError:GetMessageNum(1) ')' skip(2)        
        oError:CallStack
        view-as alert-box error title 'Unhandled Progress.Lang.Error'.
end catch.

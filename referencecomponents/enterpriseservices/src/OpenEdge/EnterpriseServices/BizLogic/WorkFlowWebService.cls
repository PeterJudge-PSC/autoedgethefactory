/** ------------------------------------------------------------------------
    File        : WorkFlowWebService
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : pjudge
    Created     : Fri Jul 02 15:16:37 EDT 2010
    Notes       : * Some of the operations herein - particularly those that have
                    primitive and/or void arguments (in and out) use the RUN syntax
                    and let the ABL perform the datatype transformations.
                    The other operations - those that use the complex types descended
                    from the SavvionType - construct SOAP messages coming and going. 
                    There are currently no mixed-mode calls (where the inputs are primitives and
                    the outputs SOAP) although that's probably a candidate for refactoring.
  ---------------------------------------------------------------------- */
{routinelevel.i}

using OpenEdge.EnterpriseServices.BizLogic.IBizLogicAPI.
using OpenEdge.EnterpriseServices.BizLogic.WorkFlowWebService.
using OpenEdge.EnterpriseServices.BizLogic.SavvionType.
using OpenEdge.EnterpriseServices.BizLogic.ProcessTemplate.
using OpenEdge.EnterpriseServices.BizLogic.ProcessInstance.
using OpenEdge.EnterpriseServices.BizLogic.WorkItem.
using OpenEdge.EnterpriseServices.BizLogic.WorkStepTemplate.
using OpenEdge.EnterpriseServices.BizLogic.WorkStepInstance.
using OpenEdge.EnterpriseServices.BizLogic.DataSlotTemplate.
using OpenEdge.EnterpriseServices.BizLogic.DataSlotInstance.

using OpenEdge.Core.XML.WebServiceProtocol.
using OpenEdge.Core.XML.SaxWriter.

using OpenEdge.Lang.Assert.
using Progress.Lang.Object.
using Progress.Lang.Class.

class OpenEdge.EnterpriseServices.BizLogic.WorkFlowWebService inherits WebServiceProtocol
        implements IBizLogicAPI:
    
    define private variable mcPortType as character initial 'WorkFlowWS' no-undo.
    define private variable moSaxWriter as SaxWriter no-undo.
    define private variable mhSoapMessage as memptr no-undo.
    
    constructor public WorkFlowWebService(input pcHost as character):
        super('WorkFlowService',
              substitute('http://&1/sbm/services/BizLogic1?wsdl', pcHost),
              '').
        
        InitializeSaxWriter().
    end constructor.
    
    destructor public WorkFlowWebService():
        set-size(mhSoapMessage) = 0.
    end destructor.
    
/*  BizLogicAPI implementations */
    method public character Connect(input pcUser as character,
                                    input pcPassword as character):
        define variable cSessionId as character no-undo.
        
        ConnectService().
        
        run connect in ConnectPortType(mcPortType) (
                input pcUser,
                input pcPassword,
                output cSessionId).
        
        return cSessionId.
        finally:
            DisconnectPortType().
            DisconnectService().
        end finally.        
    end method.
    
    method public void Disconnect(input pcSessionId as longchar):
        Assert:ArgumentNotNullOrEmpty(pcSessionId, 'Session Id').
        
        ConnectService().
        
        run disconnect in ConnectPortType(mcPortType) (input pcSessionId).
        
        finally:
            DisconnectPortType().
            DisconnectService().
        end finally.
    end method.
            
    method public character GetStatus().
        define variable cStatus as character no-undo.
        
        ConnectService().
        
        run getStatus in ConnectPortType(mcPortType) (output cStatus).
        
        return cStatus.        
        finally:
            DisconnectPortType().
            DisconnectService().
        end finally.        
    end method.
    
    method public ProcessTemplate GetProcessTemplate(input pcSessionId as longchar,
                                                     input pcProcessTemplateName as character):
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        define variable oPT as SavvionType extent no-undo.
        define variable cOutputParam as longchar no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'getProcessTemplate'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', pcSessionId, cNamespace).
            WriteElement('ptName', pcProcessTemplateName, cNamespace).
        EndSoapMessage(cOperation, cNamespace).
        
        cOutputParam = ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).
        
        oPT = SavvionType:XMLToArray(cOutputParam,
                                     cOperation,
                                     Class:GetClass('OpenEdge.EnterpriseServices.BizLogic.ProcessTemplate')).
        
        return cast(oPT[1] , ProcessTemplate).                                                             
    end method.
    
    method public logical IsSessionValid(input pcSessionId as longchar).
        define variable lValidSession as logical no-undo.
        
        ConnectService().
        
        run isSessionValid in ConnectPortType(mcPortType) (input pcSessionId, output lValidSession).
        
        return lValidSession.
        finally:
            DisconnectPortType().
            DisconnectService().
        end finally.        
    end method.
    
    method public ProcessTemplate extent GetUserAuthorizedProcessTemplateList(input pcSessionId as longchar):
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        define variable oPT as ProcessTemplate extent no-undo.
        define variable cOutputParam as longchar no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'getUserAuthorizedProcessTemplateList'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', pcSessionId, cNamespace).
        EndSoapMessage(cOperation, cNamespace).
        
        cOutputParam = ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).

        return cast(SavvionType:XMLToArray(
                        cOutputParam,
                        cOperation,
                        Class:GetClass('OpenEdge.EnterpriseServices.BizLogic.ProcessTemplate'))
                , ProcessTemplate).    
    end method.
    
    method public void CompleteWorkItem(input pcSessionId as longchar,
                                        input pcWorkItemName as character,
                                        input poDataSlotInstance as DataSlotInstance extent):
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'completeWorkItem'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', pcSessionId, cNamespace).
            WriteElement('wiName', pcWorkItemName, cNamespace).
            if extent(poDataSlotInstance) ne ? then
                SavvionType:ArrayToXML(moSaxWriter,
                                       'dsi',
                                       cNamespace,
                                       poDataSlotInstance).
        EndSoapMessage(cOperation, cNamespace).
        
        ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).
    end method.
    
    method public ProcessInstance extent GetProcessInstanceList(input pcSessionId as longchar):
        define variable cOutputParam as longchar no-undo.
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        define variable oPI as SavvionType extent no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'getProcessInstanceList'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', pcSessionId, cNamespace).
        EndSoapMessage(cOperation, cNamespace).
        
        cOutputParam = ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).
        oPI = SavvionType:XMLToArray(cOutputParam,
                    cOperation,
                    Class:GetClass('OpenEdge.EnterpriseServices.BizLogic.ProcessInstance')).                         
        
        return cast(oPI, ProcessInstance).
    end method.
            
    method public void AssignWorkItem(input pcSessionId as longchar,
                                      input pcWorkItemName as character,
                                      input pcPerformer as character):
        ConnectService().
        
        run assignWorkItem in ConnectPortType(mcPortType) (
                    input pcSessionId,
                    input pcWorkItemName,
                    input pcPerformer).
        
        finally:
            DisconnectPortType().
            DisconnectService().
        end finally.        
    end method.
            
    method public int64 GetProcessTemplateID(input pcSessionId as longchar,
                                             input pcProcessTemplateName as character):
        define variable cPTId as int64 no-undo.
        
        ConnectService().
        
        run getProcessTemplateID in ConnectPortType(mcPortType) (
                    input pcSessionId,
                    input pcProcessTemplateName,
                    output cPTId).
                    
        return cPTId.
        finally:
            DisconnectPortType().
            DisconnectService().
        end finally.        
    end method.
            
    method public ProcessInstance CreateProcessInstance(input pcSessionId as longchar,
                                                        input pcProcessTemplateName as character,
                                                        input pcProcessInstanceNamePrefix as character,
                                                        input pcPriority as character,
                                                        input poDataSlotTemplate as DataSlotTemplate extent):
        define variable cOutputParam as longchar no-undo.
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        define variable oPI as SavvionType extent no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'createProcessInstance'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', pcSessionId, cNamespace).
            WriteElement('ptName', pcProcessTemplateName, cNamespace).
            WriteElement('piNamePrefix', pcProcessInstanceNamePrefix, cNamespace).
            WriteElement('priority', pcPriority, cNamespace).
            if extent(poDataSlotTemplate) ne ? then
                SavvionType:ArrayToXML(moSaxWriter,
                                       'dst',
                                       cNamespace,
                                       poDataSlotTemplate).
        EndSoapMessage(cOperation, cNamespace).
        
        cOutputParam = ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).
        oPI = SavvionType:XMLToArray(cOutputParam,
                    cOperation,
                    Class:GetClass('OpenEdge.EnterpriseServices.BizLogic.ProcessInstance')).                         
        
        return cast(oPI[1], ProcessInstance).
    end method.
            
    method public WorkStepInstance GetWorkStepInstance(input pcSessionId as longchar,
                                                       input pcProcessInstanceName as character,
                                                       input pcWorkStepName as character):
        define variable cOutputParam as longchar no-undo.
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        define variable oWSI as SavvionType extent no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'getWorkStepInstance'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', pcSessionId, cNamespace).
            WriteElement('piName', pcProcessInstanceName, cNamespace).
            WriteElement('wsName', pcWorkStepName, cNamespace).
        EndSoapMessage(cOperation, cNamespace).
        
        cOutputParam = ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).
        oWSI = SavvionType:XMLToArray(cOutputParam,
                    cOperation,
                    Class:GetClass('OpenEdge.EnterpriseServices.BizLogic.WorkStepInstance')).
        
        return cast(oWSI[1], WorkStepInstance).
    end method.
            
    method public WorkStepTemplate GetWorkStepTemplate(input pcSessionId as longchar,
                                                       input pcProcessTemplateName as character,
                                                       input pcWorkStepName as character):
        define variable cOutputParam as longchar no-undo.
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        define variable oWST as SavvionType extent no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'getWorkStepTemplate'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', pcSessionId, cNamespace).
            WriteElement('ptName', pcProcessTemplateName, cNamespace).
            WriteElement('wsName', pcWorkStepName, cNamespace).
        EndSoapMessage(cOperation, cNamespace).
        
        cOutputParam = ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).
        oWST = SavvionType:XMLToArray(cOutputParam,
                    cOperation,
                    Class:GetClass('OpenEdge.EnterpriseServices.BizLogic.WorkStepTemplate')).
        
        return cast(oWST[1], WorkStepTemplate).
    end method.
    
    method public WorkItem extent GetAvailableWorkItemList(input pcSessionId as longchar):
        define variable cOutputParam as longchar no-undo.
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        define variable oWI as SavvionType extent no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'getAvailableWorkItemList'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', pcSessionId, cNamespace).
        EndSoapMessage(cOperation, cNamespace).
        
        cOutputParam = ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).
        oWI = SavvionType:XMLToArray(cOutputParam,
                    cOperation,
                    Class:GetClass('OpenEdge.EnterpriseServices.BizLogic.WorkItem')).
        
        return cast(oWI, WorkItem).
    end method.
            
    method public WorkItem extent GetAssignedWorkItemList(input pcSessionId as longchar).
        define variable cOutputParam as longchar no-undo.
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        define variable oWI as SavvionType extent no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'getAssignedWorkItemList'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', pcSessionId, cNamespace).
        EndSoapMessage(cOperation, cNamespace).
        
        cOutputParam = ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).
        oWI = SavvionType:XMLToArray(cOutputParam,
                    cOperation,
                    Class:GetClass('OpenEdge.EnterpriseServices.BizLogic.WorkItem')).
        
        return cast(oWI, WorkItem).
    end method.
            
    method public ProcessInstance GetProcessInstance(input pcSessionId as longchar,
                                                     input pcProcessInstanceName as character).
        define variable cOutputParam as longchar no-undo.
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        define variable oPI as SavvionType extent no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'getProcessInstance'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', pcSessionId, cNamespace).
            WriteElement('piName', pcProcessInstanceName, cNamespace).
        EndSoapMessage(cOperation, cNamespace).
        
        cOutputParam = ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).
        oPI = SavvionType:XMLToArray(cOutputParam,
                    cOperation,
                    Class:GetClass('OpenEdge.EnterpriseServices.BizLogic.ProcessInstance')).                         
        
        return cast(oPI[1], ProcessInstance).
    end method.
            
    method public WorkItem GetWorkItem(input pcSessionId as longchar,
                                       input pcWorkItemName as character).
        define variable cOutputParam as longchar no-undo.
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        define variable oWI as SavvionType extent no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'getWorkItem'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', pcSessionId, cNamespace).
            WriteElement('wiName', pcWorkItemName, cNamespace).
        EndSoapMessage(cOperation, cNamespace).
        
        cOutputParam = ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).
        oWI = SavvionType:XMLToArray(cOutputParam,
                    cOperation,
                    Class:GetClass('OpenEdge.EnterpriseServices.BizLogic.WorkItem')).
        
        return cast(oWI[1], WorkItem).
    end method.
            
    method public character extent GetProcessTemplateVersions(input pcSessionId as longchar,
                                                              input pcApplicationName as character).
        
        define variable cPTVersion as character extent no-undo. 
         
        ConnectService().
        
        run getProcessTemplateVersions in ConnectPortType(mcPortType)
                (input pcSessionId,
                 input pcApplicationName,
                 output cPTVersion).
        
        return cPTVersion.
        finally:
            DisconnectPortType().
            DisconnectService().
        end finally.        
    end method.
            
    method public void SetProcessInstancePriority(input pcSessionId as longchar,
                                                  input pcProcessInstanceName as character,
                                                  input pcPriority as character).
        ConnectService().
        
        run setProcessInstancePriority in ConnectPortType(mcPortType)
                (input pcSessionId,
                 input pcProcessInstanceName,
                 input pcPriority).
        
        finally:
            DisconnectPortType().
            DisconnectService().
        end finally.        
    end method.
            
    method public longchar GetProcessTemplateXML(input pcSessionId as longchar,
                                                 input pcProcessTemplateName as character).
        define variable cOutputParam as longchar no-undo.
        
        ConnectService().
        
        run getProcessTemplateXML in ConnectPortType(mcPortType)
                (input pcSessionId,
                 input pcProcessTemplateName,
                 output cOutputParam).
        
        return cOutputParam.
        finally:
            DisconnectPortType().
            DisconnectService().
        end finally.        
    end method.
            
    method public void RemoveProcessTemplate(input pcSessionId as longchar,
                                             input pcProcessTemplateName as character).
        ConnectService().
        
        run removeProcessTemplate in ConnectPortType(mcPortType)
                (input pcSessionId,
                 input pcProcessTemplateName).
        
        finally:
            DisconnectPortType().
            DisconnectService().
        end finally.        
    end method.
            
    method public void ResumeProcessInstance(input pcSessionId as longchar,
                                             input pcProcessInstanceName as character).
        ConnectService().
        
        run resumeProcessInstance in ConnectPortType(mcPortType)
                (input pcSessionId,
                 input pcProcessInstanceName).

        finally:
            DisconnectPortType().
            DisconnectService().
        end finally.        
    end method.
            
    method public void SuspendProcessInstance(input pcSessionId as longchar,
                                              input pcProcessInstanceName as character).
        ConnectService().
        
        run suspendProcessInstance in ConnectPortType(mcPortType)
                (input pcSessionId,
                 input pcProcessInstanceName).

        finally:
            DisconnectPortType().
            DisconnectService().
        end finally.        
    end method.
            
    method public logical IsProcessTemplateExist(input pcSessionId as longchar,
                                                 input pcProcessTemplateName as character).
        define variable lPTExists as logical no-undo.
        
        ConnectService().
        
        run isProcessTemplateExist in ConnectPortType(mcPortType)
                (input pcSessionId,
                 input pcProcessTemplateName,
                 output lPTExists).

        return lPTExists.
        finally:
            DisconnectPortType().
            DisconnectService().
        end finally.        
    end method.
            
    method public WorkItem extent GetProxyAssignedWorkItemList(input pcSessionId as longchar).
        define variable cOutputParam as longchar no-undo.
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        define variable oWI as SavvionType extent no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'getProxyAssignedWorkItemList'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', pcSessionId, cNamespace).
        EndSoapMessage(cOperation, cNamespace).
        
        cOutputParam = ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).
        oWI = SavvionType:XMLToArray(cOutputParam,
                    cOperation,
                    Class:GetClass('OpenEdge.EnterpriseServices.BizLogic.WorkItem')).
        
        return cast(oWI, WorkItem).
    end method.
            
    method public WorkItem extent GetProxyAvailableWorkItemList(input pcSessionId as longchar).
        define variable cOutputParam as longchar no-undo.
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        define variable oWI as SavvionType extent no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'getProxyAvailableWorkItemList'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', pcSessionId, cNamespace).
        EndSoapMessage(cOperation, cNamespace).
        
        cOutputParam = ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).
        oWI = SavvionType:XMLToArray(cOutputParam,
                    cOperation,
                    Class:GetClass('OpenEdge.EnterpriseServices.BizLogic.WorkItem')).
        
        return cast(oWI, WorkItem).
    end method.
            
    method public WorkItem extent GetSuspendedWorkItemList(input pcSessionId as longchar).
        define variable cOutputParam as longchar no-undo.
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        define variable oWI as SavvionType extent no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'getSuspendedWorkItemList'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', pcSessionId, cNamespace).
        EndSoapMessage(cOperation, cNamespace).
        
        cOutputParam = ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).
        oWI = SavvionType:XMLToArray(cOutputParam,
                    cOperation,
                    Class:GetClass('OpenEdge.EnterpriseServices.BizLogic.WorkItem')).
        
        return cast(oWI, WorkItem).
    end method.
            
    method public character extent GetUserAuthorizedProcessTemplateNames(input pcSessionId as longchar).
        define variable cTemplateName as character extent no-undo.
        
        ConnectService().
        
        run getUserAuthorizedProcessTemplateNames in ConnectPortType(mcPortType)
                (input pcSessionId,
                 output cTemplateName).

        return cTemplateName.                 
        finally:
            DisconnectPortType().
            DisconnectService().
        end finally.        
    end method.
    
    method public character GetProcessTemplateAppName(input pcSessionId as longchar,
                                                      input pcProcessTemplateName as character).
        define variable cAppName as character no-undo.
        
        ConnectService().
        
        run getProcessTemplateAppName in ConnectPortType(mcPortType)
                (input pcSessionId,
                 input pcProcessTemplateName,
                 output cAppName).

        return cAppName.
        finally:
            DisconnectPortType().
            DisconnectService().
        end finally.        
    end method.
            
    method public character GetProcessTemplateNameFromProcessInstance(input pcSessionId as longchar,
                                                                      input pcProcessInstanceName as character).
        define variable cTemplateName as character no-undo.
        
        ConnectService().
        
        run getProcessTemplateNameFromProcessInstance in ConnectPortType(mcPortType)
                (input pcSessionId,
                 input pcProcessInstanceName,
                 output cTemplateName).

        return cTemplateName.                 
        finally:
            DisconnectPortType().
            DisconnectService().
        end finally.        
    end method.
    
    method public character GetProcessTemplateNameFromProcessID(input pcSessionId as longchar,
                                                                input piProcessTemplateId as int64).
        define variable cTemplateName as character no-undo.
        
        ConnectService().
        
        run getProcessTemplateNameFromProcessInstance in ConnectPortType(mcPortType)
                (input pcSessionId,
                 input piProcessTemplateId,
                 output cTemplateName).

        return cTemplateName.                 
        finally:
            DisconnectPortType().
            DisconnectService().
        end finally.        
    end method.
    
    method public WorkStepTemplate extent GetProcessTemplateWorkSteps(input pcSessionId as longchar,
                                                                      input pcProcessTemplateName as character).
        define variable cOutputParam as longchar no-undo.
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        define variable oWST as SavvionType extent no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'getProcessTemplateWorkSteps'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', pcSessionId, cNamespace).
            WriteElement('ptName', pcProcessTemplateName, cNamespace).
        EndSoapMessage(cOperation, cNamespace).
        
        cOutputParam = ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).
        oWST = SavvionType:XMLToArray(cOutputParam,
                    cOperation,
                    Class:GetClass('OpenEdge.EnterpriseServices.BizLogic.WorkStepTemplate')).
        
        return cast(oWST, WorkStepTemplate).
    end method.
            
    method public ProcessTemplate GetProcessTemplateFromID(input pcSessionId as longchar,
                                                           input piProcessTemplateId as int64).
        define variable cOutputParam as longchar no-undo.
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        define variable oPT as SavvionType extent no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'getProcessTemplateFromID'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', pcSessionId, cNamespace).
            WriteElement('ptid', string(piProcessTemplateId), cNamespace).
        EndSoapMessage(cOperation, cNamespace).
        
        cOutputParam = ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).
        oPT = SavvionType:XMLToArray(cOutputParam,
                    cOperation,
                    Class:GetClass('OpenEdge.EnterpriseServices.BizLogic.ProcessTemplate')).
        
        return cast(oPT[1], ProcessTemplate).
    end method.
            
    method public DataSlotTemplate extent GetProcessTemplateDataSlots(input pcSessionId as longchar,
                                                                      input pcProcessTemplateName as character).
        define variable cOutputParam as longchar no-undo.
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        define variable oDST as SavvionType extent no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'getProcessTemplateDataSlots'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', pcSessionId, cNamespace).
            WriteElement('ptName', pcProcessTemplateName, cNamespace).
        EndSoapMessage(cOperation, cNamespace).
        cOutputParam = ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).
        oDST = SavvionType:XMLToArray(cOutputParam,
                    cOperation,
                    Class:GetClass('OpenEdge.EnterpriseServices.BizLogic.DataSlotTemplate')).
        
        return cast(oDST, DataSlotTemplate).
    end method.
            
    method public DataSlotTemplate extent GetProcessTemplateDataSlot(input pcSessionId as longchar,            
                                                                     input pcProcessTemplateName as character,
                                                                     input pcDataslotName as character extent).
        define variable cOutputParam as longchar no-undo.
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        define variable oDST as SavvionType extent no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'getProcessTemplateDataSlot'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', pcSessionId, cNamespace).
            WriteElement('ptName', pcProcessTemplateName, cNamespace).
            if extent(pcDataslotName) ne ? then
                SavvionType:ArrayToXML(moSaxWriter,
                                       'dsName',
                                       cNamespace,
                                       pcDataslotName).
        EndSoapMessage(cOperation, cNamespace).
        
        cOutputParam = ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).
        oDST = SavvionType:XMLToArray(cOutputParam,
                    cOperation,
                    Class:GetClass('OpenEdge.EnterpriseServices.BizLogic.DataSlotTemplate')).
        
        return cast(oDST, DataSlotTemplate).
    end method.
            
    method public DataSlotInstance extent GetProcessInstanceDataSlots(input pcSessionId as longchar,
                                                                      input pcProcessInstanceName as character).
        define variable cOutputParam as longchar no-undo.
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        define variable oDST as SavvionType extent no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'getProcessInstanceDataSlots'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', pcSessionId, cNamespace).
            WriteElement('piName', pcProcessInstanceName, cNamespace).
        EndSoapMessage(cOperation, cNamespace).
        
        cOutputParam = ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).
        oDST = SavvionType:XMLToArray(cOutputParam,
                    cOperation,
                    Class:GetClass('OpenEdge.EnterpriseServices.BizLogic.DataSlotInstance')).
        
        return cast(oDST, DataSlotInstance).
    end method.
            
    method public DataSlotInstance extent GetProcessInstanceDataSlot(input pcSessionId as longchar,
                                                                     input pcProcessInstanceName as character,
                                                                     input pcDataslotName as character extent).
        define variable cOutputParam as longchar no-undo.
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        define variable oDST as SavvionType extent no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'getProcessInstanceDataSlot'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', pcSessionId, cNamespace).
            WriteElement('piName', pcProcessInstanceName, cNamespace).
            if extent(pcDataslotName) ne ? then
                SavvionType:ArrayToXML(moSaxWriter,
                                       'dsName',
                                       cNamespace,
                                       pcDataslotName).
        EndSoapMessage(cOperation, cNamespace).
        
        cOutputParam = ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).
        oDST = SavvionType:XMLToArray(cOutputParam,
                    cOperation,
                    Class:GetClass('OpenEdge.EnterpriseServices.BizLogic.DataSlotInstance')).
        
        return cast(oDST, DataSlotInstance).
    end method.
            
    method public DataSlotInstance extent GetProcessInstanceDataSlotFromPiid(input pcSessionId as longchar,
                                                                             input piProcessInstanceId as int64,
                                                                             input pcDataslotName as character extent).
        define variable cOutputParam as longchar no-undo.
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        define variable oDST as SavvionType extent no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'getProcessInstanceDataSlotFromPiid'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', pcSessionId, cNamespace).
            WriteElement('piid', string(piProcessInstanceId), cNamespace).
            if extent(pcDataslotName) ne ? then
                SavvionType:ArrayToXML(moSaxWriter,
                                       'dsName',
                                       cNamespace,
                                       pcDataslotName).
        EndSoapMessage(cOperation, cNamespace).
        
        cOutputParam = ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).
        oDST = SavvionType:XMLToArray(cOutputParam,
                    cOperation,
                    Class:GetClass('OpenEdge.EnterpriseServices.BizLogic.DataSlotInstance')).
        
        return cast(oDST, DataSlotInstance).
    end method.
            
    method public DataSlotInstance extent GetWorkStepInstanceDataSlots(input pcSessionId as longchar,
                                                                       input pcProcessInstanceName as character,
                                                                       input pcWorkstepInstanceName as character).
        define variable cOutputParam as longchar no-undo.
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        define variable oDST as SavvionType extent no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'getWorkStepInstanceDataSlots'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', pcSessionId, cNamespace).
            WriteElement('piName', pcProcessInstanceName, cNamespace).
            WriteElement('wsName', pcWorkstepInstanceName, cNamespace).
        EndSoapMessage(cOperation, cNamespace).
        
        cOutputParam = ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).
        oDST = SavvionType:XMLToArray(cOutputParam,
                    cOperation,
                    Class:GetClass('OpenEdge.EnterpriseServices.BizLogic.DataSlotInstance')).
        
        return cast(oDST, DataSlotInstance).
    end method.
            
    method public DataSlotInstance extent GetWorkStepInstanceDataSlotsFromPiid(input pcSessionId as longchar,
                                                                               input piProcessInstanceId as int64,
                                                                               input pcWorkstepInstanceName as character).
        define variable cOutputParam as longchar no-undo.
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        define variable oDST as SavvionType extent no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'getWorkStepInstanceDataSlotsFromPiid'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', pcSessionId, cNamespace).
            WriteElement('piid', string(piProcessInstanceId), cNamespace).
            WriteElement('wsiName', pcWorkstepInstanceName, cNamespace).
        EndSoapMessage(cOperation, cNamespace).
        
        cOutputParam = ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).
        oDST = SavvionType:XMLToArray(cOutputParam,
                    cOperation,
                    Class:GetClass('OpenEdge.EnterpriseServices.BizLogic.DataSlotInstance')).
        
        return cast(oDST, DataSlotInstance).
    end method.
            
    method public DataSlotInstance extent GetWorkItemDataSlots(input pcSessionId as longchar,
                                                               input pcWorkItemName as character):
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        define variable cOutputParam as longchar no-undo.
        define variable oDataSlotInstance as SavvionType extent no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'getWorkItemDataSlots'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', pcSessionId, cNamespace).
            WriteElement('wiName', pcWorkItemName, cNamespace).
        EndSoapMessage(cOperation, cNamespace).
        
        cOutputParam =  ExecuteOperation(mcPortType,
                                         cOperation,
                                         SoapMessageToLongchar()).
        
        oDataSlotInstance = SavvionType:XMLToArray(
                                cOutputParam,
                                cOperation,
                                Class:GetClass('OpenEdge.EnterpriseServices.BizLogic.DataSlotInstance')).
        
        return cast(oDataSlotInstance, DataSlotInstance). 
    end method.
            
    method public DataSlotInstance extent GetWorkItemDataSlotsFromWiid(input pcSessionId as longchar,
                                                                       input piWorkstepInstanceId as int64):
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        define variable cOutputParam as longchar no-undo.
        define variable oDataSlotInstance as SavvionType extent no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'getWorkItemDataSlotsFromWIID'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', pcSessionId, cNamespace).
            WriteElement('wiid', string(piWorkstepInstanceId), cNamespace).
        EndSoapMessage(cOperation, cNamespace).
        
        cOutputParam =  ExecuteOperation(mcPortType,
                                         cOperation,
                                         SoapMessageToLongchar()).
        
        oDataSlotInstance = SavvionType:XMLToArray(
                                cOutputParam,
                                cOperation,
                                Class:GetClass('OpenEdge.EnterpriseServices.BizLogic.DataSlotInstance')).

        
        return cast(oDataSlotInstance, DataSlotInstance). 
    end method.
            
    method public DataSlotTemplate extent GetWorkStepTemplateDataSlots(input pcSessionId as longchar,
                                                                       input pcProcessTemplateName as character,
                                                                       input pcWorkStepName as character):
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        define variable cOutputParam as longchar no-undo.
        define variable oDataSlotTemplate as SavvionType extent no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'getWorkStepTemplateDataSlots'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', pcSessionId, cNamespace).
            WriteElement('ptName', pcProcessTemplateName, cNamespace).
            WriteElement('wsName', pcWorkStepName, cNamespace).
        EndSoapMessage(cOperation, cNamespace).
        
        cOutputParam =  ExecuteOperation(mcPortType,
                                         cOperation,
                                         SoapMessageToLongchar()).
        
        oDataSlotTemplate = SavvionType:XMLToArray(
                                cOutputParam,
                                cOperation,
                                Class:GetClass('OpenEdge.EnterpriseServices.BizLogic.DataSlotTemplate')).
        
        return cast(oDataSlotTemplate, DataSlotTemplate). 
    end method.
    
    method public DataSlotTemplate extent GetWorkStepTemplateDataSlotsFromPtid(input pcSessionId as longchar,
                                                                               input piProcessTemplateId as int64,
                                                                               input pcWorkStepName as character):
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        define variable cOutputParam as longchar no-undo.
        define variable oDataSlotTemplate as SavvionType extent no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'getWorkStepTemplateDataSlotsFromPtid'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', pcSessionId, cNamespace).
            WriteElement('ptid', string(piProcessTemplateId), cNamespace).
            WriteElement('wsName', pcWorkStepName, cNamespace).
        EndSoapMessage(cOperation, cNamespace).
        
        cOutputParam =  ExecuteOperation(mcPortType,
                                         cOperation,
                                         SoapMessageToLongchar()).
        
        oDataSlotTemplate = SavvionType:XMLToArray(
                                cOutputParam,
                                cOperation,
                                Class:GetClass('OpenEdge.EnterpriseServices.BizLogic.DataSlotTemplate')).
        
        return cast(oDataSlotTemplate, DataSlotTemplate).    
    end method.
            
    method public void SetProcessTemplateDataSlotValue(input pcSessionId as longchar,
                                                       input pcProcessTemplateName as character,
                                                       input poDataSlotTemplate as DataSlotTemplate):
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        define variable oST as SavvionType extent no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'setProcessTemplateDataSlotValue'.
        extent(oST) = 1.
        oST[1] = poDataSlotTemplate.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', pcSessionId, cNamespace).
            WriteElement('ptName', pcProcessTemplateName, cNamespace).
            SavvionType:ArrayToXML(moSaxWriter,
                                   'dst',
                                   cNamespace,
                                   oST).
        EndSoapMessage(cOperation, cNamespace).
        
        ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).
    end method.
            
    method public void SetProcessTemplateDataSlotsValue(input pcSessionId as longchar,
                                                        input pcProcessTemplateName as character,
                                                        input poDataSlotTemplate as DataSlotTemplate extent).
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'setProcessTemplateDataSlotsValue'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', pcSessionId, cNamespace).
            WriteElement('ptName', pcProcessTemplateName, cNamespace).
            SavvionType:ArrayToXML(moSaxWriter,
                                   'dst',
                                   cNamespace,
                                   poDataSlotTemplate).
        EndSoapMessage(cOperation, cNamespace).
        
        ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).
    end method.
    
    method public void SetProcessInstanceDataSlotValue(input pcSessionId as longchar,
                                                       input pcProcessInstanceName as character,
                                                       input poDataSlotInstance as DataSlotInstance):
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        define variable oST as SavvionType extent no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'setProcessTemplateDataSlotValue'.
        extent(oST) = 1.
        oST[1] = poDataSlotInstance.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', pcSessionId, cNamespace).
            WriteElement('piName', pcProcessInstanceName, cNamespace).
            SavvionType:ArrayToXML(moSaxWriter,
                                   'dsi',
                                   cNamespace,
                                   oST).
        EndSoapMessage(cOperation, cNamespace).
        
        ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).
    end method.
            
    method public void SetProcessInstanceDataSlotsValue(input pcSessionId as longchar,
                                                        input pcProcessInstanceName as character,
                                                        input poDataSlotInstance as DataSlotInstance extent):
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'setProcessInstanceDataSlotsValue'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', pcSessionId, cNamespace).
            WriteElement('piName', pcProcessInstanceName, cNamespace).
            SavvionType:ArrayToXML(moSaxWriter,
                                   'dsi',
                                   cNamespace,
                                   poDataSlotInstance).
        EndSoapMessage(cOperation, cNamespace).
        
        ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).
    end method.
            
    method public void SetWorkItemDataSlotsValue(input pcSessionId as longchar,
                                                 input pcWorkItemName as character,
                                                 input poDataSlotInstance as DataSlotInstance extent).
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'setWorkItemDataSlotsValue'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', pcSessionId, cNamespace).
            WriteElement('wiName', pcWorkItemName, cNamespace).
            SavvionType:ArrayToXML(moSaxWriter,
                                   'dsi',
                                   cNamespace,
                                   poDataSlotInstance).
        EndSoapMessage(cOperation, cNamespace).
        
        ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).
    end method.
            
    method public void SetWorkItemDataSlotValue(input pcSessionId as longchar,
                                                input pcWorkItemName as character,
                                                input poDataSlotInstance as DataSlotInstance).
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        define variable oST as SavvionType extent no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'setWorkItemDataSlotValue'.
        extent(oST) = 1.
        oST[1] = poDataSlotInstance.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', pcSessionId, cNamespace).
            WriteElement('wiName', pcWorkItemName, cNamespace).
            SavvionType:ArrayToXML(moSaxWriter,
                                   'dsi',
                                   cNamespace,
                                   oST).
        EndSoapMessage(cOperation, cNamespace).
        
        ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).
    end method.
            
    method public ProcessInstance GetProcessInstanceFromID(input pcSessionId as longchar,
                                                           input piProcessInstanceId as int64):
        define variable cOutputParam as longchar no-undo.
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        define variable oPI as SavvionType extent no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'getProcessInstanceFromID'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', pcSessionId, cNamespace).
            WriteElement('piid', string(piProcessInstanceId), cNamespace).
        EndSoapMessage(cOperation, cNamespace).
        
        cOutputParam = ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).
        oPI = SavvionType:XMLToArray(cOutputParam,
                    cOperation,
                    Class:GetClass('OpenEdge.EnterpriseServices.BizLogic.ProcessInstance')).
        
        return cast(oPI[1], ProcessInstance).
    end method.
            
    method public void SetProcessInstanceDueDate(input pcSessionId as longchar,
                                                 input pcProcessInstanceName as character,
                                                 input ptDueDate as datetime-tz):
        ConnectService().
        
        run setProcessInstanceDueDate in ConnectPortType(mcPortType)
                (input pcSessionId,
                 input pcProcessInstanceName,
                 input ptDueDate).
        
        finally:
            DisconnectPortType().
            DisconnectService().
        end finally.        
    end method.
    
    method public WorkItem GetWorkItemFromID(input pcSessionId as longchar,
                                             input piWorkItemInstanceId as int64):
        define variable cOutputParam as longchar no-undo.
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        define variable oWI as SavvionType extent no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'getWorkItemFromID'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', pcSessionId, cNamespace).
            WriteElement('wiid', string(piWorkItemInstanceId), cNamespace).
        EndSoapMessage(cOperation, cNamespace).
        
        cOutputParam = ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).
        oWI = SavvionType:XMLToArray(cOutputParam,
                    cOperation,
                    Class:GetClass('OpenEdge.EnterpriseServices.BizLogic.WorkItem')).
        
        return cast(oWI[1], WorkItem).
    end method.
            
    method public void SuspendWorkItem(input pcSessionId as longchar,
                                       input pcWorkItemName as character).

        ConnectService().
        
        run suspendWorkItem in ConnectPortType(mcPortType)
                (input pcSessionId,
                 input pcWorkItemName).        
        
        finally:
            DisconnectPortType().
            DisconnectService().
        end finally.        
    end method.
                
    method public void ResumeWorkItem(input pcSessionId as longchar,
                                      input pcWorkItemName as character).
        ConnectService().
        
        run resumeWorkItem in ConnectPortType(mcPortType)
                (input pcSessionId,
                 input pcWorkItemName).        
        
        finally:
            DisconnectPortType().
            DisconnectService().
        end finally.        
    end method.
    
    method public void AssignWorkItemFromWiid(input pcSessionId as longchar,
                                              input piWorkItemInstanceId as int64,
                                              input pcPerformer as character).
        ConnectService().
        
        run assignWorkItemFromWiid in ConnectPortType(mcPortType)
                (input pcSessionId,
                 input piWorkItemInstanceId,
                 input pcPerformer).        
        finally:
            DisconnectPortType().
            DisconnectService().
        end finally.        
    end method.
    
    method public void ReassignWorkItem(input pcSessionId as longchar,
                                        input pcWorkItemName as character,
                                        input pcPerformer as character).
        ConnectService().
        
        run reassignWorkItem in ConnectPortType(mcPortType)
                (input pcSessionId,
                 input pcWorkItemName,
                 input pcPerformer).        
        finally:
            DisconnectPortType().
            DisconnectService().
        end finally.        
    end method.
          
    method public void ReassignWorkItemFromWiid(input pcSessionId as longchar,
                                                input piWorkItemInstanceId as int64,
                                                input pcPerformer as character).
        ConnectService().
        
        run reassignWorkItemFromWiid in ConnectPortType(mcPortType)
                (input pcSessionId,
                 input piWorkItemInstanceId,
                 input pcPerformer).        
        finally:
            DisconnectPortType().
            DisconnectService().
        end finally.        
    end method.
    
    method public void MakeAvailableWorkItem(input pcSessionId as longchar,
                                             input pcWorkItemName as character,
                                             input pcPerformers as character extent).
        ConnectService().
        
        run makeAvailableWorkItem in ConnectPortType(mcPortType)
                (input pcSessionId,
                 input pcWorkItemName,
                 input pcPerformers).        
        
        finally:
            DisconnectPortType().
            DisconnectService().
        end finally.        
    end method.
    
    method public void MakeAvailableWorkItemFromWiid(input pcSessionId as longchar,        
                                                     input piWorkItemInstanceId as int64,
                                                     input pcPerformers as character extent).
        ConnectService().
        
        run makeAvailableWorkItemFromWiid in ConnectPortType(mcPortType)
                (input pcSessionId,
                 input piWorkItemInstanceId,
                 input pcPerformers).
                   
        finally:
            DisconnectPortType().
            DisconnectService().
        end finally.        
    end method.
    
    method public void CompleteWorkItemFromWiid(input pcSessionId as longchar,
                                                input piWorkItemInstanceId as int64,
                                                input poDataSlotInstance as DataSlotInstance extent).
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'completeWorkItemFromWIID'.
        
        StartSoapMessage(cOperation, cNamespace).        
            WriteElement('session', pcSessionId, cNamespace).
            WriteElement('wiid', string(piWorkItemInstanceId), cNamespace).        
            if extent(poDataSlotInstance) ne ? then
                SavvionType:ArrayToXML(moSaxWriter,
                                       'dsi',
                                       cNamespace,
                                       poDataSlotInstance).
        EndSoapMessage(cOperation, cNamespace).
        
        ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).
    end method.
    
    method public WorkStepInstance GetWorkStepInstanceFromPiid(input pcSessionId as longchar,
                                                               input piProcessInstanceId as int64,
                                                               input pcWorkStepName as character).
        define variable cOutputParam as longchar no-undo.
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        define variable oWSI as SavvionType extent no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'getWorkStepInstanceFromPiid'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', pcSessionId, cNamespace).
            WriteElement('piid', string(piProcessInstanceId), cNamespace).
            WriteElement('wsName', pcWorkStepName, cNamespace).
        EndSoapMessage(cOperation, cNamespace).
        
        cOutputParam = ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).
        oWSI = SavvionType:XMLToArray(cOutputParam,
                    cOperation,
                    Class:GetClass('OpenEdge.EnterpriseServices.BizLogic.WorkStepInstance')).
        
        return cast(oWSI[1], WorkStepInstance).
    end method.
    
    method public WorkStepInstance extent GetProcessInstanceWorkSteps(input pcSessionId as longchar,
                                                                      input pcProcessInstanceName as character).
        define variable cOutputParam as longchar no-undo.
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        define variable oWSI as SavvionType extent no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'getProcessInstanceWorkSteps'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', pcSessionId, cNamespace).
            WriteElement('piName', pcProcessInstanceName, cNamespace).
        EndSoapMessage(cOperation, cNamespace).
        
        cOutputParam = ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).
        oWSI = SavvionType:XMLToArray(cOutputParam,
                    cOperation,
                    Class:GetClass('OpenEdge.EnterpriseServices.BizLogic.WorkStepInstance')).
        
        return cast(oWSI, WorkStepInstance).
    end method.
    
    method public void SuspendWorkStepInstance(input pcSessionId as longchar,
                                               input pcProcessInstanceName as character,
                                               input pcWorkStepName as character).
        ConnectService().
        
        run suspendWorkStepInstance in ConnectPortType(mcPortType)
                (input pcSessionId,
                 input pcProcessInstanceName,
                 input pcWorkStepName).
        
        finally:
            DisconnectPortType().
            DisconnectService().
        end finally.        
    end method.
    
    method public void ResumeWorkStepInstance(input pcSessionId as longchar,
                                              input pcProcessInstanceName as character,
                                              input pcWorkStepName as character).
        ConnectService().
        
        run resumeWorkStepInstance in ConnectPortType(mcPortType)
                (input pcSessionId,
                 input pcProcessInstanceName,
                 input pcWorkStepName).        
        finally:
            DisconnectPortType().
            DisconnectService().
        end finally.        
    end method.
    
    method public WorkStepTemplate extent GetStartWorkStepTemplate(input pcSessionId as longchar,
                                                                   input pcProcessTemplateName as character).
        define variable cOutputParam as longchar no-undo.
        define variable cNamespace as character no-undo.
        define variable cOperation as character no-undo.
        define variable oWST as SavvionType extent no-undo.
        
        cNamespace = 'ns0'.
        cOperation = 'getStartWorkStepTemplate'.
        
        StartSoapMessage(cOperation, cNamespace).
            WriteElement('session', pcSessionId, cNamespace).
            WriteElement('ptName', pcProcessTemplateName, cNamespace).
        EndSoapMessage(cOperation, cNamespace).
        
        cOutputParam = ExecuteOperation(mcPortType,
                         cOperation,
                         SoapMessageToLongchar()).
        oWST = SavvionType:XMLToArray(cOutputParam,
                    cOperation,
                    Class:GetClass('OpenEdge.EnterpriseServices.BizLogic.WorkStepTemplate')).
        
        return cast(oWST, WorkStepTemplate).
    end method.
    
/* SOAP Message Helper methods */
    method protected void InitializeSaxWriter():   
        moSaxWriter = new SaxWriter().
        moSaxWriter:IsFragment = true.
        moSaxWriter:IsStrict = false.
        /* for debugging 
        moSaxWriter:IsFormatted = true.
        */
        
        moSaxWriter:WriteTo(mhSoapMessage).
    end method.
    
    method protected void ResetSaxWriter():
        if not moSaxWriter:Reset() then
            InitializeSaxWriter().
        
        /* no leaks, please */
        set-size(mhSoapMessage) = 0.        
    end method.
    
    method protected void StartSoapMessage(input pcElementName as character,
                                           input pcNamespace as character):
        ResetSaxWriter().
        
        moSaxWriter:StartDocument().
        moSaxWriter:StartElement(substitute('&1:&2', pcNamespace, pcElementName)).
        
        /* standard namespaces */
        moSaxWriter:DeclareNamespace("http://workflow.webservice.savvion.com", pcNamespace).
        moSaxWriter:DeclareNamespace("http://www.w3.org/2001/XMLSchema-instance", 'xsi').        
        moSaxWriter:DeclareNamespace("http://www.w3.org/2001/XMLSchema", 'xsd').
    end method.

    method protected void WriteElement(input pcElementName as character,
                                       input pcValue as longchar,
                                       input pcNamespace as character):
        moSaxWriter:StartElement(substitute('&1:&2', pcNamespace, pcElementName)).
        moSaxWriter:WriteValue(pcValue).
        moSaxWriter:EndElement(substitute('&1:&2', pcNamespace, pcElementName)).
    end method.
    
    method protected void EndSoapMessage(input pcElementName as character,
                                         input pcNamespace as character):
        moSaxWriter:EndElement(substitute('&1:&2', pcNamespace, pcElementName)).
        moSaxWriter:EndDocument().
    end method.
    
    /** Converts the current soap message to LONGCHAR for use as an operation.
        
        @return longchar The current SOAP message.  */
    method protected longchar SoapMessageToLongchar():        
        define variable cMessage as longchar no-undo.
        
        copy-lob mhSoapMessage to cMessage.
        set-size(mhSoapMessage) = 0.
        
        return cMessage.
    end method.
        
end class.
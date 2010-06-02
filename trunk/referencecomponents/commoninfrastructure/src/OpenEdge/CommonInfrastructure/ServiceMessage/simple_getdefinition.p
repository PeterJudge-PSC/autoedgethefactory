/*------------------------------------------------------------------------
    File        : simple_getdefinition.p
    Description : 
    Author(s)   : pjudge
    Created     : Fri Dec 21 13:48:14 EST 2007
    Notes       :
  ----------------------------------------------------------------------*/
using SampleApp.OERA.Interfaces.*.
using SampleApp.OERA.Infrastructure.*.

define input  parameter pcServiceName as character no-undo.  
define output parameter dataset-handle phDataset.

def var oDSM as DataServiceManager.
def var oBE as IBusinessEntity.
def var hDataset as handle.

oDSM = DataServiceManager:GetInstance(). 

oBE = cast(oDSM:GetService(pcServiceName, "BE"), IBusinessEntity).
cast(oBE, IBusinessService):InitializeComponent().

phDataset = oBE:GetDatasetHandle(). 

error-status:error = no.
return.
/* EOF */
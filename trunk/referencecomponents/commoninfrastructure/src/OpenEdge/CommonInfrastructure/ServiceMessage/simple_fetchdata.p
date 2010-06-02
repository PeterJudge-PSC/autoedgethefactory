/*------------------------------------------------------------------------
    File        : simple_fetchdata.p
    Purpose     :  
    
    Syntax      :

    Description : Standard Service Interface procedure for the fetchdata method
    
    Author(s)   : john
    Created     : Tue Jan 27 16:17:52 EST 2009
    Notes       :
  ----------------------------------------------------------------------*/
using OpenEdge.CommonInfrastructure.Common.IServiceManager.
  
define input        parameter pcServiceName as character no-undo.
define input-output parameter dataset-handle phDataset.
define input-output parameter pcContext as longchar no-undo.

define variable oServiceManager as IServiceManager no-undo.
define variable hDataset as handle no-undo.

oService = DataServiceManager:GetInstance(). 

/* Register the entity so that we connect the datasources etc. */
oBE = cast(oService:GetService(pcServiceName, "BE"), IBusinessEntity).
cast(oBE, IBusinessService):InitializeComponent().

/* don't pass the dataset around, making deep copies all over the place. */
oContext = new ServerDataContext(pcContext).
oBE:FetchData(phDataset:HANDLE, input oContext). 

/* we have no further use for this dataset. 
   NB: I don't think this is true; leave the service running 
       unless cleaned up by someone. 
oService:ReleaseEntity(phDataset:Name).
*/

pcContext = cast(oContext, ISerializable):Serialize().

delete object phdataset.

error-status:error = no.
return.
/* EOF */
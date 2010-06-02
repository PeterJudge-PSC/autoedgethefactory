/*------------------------------------------------------------------------
    File        : simple_savedata.p
    Purpose     : 

    Syntax      :

    Description : Standard Service Interface procedure for the fetchdata method

    Author(s)   : john
    Created     : Tue Jan 27 16:17:52 EST 2009
    Notes       :
  ----------------------------------------------------------------------*/
using SampleApp.OERA.Interfaces.*.
using SampleApp.OERA.Infrastructure.*.
using SampleApp.OERA.Services.*.
using OpenEdge.MVP.Interfaces.*.
using OpenEdge.MVP.Model.*.
using OpenEdge.Base.Interfaces.*.
using OpenEdge.Base.System.*.

DEFINE INPUT        PARAMETER pcServiceName AS CHARACTER NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER DATASET-HANDLE phDataset.
DEFINE INPUT-OUTPUT PARAMETER pcContext as longchar no-undo.


DEFINE VARIABLE oService AS DataServiceManager NO-UNDO.
DEFINE VARIABLE oBE      AS IBusinessEntity    NO-UNDO.
DEFINE VARIABLE hDataset AS HANDLE NO-UNDO.
DEFINE VARIABLE oContext AS IServerDataContext no-undo. 

oService = DataServiceManager:GetInstance(). 

/* Register the entity so that we connect the datasources etc. */
oBE = CAST(oService:GetService(pcServiceName, "BE"), IBusinessEntity).
cast(oBE, IBusinessService):InitializeComponent().

/* don't pass the dataset around, making deep copies all over the place. */
oContext = new ServerDataContext(pcContext).

oBE:StoreData(phDataset:HANDLE, INPUT oContext). 

/* we have no further use for this dataset. 
   NB: I don't think this is true; leave the service running 
       unless cleaned up by someone. 
oService:ReleaseEntity(phDataset:Name).
*/

pcContext = cast(oContext, ISerializable):Serialize().

delete object phdataset.

ERROR-STATUS:ERROR = NO.
RETURN.
/* EOF */
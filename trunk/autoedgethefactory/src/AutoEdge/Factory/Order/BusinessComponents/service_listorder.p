/*------------------------------------------------------------------------
    File        : service_listorder.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : pjudge
    Created     : Tue Aug 03 16:40:47 EDT 2010
    Notes       :
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using OpenEdge.CommonInfrastructure.Common.ISecurityManager.
using OpenEdge.CommonInfrastructure.Common.IUserContext.

/* ***************************  Definitions  ************************** */
define temp-table ttOrder no-undo
        field OrderId as character
        field OrderApproved as logical
        field VehicleOnHand as logical
        field CustomerName as character
        field CustomerEmail as character
        field Brand as character
        field DealerId as character
        field Model as character
        field InteriorTrimMaterial as character
        field InteriorTrimColour as character
        field InteriorAccessories as character
        field ExteriorColour as character
        field Moonroof as character
        field Wheels as character
        .
define input parameter pcOrderId as character no-undo.
define output parameter table for ttOrder.

/* ***************************  Main Block  *************************** */
define variable cFile as character no-undo.
define variable oContext as IUserContext no-undo.
define variable oSecMgr as ISecurityManager no-undo.

/*oSecMgr:ValidateSession(pcContextId).*/
/* add parameter values to the user context */ 

cFile = 'data/customerorder_' + entry(num-entries(pcOrderId, '#'), pcOrderId,'#') + '.xml'.
buffer ttOrder:read-xml('file',  cFile, 'empty', ?, ?) no-error.

/*buffer ttOrder:read-xml('file', 'data/customerorder_' + pcOrderId + '.xml', 'empty', ?, ?).*/

return. 
/** EOF **/
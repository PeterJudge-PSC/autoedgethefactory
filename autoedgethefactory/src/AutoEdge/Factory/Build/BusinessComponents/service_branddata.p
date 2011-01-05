/*------------------------------------------------------------------------
    File        : service_branddata.p
    Purpose     : 

    Syntax      :

    Description : Vehicle and dealer info for a give brand

    Author(s)   : pjudge
    Created     : Wed Jul 28 16:50:34 EDT 2010
    Notes       :
  ----------------------------------------------------------------------*/
routine-level on error undo, throw.

using AutoEdge.Factory.Build.BusinessComponents.VehicleBrandData.

define input  parameter pcBrand as character no-undo.

define output parameter pcDealerNameList as longchar no-undo.
define output parameter pcCompactModels as longchar no-undo.
define output parameter pcTruckModels as longchar no-undo.
define output parameter pcSuvModels as longchar no-undo.
define output parameter pcPremiumModels as longchar no-undo.
define output parameter pcSedanModels as longchar no-undo.
define output parameter pcInteriorTrimMaterial as longchar no-undo.
define output parameter pcInteriorTrimColour as longchar no-undo.
define output parameter pcInteriorAccessories as longchar no-undo.
define output parameter pcExteriorColour as longchar no-undo.
define output parameter pcMoonroof as longchar no-undo.
define output parameter pcWheels as longchar no-undo.

/* ***************************  Main Block  *************************** */
define variable oBrandData as VehicleBrandData no-undo.

oBrandData = new VehicleBrandData(pcBrand).
assign pcDealerNameList = oBrandData:DealerNames
       pcCompactModels  = oBrandData:CompactModels
       pcTruckModels = oBrandData:TruckModels
       pcSuvModels  = oBrandData:SuvModels
       pcPremiumModels  = oBrandData:PremiumModels
       pcSedanModels = oBrandData:SedanModels
       
       pcInteriorTrimMaterial = oBrandData:InteriorTrimMaterial
       pcInteriorTrimColour = oBrandData:InteriorTrimColour
       pcInteriorAccessories = oBrandData:InteriorAccessories
       pcExteriorColour = oBrandData:ExteriorColour
       pcMoonroof = oBrandData:Moonroof
       pcWheels = oBrandData:Wheels.
       
return.
/** EOF **/
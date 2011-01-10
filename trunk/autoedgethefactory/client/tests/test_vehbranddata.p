/*------------------------------------------------------------------------
    File        : test_vehbranddata.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : pjudge
    Created     : Mon Aug 09 08:10:45 EDT 2010
    Notes       :
  ----------------------------------------------------------------------*/


/* ***************************  Main Block  *************************** */
def var cjson as longchar.
def var ovbd as VehicleBrandData.

ovbd = new VehicleBrandData('potomoc').


message 
string(ovbd:CompactModels) skip
string(ovbd:SedanModels) skip
string(ovbd:PremiumModels) skip
string(ovbd:TruckModels) skip
string(ovbd:SuvModels) skip
view-as alert-box.


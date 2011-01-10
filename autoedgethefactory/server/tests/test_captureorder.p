/*------------------------------------------------------------------------
    File        : test_captureorder.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : pjudge
    Created     : Fri Aug 06 12:45:42 EDT 2010
    Notes       :
  ----------------------------------------------------------------------*/
define temp-table ttOrder no-undo
        field OrderId as character
        field OrderApproved as logical
        field VehicleOnHand as logical
        field Customervalue as character
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
    
def var dPrice as decimal.
def var ctrim as char.
def var caccess as char.

ctrim = ' ~{"ttOptions": [ ' 
    + '~{' + quoter("selected") + ' : true, '
    + quoter("value") + ' : ' + quoter("pec-microfiber") + ','
    + quoter("label") + ' : ' + quoter("Plush-E-Comfort Microfiber") + ' } , '

    + '~{' + quoter("selected") + ' : false, '
    + quoter("value") + ' : ' + quoter("Leather") + ','
    + quoter("label") + ' : ' + quoter("Leather") + ' } , '

    + '~{' + quoter("selected") + ' : false, '
    + quoter("value") + ' : ' + quoter("Fabric") + ','
    + quoter("label") + ' : ' + quoter("Fabric") + ' } '

    + '] ~} '.

caccess = '['
    + '~{' + quoter("selected") + ' : true, '
    + quoter("value") + ' : ' + quoter("nav") + ','
    + quoter("label") + ' : ' + quoter("In-dash navigation") + ' ~} , '

    + '~{' + quoter("selected") + ' : true, '
    + quoter("value") + ' : ' + quoter("prem-sound") + ','
    + quoter("label") + ' : ' + quoter("Premium Sound System") + ' ~} , '

    + '~{' + quoter("selected") + ' : true, '
    + quoter("value") + ' : ' + quoter("bluetooth") + ','
    + quoter("label") + ' : ' + quoter("Bluetooth") + ' ~} '

        + ']'.


run service_captureorder.p (
                input 'AE_TF_REL_V2#1600',
                input yes,
                input 'pj',
                input 'pjudge@progress.com',
                input 'chery',
                input 'dealer01',
                input 'curve - 1.6t',
                input ctrim, 
                input '',
                input caccess,
                input '',
                input '',
                input '',
                output dPrice).

run service_listorder.p (input 'AE_TF_REL_V2#1600', output table ttOrder).

find first ttOrder.

message 
ttOrder.Brand skip
ttOrder.Customervalue skip
ttOrder.CustomerEmail skip
ttORder.InteriorTrimMaterial skip
ttorder.InteriorAccessories skip(2)
dPrice

view-as alert-box.
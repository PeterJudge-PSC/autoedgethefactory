/*------------------------------------------------------------------------
    File        : load_addresses.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : pjudge
    Created     : Wed Dec 15 09:38:43 EST 2010
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

{routinelevel.i}

/* ********************  Definitions  ******************** */
define variable iLoop as integer no-undo.
define variable iMax as integer no-undo.
define variable cStreets as character no-undo.
define variable cStreetTypes as character no-undo.
define variable cCities as character no-undo.
define variable cPostCodes as character no-undo.

function getRandom returns character (input cValueList as character):
    define variable iEntries as integer    no-undo.
    iEntries = num-entries (cValueList, '|') .
    if iEntries > 1 
        then return entry ((random (1, iEntries)), cValueList, '|') .
        else return cValueList .
end function .

cStreets = 'Smith|Main|Shawsheen|Yellow Brick|High|Loopy|Apple Blossom|Long|Shore|Pine|Oak|Park|Barnyard'.
cStreetTypes = 'Ave|Str|Rd|Terrace|Lane|Rt|Ct'.
cCities = 'Nashua|Bedford|Burlington|Boston|Manchester|Springfield|Milford|Danbury|Shrewsbury|Abbotdale|Malden'.
cPostCodes = '03060|01730|02155|90210|10010|32329|90210|02020'.


/* ***************************  Main Block  *************************** */
run createTypes.
run createDetail.

procedure createTypes:
    create AddressType.
    assign AddressType.AddressType = 'shipping'.

    create AddressType.
    assign AddressType.AddressType = 'billing'.

    create AddressType.
    assign AddressType.AddressType = 'postal'.

    create AddressType.
    assign AddressType.AddressType = 'home'.

    create AddressType.
    assign AddressType.AddressType = 'street'.
    
end procedure.

procedure createDetail:
    iMax = 60.
    do iLoop = 1 to iMax:
        create AddressDetail.
        assign AddressDetail.AddressDetailId = guid(generate-uuid)
               AddressDetail.AddressLine1 = string(random(1, 1000)) + ' ' + getRandom(cStreets) + ' ' + getRandom(cStreetTypes)
               AddressDetail.AddressLine2 = ''
               AddressDetail.City = getRandom(cCities)
               AddressDetail.PostalCode = getRandom(cPostCodes).
               
    end.
end procedure.


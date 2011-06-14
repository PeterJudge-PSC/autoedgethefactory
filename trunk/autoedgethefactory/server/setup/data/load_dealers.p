/** ------------------------------------------------------------------------
    File        : load_dealers.p
    Purpose     : 

    Syntax      :

    Description : 

    @author pjudge
    Created     : Tue Jan 25 14:49:02 EST 2011
    Notes       :
  ---------------------------------------------------------------------- */
routine-level on error undo, throw.

using OpenEdge.Lang.FillModeEnum.

/* ***************************  Definitions  ************************** */
define temp-table ttDealer no-undo serialize-name 'dealer'
    field TenantName as character serialize-name 'brand' xml-node-type 'hidden'
    field DealerCode as character serialize-name 'code' xml-node-type 'attribute'
    field DealerName as character serialize-name 'name'
    field Address1 as character
    field Address2 as character
    field City as character
    field Country as character
    field SalesEmail as character
    field Fax as character
    field ZIP as character
    field State as character
    field Phone as character
    field Mobile as character  
    index idx1 as primary unique TenantName DealerCode.    

define temp-table ttBrand no-undo serialize-name 'brand'
    field TenantName as character serialize-name 'name' xml-node-type 'attribute'
    index idx1 as primary unique TenantName.

define dataset dsDealers serialize-name 'dealers' for ttBrand, ttDealer
    data-relation for ttBrand , ttDealer relation-fields (TenantName, TenantName) nested.

/** -- functions & procedure -- **/
function GetAddressId returns longchar (input pcLine1 as char,
                                        input pcLine2 as char,
                                        input pcCity as char,
                                        input pcState as char,
                                        input pcZip as char):
    create AddressDetail.
    assign AddressDetail.AddressDetailId = guid(generate-uuid)
           AddressDetail.AddressLine1 = pcLine1
           AddressDetail.AddressLine2 = pcLine2
           AddressDetail.City = pcCity
           AddressDetail.PostalCode = pcZip
           AddressDetail.State = pcState.
    
    return AddressDetail.AddressDetailId.
end function.   

function GetContactId returns longchar (input pcDetail as char):
    find first ContactDetail where ContactDetail.Detail eq pcDetail no-lock no-error.
    if not available ContactDetail then
    do:
        create ContactDetail.
        assign ContactDetail.ContactDetailId = guid(generate-uuid)
               ContactDetail.Detail = pcDetail.
    end.
    
    return ContactDetail.ContactDetailId.
end function.

procedure load_dealer:
    define variable cDealerDomain as character no-undo.
    
    for each ttBrand:
        find Tenant where Tenant.Name = ttBrand.TenantName no-lock.
        
        for each ttDealer where 
                 ttDealer.TenantName = ttBrand.TenantName:
            cDealerDomain  = ''.
            create Dealer.
            assign Dealer.DealerId = guid(generate-uuid)
                   Dealer.Name = ttDealer.DealerName
                   Dealer.Code = ttDealer.DealerCode
                   Dealer.TenantId = Tenant.TenantId
                   
                   Dealer.SalesEmailContactId = GetContactId(ttDealer.SalesEmail)
                   Dealer.StreetAddressId = GetAddressId(ttDealer.Address1,
                                                         ttDealer.Address2,
                                                         ttDealer.City,
                                                         ttDealer.State,
                                                         ttDealer.ZIP)
                   Dealer.SwitchboardPhoneNumberId = GetContactId(ttDealer.Phone)
                   .
            if ttDealer.Fax ne '' then                   
                run create_contact_xref ('fax', 
                                         GetContactId(ttDealer.Fax),
                                         Dealer.DealerId,
                                         Dealer.TenantId).
            if ttDealer.Mobile ne '' then
                run create_contact_xref ('phone-mobile', 
                                         GetContactId(ttDealer.Mobile),
                                         Dealer.DealerId,
                                         Dealer.TenantId).
                
            if num-entries(ttDealer.SalesEmail, '@') ge 2 then
                cDealerDomain = entry(2, ttDealer.SalesEmail, '@').
            if cDealerDomain ne '' then
                /* admin email */
                run create_contact_xref ('email-work', 
                                         GetContactId('admin@' + cDealerDomain),
                                         Dealer.DealerId,
                                         Dealer.TenantId).
        end.
    end.
end procedure.

procedure create_contact_xref:
    define input  parameter pcContactType as character no-undo.
    define input  parameter pcContactId as longchar no-undo.
    define input  parameter pcDealerId as longchar no-undo.
    define input  parameter pcTenantId as longchar no-undo.
    
    find ContactType where ContactType.Name = pcContactType no-lock.
    
    create ContactXref.
    assign ContactXref.ContactDetailId = pcContactId
           ContactXref.ParentId = pcDealerId
           ContactXref.TenantId = pcTenantId
           ContactXref.ContactType = ContactType.Name
           .
end procedure.

/* ***************************  Main Block  *************************** */
dataset dsDealers:read-xml('file', search('data/dealers.xml'), FillModeEnum:Empty:ToString(), ?, ?).

/*dataset dsDealers:write-json('file', session:temp-dir + '/dealers.json', true).*/

run load_dealer.

/** -- eof -- **/
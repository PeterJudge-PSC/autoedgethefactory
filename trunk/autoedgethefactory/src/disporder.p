FOR each order where ordernum = 376 no-lock, 
    first statusdetail where statusdetail.statusdetailid = statusid no-lock,
    first customer where customer.customerid = order.customerid no-lock,
    first addressdetail where addressdetail.addressdetailid = order.shippingaddressid.

    displ 
        ordernum         
        orderid format 'x(40)'
        emaildate
        customer.name
        statusdetail.description form 'x(40)'
        statusdetail.code form 'x(30)'
        addressdetail.addressline1  
        addressdetail.city
        with frame f1 1 col width 80.
END.


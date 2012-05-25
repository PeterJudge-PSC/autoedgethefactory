<%@page import="com.savvion.BizSolo.Server.*,com.savvion.BizSolo.beans.*,java.util.*" contentType="text/html;charset=UTF-8"%>
<%@page errorPage="/BizSolo/common/jsp/error.jsp" %>
<%@taglib uri="/BizSolo/common/tlds/bizsolo.tld" prefix="bizsolo"%>
<%@taglib uri="http://java.sun.com/jstl/core" prefix="c"%>
<jsp:useBean id="bean" class="com.savvion.BizSolo.beans.Bean" scope="session"/>
<jsp:useBean id="factoryBean" class="com.savvion.BizSolo.beans.EPFactoryBean" scope="session"/>
<jsp:useBean id="bizSite" class="com.savvion.sbm.bpmportal.bizsite.api.BizSiteBean" scope="session"/>

<%! String _PageName = "Start"; %>
<%! String __webAppName = "CustomerVehicleOrderSubmit"; %>
<%! int res=-10; %>
<bizsolo:ifCrtWS name="Start" isDefault="true" >
<bizsolo:initApp name="CustomerVehicleOrderSubmit" />
<bizsolo:getParentData />
<bizsolo:if test="<%=request.getParameter(\"workitemName\")!=null %>" >
<bizsolo:executeAction wsName="" epClassName="com.savvion.BizSolo.beans.PAKGetDS" perfMethod="commit" />
</bizsolo:if>
<bizsolo:checkSecure />
<bizsolo:redirectURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=SelectBrand" />
</bizsolo:ifCrtWS>



<%String PT_NAME=bean.getPropString("PT_NAME");
String BIZSITE_USER=bean.getPropString("BIZSITE_USER");
String BIZSITE_PASSWORD=bean.getPropString("BIZSITE_PASSWORD");
Vector SelectedAccessoryList=bean.getPropVector("SelectedAccessoryList");
String userid=bean.getPropString("userid");
String TruckModels=bean.getPropString("TruckModels");
String SUVModels=bean.getPropString("SUVModels");
String SelectedVehicleModel=bean.getPropString("SelectedVehicleModel");
String SelectedVehicleBrand=bean.getPropString("SelectedVehicleBrand");
String SelectedInteriorTrimColour=bean.getPropString("SelectedInteriorTrimColour");
String SelectedInteriorSeatMaterial=bean.getPropString("SelectedInteriorSeatMaterial");
String SelectedInteriorAccessories=bean.getPropString("SelectedInteriorAccessories");
String SelectedExteriorWheels=bean.getPropString("SelectedExteriorWheels");
String SelectedExteriorMoonroof=bean.getPropString("SelectedExteriorMoonroof");
String SelectedExteriorColour=bean.getPropString("SelectedExteriorColour");
String SedanModels=bean.getPropString("SedanModels");
String SalesrepCode=bean.getPropString("SalesrepCode");
String PremiumModels=bean.getPropString("PremiumModels");
String password=bean.getPropString("password");
long OrderNum=bean.getPropLong("OrderNum");
long orderid=bean.getPropLong("orderid");
String OrderChannel=bean.getPropString("OrderChannel");
long NumLoginAttempts=bean.getPropLong("NumLoginAttempts");
String ModelName=bean.getPropString("ModelName");
long MaxLoginAttempts=bean.getPropLong("MaxLoginAttempts");
String InteriorTrimColour=bean.getPropString("InteriorTrimColour");
String InteriorSeatMaterial=bean.getPropString("InteriorSeatMaterial");
String InteriorAccessories=bean.getPropString("InteriorAccessories");
String ExteriorWheels=bean.getPropString("ExteriorWheels");
String ExteriorMoonroof=bean.getPropString("ExteriorMoonroof");
String ExteriorColour=bean.getPropString("ExteriorColour");
String error=bean.getPropString("error");
String DealerList=bean.getPropString("DealerList");
String DealerCode=bean.getPropString("DealerCode");
String CustomerName=bean.getPropString("CustomerName");
String CustomerId=bean.getPropString("CustomerId");
String CustomerEmail=bean.getPropString("CustomerEmail");
Object CustomerCreditLimit=bean.getPropObject("CustomerCreditLimit");
String ContextId=bean.getPropString("ContextId");
String CompactModels=bean.getPropString("CompactModels");
%>




<bizsolo:ifCrtWS name="ExitPage" >
<bizsolo:choose >
<bizsolo:when test="<%=\"procReq\".equals(request.getParameter(\"activityMode\")) %>" >

<bizsolo:choose >
<bizsolo:when test="<%=\"Exit\".equals(request.getParameter(\"SB_Name\")) || \"2174270\".equals(request.getParameter(\"SB_Name\")) || \"linkExitComplete\".equals(request.getParameter(\"SB_Name\")) || \"-504418927\".equals(request.getParameter(\"SB_Name\")) %>" >
<bizsolo:forwardURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=End_1" />
</bizsolo:when>
</bizsolo:choose>
</bizsolo:when>
<bizsolo:otherwise >
<bizsolo:redirectURL page="ExitPage.jsp" />
</bizsolo:otherwise>
</bizsolo:choose>
</bizsolo:ifCrtWS>



<bizsolo:ifCrtWS name="LoginCustomer" >
<bizsolo:choose >
<bizsolo:when test="<%=\"procReq\".equals(request.getParameter(\"activityMode\")) %>" >
<bizsolo:setDS name="userid,password"/><bizsolo:choose >
<bizsolo:when test="<%=\"Register\".equals(request.getParameter(\"SB_Name\")) || \"-625569085\".equals(request.getParameter(\"SB_Name\")) || \"linkRegisterCustomer\".equals(request.getParameter(\"SB_Name\")) || \"620265403\".equals(request.getParameter(\"SB_Name\")) %>" >
<bizsolo:forwardURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=RegisterCustomer" />
</bizsolo:when>
</bizsolo:choose>
<bizsolo:choose >
<bizsolo:when test="<%=\"Login\".equals(request.getParameter(\"SB_Name\")) || \"73596745\".equals(request.getParameter(\"SB_Name\")) || \"linkCustomerLogin\".equals(request.getParameter(\"SB_Name\")) || \"1061453905\".equals(request.getParameter(\"SB_Name\")) %>" >
<bizsolo:forwardURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=CustomerLogin" />
</bizsolo:when>
</bizsolo:choose>
</bizsolo:when>
<bizsolo:otherwise >
<bizsolo:redirectURL page="LoginCustomer.jsp" />
</bizsolo:otherwise>
</bizsolo:choose>
</bizsolo:ifCrtWS>



<bizsolo:ifCrtWS name="LoginFailure" >
<bizsolo:choose >
<bizsolo:when test="<%=\"procReq\".equals(request.getParameter(\"activityMode\")) %>" >
<bizsolo:setDS name="NumLoginAttempts,password,userid"/><bizsolo:choose >
<bizsolo:when test="<%=\"Retry Login\".equals(request.getParameter(\"SB_Name\")) || \"-1085063247\".equals(request.getParameter(\"SB_Name\")) || \"linkRetryLogin\".equals(request.getParameter(\"SB_Name\")) || \"-651386565\".equals(request.getParameter(\"SB_Name\")) %>" >
<bizsolo:forwardURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=CustomerLogin" />
</bizsolo:when>
</bizsolo:choose>
</bizsolo:when>
<bizsolo:otherwise >
<bizsolo:redirectURL page="LoginFailure.jsp" />
</bizsolo:otherwise>
</bizsolo:choose>
</bizsolo:ifCrtWS>



<bizsolo:ifCrtWS name="LoginRetryExceeded" >
<bizsolo:choose >
<bizsolo:when test="<%=\"procReq\".equals(request.getParameter(\"activityMode\")) %>" >

<bizsolo:choose >
<bizsolo:when test="<%=\"Exit\".equals(request.getParameter(\"SB_Name\")) || \"2174270\".equals(request.getParameter(\"SB_Name\")) || \"linkExitRetryAttempts\".equals(request.getParameter(\"SB_Name\")) || \"1873731766\".equals(request.getParameter(\"SB_Name\")) %>" >
<bizsolo:forwardURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=End_2" />
</bizsolo:when>
</bizsolo:choose>
</bizsolo:when>
<bizsolo:otherwise >
<bizsolo:redirectURL page="LoginRetryExceeded.jsp" />
</bizsolo:otherwise>
</bizsolo:choose>
</bizsolo:ifCrtWS>



<bizsolo:ifCrtWS name="RegisterCustomer" >
<bizsolo:choose >
<bizsolo:when test="<%=\"procReq\".equals(request.getParameter(\"activityMode\")) %>" >

<bizsolo:choose >
<bizsolo:when test="<%=\"Return To Login\".equals(request.getParameter(\"SB_Name\")) || \"-1962889644\".equals(request.getParameter(\"SB_Name\")) || \"linkReturnToLogin\".equals(request.getParameter(\"SB_Name\")) || \"-481578876\".equals(request.getParameter(\"SB_Name\")) %>" >
<bizsolo:forwardURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=LoginCustomer" />
</bizsolo:when>
</bizsolo:choose>
</bizsolo:when>
<bizsolo:otherwise >
<% /* Workaround, tmpStr will disappear in the future */ %>
<% String tmpStr = response.encodeURL("Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=RegisterCustomer&activityMode=procReq&SB_Name=-1962889644&nextPage=Start.jsp"); %>
<bizsolo:initDS name="linkReturnToLogin_target" value="<%= tmpStr %>" />
<bizsolo:redirectURL page="RegisterCustomer.jsp" />
</bizsolo:otherwise>
</bizsolo:choose>
</bizsolo:ifCrtWS>



<bizsolo:ifCrtWS name="SelectBrand" >
<bizsolo:choose >
<bizsolo:when test="<%=\"procReq\".equals(request.getParameter(\"activityMode\")) %>" >
<bizsolo:setDS name="SelectedVehicleBrand"/><bizsolo:choose >
<bizsolo:when test="<%=\"Select Model\".equals(request.getParameter(\"SB_Name\")) || \"708967173\".equals(request.getParameter(\"SB_Name\")) || \"linkSelectModel\".equals(request.getParameter(\"SB_Name\")) || \"-1353274573\".equals(request.getParameter(\"SB_Name\")) %>" >
<bizsolo:forwardURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=GetBrandDetail" />
</bizsolo:when>
</bizsolo:choose>
</bizsolo:when>
<bizsolo:otherwise >
<bizsolo:redirectURL page="SelectBrand.jsp" />
</bizsolo:otherwise>
</bizsolo:choose>
</bizsolo:ifCrtWS>



<bizsolo:ifCrtWS name="SelectModel" >
<bizsolo:choose >
<bizsolo:when test="<%=\"procReq\".equals(request.getParameter(\"activityMode\")) %>" >
<bizsolo:setDS name="ModelName,PremiumModels,SUVModels,TruckModels,SedanModels,CompactModels,SelectedVehicleModel"/><bizsolo:choose >
<bizsolo:when test="<%=\"Select Options\".equals(request.getParameter(\"SB_Name\")) || \"236191610\".equals(request.getParameter(\"SB_Name\")) || \"linkSelectOptions\".equals(request.getParameter(\"SB_Name\")) || \"-1598202840\".equals(request.getParameter(\"SB_Name\")) %>" >
<bizsolo:forwardURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=SelectOptions" />
</bizsolo:when>
</bizsolo:choose>
</bizsolo:when>
<bizsolo:otherwise >
<bizsolo:redirectURL page="SelectModel.jsp" />
</bizsolo:otherwise>
</bizsolo:choose>
</bizsolo:ifCrtWS>



<bizsolo:ifCrtWS name="SelectOptions" >
<bizsolo:choose >
<bizsolo:when test="<%=\"procReq\".equals(request.getParameter(\"activityMode\")) %>" >
<bizsolo:setDS name="SelectedInteriorSeatMaterial,DealerList,SelectedAccessoryList,SelectedExteriorMoonroof,SelectedExteriorColour,DealerCode,ExteriorColour,ExteriorWheels,SelectedInteriorTrimColour,SelectedExteriorWheels,ExteriorMoonroof,InteriorSeatMaterial,InteriorAccessories,InteriorTrimColour"/><bizsolo:choose >
<bizsolo:when test="<%=\"Complete Order\".equals(request.getParameter(\"SB_Name\")) || \"-1399842393\".equals(request.getParameter(\"SB_Name\")) || \"linkLoginCustomer\".equals(request.getParameter(\"SB_Name\")) || \"-1393811315\".equals(request.getParameter(\"SB_Name\")) %>" >
<bizsolo:forwardURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=LoginCustomer" />
</bizsolo:when>
</bizsolo:choose>
</bizsolo:when>
<bizsolo:otherwise >
<bizsolo:redirectURL page="SelectOptions.jsp" />
</bizsolo:otherwise>
</bizsolo:choose>
</bizsolo:ifCrtWS>



<bizsolo:ifCrtWS name="End_1" >
<bizsolo:transferDS />
<bizsolo:setParentData />
<% /* Workaround, retAddr will disappear in the future */ %>
<% String retAddr = bean.getPropString("returnPage"); %>
<% if(retAddr != null) { %>
  <bizsolo:redirectURL page="<%= retAddr %>" />
<% } %>
</bizsolo:ifCrtWS>



<bizsolo:ifCrtWS name="End_2" >
<bizsolo:transferDS />
<bizsolo:setParentData />
<% /* Workaround, retAddr will disappear in the future */ %>
<% String retAddr = bean.getPropString("returnPage"); %>
<% if(retAddr != null) { %>
  <bizsolo:redirectURL page="<%= retAddr %>" />
<% } %>
</bizsolo:ifCrtWS>



<bizsolo:ifCrtWS name="CreateOrder" >
<% // Each tenant/brand has its own admin user
bean.setPropString("BIZSITE_USER", "lob_manager@"+bean.getPropString("SelectedVehicleBrand").toLowerCase());

// ABL doesn't like List objects, turn into String for passing into BizLogic process
java.util.Vector accessoryList = bean.getPropVector("SelectedAccessoryList");
java.lang.StringBuilder accessoryString = new  java.lang.StringBuilder("[");

java.lang.String prefix = "";
for (java.lang.Object element : accessoryList) {
    accessoryString.append(prefix);
    prefix = ",";
    accessoryString.append("\"" + element.toString() + "\" ");
}
accessoryString.append("]");

//System.out.println(accessoryString.toString());

bean.setPropString("SelectedInteriorAccessories", accessoryString.toString());%>
<bizsolo:executeAction wsName="CreateOrder" epClassName="com.savvion.BizSolo.beans.PAKCreatePI" perfMethod="commit" dsi="CustomerName@CustomerName,SelectedInteriorSeatMaterial@SelectedInteriorSeatMaterial,CustomerId@CustomerId,DealerCode@DealerCode,SelectedExteriorWheels@SelectedExteriorWheels,SelectedExteriorMoonroof@SelectedExteriorMoonroof,ModelName@ModelName,SelectedInteriorTrimColour@SelectedInteriorTrimColour,CustomerEmail@CustomerEmail,SelectedVehicleModel@VehicleModel,SelectedExteriorColour@SelectedExteriorColour,SelectedVehicleBrand@VehicleBrand,SelectedInteriorAccessories@SelectedInteriorAccessories,CustomerCreditLimit@CustomerCreditLimit,BIZSITE_PASSWORD@bizsite_pass,BIZSITE_USER@bizsite_user,PT_NAME@ptName" dso="error@error" />
<bizsolo:forwardURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=ExitPage" />
</bizsolo:ifCrtWS>



<bizsolo:ifCrtWS name="CustomerLogin" >
<bizsolo:executeAction wsName="CustomerLogin" epClassName="com.savvion.sbm.adapters.oe.OEAdapter" perfMethod="execute" dsi="password,SelectedVehicleBrand,userid" dso="CustomerName,ContextId,CustomerEmail,CustomerId,CustomerCreditLimit" />
<bizsolo:forwardURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=Decision_1" />
</bizsolo:ifCrtWS>



<bizsolo:ifCrtWS name="CustomerLogout" >
<bizsolo:executeAction wsName="CustomerLogout" epClassName="com.savvion.sbm.adapters.oe.OEAdapter" perfMethod="execute" dsi="ContextId" />
<bizsolo:forwardURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=CreateOrder" />
</bizsolo:ifCrtWS>



<bizsolo:ifCrtWS name="GetBrandDetail" >
<bizsolo:executeAction wsName="GetBrandDetail" epClassName="com.savvion.sbm.adapters.oe.OEAdapter" perfMethod="execute" dsi="SelectedVehicleBrand,ContextId" dso="InteriorTrimColour,SUVModels,ExteriorMoonroof,SedanModels,PremiumModels,ExteriorColour,CompactModels,InteriorAccessories,DealerList,InteriorSeatMaterial,ExteriorWheels,TruckModels" />
<bizsolo:forwardURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=SelectModel" />
</bizsolo:ifCrtWS>



<bizsolo:ifCrtWS name="Decision_1" >
<bizsolo:if test="<%= !ContextId.equals(\"-1\") %>" >
<bizsolo:redirectURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=CustomerLogout" />
</bizsolo:if>
<% // executed  only when condition is not true %>
<bizsolo:forwardURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=Decision_2" />
</bizsolo:ifCrtWS>



<bizsolo:ifCrtWS name="Decision_2" >
<bizsolo:if test="<%= NumLoginAttempts<=MaxLoginAttempts %>" >
<bizsolo:redirectURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=LoginFailure" />
</bizsolo:if>
<% // executed  only when condition is not true %>
<bizsolo:forwardURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=LoginRetryExceeded" />
</bizsolo:ifCrtWS>

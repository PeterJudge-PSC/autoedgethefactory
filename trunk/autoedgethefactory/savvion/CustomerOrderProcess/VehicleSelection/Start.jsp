<%@page import="com.savvion.BizSolo.Server.*,com.savvion.BizSolo.beans.*,java.util.*" contentType="text/html;charset=UTF-8"%>
<%@page errorPage="/BizSolo/common/jsp/error.jsp" %>
<%@taglib uri="/BizSolo/common/tlds/bizsolo.tld" prefix="bizsolo"%>
<%@taglib uri="http://java.sun.com/jstl/core" prefix="c"%>
<jsp:useBean id="bean" class="com.savvion.BizSolo.beans.Bean" scope="session"/>
<jsp:useBean id="factoryBean" class="com.savvion.BizSolo.beans.EPFactoryBean" scope="session"/>
<jsp:useBean id="bizSite" class="com.savvion.sbm.bpmportal.bizsite.api.BizSiteBean" scope="session"/>

<%! String _PageName = "Start"; %>
<%! String __webAppName = "VehicleSelection"; %>
<%! int res=-10; %>
<bizsolo:ifCrtWS name="Start" isDefault="true" >
<bizsolo:initApp name="VehicleSelection" />
<bizsolo:getParentData />
<bizsolo:if test="<%=request.getParameter(\"workitemName\")!=null %>" >
<bizsolo:executeAction wsName="" epClassName="com.savvion.BizSolo.beans.PAKGetDS" perfMethod="commit" />
</bizsolo:if>
<bizsolo:checkSecure />
<bizsolo:redirectURL page="Start.jsp?crtApp=VehicleSelection&crtPage=SelectBrand" />
</bizsolo:ifCrtWS>



<%String BIZSITE_PASSWORD=bean.getPropString("BIZSITE_PASSWORD");
String BIZSITE_USER=bean.getPropString("BIZSITE_USER");
String CompactModels=bean.getPropString("CompactModels");
String ContextId=bean.getPropString("ContextId");
Object CustomerCreditLimit=bean.getPropObject("CustomerCreditLimit");
String CustomerEmail=bean.getPropString("CustomerEmail");
String CustomerId=bean.getPropString("CustomerId");
String CustomerName=bean.getPropString("CustomerName");
String DealerCode=bean.getPropString("DealerCode");
String DealerList=bean.getPropString("DealerList");
String error=bean.getPropString("error");
String ExteriorColour=bean.getPropString("ExteriorColour");
String ExteriorMoonroof=bean.getPropString("ExteriorMoonroof");
String ExteriorWheels=bean.getPropString("ExteriorWheels");
String InteriorAccessories=bean.getPropString("InteriorAccessories");
String InteriorSeatMaterial=bean.getPropString("InteriorSeatMaterial");
String InteriorTrimColour=bean.getPropString("InteriorTrimColour");
long MaxLoginAttempts=bean.getPropLong("MaxLoginAttempts");
String ModelName=bean.getPropString("ModelName");
long NumLoginAttempts=bean.getPropLong("NumLoginAttempts");
String OrderChannel=bean.getPropString("OrderChannel");
long orderid=bean.getPropLong("orderid");
long OrderNum=bean.getPropLong("OrderNum");
String PAK_URL=bean.getPropString("PAK_URL");
String password=bean.getPropString("password");
String PremiumModels=bean.getPropString("PremiumModels");
String PT_NAME=bean.getPropString("PT_NAME");
String SalesrepCode=bean.getPropString("SalesrepCode");
String SedanModels=bean.getPropString("SedanModels");
String SelectedExteriorColour=bean.getPropString("SelectedExteriorColour");
String SelectedExteriorMoonroof=bean.getPropString("SelectedExteriorMoonroof");
String SelectedExteriorWheels=bean.getPropString("SelectedExteriorWheels");
String SelectedInteriorAccessories=bean.getPropString("SelectedInteriorAccessories");
String SelectedInteriorSeatMaterial=bean.getPropString("SelectedInteriorSeatMaterial");
String SelectedInteriorTrimColour=bean.getPropString("SelectedInteriorTrimColour");
String SelectedVehicleBrand=bean.getPropString("SelectedVehicleBrand");
String SelectedVehicleModel=bean.getPropString("SelectedVehicleModel");
String SUVModels=bean.getPropString("SUVModels");
String TruckModels=bean.getPropString("TruckModels");
String userid=bean.getPropString("userid");
Vector SelectedAccessoryList=bean.getPropVector("SelectedAccessoryList");
%>




<bizsolo:ifCrtWS name="ExitPage" >
<bizsolo:choose >
<bizsolo:when test="<%=\"procReq\".equals(request.getParameter(\"activityMode\")) %>" >

<bizsolo:choose >
<bizsolo:when test="<%=\"Exit\".equals(request.getParameter(\"SB_Name\")) || \"2174270\".equals(request.getParameter(\"SB_Name\")) || \"linkExitComplete\".equals(request.getParameter(\"SB_Name\")) || \"-504418927\".equals(request.getParameter(\"SB_Name\")) %>" >
<bizsolo:forwardURL page="Start.jsp?crtApp=VehicleSelection&crtPage=End_1" />
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
<bizsolo:when test="<%=\"Login\".equals(request.getParameter(\"SB_Name\")) || \"73596745\".equals(request.getParameter(\"SB_Name\")) || \"linkCustomerLogin\".equals(request.getParameter(\"SB_Name\")) || \"1061453905\".equals(request.getParameter(\"SB_Name\")) %>" >
<bizsolo:forwardURL page="Start.jsp?crtApp=VehicleSelection&crtPage=CustomerLogin" />
</bizsolo:when>
</bizsolo:choose>
<bizsolo:choose >
<bizsolo:when test="<%=\"Register\".equals(request.getParameter(\"SB_Name\")) || \"-625569085\".equals(request.getParameter(\"SB_Name\")) || \"linkRegisterCustomer\".equals(request.getParameter(\"SB_Name\")) || \"620265403\".equals(request.getParameter(\"SB_Name\")) %>" >
<bizsolo:forwardURL page="Start.jsp?crtApp=VehicleSelection&crtPage=RegisterCustomer" />
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
<bizsolo:forwardURL page="Start.jsp?crtApp=VehicleSelection&crtPage=CustomerLogin" />
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
<bizsolo:forwardURL page="Start.jsp?crtApp=VehicleSelection&crtPage=End_1" />
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
<bizsolo:forwardURL page="Start.jsp?crtApp=VehicleSelection&crtPage=LoginCustomer" />
</bizsolo:when>
</bizsolo:choose>
<bizsolo:choose >
<bizsolo:when test="<%=\"Submit\".equals(request.getParameter(\"SB_Name\")) || \"-1807668168\".equals(request.getParameter(\"SB_Name\")) || \"linkCustomerRegistration\".equals(request.getParameter(\"SB_Name\")) || \"1710490321\".equals(request.getParameter(\"SB_Name\")) %>" >
<bizsolo:forwardURL page="Start.jsp?crtApp=VehicleSelection&crtPage=CustomerRegistration" />
</bizsolo:when>
</bizsolo:choose>
</bizsolo:when>
<bizsolo:otherwise >
<% /* Workaround, tmpStr will disappear in the future */ %>
<% String tmpStr = response.encodeURL("Start.jsp?crtApp=VehicleSelection&crtPage=RegisterCustomer&activityMode=procReq&SB_Name=-1962889644&nextPage=Start.jsp"); %>
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
<bizsolo:forwardURL page="Start.jsp?crtApp=VehicleSelection&crtPage=GetBrandDetail" />
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
<bizsolo:setDS name="PremiumModels,ModelName,SelectedVehicleModel,SUVModels,TruckModels,SedanModels,CompactModels"/><bizsolo:choose >
<bizsolo:when test="<%=\"Select Options\".equals(request.getParameter(\"SB_Name\")) || \"236191610\".equals(request.getParameter(\"SB_Name\")) || \"linkSelectOptions\".equals(request.getParameter(\"SB_Name\")) || \"-1598202840\".equals(request.getParameter(\"SB_Name\")) %>" >
<bizsolo:forwardURL page="Start.jsp?crtApp=VehicleSelection&crtPage=SelectOptions" />
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
<bizsolo:forwardURL page="Start.jsp?crtApp=VehicleSelection&crtPage=LoginCustomer" />
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



<bizsolo:ifCrtWS name="CustomerLogin" >
<bizsolo:executeAction wsName="CustomerLogin" epClassName="com.savvion.sbm.adapters.oe.OEAdapter" perfMethod="execute" dsi="password,SelectedVehicleBrand,userid" dso="CustomerName,ContextId,CustomerEmail,CustomerId,CustomerCreditLimit" />
<bizsolo:forwardURL page="Start.jsp?crtApp=VehicleSelection&crtPage=Decision_1" />
</bizsolo:ifCrtWS>



<bizsolo:ifCrtWS name="CustomerLogout" >
<bizsolo:executeAction wsName="CustomerLogout" epClassName="com.savvion.sbm.adapters.oe.OEAdapter" perfMethod="execute" dsi="ContextId" />
<bizsolo:forwardURL page="Start.jsp?crtApp=VehicleSelection&crtPage=ExitPage" />
</bizsolo:ifCrtWS>



<bizsolo:ifCrtWS name="CustomerRegistration" >
<bizsolo:executeAction wsName="CustomerRegistration" epClassName="com.savvion.sbm.adapters.oe.OEAdapter" perfMethod="execute" dsi="CustomerName,CustomerEmail,password,SelectedVehicleBrand,userid" dso="CustomerId,SalesrepCode" />
<bizsolo:forwardURL page="Start.jsp?crtApp=VehicleSelection&crtPage=RegistrationConfirmation" />
</bizsolo:ifCrtWS>



<bizsolo:ifCrtWS name="GetBrandDetail" >
<bizsolo:executeAction wsName="GetBrandDetail" epClassName="com.savvion.sbm.adapters.oe.OEAdapter" perfMethod="execute" dsi="SelectedVehicleBrand,ContextId" dso="InteriorTrimColour,SUVModels,ExteriorMoonroof,SedanModels,ExteriorColour,PremiumModels,CompactModels,InteriorAccessories,DealerList,InteriorSeatMaterial,ExteriorWheels,TruckModels" />
<bizsolo:forwardURL page="Start.jsp?crtApp=VehicleSelection&crtPage=SelectModel" />
</bizsolo:ifCrtWS>



<bizsolo:ifCrtWS name="OrderCreation" >
<% // each tenant/brand has its own admin user
java.lang.String userName = "lob_manager@"+bean.getPropString("SelectedVehicleBrand").toLowerCase();
bean.setPropString("BIZSITE_USER", userName);

//System.out.println("BIZSITE_USER=" + bean.getPropString("BIZSITE_USER"));


// ABL doesn't like List objects, turn into String for passing into BizLogic process
java.lang.String accessoryList = bean.getPropVector("SelectedAccessoryList").toString();
bean.setPropString("SelectedInteriorAccessories", accessoryList);

//System.out.println("SelectedAccessoryList=" + bean.getPropVector("SelectedAccessoryList").toString());
//System.out.println("SelectedInteriorAccessories=" + bean.getPropString("SelectedInteriorAccessories"));%>
<bizsolo:executeAction wsName="OrderCreation" epClassName="com.savvion.BizSolo.beans.PAKCreatePI" perfMethod="commit" dsi="PT_NAME@ptName,SelectedInteriorTrimColour@SelectedInteriorTrimColour,BIZSITE_USER@bizsite_user,CustomerCreditLimit@CustomerCreditLimit,CustomerEmail@CustomerEmail,ModelName@ModelName,SelectedInteriorAccessories@SelectedInteriorAccessories,SelectedVehicleBrand@VehicleBrand,SelectedInteriorSeatMaterial@SelectedInteriorSeatMaterial,CustomerId@CustomerId,SelectedVehicleModel@VehicleModel,BIZSITE_PASSWORD@bizsite_pass,SelectedExteriorColour@SelectedExteriorColour,CustomerName@CustomerName,SelectedExteriorMoonroof@SelectedExteriorMoonroof,DealerCode@DealerCode,SelectedExteriorWheels@SelectedExteriorWheels" dso="error@error" />
<bizsolo:forwardURL page="Start.jsp?crtApp=VehicleSelection&crtPage=CustomerLogout" />
</bizsolo:ifCrtWS>



<bizsolo:ifCrtWS name="RegistrationConfirmation" >
<bizsolo:executeAction wsName="RegistrationConfirmation" epClassName="com.savvion.sbm.adapters.email.EmailAdapter" perfMethod="execute" dsi="CustomerEmail" />
<bizsolo:forwardURL page="Start.jsp?crtApp=VehicleSelection&crtPage=CustomerLogin" />
</bizsolo:ifCrtWS>



<bizsolo:ifCrtWS name="Decision_1" >
<bizsolo:if test="<%= !ContextId.equals(\"-1\") %>" >
<bizsolo:redirectURL page="Start.jsp?crtApp=VehicleSelection&crtPage=OrderCreation" />
</bizsolo:if>
<% // executed  only when condition is not true %>
<bizsolo:forwardURL page="Start.jsp?crtApp=VehicleSelection&crtPage=Decision_2" />
</bizsolo:ifCrtWS>



<bizsolo:ifCrtWS name="Decision_2" >
<bizsolo:if test="<%= NumLoginAttempts<=MaxLoginAttempts %>" >
<bizsolo:redirectURL page="Start.jsp?crtApp=VehicleSelection&crtPage=LoginFailure" />
</bizsolo:if>
<% // executed  only when condition is not true %>
<bizsolo:forwardURL page="Start.jsp?crtApp=VehicleSelection&crtPage=LoginRetryExceeded" />
</bizsolo:ifCrtWS>

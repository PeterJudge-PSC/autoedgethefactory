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



<%String ContextId=bean.getPropString("ContextId");
String SalesrepCode=bean.getPropString("SalesrepCode");
String CustomerName=bean.getPropString("CustomerName");
long CustomerCreditLimit=bean.getPropLong("CustomerCreditLimit");
String CustomerId=bean.getPropString("CustomerId");
long OrderNum=bean.getPropLong("OrderNum");
String OrderChannel=bean.getPropString("OrderChannel");
String AutoEdgeWebServiceEndpoint=bean.getPropString("AutoEdgeWebServiceEndpoint");
String CustomerEmail=bean.getPropString("CustomerEmail");
String userid=bean.getPropString("userid");
String password=bean.getPropString("password");
long orderid=bean.getPropLong("orderid");
String BIZSITE_PASSWORD=bean.getPropString("BIZSITE_PASSWORD");
String BIZSITE_USER=bean.getPropString("BIZSITE_USER");
String PAK_URL=bean.getPropString("PAK_URL");
String PT_NAME=bean.getPropString("PT_NAME");
String error=bean.getPropString("error");
String SelectedVehicleBrand=bean.getPropString("SelectedVehicleBrand");
String SelectedVehicleModel=bean.getPropString("SelectedVehicleModel");
String InteriorSeatMaterial=bean.getPropString("InteriorSeatMaterial");
String InteriorTrimColour=bean.getPropString("InteriorTrimColour");
String InteriorAccessories=bean.getPropString("InteriorAccessories");
String ExteriorColour=bean.getPropString("ExteriorColour");
String ExteriorMoonroof=bean.getPropString("ExteriorMoonroof");
String ExteriorWheels=bean.getPropString("ExteriorWheels");
String DealerCode=bean.getPropString("DealerCode");
String CompactModels=bean.getPropString("CompactModels");
String SedanModels=bean.getPropString("SedanModels");
String PremiumModels=bean.getPropString("PremiumModels");
String SUVModels=bean.getPropString("SUVModels");
String TruckModels=bean.getPropString("TruckModels");
String DealerList=bean.getPropString("DealerList");
String ModelName=bean.getPropString("ModelName");
%>




<bizsolo:ifCrtWS name="ExitPage" >
<bizsolo:choose >
<bizsolo:when test="<%=\"procReq\".equals(request.getParameter(\"activityMode\")) %>" >

<bizsolo:choose >
<bizsolo:when test="<%=\"Connection 16\".equals(request.getParameter(\"SB_Name\")) || \"285694599\".equals(request.getParameter(\"SB_Name\")) %>" >
<bizsolo:forwardURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=End" />
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
<bizsolo:setDS name="password,userid"/><bizsolo:choose >
<bizsolo:when test="<%=\"Register\".equals(request.getParameter(\"SB_Name\")) || \"-625569085\".equals(request.getParameter(\"SB_Name\")) || \"RegisterCustomer\".equals(request.getParameter(\"SB_Name\")) || \"-467598399\".equals(request.getParameter(\"SB_Name\")) %>" >
<bizsolo:forwardURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=RegisterCustomer" />
</bizsolo:when>
</bizsolo:choose>
<bizsolo:choose >
<bizsolo:when test="<%=\"Login\".equals(request.getParameter(\"SB_Name\")) || \"73596745\".equals(request.getParameter(\"SB_Name\")) || \"ExistingCustomer\".equals(request.getParameter(\"SB_Name\")) || \"157131433\".equals(request.getParameter(\"SB_Name\")) %>" >
<bizsolo:forwardURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=CustomerLogin" />
</bizsolo:when>
</bizsolo:choose>
</bizsolo:when>
<bizsolo:otherwise >
<bizsolo:redirectURL page="LoginCustomer.jsp" />
</bizsolo:otherwise>
</bizsolo:choose>
</bizsolo:ifCrtWS>



<bizsolo:ifCrtWS name="ModelSelection" >
<bizsolo:choose >
<bizsolo:when test="<%=\"procReq\".equals(request.getParameter(\"activityMode\")) %>" >
<bizsolo:setDS name="ModelName,SelectedVehicleModel,TruckModels,SUVModels,SedanModels,PremiumModels,CompactModels"/><bizsolo:choose >
<bizsolo:when test="<%=\"Select Options and Accessories\".equals(request.getParameter(\"SB_Name\")) || \"-1057362527\".equals(request.getParameter(\"SB_Name\")) || \"linkSelectOptions\".equals(request.getParameter(\"SB_Name\")) || \"-1598202840\".equals(request.getParameter(\"SB_Name\")) %>" >
<bizsolo:forwardURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=SelectVehicleOptions" />
</bizsolo:when>
</bizsolo:choose>
</bizsolo:when>
<bizsolo:otherwise >
<bizsolo:redirectURL page="ModelSelection.jsp" />
</bizsolo:otherwise>
</bizsolo:choose>
</bizsolo:ifCrtWS>



<bizsolo:ifCrtWS name="RegisterCustomer" >
<bizsolo:choose >
<bizsolo:when test="<%=\"procReq\".equals(request.getParameter(\"activityMode\")) %>" >

<bizsolo:choose >
<bizsolo:when test="<%=\"Return To Login\".equals(request.getParameter(\"SB_Name\")) || \"-1962889644\".equals(request.getParameter(\"SB_Name\")) || \"ReturnToLogin\".equals(request.getParameter(\"SB_Name\")) || \"1389566526\".equals(request.getParameter(\"SB_Name\")) %>" >
<bizsolo:forwardURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=LoginCustomer" />
</bizsolo:when>
</bizsolo:choose>
<bizsolo:choose >
<bizsolo:when test="<%=\"Continue\".equals(request.getParameter(\"SB_Name\")) || \"-502558521\".equals(request.getParameter(\"SB_Name\")) || \"PerformRegistration\".equals(request.getParameter(\"SB_Name\")) || \"1888477850\".equals(request.getParameter(\"SB_Name\")) %>" >
<bizsolo:forwardURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=CustomerRegistration" />
</bizsolo:when>
</bizsolo:choose>
</bizsolo:when>
<bizsolo:otherwise >
<% /* Workaround, tmpStr will disappear in the future */ %>
<% String tmpStr = response.encodeURL("Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=RegisterCustomer&activityMode=procReq&SB_Name=-1962889644&nextPage=Start.jsp"); %>
<bizsolo:initDS name="ReturnToLogin_target" value="<%= tmpStr %>" />
<bizsolo:redirectURL page="RegisterCustomer.jsp" />
</bizsolo:otherwise>
</bizsolo:choose>
</bizsolo:ifCrtWS>



<bizsolo:ifCrtWS name="ReviewSelection" >
<bizsolo:choose >
<bizsolo:when test="<%=\"procReq\".equals(request.getParameter(\"activityMode\")) %>" >
<bizsolo:setDS name="DealerCode,DealerList"/><bizsolo:choose >
<bizsolo:when test="<%=\"Login\".equals(request.getParameter(\"SB_Name\")) || \"73596745\".equals(request.getParameter(\"SB_Name\")) || \"linkCustomerLogin\".equals(request.getParameter(\"SB_Name\")) || \"1061453905\".equals(request.getParameter(\"SB_Name\")) %>" >
<bizsolo:forwardURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=LoginCustomer" />
</bizsolo:when>
</bizsolo:choose>
</bizsolo:when>
<bizsolo:otherwise >
<bizsolo:redirectURL page="ReviewSelection.jsp" />
</bizsolo:otherwise>
</bizsolo:choose>
</bizsolo:ifCrtWS>



<bizsolo:ifCrtWS name="SelectBrand" >
<bizsolo:choose >
<bizsolo:when test="<%=\"procReq\".equals(request.getParameter(\"activityMode\")) %>" >
<bizsolo:setDS name="SelectedVehicleBrand"/><bizsolo:choose >
<bizsolo:when test="<%=\"Select Model\".equals(request.getParameter(\"SB_Name\")) || \"708967173\".equals(request.getParameter(\"SB_Name\")) || \"SelectModel\".equals(request.getParameter(\"SB_Name\")) || \"1866546029\".equals(request.getParameter(\"SB_Name\")) %>" >
<bizsolo:forwardURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=GetBrandDetails" />
</bizsolo:when>
</bizsolo:choose>
</bizsolo:when>
<bizsolo:otherwise >
<bizsolo:redirectURL page="SelectBrand.jsp" />
</bizsolo:otherwise>
</bizsolo:choose>
</bizsolo:ifCrtWS>



<bizsolo:ifCrtWS name="SelectVehicleOptions" >
<bizsolo:choose >
<bizsolo:when test="<%=\"procReq\".equals(request.getParameter(\"activityMode\")) %>" >
<bizsolo:setDS name="ExteriorMoonroof,ExteriorWheels,ExteriorColour,InteriorAccessories,InteriorTrimColour,InteriorSeatMaterial"/><bizsolo:choose >
<bizsolo:when test="<%=\"Review and Complete Order\".equals(request.getParameter(\"SB_Name\")) || \"-1494740808\".equals(request.getParameter(\"SB_Name\")) || \"linkOptionsReviewSelection\".equals(request.getParameter(\"SB_Name\")) || \"883196720\".equals(request.getParameter(\"SB_Name\")) %>" >
<bizsolo:forwardURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=ReviewSelection" />
</bizsolo:when>
</bizsolo:choose>
</bizsolo:when>
<bizsolo:otherwise >
<bizsolo:redirectURL page="SelectVehicleOptions.jsp" />
</bizsolo:otherwise>
</bizsolo:choose>
</bizsolo:ifCrtWS>



<bizsolo:ifCrtWS name="End" >
<bizsolo:transferDS />
<bizsolo:setParentData />
<% /* Workaround, retAddr will disappear in the future */ %>
<% String retAddr = bean.getPropString("returnPage"); %>
<% if(retAddr != null) { %>
  <bizsolo:redirectURL page="<%= retAddr %>" />
<% } %>
</bizsolo:ifCrtWS>



<bizsolo:ifCrtWS name="CustomerLogin" >
<bizsolo:executeAction wsName="CustomerLogin" epClassName="com.savvion.sbm.adapters.webservice.WebServiceAdapter" perfMethod="execute" dsi="password,SelectedVehicleBrand,userid,AutoEdgeWebServiceEndpoint" dso="CustomerName,ContextId,CustomerEmail,CustomerId,CustomerCreditLimit" />
<bizsolo:forwardURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=Decision_3" />
</bizsolo:ifCrtWS>



<bizsolo:ifCrtWS name="CustomerLogout" >
<bizsolo:executeAction wsName="CustomerLogout" epClassName="com.savvion.sbm.adapters.webservice.WebServiceAdapter" perfMethod="execute" dsi="ContextId,AutoEdgeWebServiceEndpoint" dso="error" />
<bizsolo:forwardURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=ExitPage" />
</bizsolo:ifCrtWS>



<bizsolo:ifCrtWS name="CustomerRegistration" >
<bizsolo:executeAction wsName="CustomerRegistration" epClassName="com.savvion.sbm.adapters.webservice.WebServiceAdapter" perfMethod="execute" dsi="password,SelectedVehicleBrand,userid,CustomerName,CustomerEmail,AutoEdgeWebServiceEndpoint" dso="CustomerId,SalesrepCode" />
<bizsolo:forwardURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=RegistrationConfirmation" />
</bizsolo:ifCrtWS>



<bizsolo:ifCrtWS name="GetBrandDetails" >
<bizsolo:executeAction wsName="GetBrandDetails" epClassName="com.savvion.sbm.adapters.webservice.WebServiceAdapter" perfMethod="execute" dsi="SelectedVehicleBrand,ContextId,AutoEdgeWebServiceEndpoint" dso="InteriorTrimColour,SUVModels,ExteriorMoonroof,SedanModels,PremiumModels,ExteriorColour,CompactModels,InteriorAccessories,DealerList,InteriorSeatMaterial,ExteriorWheels,TruckModels" />
<bizsolo:forwardURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=ModelSelection" />
</bizsolo:ifCrtWS>



<bizsolo:ifCrtWS name="RegistrationConfirmation" >
<bizsolo:executeAction wsName="RegistrationConfirmation" epClassName="com.savvion.sbm.adapters.email.EmailAdapter" perfMethod="execute" dsi="SalesrepCode,CustomerEmail,password,CustomerName,SelectedVehicleBrand,CustomerEmail" />
<bizsolo:forwardURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=CustomerLogin" />
</bizsolo:ifCrtWS>



<bizsolo:ifCrtWS name="createOrder" >
<bizsolo:executeAction wsName="createOrder" epClassName="com.savvion.BizSolo.beans.PAKCreatePI" perfMethod="commit" dsi="BIZSITE_USER@bizsite_user,PT_NAME@ptName,BIZSITE_PASSWORD@bizsite_pass,SelectedVehicleBrand@VehicleBrand,SelectedVehicleModel@VehicleModel,CustomerCreditLimit@CustomerCreditLimit,CustomerEmail@CustomerEmail,CustomerId@CustomerId,CustomerName@CustomerName,DealerCode@DealerCode,ModelName@ModelName" dso="error@error,ModelName@ModelName" />
<bizsolo:forwardURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=CustomerLogout" />
</bizsolo:ifCrtWS>



<bizsolo:ifCrtWS name="Decision_3" >
<bizsolo:if test="<%= ContextId!=null %>" >
<bizsolo:redirectURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=createOrder" />
</bizsolo:if>
<% // executed  only when condition is not true %>
<bizsolo:forwardURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=LoginCustomer" />
</bizsolo:ifCrtWS>

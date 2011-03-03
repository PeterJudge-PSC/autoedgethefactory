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



<%Vector SelectedAccessories=bean.getPropVector("SelectedAccessories");
String SelectedDealerName=bean.getPropString("SelectedDealerName");
long CustomerCreditLimit=bean.getPropLong("CustomerCreditLimit");
String CustomerId=bean.getPropString("CustomerId");
long OrderNum=bean.getPropLong("OrderNum");
String OrderChannel=bean.getPropString("OrderChannel");
String AutoEdgeWebServiceEndpoint=bean.getPropString("AutoEdgeWebServiceEndpoint");
String CustomerEmail=bean.getPropString("CustomerEmail");
String userid=bean.getPropString("userid");
String password=bean.getPropString("password");
String BIZSITE_PASSWORD=bean.getPropString("BIZSITE_PASSWORD");
String BIZSITE_USER=bean.getPropString("BIZSITE_USER");
String PAK_URL=bean.getPropString("PAK_URL");
String PT_NAME=bean.getPropString("PT_NAME");
String error=bean.getPropString("error");
String SelectedVehicleBrand=bean.getPropString("SelectedVehicleBrand");
String SelectedVehicleModel=bean.getPropString("SelectedVehicleModel");
String VehicleModelsCompact=bean.getPropString("VehicleModelsCompact");
String VehicleModelsSUV=bean.getPropString("VehicleModelsSUV");
String VehicleModelsTruck=bean.getPropString("VehicleModelsTruck");
String VehicleModelsSedan=bean.getPropString("VehicleModelsSedan");
String VehicleModelsPremium=bean.getPropString("VehicleModelsPremium");
String InteriorSeatMaterial=bean.getPropString("InteriorSeatMaterial");
String InteriorTrimColour=bean.getPropString("InteriorTrimColour");
String InteriorAccessories=bean.getPropString("InteriorAccessories");
String ExteriorColour=bean.getPropString("ExteriorColour");
String ExteriorMoonroof=bean.getPropString("ExteriorMoonroof");
String ExteriorWheels=bean.getPropString("ExteriorWheels");
String DealerCode=bean.getPropString("DealerCode");
String ContextId=bean.getPropString("ContextId");
String SelectedTrimColour=bean.getPropString("SelectedTrimColour");
String SelectedSeatMaterial=bean.getPropString("SelectedSeatMaterial");
String SelectedWheels=bean.getPropString("SelectedWheels");
String SelectedMoonroof=bean.getPropString("SelectedMoonroof");
String SelectedExtColour=bean.getPropString("SelectedExtColour");
String BrandDealers=bean.getPropString("BrandDealers");
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



<bizsolo:ifCrtWS name="LoginUser" >
<bizsolo:choose >
<bizsolo:when test="<%=\"procReq\".equals(request.getParameter(\"activityMode\")) %>" >
<bizsolo:setDS name="password,userid"/><bizsolo:choose >
<bizsolo:when test="<%=\"Login\".equals(request.getParameter(\"SB_Name\")) || \"73596745\".equals(request.getParameter(\"SB_Name\")) || \"Registered\".equals(request.getParameter(\"SB_Name\")) || \"123533986\".equals(request.getParameter(\"SB_Name\")) %>" >
<bizsolo:forwardURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=ApplicationUserLogin" />
</bizsolo:when>
</bizsolo:choose>
</bizsolo:when>
<bizsolo:otherwise >
<bizsolo:redirectURL page="LoginUser.jsp" />
</bizsolo:otherwise>
</bizsolo:choose>
</bizsolo:ifCrtWS>



<bizsolo:ifCrtWS name="PreOrderLoginUser" >
<bizsolo:choose >
<bizsolo:when test="<%=\"procReq\".equals(request.getParameter(\"activityMode\")) %>" >
<bizsolo:setDS name="userid,password"/><bizsolo:choose >
<bizsolo:when test="<%=\"Login\".equals(request.getParameter(\"SB_Name\")) || \"73596745\".equals(request.getParameter(\"SB_Name\")) || \"Copy of Registered\".equals(request.getParameter(\"SB_Name\")) || \"-274729152\".equals(request.getParameter(\"SB_Name\")) %>" >
<bizsolo:forwardURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=PreOrderApplicationUserLogin" />
</bizsolo:when>
</bizsolo:choose>
</bizsolo:when>
<bizsolo:otherwise >
<bizsolo:redirectURL page="PreOrderLoginUser.jsp" />
</bizsolo:otherwise>
</bizsolo:choose>
</bizsolo:ifCrtWS>



<bizsolo:ifCrtWS name="ReviewSelection" >
<bizsolo:choose >
<bizsolo:when test="<%=\"procReq\".equals(request.getParameter(\"activityMode\")) %>" >
<bizsolo:setDS name="DealerCode,BrandDealers,InteriorAccessories"/><bizsolo:choose >
<bizsolo:when test="<%=\"Done\".equals(request.getParameter(\"SB_Name\")) || \"2135970\".equals(request.getParameter(\"SB_Name\")) || \"linkCreateOrder\".equals(request.getParameter(\"SB_Name\")) || \"-2060367016\".equals(request.getParameter(\"SB_Name\")) %>" >
<bizsolo:forwardURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=Decision_1" />
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
<bizsolo:setDS name="SelectedVehicleBrand"/><% System.out.println(bean.getPropString("VehicleYear"));%>
<bizsolo:choose >
<bizsolo:when test="<%=\"Continue\".equals(request.getParameter(\"SB_Name\")) || \"-502558521\".equals(request.getParameter(\"SB_Name\")) || \"SelectModel\".equals(request.getParameter(\"SB_Name\")) || \"1866546029\".equals(request.getParameter(\"SB_Name\")) %>" >
<bizsolo:forwardURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=SpecifyOrder" />
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
<bizsolo:setDS name="SelectedVehicleModel,SelectedDealerName,VehicleModelsTruck,VehicleModelsSUV,VehicleModelsSedan,VehicleModelsPremium,VehicleModelsCompact"/><bizsolo:choose >
<bizsolo:when test="<%=\"Select Options and Accessories\".equals(request.getParameter(\"SB_Name\")) || \"-1057362527\".equals(request.getParameter(\"SB_Name\")) || \"linkSelectOptions\".equals(request.getParameter(\"SB_Name\")) || \"-1598202840\".equals(request.getParameter(\"SB_Name\")) %>" >
<bizsolo:forwardURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=SelectVehicleOptions" />
</bizsolo:when>
</bizsolo:choose>
</bizsolo:when>
<bizsolo:otherwise >
<bizsolo:redirectURL page="SelectModel.jsp" />
</bizsolo:otherwise>
</bizsolo:choose>
</bizsolo:ifCrtWS>



<bizsolo:ifCrtWS name="SelectVehicleOptions" >
<bizsolo:choose >
<bizsolo:when test="<%=\"procReq\".equals(request.getParameter(\"activityMode\")) %>" >
<bizsolo:setDS name="InteriorSeatMaterial,SelectedSeatMaterial,InteriorTrimColour,SelectedTrimColour,InteriorAccessories,SelectedAccessories,ExteriorColour,SelectedExtColour,ExteriorWheels,SelectedWheels,ExteriorMoonroof,SelectedMoonroof"/><bizsolo:choose >
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



<bizsolo:ifCrtWS name="SpecifyOrder" >
<bizsolo:choose >
<bizsolo:when test="<%=\"procReq\".equals(request.getParameter(\"activityMode\")) %>" >
<bizsolo:setDS name="OrderNum"/><% System.out.println(bean.getPropString("userid"));%>
<bizsolo:choose >
<bizsolo:when test="<%=\"Continue\".equals(request.getParameter(\"SB_Name\")) || \"-502558521\".equals(request.getParameter(\"SB_Name\")) || \"Connection 18\".equals(request.getParameter(\"SB_Name\")) || \"285694601\".equals(request.getParameter(\"SB_Name\")) %>" >
<bizsolo:forwardURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=Decision_2" />
</bizsolo:when>
</bizsolo:choose>
</bizsolo:when>
<bizsolo:otherwise >
<bizsolo:redirectURL page="SpecifyOrder.jsp" />
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



<bizsolo:ifCrtWS name="ApplicationUserLogin" >
<bizsolo:executeAction wsName="ApplicationUserLogin" epClassName="com.savvion.sbm.adapters.webservice.WebServiceAdapter" perfMethod="execute" dsi="password,SelectedVehicleBrand,AutoEdgeWebServiceEndpoint,userid" dso="ContextId,CustomerEmail,CustomerId,CustomerCreditLimit" />
<bizsolo:forwardURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=Decision_3" />
</bizsolo:ifCrtWS>



<bizsolo:ifCrtWS name="GetBrandDetails" >
<bizsolo:executeAction wsName="GetBrandDetails" epClassName="com.savvion.sbm.adapters.webservice.WebServiceAdapter" perfMethod="execute" dsi="OrderNum,ContextId,SelectedVehicleBrand,AutoEdgeWebServiceEndpoint" dso="VehicleModelsCompact,VehicleModelsSUV,VehicleModelsPremium,InteriorTrimColour,ExteriorMoonroof,BrandDealers,ExteriorColour,VehicleModelsTruck,error,InteriorAccessories,InteriorSeatMaterial,VehicleModelsSedan,ExteriorWheels" />
<bizsolo:forwardURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=SelectModel" />
</bizsolo:ifCrtWS>



<bizsolo:ifCrtWS name="PreOrderApplicationUserLogin" >
<bizsolo:executeAction wsName="PreOrderApplicationUserLogin" epClassName="com.savvion.sbm.adapters.webservice.WebServiceAdapter" perfMethod="execute" dsi="password,SelectedVehicleBrand,AutoEdgeWebServiceEndpoint,userid" dso="ContextId,CustomerEmail,CustomerId,CustomerCreditLimit" />
<bizsolo:forwardURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=Copy_of_Decision_3" />
</bizsolo:ifCrtWS>



<bizsolo:ifCrtWS name="createOrder" >
<bizsolo:executeAction wsName="createOrder" epClassName="com.savvion.BizSolo.beans.PAKCreatePI" perfMethod="commit" dsi="BIZSITE_USER@BIZSITE_USER,PT_NAME@PT_NAME,BIZSITE_PASSWORD@BIZSITE_PASSWORD,SelectedVehicleBrand@VehicleBrand,SelectedVehicleModel@VehicleModel,userid@CustomerName,CustomerEmail@CustomerEmail,OrderChannel@OrderChannel,CustomerId@CustomerId,CustomerCreditLimit@CustomerCreditLimit,SelectedExtColour@ExteriorColour,SelectedMoonroof@ExteriorMoonroof,SelectedSeatMaterial@InteriorSeatMaterial,SelectedTrimColour@InteriorTrimColour,SelectedWheels@ExteriorWheels,DealerCode@DealerCode,SelectedAccessories@SelectedAccessories" dso="error@error" />
<bizsolo:forwardURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=ExitPage" />
</bizsolo:ifCrtWS>



<bizsolo:ifCrtWS name="Copy_of_Decision_3" >
<bizsolo:if test="<%= ContextId!=null %>" >
<bizsolo:redirectURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=createOrder" />
</bizsolo:if>
<% // executed  only when condition is not true %>
<bizsolo:forwardURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=PreOrderLoginUser" />
</bizsolo:ifCrtWS>



<bizsolo:ifCrtWS name="Decision_1" >
<bizsolo:if test="<%= ContextId!=null %>" >
<bizsolo:redirectURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=createOrder" />
</bizsolo:if>
<% // executed  only when condition is not true %>
<bizsolo:forwardURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=PreOrderLoginUser" />
</bizsolo:ifCrtWS>



<bizsolo:ifCrtWS name="Decision_2" >
<bizsolo:if test="<%= OrderNum>0 %>" >
<bizsolo:redirectURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=LoginUser" />
</bizsolo:if>
<% // executed  only when condition is not true %>
<bizsolo:forwardURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=GetBrandDetails" />
</bizsolo:ifCrtWS>



<bizsolo:ifCrtWS name="Decision_3" >
<bizsolo:if test="<%= ContextId!=null %>" >
<bizsolo:redirectURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=GetBrandDetails" />
</bizsolo:if>
<% // executed  only when condition is not true %>
<bizsolo:forwardURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=LoginUser" />
</bizsolo:ifCrtWS>

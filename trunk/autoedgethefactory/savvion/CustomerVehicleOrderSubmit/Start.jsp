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
Vector DealerList=bean.getPropVector("DealerList");
String DealerId=bean.getPropString("DealerId");
String ExteriorWheels=bean.getPropString("ExteriorWheels");
String ExteriorMoonroof=bean.getPropString("ExteriorMoonroof");
String ExteriorColour=bean.getPropString("ExteriorColour");
String InteriorAccessories=bean.getPropString("InteriorAccessories");
String InteriorTrimColour=bean.getPropString("InteriorTrimColour");
String InteriorSeatMaterial=bean.getPropString("InteriorSeatMaterial");
String DealerName=bean.getPropString("DealerName");
Vector VehicleModelsPremium=bean.getPropVector("VehicleModelsPremium");
Vector VehicleModelsSedan=bean.getPropVector("VehicleModelsSedan");
Vector VehicleModelsTruck=bean.getPropVector("VehicleModelsTruck");
Vector VehicleModelsSUV=bean.getPropVector("VehicleModelsSUV");
Vector VehicleModelsCompact=bean.getPropVector("VehicleModelsCompact");
String SelectedVehicleModel=bean.getPropString("SelectedVehicleModel");
String SelectedVehicleBrand=bean.getPropString("SelectedVehicleBrand");
String error=bean.getPropString("error");
String PT_NAME=bean.getPropString("PT_NAME");
String PAK_URL=bean.getPropString("PAK_URL");
String BIZSITE_USER=bean.getPropString("BIZSITE_USER");
String BIZSITE_PASSWORD=bean.getPropString("BIZSITE_PASSWORD");
long orderid=bean.getPropLong("orderid");
String password=bean.getPropString("password");
String userid=bean.getPropString("userid");
String CustomerEmail=bean.getPropString("CustomerEmail");
String DealerEmail=bean.getPropString("DealerEmail");
String AutoEdgeWebServiceEndpoint=bean.getPropString("AutoEdgeWebServiceEndpoint");
String OrderChannel=bean.getPropString("OrderChannel");
long OrderNum=bean.getPropLong("OrderNum");
String CustomerId=bean.getPropString("CustomerId");
long CustomerCreditLimit=bean.getPropLong("CustomerCreditLimit");
%>




<bizsolo:ifCrtWS name="ExitPage" >
<bizsolo:choose >
<bizsolo:when test="<%=\"procReq\".equals(request.getParameter(\"activityMode\")) %>" >

<bizsolo:choose >
<bizsolo:when test="<%=\"Connection 16\".equals(new String(request.getParameter(\"SB_Name\").getBytes(\"8859_1\"), \"UTF-8\")) || \"285694599\".equals(new String(request.getParameter(\"SB_Name\").getBytes(\"8859_1\"), \"UTF-8\")) %>" >
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
<bizsolo:when test="<%=\"Login\".equals(new String(request.getParameter(\"SB_Name\").getBytes(\"8859_1\"), \"UTF-8\")) || \"73596745\".equals(new String(request.getParameter(\"SB_Name\").getBytes(\"8859_1\"), \"UTF-8\")) || \"Registered\".equals(new String(request.getParameter(\"SB_Name\").getBytes(\"8859_1\"), \"UTF-8\")) || \"123533986\".equals(new String(request.getParameter(\"SB_Name\").getBytes(\"8859_1\"), \"UTF-8\")) %>" >
<bizsolo:forwardURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=ApplicationUserLogin" />
</bizsolo:when>
</bizsolo:choose>
</bizsolo:when>
<bizsolo:otherwise >
<bizsolo:redirectURL page="LoginUser.jsp" />
</bizsolo:otherwise>
</bizsolo:choose>
</bizsolo:ifCrtWS>



<bizsolo:ifCrtWS name="LoginUser" >
<bizsolo:choose >
<bizsolo:when test="<%=\"procReq\".equals(request.getParameter(\"activityMode\")) %>" >
<bizsolo:setDS name="password,userid"/><bizsolo:choose >
<bizsolo:when test="<%=\"Login\".equals(new String(request.getParameter(\"SB_Name\").getBytes(\"8859_1\"), \"UTF-8\")) || \"73596745\".equals(new String(request.getParameter(\"SB_Name\").getBytes(\"8859_1\"), \"UTF-8\")) || \"Copy of Registered\".equals(new String(request.getParameter(\"SB_Name\").getBytes(\"8859_1\"), \"UTF-8\")) || \"-274729152\".equals(new String(request.getParameter(\"SB_Name\").getBytes(\"8859_1\"), \"UTF-8\")) %>" >
<bizsolo:forwardURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=PreOrderApplicationUserLogin" />
</bizsolo:when>
</bizsolo:choose>
</bizsolo:when>
<bizsolo:otherwise >
<bizsolo:redirectURL page="LoginUser.jsp" />
</bizsolo:otherwise>
</bizsolo:choose>
</bizsolo:ifCrtWS>



<bizsolo:ifCrtWS name="ReviewSelection" >
<bizsolo:choose >
<bizsolo:when test="<%=\"procReq\".equals(request.getParameter(\"activityMode\")) %>" >
<bizsolo:setDS name="DealerId,DealerEmail,CustomerEmail,DealerName"/><bizsolo:choose >
<bizsolo:when test="<%=\"Done\".equals(new String(request.getParameter(\"SB_Name\").getBytes(\"8859_1\"), \"UTF-8\")) || \"2135970\".equals(new String(request.getParameter(\"SB_Name\").getBytes(\"8859_1\"), \"UTF-8\")) || \"linkCreateOrder\".equals(new String(request.getParameter(\"SB_Name\").getBytes(\"8859_1\"), \"UTF-8\")) || \"-2060367016\".equals(new String(request.getParameter(\"SB_Name\").getBytes(\"8859_1\"), \"UTF-8\")) %>" >
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
<bizsolo:when test="<%=\"Continue\".equals(new String(request.getParameter(\"SB_Name\").getBytes(\"8859_1\"), \"UTF-8\")) || \"-502558521\".equals(new String(request.getParameter(\"SB_Name\").getBytes(\"8859_1\"), \"UTF-8\")) || \"SelectModel\".equals(new String(request.getParameter(\"SB_Name\").getBytes(\"8859_1\"), \"UTF-8\")) || \"1866546029\".equals(new String(request.getParameter(\"SB_Name\").getBytes(\"8859_1\"), \"UTF-8\")) %>" >
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
<bizsolo:setDS name="SelectedVehicleModel"/><bizsolo:choose >
<bizsolo:when test="<%=\"Select Options and Accessories\".equals(new String(request.getParameter(\"SB_Name\").getBytes(\"8859_1\"), \"UTF-8\")) || \"-1057362527\".equals(new String(request.getParameter(\"SB_Name\").getBytes(\"8859_1\"), \"UTF-8\")) || \"linkSelectOptions\".equals(new String(request.getParameter(\"SB_Name\").getBytes(\"8859_1\"), \"UTF-8\")) || \"-1598202840\".equals(new String(request.getParameter(\"SB_Name\").getBytes(\"8859_1\"), \"UTF-8\")) %>" >
<bizsolo:forwardURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=selectVehicleOptions" />
</bizsolo:when>
</bizsolo:choose>
</bizsolo:when>
<bizsolo:otherwise >
<bizsolo:redirectURL page="SelectModel.jsp" />
</bizsolo:otherwise>
</bizsolo:choose>
</bizsolo:ifCrtWS>



<bizsolo:ifCrtWS name="SpecifyOrder" >
<bizsolo:choose >
<bizsolo:when test="<%=\"procReq\".equals(request.getParameter(\"activityMode\")) %>" >
<bizsolo:setDS name="OrderNum"/><% System.out.println(bean.getPropString("userid"));%>
<bizsolo:choose >
<bizsolo:when test="<%=\"Continue\".equals(new String(request.getParameter(\"SB_Name\").getBytes(\"8859_1\"), \"UTF-8\")) || \"-502558521\".equals(new String(request.getParameter(\"SB_Name\").getBytes(\"8859_1\"), \"UTF-8\")) || \"Connection 18\".equals(new String(request.getParameter(\"SB_Name\").getBytes(\"8859_1\"), \"UTF-8\")) || \"285694601\".equals(new String(request.getParameter(\"SB_Name\").getBytes(\"8859_1\"), \"UTF-8\")) %>" >
<bizsolo:forwardURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=Decision_2" />
</bizsolo:when>
</bizsolo:choose>
</bizsolo:when>
<bizsolo:otherwise >
<bizsolo:redirectURL page="SpecifyOrder.jsp" />
</bizsolo:otherwise>
</bizsolo:choose>
</bizsolo:ifCrtWS>



<bizsolo:ifCrtWS name="selectVehicleOptions" >
<bizsolo:choose >
<bizsolo:when test="<%=\"procReq\".equals(request.getParameter(\"activityMode\")) %>" >
<bizsolo:setDS name="ExteriorMoonroof,ExteriorWheels,ExteriorColour,InteriorAccessories,InteriorTrimColour,InteriorSeatMaterial"/><bizsolo:choose >
<bizsolo:when test="<%=\"Review and Complete Order\".equals(new String(request.getParameter(\"SB_Name\").getBytes(\"8859_1\"), \"UTF-8\")) || \"-1494740808\".equals(new String(request.getParameter(\"SB_Name\").getBytes(\"8859_1\"), \"UTF-8\")) || \"linkOptionsReviewSelection\".equals(new String(request.getParameter(\"SB_Name\").getBytes(\"8859_1\"), \"UTF-8\")) || \"883196720\".equals(new String(request.getParameter(\"SB_Name\").getBytes(\"8859_1\"), \"UTF-8\")) %>" >
<bizsolo:forwardURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=ReviewSelection" />
</bizsolo:when>
</bizsolo:choose>
</bizsolo:when>
<bizsolo:otherwise >
<bizsolo:redirectURL page="selectVehicleOptions.jsp" />
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



<bizsolo:ifCrtWS name="PreOrderApplicationUserLogin" >
<bizsolo:executeAction wsName="PreOrderApplicationUserLogin" epClassName="com.savvion.sbm.adapters.webservice.WebServiceAdapter" perfMethod="execute" dsi="password,SelectedVehicleBrand,AutoEdgeWebServiceEndpoint,userid" dso="ContextId,CustomerEmail,CustomerId,CustomerCreditLimit" />
<bizsolo:forwardURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=Copy_of_Decision_3" />
</bizsolo:ifCrtWS>



<bizsolo:ifCrtWS name="createOrder" >
<bizsolo:executeAction wsName="createOrder" epClassName="com.savvion.BizSolo.beans.PAKCreatePI" perfMethod="commit" dsi="BIZSITE_USER@BIZSITE_USER,PT_NAME@PT_NAME,BIZSITE_PASSWORD@BIZSITE_PASSWORD,SelectedVehicleBrand@VehicleBrand,SelectedVehicleModel@VehicleModel,userid@userid,DealerName@DealerName,InteriorTrimColour@InteriorTrimColour,InteriorSeatMaterial@InteriorSeatMaterial,InteriorAccessories@InteriorAccessories,ExteriorWheels@ExteriorWheels,ExteriorMoonroof@ExteriorMoonroof,ExteriorColour@ExteriorColour,CustomerEmail@CustomerEmail,OrderChannel@OrderChannel,DealerEmail@DealerEmail,DealerId@DealerId,CustomerId@CustomerId,CustomerCreditLimit@CreditLimit,OrderNum@OrderNum" dso="error@error,CustomerId@CustomerId,CustomerCreditLimit@CreditLimit,OrderNum@OrderNum" />
<bizsolo:forwardURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=ExitPage" />
</bizsolo:ifCrtWS>



<bizsolo:ifCrtWS name="wsBrandDetails" >
<bizsolo:executeAction wsName="wsBrandDetails" epClassName="com.savvion.sbm.adapters.webservice.WebServiceAdapter" perfMethod="execute" dsi="OrderNum,ContextId,SelectedVehicleBrand,AutoEdgeWebServiceEndpoint" dso="VehicleModelsCompact,VehicleModelsSUV,VehicleModelsPremium,InteriorTrimColour,ExteriorMoonroof,ExteriorColour,VehicleModelsTruck,InteriorAccessories,DealerList,InteriorSeatMaterial,ExteriorWheels,VehicleModelsSedan" />
<bizsolo:forwardURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=SelectModel" />
</bizsolo:ifCrtWS>



<bizsolo:ifCrtWS name="Copy_of_Decision_3" >
<bizsolo:if test="<%= ContextId!=null %>" >
<bizsolo:redirectURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=createOrder" />
</bizsolo:if>
<% // executed  only when condition is not true %>
<bizsolo:forwardURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=LoginUser" />
</bizsolo:ifCrtWS>



<bizsolo:ifCrtWS name="Decision_1" >
<bizsolo:if test="<%= ContextId!=null %>" >
<bizsolo:redirectURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=createOrder" />
</bizsolo:if>
<% // executed  only when condition is not true %>
<bizsolo:forwardURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=LoginUser" />
</bizsolo:ifCrtWS>



<bizsolo:ifCrtWS name="Decision_2" >
<bizsolo:if test="<%= OrderNum>0 %>" >
<bizsolo:redirectURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=LoginUser" />
</bizsolo:if>
<% // executed  only when condition is not true %>
<bizsolo:forwardURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=wsBrandDetails" />
</bizsolo:ifCrtWS>



<bizsolo:ifCrtWS name="Decision_3" >
<bizsolo:if test="<%= ContextId!=null %>" >
<bizsolo:redirectURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=wsBrandDetails" />
</bizsolo:if>
<% // executed  only when condition is not true %>
<bizsolo:forwardURL page="Start.jsp?crtApp=CustomerVehicleOrderSubmit&crtPage=LoginUser" />
</bizsolo:ifCrtWS>

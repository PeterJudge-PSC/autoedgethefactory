<html xmlns:bizsolo="http://www.savvion.com/sbm/BizSolo" xmlns:sbm="http://www.savvion.com/sbm" xmlns:jsp="http://java.sun.com/JSP/Page" xmlns:xalan="http://xml.apache.org/xalan" xmlns:fn="http://www.w3.org/2005/02/xpath-functions" xmlns:sfe="http://www.savvion.com/sbm/sfe" xmlns:c="http://java.sun.com/jsp/jstl/core">
<head><META http-equiv="Content-Type" content="text/html; charset=utf-8">

<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.savvion.BizSolo.Server.*,com.savvion.BizSolo.beans.*,com.savvion.sbm.util.DatabaseMapping,java.util.Vector,java.util.Locale" %>
<%@ page errorPage="/BizSolo/common/jsp/error.jsp" %>
<%@ taglib uri="/BizSolo/common/tlds/bizsolo.tld" prefix="bizsolo" %>
<%@ taglib uri="/bpmportal/tld/bpmportal.tld" prefix="sbm" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib prefix="sfe" uri="http://jmaki/v1.0/jsp" %>
  <jsp:useBean id="bizManage" class="com.savvion.sbm.bizmanage.api.BizManageBean" scope="session"></jsp:useBean>
  <jsp:useBean id="bean" class="com.savvion.BizSolo.beans.Bean" scope="session"></jsp:useBean>
  <jsp:useBean id="factoryBean" class="com.savvion.BizSolo.beans.EPFactoryBean" scope="session"></jsp:useBean>
  <jsp:useBean id="bizSite" class="com.savvion.sbm.bpmportal.bizsite.api.BizSiteBean" scope="session"></jsp:useBean>
<%! String _PageName = "CreditCheck"; %>
<%! String __webAppName = "CustomerOrderVehicle"; %>
<% pageContext.setAttribute( "contextPath", request.getContextPath()+"/"); %>
<% pageContext.setAttribute( "maxMulitLineLength", DatabaseMapping.self().getSQLSize(java.lang.String.class));  %>
<bizsolo:if test='<%=_PageName.equals(request.getParameter("_PageName")) %>'>
    <bizsolo:setDS name="CreditApproval,CustomerCreditLimit,CustomerEmail,CustomerId,CustomerName,CustomerOrderDate,DealerCode,DealerName,ModelName,OrderChannel,VehicleBrand,CustomerName"></bizsolo:setDS>
    <bizsolo:choose>
<bizsolo:when test='<%=request.getParameter("bizsite_reassignTask") !=null %>'>
      <bizsolo:initDS name="performer" param="bizsite_assigneeName" hexval="FALSE"></bizsolo:initDS>
      <bizsolo:executeAction epClassName="com.savvion.BizSolo.beans.PAKReassignWI" perfMethod="commit" mode="BizSite" dsi="VehicleBrand,ModelName,DealerName,DealerCode,CustomerOrderDate,CustomerName,CustomerId,CustomerEmail,OrderChannel" dso="CustomerCreditLimit,CreditApproval"></bizsolo:executeAction>
</bizsolo:when>
<bizsolo:when test='<%=request.getParameter("bizsite_saveTask") !=null %>'>
      <bizsolo:executeAction epClassName="com.savvion.BizSolo.beans.PAKUpdateDS" perfMethod="commit" mode="BizSite" dsi="CustomerCreditLimit,CreditApproval"></bizsolo:executeAction>
</bizsolo:when>
    <bizsolo:otherwise>
      <bizsolo:executeAction epClassName="com.savvion.BizSolo.beans.PAKSetDS" perfMethod="commit" mode="BizSite" dsi="CustomerCreditLimit,CreditApproval" res=""></bizsolo:executeAction>
      </bizsolo:otherwise>
    </bizsolo:choose>
<% /* Workaround, retAddr will disappear in the future */ %>
<% String retAddr = bean.getPropString("returnPage"); %>
<% if(retAddr != null) { %>
<bizsolo:redirectURL page="<%= retAddr %>"/>
<% } %>
</bizsolo:if>
<bizsolo:if test='<%= ! _PageName.equals(request.getParameter("_PageName")) %>'>
    <bizsolo:initApp mode="BizSite" name="CustomerOrderVehicle"></bizsolo:initApp>
    <bizsolo:initDS name="CreditApproval" type="BOOLEAN"></bizsolo:initDS>
<bizsolo:initDS name="CustomerCreditLimit" type="BUSINESSOBJECT" classType="com.progress.lang.Decimal"></bizsolo:initDS>
    <bizsolo:initDS name="CustomerEmail" type="STRING"></bizsolo:initDS>
    <bizsolo:initDS name="CustomerId" type="STRING"></bizsolo:initDS>
    <bizsolo:initDS name="CustomerName" type="STRING"></bizsolo:initDS>
    <bizsolo:initDS name="CustomerOrderDate" type="DATETIME"></bizsolo:initDS>
    <bizsolo:initDS name="DealerCode" type="STRING"></bizsolo:initDS>
    <bizsolo:initDS name="DealerName" type="STRING"></bizsolo:initDS>
    <bizsolo:initDS name="ModelName" type="STRING"></bizsolo:initDS>
    <bizsolo:initDS name="OrderChannel" type="STRING"></bizsolo:initDS>
    <bizsolo:initDS name="VehicleBrand" type="STRING"></bizsolo:initDS>
    <bizsolo:initDS name="CustomerName" type="STRING"></bizsolo:initDS>
    <bizsolo:executeAction epClassName="com.savvion.BizSolo.beans.PAKGetDS" perfMethod="commit" mode="BizSite" dso="CustomerCreditLimit,VehicleBrand,ModelName,DealerName,DealerCode,CustomerOrderDate,CustomerName,CustomerId,CustomerEmail,CreditApproval,OrderChannel"></bizsolo:executeAction>
</bizsolo:if>

<title>CreditCheck</title>
<%boolean isStandaloneBS = (bizManage == null || bizManage.getName() == null || "".equals(bizManage.getName()) || bizManage.getLocale() == null);Locale myLocale = (!isStandaloneBS) ? bizManage.getLocale() : request.getLocale();%>
<!-- Javascript -->
<script language="JavaScript"> var getLocalizedString = parent.getLocalizedString; </script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/initControls.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/customValidation.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/prototype.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/effects.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/scriptaculous.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/pwr.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>dwr/engine.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/cal.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>dwr/util.js"></script>
<script>DWREngine = dwr.engine; DWRUtil = dwr.util;</script><script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/utilities.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/fvalidate/fValidate.config.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/fvalidate/fValidate.core.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/fvalidate/fValidate.lang-<%=myLocale.getLanguage()%><%=myLocale.getCountry()%>.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/fvalidate/fValidate.validators.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/fvalidate/fValidate.validators-<%=myLocale.getLanguage()%><%=myLocale.getCountry()%>.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/fvalidate/pValidate.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/document.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/jscalendar/calendar.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/jscalendar/calendar-<%=myLocale.getLanguage() %>.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/jscalendar/calendar-setup-<%=myLocale.getLanguage() %>.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>dwr/interface/adapterDWR.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/yahoo/utilities/utilities.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/yahoo/container/container-min.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/yahoo/connection/connection-min.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/yahoo/resize/resize-beta-min.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/yahoo/json/json-min.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/yahoo/logger/logger-min.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/spry/checkboxvalidation/SpryValidationCheckbox.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/spry/confirmvalidation/SpryValidationConfirm.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/spry/passwordvalidation/SpryValidationPassword.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/spry/radiovalidation/SpryValidationRadio.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/spry/selectvalidation/SpryValidationSelect.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/spry/textareavalidation/SpryValidationTextarea.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/spry/textfieldvalidation/SpryValidationTextField.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/spry//SpryEffects.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/ext/adapter/ext/ext-base.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/ext/ext-all.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/ext/PagingRowNumberer.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/BmViewport.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/sbm/WaitDialog.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/sbm/LoggerDialog.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/sbm/ResizableDialog.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/sbm/FormWidget.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/sbm/FormWidgetHandler.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/sbm/TransactionAjaxObject.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/sbm/BusinessObjectHandler.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/sbm/sbm.utils.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/ux/fileuploadfield/FileUploadField.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/bm/common/bmfield.js"></script>
<script language="JavaScript" src="<c:out value='${contextPath}'/>bpmportal/javascript/fileupload.js"></script>
<link rel="stylesheet" type="text/css" href="<c:out value='${contextPath}'/>bpmportal/javascript/yahoo/fonts/fonts.css">
<link rel="stylesheet" type="text/css" href="<c:out value='${contextPath}'/>bpmportal/javascript/yahoo/resize/assets/skins/sam/resize.css">
<link rel="stylesheet" type="text/css" href="<c:out value='${contextPath}'/>bpmportal/javascript/yahoo/container/assets/skins/sam/container.css">
<link rel="stylesheet" type="text/css" href="<c:out value='${contextPath}'/>bpmportal/javascript/yahoo/logger/assets/skins/sam/logger.css">
<link rel="stylesheet" type="text/css" href="<c:out value='${contextPath}'/>bpmportal/javascript/spry/checkboxvalidation/SpryValidationCheckbox.css">
<link rel="stylesheet" type="text/css" href="<c:out value='${contextPath}'/>bpmportal/javascript/spry/confirmvalidation/SpryValidationConfirm.css">
<link rel="stylesheet" type="text/css" href="<c:out value='${contextPath}'/>bpmportal/javascript/spry/textareavalidation/SpryValidationTextarea.css">
<link rel="stylesheet" type="text/css" href="<c:out value='${contextPath}'/>bpmportal/javascript/spry/passwordvalidation/SpryValidationPassword.css">
<link rel="stylesheet" type="text/css" href="<c:out value='${contextPath}'/>bpmportal/javascript/spry/radiovalidation/SpryValidationRadio.css">
<link rel="stylesheet" type="text/css" href="<c:out value='${contextPath}'/>bpmportal/javascript/spry/selectvalidation/SpryValidationSelect.css">
<link rel="stylesheet" type="text/css" href="<c:out value='${contextPath}'/>bpmportal/javascript/spry/textfieldvalidation/SpryValidationTextField.css">
<link rel="stylesheet" type="text/css" href="<c:out value='${contextPath}'/>bpmportal/javascript/ext/resources/css/ext-all.css">
<bizsolo:link rel="stylesheet"></bizsolo:link>
<link rel="stylesheet" type="text/css" href="<c:out value='${contextPath}'/>bpmportal/css/<%= bizManage.getTheme() %>/bm-all.css">
<link rel="stylesheet" type="text/css" href="<c:out value='${contextPath}'/>bpmportal/css/<%= bizManage.getTheme() %>/bm-xml.css">
<script language="JavaScript">
 Ext.BLANK_IMAGE_URL = '<c:out value='${contextPath}'/>bpmportal/javascript/ext/resources/images/default/s.gif';
	 
	  var isIFrame = <%= (PublicResources.INTERACTIVE_MODE.equalsIgnoreCase(bean.getPropString(PublicResources.MODE)) || PublicResources.SLAVE_MODE.equalsIgnoreCase(bean.getPropString(PublicResources.MODE))) ? true : false %>;
	  
<!--
    function AlertReassign()
    {
      if (document.form.elements['bizsite_assigneeName'].value == '' )
      {
        alert('Please provide assignee name!')
        document.form.elements['bizsite_assigneeName'].focus();
        return false;
      }
      else
      {
        return true;
      }
    }
    
    var uploadWnd;
    var param;
 
    function openDocAttWin( slotName,sesID, ptname, piname, docurl, docServer, readonly, ismultiline, appendwith, isStart )
    {
      param = 'bzsid=' + sesID;
      param += '&pt=' + ptname;
      param += '&pi=' + piname;
      param += '&ds=' + slotName;
      param += '&docurl=' + docurl;
      param += '&readonly=' + readonly;
      param += '&ismultiline=' + ismultiline;
      param += '&appendwith=' + appendwith;
      param += '&isPICreation=' + isStart;
      uploadWnd = openDocumentPresentation(docServer + '/BizSite.DocAttacher?' + param, isIFrame);
    }

    function setCheckBoxStyleForIE()
    {
      var isIE = (navigator.appName == "Microsoft Internet Explorer") ? 1 : 0;
      var w_Elements = document.getElementsByTagName("input");
      for ( i=0; i < w_Elements.length; ++i)
      {
          if(isIE && (w_Elements.item(i).getAttribute("type") == "checkbox" || w_Elements.item(i).getAttribute("type") == "radio"))
            w_Elements.item(i).className = "ChkBoxNone";
      }
    }
    
    function onSuccess() {
    }
    
    
   function editDecimal(element,pms,scale)
    {
    if(typeof element == 'string') element = document.getElementById(element);
	var id = element.getAttribute('id');
	if (element != null)
	{
	      var newurl = '<c:out value='${contextPath}'/>bpmportal/common/pop_decimal_dataslot.jsp?elementID=' + id + '&pms=' + pms + '&scale=' + scale + '&value=' + element.value;
	      
        MM_openBrWindow(newurl,'editdecimal','scrollbars=yes,resizable=yes,width=690,height=174');
	}
}
//-->
</script>



<sbm:setLocale value="<%= bizManage.getLocale() %>"></sbm:setLocale>
<% try{ %><sbm:setBundle scope="page" basename="CustomerOrderVehicle/properties/CustomerOrderVehicle"></sbm:setBundle><% } catch(Exception e){}%>
<bizsolo:getApplicationResources baseName="CustomerOrderVehicle/properties/CustomerOrderVehicle"/></head>
<body class="apbody yui-skin-sam" onUnload="pwr.removePakBizSoloBeanFromCache('<%=session.getId()%>', onSuccess);" onLoad="setCheckBoxStyleForIE();hideControls();beforeInitControls();initControls();initTabs();sbm.utils.onDOMReady();">
<form method="post" name="form" onsubmit="return sbm.utils.onFormSubmit();">
<div id="northDiv"><bizsolo:xsrf/></div><% /* Workaround, activityName will disappear in the future */ %>
<% String activityName = bean.getPropString("workitemName"); %>
<div id="resultDiv">
<div style='visibility:hidden;display:none' class='vBoxClass' name='errors' id='errors'></div>
<input name="_PageName" type="hidden" value="CreditCheck">
<%if(bean.getPropString("workitemName") != null) {%><input name="_WorkitemName" type="hidden" value="<%= URLHexCoder.encode(bean.getPropString("workitemName")) %>"/><input name="_WorkitemId" type="hidden" value="<%= bean.getPropString("workitemId") %>"/><%}%>
<input name="bizsite_pagetype" type="hidden" value="activity">
<input name="_ProcessTemplateName" type="hidden" value='<%=bean.getPropString("ptName")%>'>
<input name="_yahoo_flow_button" type="hidden" value=''>
<!-- Content --> 

    
<!-- Header -->
<table width="100%" cellspacing="0" cellpadding="0" border="0">
<tr>
<td class="ApSegTblInBg">
<table width="100%" cellpadding="4" align="center" cellspacing="0" border="0">
<tr>

<td class="ApSegTitle" align="center"><bizsolo:choose><bizsolo:when test='<%=bean.getPropString(\"workitemName\") != null %>'><bizsolo:getDS name="workitemName"></bizsolo:getDS></bizsolo:when><bizsolo:otherwise><%=_PageName%></bizsolo:otherwise></bizsolo:choose></td>
</tr>
</table>
<table class="ApSegDataTbl" width="100%" cellspacing="1" cellpadding="4" border="0">
<tr>
<td width="15%" class="ApSegGenLabel"><bizsolo:getLabel type="RESOURCE" name="BIZSITE_INSTRUCTION_LABEL"></bizsolo:getLabel></td><td width="85%" class="ApSegGenData" colspan="5"><sbm:message key="workstep.CreditCheck.instruction" escapeLine="true"></sbm:message></td>
</tr>
<tr>
<td width="15%" class="ApSegGenLabel"><bizsolo:getLabel type="RESOURCE" name="BIZSITE_PRIORITY_LABEL"></bizsolo:getLabel></td><td width="15%" class="ApSegGenData"><bizsolo:getDS name="bizsite_priority"></bizsolo:getDS></td>
<td width="15%" class="ApSegGenLabel"><bizsolo:getLabel type="RESOURCE" name="BIZSITE_STARTDATE_LABEL"></bizsolo:getLabel></td><td width="15%" class="ApSegGenData"><bizsolo:getDS name="bizsite_startDate"></bizsolo:getDS></td>
<td width="15%" class="ApSegGenLabel"><bizsolo:getLabel type="RESOURCE" name="BIZSITE_DUEDATE_LABEL"></bizsolo:getLabel></td><td width="15%" class="ApSegGenData"><bizsolo:getDS name="bizsite_dueDate"></bizsolo:getDS></td>
</tr>
</table>
</td>
</tr>
</table>

    <br clear="all">
<br clear="all">
<table align="left" cellpadding="0" cellspacing="0" class="ApSegDataTbl" id="table1" width="90%">
      <tbody>
        <tr>
          <td class="ApSegGenLabel" width="100" rowspan="1" colspan="1" valign="top">
            <Label class="ApSegDataslotLabel" for="checkBox1"><sbm:message key="dataslot.CreditApproval.label"></sbm:message></Label>
          </td>
          <td class="ApSegDataVal" width="100%" rowspan="1" colspan="1" valign="top">
            <input type="checkbox" value="true" class="ApInptChkBox" name="CreditApproval" id="checkBox1">
<script>addValue("CreditApproval", '<bizsolo:value name="CreditApproval"></bizsolo:value>');</script>
      

          </td>
        </tr>
        <tr>
          <td class="ApSegGenLabel" width="100" rowspan="1" colspan="1" valign="top">
            <Label class="ApSegDataslotLabel" for="textField4"><sbm:message key="dataslot.CustomerCreditLimit.label"></sbm:message></Label>
          </td>
          <td class="ApSegDataVal" width="100%" rowspan="1" colspan="1" valign="top">
            <input class="ApInptTxt" type="text" id="textField4" name="CustomerCreditLimit" size="30" maxlength="256" value="<bizsolo:value name='CustomerCreditLimit'/>">
    <div style="display:none" id="textField4Error"><div><font color="red"><span class="error" id="textField4ErrorMsg"></span><a href="#" onclick="textField4ErrorMsgClose();return false;"><img border="0" src="<c:out value='${contextPath}'/>bpmportal/css/app<%= bizManage.getTheme() %>/images/close.gif"></a></font></div></div>
          </td>
        </tr>
        <tr>
          <td class="ApSegGenLabel" width="100" rowspan="1" colspan="1" valign="top">
            <Label class="ApSegDataslotLabel" for="textField5"><sbm:message key="dataslot.CustomerEmail.label"></sbm:message></Label>
          </td>
          <td class="ApSegDataVal" width="100%" rowspan="1" colspan="1" valign="top">
            <input class="ApInptTxt" type="text" id="textField5" name="CustomerEmail" size="20" maxlength="256" readonly value="<bizsolo:value name='CustomerEmail'/>" alt="email|bok">
    <div style="display:none" id="textField5Error"><div><font color="red"><span class="error" id="textField5ErrorMsg"></span><a href="#" onclick="textField5ErrorMsgClose();return false;"><img border="0" src="<c:out value='${contextPath}'/>bpmportal/css/app<%= bizManage.getTheme() %>/images/close.gif"></a></font></div></div>
          </td>
        </tr>
        <tr>
          <td class="ApSegGenLabel" width="100" rowspan="1" colspan="1" valign="top">
            <Label class="ApSegDataslotLabel" for="textField6"><sbm:message key="dataslot.CustomerId.label"></sbm:message></Label>
          </td>
          <td class="ApSegDataVal" width="100%" rowspan="1" colspan="1" valign="top">
            <input class="ApInptTxt" type="text" id="textField6" name="CustomerId" size="20" maxlength="256" readonly value="<bizsolo:value name='CustomerId'/>">
    <div style="display:none" id="textField6Error"><div><font color="red"><span class="error" id="textField6ErrorMsg"></span><a href="#" onclick="textField6ErrorMsgClose();return false;"><img border="0" src="<c:out value='${contextPath}'/>bpmportal/css/app<%= bizManage.getTheme() %>/images/close.gif"></a></font></div></div>
          </td>
        </tr>
        <tr>
          <td class="ApSegGenLabel" width="100" rowspan="1" colspan="1" valign="top">
            <Label class="ApSegDataslotLabel" for="textField7"><sbm:message key="dataslot.CustomerName.label"></sbm:message></Label>
          </td>
          <td class="ApSegDataVal" width="100%" rowspan="1" colspan="1" valign="top">
            <input class="ApInptTxt" type="text" id="textField7" name="CustomerName" size="20" maxlength="256" readonly value="<bizsolo:value name='CustomerName'/>">
    <div style="display:none" id="textField7Error"><div><font color="red"><span class="error" id="textField7ErrorMsg"></span><a href="#" onclick="textField7ErrorMsgClose();return false;"><img border="0" src="<c:out value='${contextPath}'/>bpmportal/css/app<%= bizManage.getTheme() %>/images/close.gif"></a></font></div></div>
          </td>
        </tr>
        <tr>
          <td class="ApSegGenLabel" width="100" rowspan="1" colspan="1" valign="top">
            <Label class="ApSegDataslotLabel" for="CustomerOrderDate"><sbm:message key="dataslot.CustomerOrderDate.label"></sbm:message></Label>
          </td>
          <td class="ApSegDataVal" width="100%" rowspan="1" colspan="1" valign="top">
            <div style="display: inline;" id="dateTime1_div"><bizsolo:getDS type="date" id="dateTime1" name="CustomerOrderDate" wsName="CreditCheck" writePerm="false" size="20"></bizsolo:getDS></div>

          </td>
        </tr>
        <tr>
          <td class="ApSegGenLabel" width="100" rowspan="1" colspan="1" valign="top">
            <Label class="ApSegDataslotLabel" for="textField8"><sbm:message key="dataslot.DealerCode.label"></sbm:message></Label>
          </td>
          <td class="ApSegDataVal" width="100%" rowspan="1" colspan="1" valign="top">
            <input class="ApInptTxt" type="text" id="textField8" name="DealerCode" size="20" maxlength="256" readonly value="<bizsolo:value name='DealerCode'/>">
    <div style="display:none" id="textField8Error"><div><font color="red"><span class="error" id="textField8ErrorMsg"></span><a href="#" onclick="textField8ErrorMsgClose();return false;"><img border="0" src="<c:out value='${contextPath}'/>bpmportal/css/app<%= bizManage.getTheme() %>/images/close.gif"></a></font></div></div>
          </td>
        </tr>
        <tr>
          <td class="ApSegGenLabel" width="100" rowspan="1" colspan="1" valign="top">
            <Label class="ApSegDataslotLabel" for="textField11"><sbm:message key="dataslot.DealerName.label"></sbm:message></Label>
          </td>
          <td class="ApSegDataVal" width="100%" rowspan="1" colspan="1" valign="top">
            <input class="ApInptTxt" type="text" id="textField11" name="DealerName" size="20" maxlength="256" readonly value="<bizsolo:value name='DealerName'/>">
    <div style="display:none" id="textField11Error"><div><font color="red"><span class="error" id="textField11ErrorMsg"></span><a href="#" onclick="textField11ErrorMsgClose();return false;"><img border="0" src="<c:out value='${contextPath}'/>bpmportal/css/app<%= bizManage.getTheme() %>/images/close.gif"></a></font></div></div>
          </td>
        </tr>
        <tr>
          <td class="ApSegGenLabel" width="100" rowspan="1" colspan="1" valign="top">
            <Label class="ApSegDataslotLabel" for="textArea3"><sbm:message key="dataslot.ExtraInstructions.label"></sbm:message></Label>
          </td>
          <td class="ApSegDataVal" width="100%" rowspan="1" colspan="1" valign="top">
            <textarea class="ApInptTxtArea" id="textArea3" name="ExtraInstructions" cols="20" rows="4"><bizsolo:value name='ExtraInstructions'/></textarea>
      
      <div style="display:none" id="textArea3_error"><div><font color="red"><span class="error" id="textArea3_errorMsg"></span><a href="#" onclick="textArea3_errorMsgClose();return false;"><img border="0" src="<c:out value='${contextPath}'/>bpmportal/css/app<%= bizManage.getTheme() %>/images/close.gif"></a></font></div></div>
          </td>
        </tr>
        <tr>
          <td class="ApSegGenLabel" width="100" rowspan="1" colspan="1" valign="top">
            <Label class="ApSegDataslotLabel" for="textField20"><sbm:message key="dataslot.ModelName.label"></sbm:message></Label>
          </td>
          <td class="ApSegDataVal" width="100%" rowspan="1" colspan="1" valign="top">
            <input class="ApInptTxt" type="text" id="textField20" name="ModelName" size="20" maxlength="256" readonly value="<bizsolo:value name='ModelName'/>">
    <div style="display:none" id="textField20Error"><div><font color="red"><span class="error" id="textField20ErrorMsg"></span><a href="#" onclick="textField20ErrorMsgClose();return false;"><img border="0" src="<c:out value='${contextPath}'/>bpmportal/css/app<%= bizManage.getTheme() %>/images/close.gif"></a></font></div></div>
          </td>
        </tr>
        <tr>
          <td class="ApSegGenLabel" width="100" rowspan="1" colspan="1" valign="top">
            <Label class="ApSegDataslotLabel" for="textField22"><sbm:message key="dataslot.OrderChannel.label"></sbm:message></Label>
          </td>
          <td class="ApSegDataVal" width="100%" rowspan="1" colspan="1" valign="top">
            <input class="ApInptTxt" type="text" id="textField22" name="OrderChannel" size="20" maxlength="256" readonly value="<bizsolo:value name='OrderChannel'/>">
    <div style="display:none" id="textField22Error"><div><font color="red"><span class="error" id="textField22ErrorMsg"></span><a href="#" onclick="textField22ErrorMsgClose();return false;"><img border="0" src="<c:out value='${contextPath}'/>bpmportal/css/app<%= bizManage.getTheme() %>/images/close.gif"></a></font></div></div>
          </td>
        </tr>
        <tr>
          <td class="ApSegGenLabel" width="100" rowspan="1" colspan="1" valign="top">
            <Label class="ApSegDataslotLabel" for="textField30"><sbm:message key="dataslot.VehicleBrand.label"></sbm:message></Label>
          </td>
          <td class="ApSegDataVal" width="100%" rowspan="1" colspan="1" valign="top">
            <input class="ApInptTxt" type="text" id="textField30" name="VehicleBrand" size="20" maxlength="256" readonly value="<bizsolo:value name='VehicleBrand'/>">
    <div style="display:none" id="textField30Error"><div><font color="red"><span class="error" id="textField30ErrorMsg"></span><a href="#" onclick="textField30ErrorMsgClose();return false;"><img border="0" src="<c:out value='${contextPath}'/>bpmportal/css/app<%= bizManage.getTheme() %>/images/close.gif"></a></font></div></div>
          </td>
        </tr>
        <tr>
          <td class="ApSegGenLabel" width="100" rowspan="1" colspan="1" valign="top">
            <Label class="ApSegDataslotLabel" for="textField36"><sbm:message key="dataslot.userid.label"></sbm:message></Label>
          </td>
          <td class="ApSegDataVal" width="100%" rowspan="1" colspan="1" valign="top">
            <input class="ApInptTxt" type="text" id="textField36" name="CustomerName" size="125" maxlength="256" readonly value="<bizsolo:value name='CustomerName'/>">
    <div style="display:none" id="textField36Error"><div><font color="red"><span class="error" id="textField36ErrorMsg"></span><a href="#" onclick="textField36ErrorMsgClose();return false;"><img border="0" src="<c:out value='${contextPath}'/>bpmportal/css/app<%= bizManage.getTheme() %>/images/close.gif"></a></font></div></div>
          </td>
        </tr>
      </tbody>
    </table>
    <br clear="all">
<br clear="all">
<br clear="all">


</div>
<!-- Footer -->

<div id="cmdDiv">
<table width="100%" cellpadding="0" align="center" cellspacing="0" border="0">
<tr align="center">
<td class="ApButtonDarkBg" width="63%">
<table border="0" cellspacing="0" cellpadding="0">
<tr>
<td class="ApBtnSpace">
<input name="bizsite_completeTask" id="btn-complete" class="ApScrnButton" onMouseOver="this.className='ApScrnButtonHover';" onMouseOut="this.className='ApScrnButton';" onClick="clickedButton=this.name;this.onsubmit = new Function('return false');" value="<bizsolo:getLabel name='COMPLETE_LABEL' type='RESOURCE'/>" type="submit"></td>
<td class="ApBtnSpace">
<input name="bizsite_saveTask" id="btn-save" class="ApScrnButton" onMouseOver="this.className='ApScrnButtonHover';" onMouseOut="this.className='ApScrnButton';" onClick="clickedButton=this.name;this.onsubmit = new Function('return false');" value="<bizsolo:getLabel name='SAVE_LABEL' type='RESOURCE'/>" type="submit"></td>
<bizsolo:isAssigned></bizsolo:isAssigned><td class="ApBtnSpace">
<input type="button" name="bizsite_reset" id="btn-reset" class="ApScrnButton" onMouseOver="this.className='ApScrnButtonHover';" onMouseOut="this.className='ApScrnButton';" onClick="sbm.utils.reset()" value="<bizsolo:getLabel name='RESET_LABEL' type='RESOURCE'/>"></td>
<td class="ApBtnSpace">
<input type="button" name="Submit1323" id="btn-cancel" class="ApScrnButton" onMouseOver="this.className='ApScrnButtonHover';" onMouseOut="this.className='ApScrnButton';" onClick="sbm.utils.cancel()" value="<bizsolo:getLabel name='CANCEL_LABEL' type='RESOURCE'/>"></td>
<bizsolo:isAssigned><td class="ApBtnSpace"><input class="ApInptTxt" type="text" name="bizsite_assigneeName" size="20"></td><td class="ApBtnSpace"><a href="javascript://" onClick="setUserControl(document.form.bizsite_assigneeName);searchUser()"><img width="16" height="16" border="0" title="Search" src="<c:out value='${contextPath}'/>bpmportal/css/app<%= bizManage.getTheme() %>/images/icon_edit_user_search_single.gif"></img></a></td><td class="ApBtnSpace"><input name="bizsite_reassignTask" id="btn-reassign" class="ApScrnButton" onMouseOver="this.className='ApScrnButtonHover';" onMouseOut="this.className='ApScrnButton';" onClick="clickedButton=this.name;return AlertReassign();this.onsubmit = new Function('return false');" value="<bizsolo:getLabel name='REASSIGN_LABEL' type='RESOURCE'/>" type="submit"></td>
</bizsolo:isAssigned></tr>
</table>
</td>
</tr>
</table>
</div>

  
                    <div id="resizablepanel" style="display:none">
                        <div class="hd">Alert Dialog</div>
                        <div class="bd"></div>
                        <div class="ft"></div>
                    </div> 
<div id="southDiv"></div></form>
</body>

<script language="JavaScript">
<!--
function beforeInitControls() {
}
-->
</script>
<script language="JavaScript">
<!--
function userValidationJavascipt() {
  return true;
}
-->
</script>
<sbm:dataSources appName="CustomerOrderVehicle" appType="bizlogic">
</sbm:dataSources>
<script language="JavaScript">
<!---->
</script>
<!--Initialize extensible widgets.-->
<script language="JavaScript">
<!--
var allWidgets = [];
var businessObjects = [];
var formWidgetHandler;
sbm.utils.onDOMReady = function() {
YAHOO.util.Event.onDOMReady(function(){
formWidgetHandler = new FormWidgetHandler(allWidgets,{processName:'CustomerOrderVehicle',adapletCache:{'user':''}});
 });
 }
Ext.onReady(function(){

});
         var viewport = new Bm.util.BmViewport('');
sbm.utils.onFormSubmit = function() {
         if(!formWidgetHandler.validateWidgets()) return false;
        try{
             if(!userValidationJavascipt()) return false;
             if(!sbm.utils.beforeFormSubmit('box+label')) return false;
         }catch(e){return false;}
         document.form.action='<%=response.encodeURL("CreditCheck.jsp")%>';
         if(allWidgets.length > 0)formWidgetHandler.saveDataSlots();
         return true;
}
-->
</script>

</html>
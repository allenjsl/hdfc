﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="OtherPayAdd.aspx.cs" Inherits="Web.Fin.OtherPayAdd"
    MasterPageFile="~/MasterPage/Boxy.Master" %>

<%@ Register Src="../UserControl/UploadControl.ascx" TagName="UploadControl" TagPrefix="uc1" %>
<asp:Content ID="Content1" ContentPlaceHolderID="PageHead" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="PageBody" runat="server">
    <form id="Form1" runat="server">
    <div style="width: 630px; margin: 10px auto;">
        <table width="100%" border="0" align="center" cellpadding="0" cellspacing="1">
            <tr class="odd">
                <th width="120" height="30" align="right">
                    <span style="color: red">*</span>支出日期：
                </th>
                <td bgcolor="#E3F1FC">
                    <input name="txtDate" type="text" class="inputtext" id="txtDate" runat="server" onfocus="WdatePicker()"
                        valid="required" errmsg="请输入支出日期" />
                </td>
                <th width="120" align="right">
                    <span style="color: red">*</span>支出项目：
                </th>
                <td bgcolor="#E3F1FC">
                    <input name="txtPayItem" type="text" class="inputtext" id="txtPayItem" runat="server"
                        valid="required" errmsg="请输入支出项目" />
                </td>
            </tr>
            <tr class="odd">
                <th height="30" align="right">
                    <span style="color: red">*</span>支出金额：
                </th>
                <td bgcolor="#E3F1FC">
                    <input name="txtPrice" type="text" class="inputtext" id="txtPrice" runat="server"
                        valid="required|isMoney" errmsg="请输入支出金额|金额格式不正确" />
                </td>
                <th align="right">
                    支出人：
                </th>
                <td bgcolor="#E3F1FC">
                    <input type="hidden" id="hidShouKuanRenId" name="hidShouKuanRenId" runat="server" />
                    <input type="hidden" id="hidShouKuanRen" name="hidShouKuanRen" runat="server" />
                    <input name="txtShouKuanRen" type="text" class="inputtext" runat="server" id="txtShouKuanRen"
                        disabled="disabled" />
                </td>
            </tr>
            <tr class="odd">
                <th height="30" align="right">
                    <span style="color: red">*</span>银行账号：
                </th>
                <td bgcolor="#E3F1FC">
                    <asp:DropDownList ID="ddlBank" runat="server" CssClass="inputselect" Valid="required"
                        errmsg="请选择银行账号">
                    </asp:DropDownList>
                </td>
                <th align="right">
                    <span style="color: red">*</span>支出方式：
                </th>
                <td bgcolor="#E3F1FC">
                    <asp:DropDownList runat="server" ID="ddlPayType" CssClass="inputselect" Valid="required"
                        errmsg="请选择支出方式">
                    </asp:DropDownList>
                </td>
            </tr>
            <tr class="odd">
                <th height="30" align="right">
                    是否开票：
                </th>
                <td colspan="3" bgcolor="#E3F1FC">
                    <asp:DropDownList ID="ddlIsKaiPiao" runat="server" CssClass="inputselect">
                        <asp:ListItem Value="1" Text="已开票"></asp:ListItem>
                        <asp:ListItem Value="0" Text="未开票"></asp:ListItem>
                    </asp:DropDownList>
                </td>
            </tr>
            <tr class="odd">
                <th height="30" align="right">
                    附件：
                </th>
                <td colspan="3" bgcolor="#E3F1FC">
                    <uc1:UploadControl ID="UploadControl1" runat="server" />
                    <div style="width: 450px; float: left; margin-left: 5px;">
                        <asp:Repeater ID="rpFile" runat="server">
                            <ItemTemplate>
                                <span class='upload_filename'><a href='<%#Eval("FilePath") %>' target="_blank">
                                    <%#Eval("FileName")%></a> <a href="javascript:void(0)" onclick="OtherPayAdd.RemoveFile(this)"
                                        title='删除附件'>
                                        <img style='vertical-align: middle' src='/images/cha.gif'></a>
                                    <input type="hidden" id="hidFilePath" name="hidFilePath" value='<%#Eval("FileName")%>|<%#Eval("FilePath") %>|<%#Eval("FileId") %>' />
                                </span>
                            </ItemTemplate>
                        </asp:Repeater>
                    </div>
                </td>
            </tr>
        </table>
        <table width="320" border="0" align="center" cellpadding="0" cellspacing="0">
            <tr>
                <td height="40" align="center">
                </td>
                <td height="40" align="center" class="tjbtn02">
                    <a href="javascript:;" class="save" id="btn" runat="server">保存</a>
                </td>
                <td height="40" align="center" class="tjbtn02">
                    <a href="javascript:;" id="linkCancel" onclick="parent.Boxy.getIframeDialog('<%=Request.QueryString["iframeId"] %>').hide()">
                        关闭</a>
                </td>
            </tr>
        </table>
    </div>
    </form>

    <script type="text/javascript">
        $(function() {
            OtherPayAdd.PageInit();
        })
        var OtherPayAdd = {
            PageInit: function() {
                $("input[readonly='readonly']").css({ "background-color": "#dadada" });
                $("#<%=btn.ClientID %>").click(function() {
                    if (!OtherPayAdd.CheckForm()) {
                        return false;
                    }
                    var url = "/Fin/OtherPayAdd.aspx?dotype=" + '<%=Request.QueryString["dotype"]%>' + "&type=save&tid=" + '<%=Request.QueryString["tid"]%>';
                    OtherPayAdd.GoAjax(url);
                    return false;
                })
            },
            GoAjax: function(url) {
                OtherPayAdd.UnBind();
                $.newAjax({
                    type: "post",
                    cache: false,
                    url: url,
                    dataType: "json",
                    data: $("#<%=btn.ClientID %>").closest("form").serialize(),
                    success: function(ret) {
                        if (ret.result == "1") {
                            parent.tableToolbar._showMsg(ret.msg, function() { parent.location.href = parent.location.href; });
                        }
                        else {
                            parent.tableToolbar._showMsg(ret.msg);
                            OtherPayAdd.Bind();
                        }
                    },
                    error: function() {
                        tableToolbar._showMsg(tableToolbar.errorMsg);
                        OtherPayAdd.Bind();
                    }
                });
            },
            CheckForm: function() {
                return ValiDatorForm.validator($("#<%=btn.ClientID %>").closest("form").get(0), "parent");
            },
            RemoveFile: function(obj) {
                $(obj).parent().remove();
                return false;
            },
            Bind: function() {
                var _selfs = $("#<%=this.btn.ClientID %>");
                _selfs.html("保存");
                _selfs.css("cursor", "pointer");
                _selfs.click(function() {
                    if (!OtherPayAdd.CheckForm()) {
                        return false;
                    }
                    var url = "/Fin/OtherPayAdd.aspx?dotype=" + '<%=Request.QueryString["dotype"]%>' + "&type=save&tid=" + '<%=Request.QueryString["tid"]%>';
                    OtherPayAdd.GoAjax(url);
                    return false;
                });
            },
            UnBind: function() {
                $("#<%=this.btn.ClientID %>").html("提交中...");
                $("#<%=this.btn.ClientID %>").unbind("click");
            }
        }
    </script>

</asp:Content>

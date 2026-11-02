// <copyright file="XrmMetaData.cs" company="Ciber">
//     Company Copyright
// </copyright>

using System;
using System.ComponentModel;

namespace SFA.FCT.Xrm.TestFramework
{
    public static class AttributesHelperExtension
    {
        public static string ToDescription(this Enum value)
        {
            var da = (DescriptionAttribute[])(value.GetType().GetField(value.ToString())).GetCustomAttributes(typeof(DescriptionAttribute), false);
            return da.Length > 0 ? da[0].Description : value.ToString();
        }
    }

    /// <summary>
    /// Helper Class for XrmData Types. Contains public constants for all of the main Data Types
    /// </summary>
    public static class XrmDataType
    {
        public const string Text = "nvarchar";
        public const string DateTime = "datetime";
        public const string WholeNumber = "int";
        public const string Float = "float";
        public const string Decimal = "decimal";
        public const string TwoOptions = "bit";
        public const string OptionSet = "picklist";
        public const string Owner = "owner";
        public const string PrimaryKey = "primarykey";
        public const string Lookup = "lookup";
        public const string State = "state";
        public const string Status = "status";
        public const string Virtual = "virtual";
        public const string Internal = "internal";
        public const string Money = "money";
        public const string Customer = "customer";
        public const string Memo = "ntext";

        /// <summary>
        /// Helper Conversion method, allows conversion between data types returned by the CRM Web Service and those included in the solution file
        /// </summary>
        /// <param name="inputType">The data type returned by the web service</param>
        /// <returns>The data type held in the solution file</returns>
        public static string Convert(string inputType)
        {
            switch (inputType)
            {
                case "bool":
                    return XrmDataType.TwoOptions;
                case "CalendarRules":
                    return XrmDataType.Virtual;
                case "Customer":
                    return XrmDataType.Lookup;
                case "DateTime":
                    return XrmDataType.DateTime;
                case "Decimal":
                    return XrmDataType.Decimal;
                case "Float":
                    return XrmDataType.Float;
                case "Integer":
                    return XrmDataType.WholeNumber;
                case "Internal":
                    return XrmDataType.Internal;
                case "Lookup":
                    return XrmDataType.Lookup;
                case "Memo":
                    return XrmDataType.Memo;
                case "Money":
                    return XrmDataType.Money;
                case "Owner":
                    return XrmDataType.Owner;
                case "PartyList":
                    return XrmDataType.Internal;
                case "Picklist":
                    return XrmDataType.OptionSet;
                case "PrimaryKey":
                    return XrmDataType.PrimaryKey;
                case "State":
                    return XrmDataType.State;
                case "Status":
                    return XrmDataType.Status;
                case "string":
                    return XrmDataType.Text;
                case "UniqueIdentifier":
                    return XrmDataType.PrimaryKey;
                case "Virtual":
                    return XrmDataType.Virtual;
                default:
                    return "unknown";
            }
        }
    }

    /// <summary>
    /// Helper class of static constants for Ownership Types
    /// </summary>
    public static class XrmOwnershipType
    {
        public const string User = "user";
        public const string Organization = "organization";
    }

    /// <summary>
    /// Helper class of static constants for Requirement Levels
    /// </summary>
    public static class XrmRequirementLevel
    {
        public const string None = "none";
        public const string BusinessRecommended = "recommended";
        public const string BusinessRequired = "required";
        public const string ApplicationRequired = "applicationrequired";
    }

    public enum XrmCascadeDeleteType
    {
        [Description("Cascade")]
        Cascade,
        [Description("Remove Link")]
        RemoveLink,
        [Description("Restrict")]
        Restrict,
    }
    /// <summary>
    /// Helper class of static constants for Sort Orders
    /// </summary>
    public enum XrmSortOrder
    {
        Ascending,
        Descending
    }

    /// <summary>
    /// Helper enum of static constants for View Filters
    /// </summary>
    public enum XrmFilterOperator
    {
        [Description("eq")]
        EqualTo,
        [Description("neq")]
        NotEqualTo,
        [Description("ne")]
        NotEqual,
        [Description("gt")]
        GreaterThan,
        [Description("ge")]
        GreaterThanEqualTo,
        [Description("le")]
        LessThanEqualTo,
        [Description("lt")]
        LessThen,
        [Description("like")]
        Like,
        [Description("not-like")]
        NotLike,
        [Description("in")]
        In,
        [Description("not-in")]
        NotIn,
        [Description("between")]
        Between,
        [Description("not-between")]
        NotBetween,
        [Description("null")]
        ContainsData,
        [Description("not-null")]
        DoesNotContainData,
        [Description("yesterday")]
        Yesterday,
        [Description("today")]
        Today,
        [Description("tomorrow")]
        Tomorrow,
        [Description("last-seven-days")]
        LastSevenDays,
        [Description("next-seven-days")]
        NextSevenDays,
        [Description("last-week")]
        LastWeek,
        [Description("this-week")]
        ThisWeek,
        [Description("next-week")]
        NextWeek,
        [Description("last-month")]
        LastMonth,
        [Description("this-month")]
        ThisMonth,
        [Description("next-month")]
        NextMonth,
        [Description("on")]
        On,
        [Description("on-or-before")]
        OnOrBefore,
        [Description("on-or-after")]
        OnOrAfter,
        [Description("last-year")]
        LastYear,
        [Description("this-year")]
        ThisYear,
        [Description("next-year")]
        NextYear,
        [Description("last-x-hours")]
        LastXHours,
        [Description("next-x-hours")]
        NextXHours,
        [Description("last-x-days")]
        LastXDays,
        [Description("next-x-days")]
        NextXDays,
        [Description("last-x-weeks")]
        LastXWeeks,
        [Description("next-x-weeks")]
        NextXWeeks,
        [Description("last-x-months")]
        LastXMonths,
        [Description("next-x-months")]
        NextXMonths,
        [Description("olderthan-x-months")]
        OlderThanXMonths,
        [Description("last-x-years")]
        LastXYears,
        [Description("next-x-years")]
        NextXYears,
        [Description("eq-userid")]
        EqualsCurrentUser,
        [Description("ne-userid")]
        NotEqualsCurrentUser,
        [Description("eq-userteams")]
        EqualsUserTeams,
        [Description("eq-useroruserteams")]
        EqualsUserOrUserTeams,
        [Description("eq-businessid")]
        EqualsBusinessUnit,
        [Description("ne-businessid")]
        NotEqualsBusinessUnit,
        [Description("eq-userlanguage")]
        EqualsCurrentUserLanguage,
        [Description("this-fiscal-year")]
        ThisFiscalYear,
        [Description("this-fiscal-period")]
        ThisFiscalPeriod,
        [Description("next-fiscal-year")]
        NextFiscalYear,
        [Description("next-fiscal-period")]
        NextFiscalPeriod,
        [Description("last-fiscal-year")]
        LastFiscalYear,
        [Description("last-fiscal-period")]
        LastFiscalPeriod,
        [Description("last-x-fiscal-years")]
        LastXFiscalYears,
        [Description("last-x-fiscal-periods")]
        LastXFiscalPeriod,
        [Description("next-x-fiscal-years")]
        NextXFiscalYears,
        [Description("next-x-fiscal-periods")]
        NextXFiscalPeriod,
        [Description("in-fiscal-year")]
        InFiscalYear,
        [Description("in-fiscal-period")]
        InFiscalPeriod,
        [Description("in-fiscal-period-and-year")]
        InFiscalPeriodAndYear,
        [Description("in-or-before-fiscal-period-and-year")]
        InOrBeforeFiscalPeriodAndYear,
        [Description("in-or-after-fiscal-period-and-year")]
        InOrAfterFiscalPeriodAndYear,
        [Description("begins-with")]
        BeginsWith,
        [Description("not-begin-with")]
        DoesNotBeginWith,
        [Description("ends-with")]
        EndsWith,
        [Description("not-end-with")]
        DoesNotEndWith
    }

    /// <summary>
    /// Helper class of static constants for Form Types
    /// </summary>
    public static class XrmFormType
    {
        public const string Main = "main";
        public const string Mobile = "mobile";
        public const string QuickView = "quickview";
        public const string QuickCreate = "quickcreate";
    }

    /// <summary>
    /// Helper enum of RibbonTypes
    /// </summary>
    public enum XrmViewType
    {
        [Description("0")]
        MainApplicationView,
        [Description("1")]
        AdvancedSearch,
        [Description("2")]
        AssociatedView,
        [Description("")]
        QuickFindSearch,
        [Description("64")]
        LookupView,
        [Description("8192")]
        CustomView
    }

    /// <summary>
    /// Helper class of static constants for Entity Names
    /// </summary>
    public static class XrmEntityName
    {
        public const string Organization = "account";
        public const string Contract = "sfa_contract";
        public const string ContractType = "sfa_contracttype";
        public const string FundingType = "sfa_fundingtype";
        public const string Process = "sfa_process";
        public const string Status = "sfa_status";
        public const string Transition = "sfa_transition";
        public const string Audit = "sfa_contracttransitionhistory";
    }

    /// <summary>
    /// Helper enum of RibbonTypes
    /// </summary>
    public enum XrmRibbonType
    {
        [Description("Form")]
        Form,
        [Description("HomepageGrid")]
        HomepageGrid,
        [Description("SubGrid")]
        SubGrid
    }

    /// <summary>
    /// Helper enum of Ribbon Buttons
    /// </summary>
    public enum XrmRibbonButton
    {
        [Description("Activate")]
        Activate,
        [Description("AddToQueue")]
        AddToQueue,
        [Description("Assign")]
        Assign,
        [Description("Convert.Case")]
        ConvertToCase,
        [Description("Convert.Opportunity")]
        ConvertToOpportunity,
        [Description("Deactivate")]
        Deactivate,
        [Description("FollowButton")]
        Follow,
        [Description("Permissions.Grant")]
        GrantPermissions,
        [Description("Permissions.Sharing")]
        SharePermissions,
        [Description("PromoteToResponse")]
        PromoteToResponse,
        [Description("QueueItemDetail")]
        QueueItemDetail,
        [Description("SendSelected")]
        SendSelected,
        [Description("UnfollowButton")]
        Unfollow,
        [Description("Copy")]
        Copy,
        [Description("Edit")]
        Edit,
        [Description("Sharing")]
        Share,
        [Description("AddEmail")]
        SendDirectEmail,
        [Description("AdvMergeRecords")]
        Merge,
        [Description("AssociateParentChildCase")]
        AssociateChildCase,
        [Description("CopySelected")]
        CopyALink,
        [Description("Send")]
        EmailALink,
        [Description("RunScript")]
        RunDialog,
        [Description("RunWorkflow")]
        RunWorkflow
    }

    /// <summary>
    /// Helper enum of Security Actions
    /// </summary>
    public enum XrmSecurityAction
    {
        [Description("Create")] Create,
        [Description("Read")] Read,
        [Description("Write")] Write,
        [Description("Delete")] Delete,
        [Description("Assign")] Assign,
        [Description("Share")] Share,
        [Description("Append")] Append,
        [Description("AppendTo")] AppendTo,
        [Description("")] NonEntity
    }

    /// <summary>
    /// Helper enum of Security Privileges
    /// </summary>
    public enum XrmSecurityPriv
    {
        [Description("Basic")]
        User,
        [Description("Local")]
        BusinessUnit,
        [Description("Deep")]
        ParentChildBusinessUnit,
        [Description("Global")]
        Organization,
        [Description("None")]
        None
    }

    public enum XrmFieldValueComparison
    {
        [Description("EqualTo")]
        Equals,
        [Description("NotEqualTo")]
        NotEquals,
        [Description("GreaterThan")]
        GreaterThan,
        [Description("LessThen")]
        LessThan,
        [Description("BeginsWith")]
        BeginsWith
    }

    public enum XrmDashboardItemType
    {
        [Description("View")]
        View,
        [Description("Chart")]
        Chart,
        [Description("IFrame")]
        IFrame,
        [Description("WebResource")]
        WebResource
    }
}

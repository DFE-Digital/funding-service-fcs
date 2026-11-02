// ReSharper disable InconsistentNaming
namespace SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation
{
    using System.ComponentModel;

    public enum PeriodTypeName
    {
        [Description("ACADEMIC YEAR")]
        ACADEMICYEAR,

        [Description("CALENDAR YEAR")]
        CALENDARYEAR,

        [Description("FINANCIAL YEAR")]
        FINANCIALYEAR,

        [Description("CALENDAR MONTH")]
        CALENDARMONTH,

        [Description("CALENDAR QUARTER")]
        CALENDARQUARTER
    }
}
// ReSharper disable InconsistentNaming
namespace SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaim
{
    using System.ComponentModel;

    public enum ClaimTypeName
    {
        [Description("MID YEAR")]
        MIDYEAR,

        [Description("YEAR END")]
        YEAREND,

        FINAL
    }
}
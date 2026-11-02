namespace PerformanceManagementDomain.ReconciliationPublication.Services
{
    using System;
    using System.Globalization;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation.CorporateSchema._3_0;
    using SFA.FCT.CrossDomain.Integration.Entities.PerformanceManagement.FundingClaimReconciliation; 

    public static class EnumTransformer
    {
        public static PeriodTypeCodeST TransformPeriodTypeCode(PeriodTypeCode periodTypeCode)
        {
            return Transform<PeriodTypeCode, PeriodTypeCodeST>(periodTypeCode);
        }

        public static PeriodTypeNameST TransformPeriodTypeName(PeriodTypeName periodTypeName)
        {
            return Transform<PeriodTypeName, PeriodTypeNameST>(periodTypeName);
        }

        public static TDestination Transform<TSource, TDestination>(TSource enumValue) where TSource : struct, IConvertible, IComparable, IFormattable
            where TDestination : struct, IConvertible, IComparable, IFormattable
        {
            return (TDestination)Enum.Parse(typeof(TDestination), enumValue.ToString(CultureInfo.InvariantCulture));
        }
    }
}

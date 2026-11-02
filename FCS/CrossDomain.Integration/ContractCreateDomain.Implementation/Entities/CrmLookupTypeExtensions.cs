namespace SFA.FCT.ContractCreateDomain.Implementation.Entities
{
    using System;
    using System.Diagnostics.CodeAnalysis;

    [ExcludeFromCodeCoverage]
    public static class CrmLookupTypeExtensions
    {
        public static CrmLookupEntityDetail GetEntityDetail(this CrmLookupType columnType)
        {
            switch (columnType)
            {
                case CrmLookupType.User:
                    return new CrmLookupEntityDetail("systemuser", "fullname");
                case CrmLookupType.FundingType:
                    return new CrmLookupEntityDetail("sfa_fundingtype", "sfa_fundingtypecode" );
                case CrmLookupType.ContractType:
                    return new CrmLookupEntityDetail("sfa_contracttype", "sfa_name");
                case CrmLookupType.Organisation:
                    return new CrmLookupEntityDetail("account", "sfa_ukprn");
                case CrmLookupType.SubStatus:
                    return new CrmLookupEntityDetail("sfa_status", "sfa_name");
                case CrmLookupType.Period:
                    return new CrmLookupEntityDetail("sfa_period", new[] { "sfa_period", "sfa_periodtypecode" });
                case CrmLookupType.FundingStreamCode:
                    return new CrmLookupEntityDetail("sfa_fundingstream", "sfa_fundingstreamcode");
                case CrmLookupType.FundingStreamPeriodCode:
                    return new CrmLookupEntityDetail("sfa_fundingstreamperiod", new[] { "sfa_fundingstreamcode", "sfa_period", "sfa_periodtypecode" });
                case CrmLookupType.PeriodType:
                    return new CrmLookupEntityDetail("sfa_periodtype", "sfa_periodtypecode");
                case CrmLookupType.UnitOfProcurement:
                    return new CrmLookupEntityDetail("sfa_unitofprocurement", "sfa_uopcode");
                case CrmLookupType.InvestmentPriority:
                    return new CrmLookupEntityDetail("sfa_investmentpriority", "sfa_name");
                case CrmLookupType.LocalEnterprisePartnership:
                    return new CrmLookupEntityDetail("account",  "sfa_lepcode");
                case CrmLookupType.Contract:
                    return new CrmLookupEntityDetail("sfa_contract", "sfa_contractid");
                case CrmLookupType.RegionType:
                    return new CrmLookupEntityDetail("sfa_regiontype", "sfa_name");
                case CrmLookupType.SpecificationTitle:
                    return new CrmLookupEntityDetail("sfa_specificationtitle", "sfa_name");  // TBD - Waiting for Quintin to create the CRM entity
                default:
                    throw new Exception(string.Format("LookupType not supported: {0}", columnType));
            }
        }
    }
}
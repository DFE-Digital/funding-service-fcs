namespace SFA.FCT.ContractCreateDomain.Implementation.Entities
{
    using System;
    using System.Diagnostics.CodeAnalysis;

    [ExcludeFromCodeCoverage]
    public static class CrmOptionSetTypeExtensions
    {
        public static string GetOptionSetName(this CrmOptionSetType optionSetType)
        {
            switch (optionSetType)
            {
                case CrmOptionSetType.HierarchyType:
                    return "sfa_contracthierarchytype";
                case CrmOptionSetType.Status:
                    return "sfa_contractstatus";
                case CrmOptionSetType.AmendmentType:
                    return "sfa_amendmenttype";
                case CrmOptionSetType.TerminationReason:
                    return "sfa_terminationreasons";
                case CrmOptionSetType.NewStartSuspendedReason:
                    return "sfa_newstartssuspendedreason";
                default:
                    throw new Exception(string.Format("CrmOptionSetType not supported: {0}", optionSetType));
            }
        }

        public static string GetOptionValue(this CrmOptionSetType optionSetType, string enumToStringVal)
        {
            switch (optionSetType)
            {
                case CrmOptionSetType.HierarchyType:
                    return GetHierarchyTypeVal(enumToStringVal);
                case CrmOptionSetType.TerminationReason:
                    return ToCrmTerminationStringVal(enumToStringVal);
                default:
                    return enumToStringVal;
            }
        }

        private static string GetHierarchyTypeVal(string enumToStringVal)
        {
            switch (enumToStringVal)
            {
                case "MASTERCONTRACT":
                    return "Master";
                case "CONTRACT":
                    return "Contract";
                case "CONTRACTALLOCATION":
                    return "Contract Allocation";
                case "SUBALLOCATION":
                    return "Sub Allocation";
                default:
                    throw new Exception($"HierarchyTypeVal not supported: {enumToStringVal}");
            }
        }

        private static string ToCrmTerminationStringVal(string enumToStringVal)
        {
            switch (enumToStringVal)
            {
                case "ProviderChange":
                    return "Provider Change";
                case "NoticefromProvider":
                    return "Notice from Provider";
                case "NoticefromAgency":
                    return "Notice from Agency";
                case "Other":
                    return "Other";
                case "ProviderinLiquidation":
                    return "Provider in Liquidation";
                case "RemovedfromRoATP":
                    return "Removed from RoATP";
                case "ProviderinAdministration":
                    return "Provider in Administration";
                case "InadequateOfsted":
                    return "Inadequate Ofsted";
                case "InadequateFinancialHealth":
                    return "Inadequate Financial Health";
                case "ContractNovation":
                    return "Contract Novation";
                case "MinimumStandards":
                    return "Minimum Standards";
                case "SeriousBreach":
                    return "Serious Breach";
                case "DeactivatedUKPRN":
                    return "Deactivated UKPRN";
                case "Merger":
                    return "Merger";
                case "RoATPRefresh":
                    return "RoATP Refresh";
                case "RemovedfromAPAR":
                    return "Removed from APAR";
                case "ApprenticeshipAccountabilityFramework":
                    return "Apprenticeship Accountability Framework";
                case "APARRefresh":
                    return "APAR Refresh";
                default:
                    throw new ArgumentException($"Termination Reason not supported: {enumToStringVal}");
            }
        }
    }
}

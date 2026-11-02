namespace SFA.FCT.Operations.Integrity.Repositories
{
    using System;
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
                default:
                    throw new Exception(string.Format("CrmOptionSetType not supported: {0}", optionSetType));
            }
        }

        public static string GetOptionValue(this CrmOptionSetType optionSetType, string xmlValue)
        {
            switch (optionSetType)
            {
                case CrmOptionSetType.HierarchyType:
                    return GetHierarchyTypeVal(xmlValue);

                default:
                    return xmlValue;
            }
        }

        private static string GetHierarchyTypeVal(string xmlValue)
        {
            switch (xmlValue)
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
                    throw new Exception(string.Format("HierarchyTypeVal not supported: {0}", xmlValue));
            }
        }
    }
}

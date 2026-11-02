namespace ContractManagementDomain.Endpoint.LevyAmendmentEndpoint.Extensions
{
    using System.Collections.Generic;
    using SFA.FCT.CrossDomain.Integration.Entities;

    public static class ContractInformationExtensions
    {
        public static bool IsStatusValidForAmendment(this ContractInformation contractInformation,
            bool allowUnderTermination)
        {
            var validSubStatuses = new List<ContractSubStatus> { ContractSubStatus.Approved, ContractSubStatus.Modified};
            if (allowUnderTermination)
            {
                validSubStatuses.Add(ContractSubStatus.UnderTermination);
            }

            return contractInformation.ContractStatus == ContractStatus.Approved && validSubStatuses.Contains(contractInformation.ContractSubStatus);
        }
    }
}

namespace SFA.FCT.ContractManagementDomain.Integration.Dtos
{
    using System;

    public class ContractEndDateInfo
    {
        public ContractEndDateInfo(DateTime? endDate, bool isContractPresent)
        {
            EndDate = endDate;
            IsContractPresent = isContractPresent;
        }

        public DateTime? EndDate { get; }

        public bool IsContractPresent { get; }
    }
}

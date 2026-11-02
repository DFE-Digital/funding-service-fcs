namespace ContractManagementDomain.Termination.DTOs
{
    using System;

    public class SimpleContractTerminationInfo
    {
        public SimpleContractTerminationInfo(bool isLatest, DateTime? terminationDate)
        {
            IsLatest = isLatest;
            TerminationDate = terminationDate;
        }

        public bool IsLatest { get; }

        public DateTime? TerminationDate { get; }
    }
}

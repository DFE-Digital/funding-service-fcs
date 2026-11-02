namespace ContractManagementDomain.Termination.DTOs
{
    using System;
    using SFA.FCT.ContractManagementService.Common;

    public class TerminateContractInfo
    {
        public TerminateContractInfo(bool isLatest, DateTime? contractTerminationDate, ContractIdentifier contractIdentifier, Func<ContractIdentifier, bool> hasOutStandingPayments, Func<bool> isMonthEndRunning, DateTime currentDate)
        {
            IsLatest = isLatest;
            ContractTerminationDate = contractTerminationDate;
            ContractIdentifier = contractIdentifier;
            HasOutStandingPayments = hasOutStandingPayments;
            IsMonthEndRunning = isMonthEndRunning;
            CurrentDate = currentDate;
        }

        public bool IsLatest { get; }

        public DateTime? ContractTerminationDate { get; }

        public ContractIdentifier ContractIdentifier { get; }

        public Func<ContractIdentifier, bool> HasOutStandingPayments {get;}

        public Func<bool> IsMonthEndRunning { get; }

        public DateTime CurrentDate { get; }
    }
}

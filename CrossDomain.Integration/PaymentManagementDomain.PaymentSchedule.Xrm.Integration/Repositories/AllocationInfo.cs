namespace SFA.FCT.PaymentManagementDomain.PaymentSchedule.Xrm.Integration.Repositories
{
    using System;

    public class AllocationInfo
    {
        public AllocationInfo(Guid allocationId, DateTime allocationStartDate, DateTime? allocationEndDate, int subversion, Guid contractId, string allocationNumber)
        {
            AllocationId = allocationId;
            AllocationStartDate = allocationStartDate;
            AllocationEndDate = allocationEndDate;
            Subversion = subversion;
            ContractId = contractId;
            AllocationNumber = allocationNumber;
        }

        public Guid AllocationId { get; }

        public int Subversion { get; }

        public DateTime AllocationStartDate { get; }

        public DateTime? AllocationEndDate { get; }

        public Guid ContractId { get; }

        public string AllocationNumber { get; }
    }
}

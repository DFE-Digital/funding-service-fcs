namespace ContractManagementDomain.Termination.Extensions
{
    using System;
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    public static class CorporateContractExtensions
    {
        public static void RemoveTerminationInformation(this contract corporateContract)
        {
            corporateContract.contracts.ForEach(c =>
            {
                c.TerminationReason = null;
                c.TerminationDate = null;
                c.contractAllocations.ForEach(a =>
                {
                    a.FundingCessationDate = null;
                    a.StopNewStartsDate = null;
                });
            });
        }

        public static void SetChildContractsSubStatus(this contract corporateContract, string newStatus)
        {
            corporateContract.contracts.ForEach(c => c.contractStatus.status = newStatus);
        }

        public static void SetChildContractsStatusAndSubStatus(this contract corporateContract, string newStatus, string newSubStatus)
        {
            corporateContract.contracts.ForEach(c =>
            {
                c.contractStatus.parentStatus = newStatus;
                c.contractStatus.status = newSubStatus;
            });
        }

        public static void SetEndDatesIfEndDatesAreNull(this contract corporateContract, DateTime endDate)
        {
            corporateContract.contracts.ForEach(c =>
            {
                c.endDate = c.endDate ?? endDate;
                c.contractAllocations.ForEach(a => a.endDate = a.endDate ?? endDate);
            });
        }

        public static void ClearAllocationModificationValues(this contract corporateContract)
        {
            corporateContract.contracts.ForEach(c => c.contractAllocations.ForEach(ca =>
            {
                ca.StopNewStartsDate = null;
                ca.NewStartsSuspendedReason = null;
                ca.InflightStopNewStartsDate = null;
                ca.InflightNewStartsSuspendedReason = null;
            }));
        }
    }
}

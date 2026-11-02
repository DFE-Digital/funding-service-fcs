namespace ContractManagementDomain.Endpoint.InitiateContractApproval.Repositories
{
    using System;
    using System.Collections.Generic;
    using Dtos;

    public interface ICrmContractDeliverablePeriodRepository
    {
        IReadOnlyCollection<ContractDeliverablePeriodDto> GetContractDeliverablePeriods(string contractNumber, int versionNumber);

        IReadOnlyCollection<ContractDeliverablePeriodDto> GetContractDeliverablePeriodsForAllocation(string contractNumber, int versionNumber, string fundingStreamPeriodCode);

        void UpdatePeriod(Guid cpdId, int year, int month);
    }
}

namespace SFA.FCT.PaymentManagementDomain.PaymentSchedule.Xrm.Integration.Repositories
{
    using System;
    using System.Collections.Generic;
    using CrossDomain.Integration.Entities.Xrm.OptionSets;

    public interface ICrmAllocationRepository
    {
        Guid? GetMostRecentAllocationWithSubStatusApproved(string allocationNumber, sfa_contractstatus contractStatus);

        Guid? GetMostRecentAllocation(string allocationNumber, sfa_contractstatus contractStatus);

        AllocationInfo GetAllocationInfoFromCrm(string allocationNumber, int version);

        IReadOnlyCollection<DeliverableInfo> GetContractDeliverablesForAllocation(Guid crmAllocation);
    }
}
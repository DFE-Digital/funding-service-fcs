namespace PaymentManagementDomain.PaymentSchedule.PaymentScheduleXrm.Repositories
{
    using System;
    using Microsoft.Xrm.Sdk;
    using SFA.FCT.CrossDomain.Integration.Entities.Xrm;
    using SFA.FCT.PaymentManagementDomain.PaymentSchedule.Xrm.Integration.Repositories;

    public class CrmDeliverableRepository : ICrmDeliverableRepository
    {
        private readonly IOrganizationService _organizationService;

        public CrmDeliverableRepository(IOrganizationService organizationService)
        {
            _organizationService = organizationService;
        }

        public DeliverableInfo CreateDeliverable(
            int deliverableCode,
            FspDeliverableInfo fspDeliverable,
            Guid allocationId,
            string allocationNumber,
            Guid contractId,
            Guid? parentDeliverableId)
        {
            var parentDeliverableEntityReference = (parentDeliverableId.HasValue)
                ? new EntityReference(sfa_contractdeliverable.EntityLogicalName, parentDeliverableId.Value)
                : null;

            var newDeliverable = new sfa_contractdeliverable
            {
                sfa_DeliverableCode = fspDeliverable.DeliverableCode.ToString(),
                sfa_deliverablename = fspDeliverable.DeliverableName,
                sfa_ParentDeliverableId = parentDeliverableEntityReference,
                sfa_ContractAllocationId = new EntityReference(sfa_contractallocation.EntityLogicalName, allocationId),
                sfa_FundingStreamPeriodDeliverableId =
                    new EntityReference(sfa_fundingstreamperioddeliverable.EntityLogicalName,
                        fspDeliverable.FspDeliverableId),
                sfa_ContractId = new EntityReference(sfa_contract.EntityLogicalName, contractId),
                sfa_AllocationRef = allocationNumber,
                sfa_DisplayOrder = fspDeliverable.DisplayOrder,
                sfa_DeliverableDescription = fspDeliverable.DeliverableName
            };

            Guid id = _organizationService.Create(newDeliverable);

            return new DeliverableInfo(id, parentDeliverableEntityReference, deliverableCode.ToString(), null);
        }

        public sfa_contractdeliverable CreateDeliverableObject(
            int deliverableCode,
            FspDeliverableInfo fspDeliverable,
            Guid allocationId,
            string allocationNumber,
            Guid contractId,
            Guid? parentDeliverableId)
        {
            var parentDeliverableEntityReference = (parentDeliverableId.HasValue)
                ? new EntityReference(sfa_contractdeliverable.EntityLogicalName, parentDeliverableId.Value)
                : null;

            var newDeliverable = new sfa_contractdeliverable
            {
                sfa_DeliverableCode = fspDeliverable.DeliverableCode.ToString(),
                sfa_deliverablename = fspDeliverable.DeliverableName,
                sfa_ParentDeliverableId = parentDeliverableEntityReference,
                sfa_ContractAllocationId = new EntityReference(sfa_contractallocation.EntityLogicalName, allocationId),
                sfa_FundingStreamPeriodDeliverableId =
                    new EntityReference(sfa_fundingstreamperioddeliverable.EntityLogicalName,
                        fspDeliverable.FspDeliverableId),
                sfa_ContractId = new EntityReference(sfa_contract.EntityLogicalName, contractId),
                sfa_AllocationRef = allocationNumber,
                sfa_DisplayOrder = fspDeliverable.DisplayOrder,
                sfa_DeliverableDescription = fspDeliverable.DeliverableName
            };

            return newDeliverable;
        }
    }
}

namespace SFA.FCT.PaymentManagementDomain.Integration.PaymentSchedule.Services
{
    using System.Linq;
    using CrossDomain.Integration.Entities.Data;
    using PaymentManagementDomain.PaymentSchedule.DataStore.Repositories;
    using PaymentSchedule = CrossDomain.Integration.Entities.PaymentSchedule;

    public class ActualValueNullResetService : IActualValueNullResetService
    {
        private readonly IAllocationRepository _allocationRepository;
        private readonly IDeliverablePaymentRepository _deliverablePaymentRepository;

        public ActualValueNullResetService(IAllocationRepository allocationRepository, IDeliverablePaymentRepository deliverablePaymentRepository)
        {
            _allocationRepository = allocationRepository;
            _deliverablePaymentRepository = deliverablePaymentRepository;
        }

        public PaymentSchedule.Allocation ConditionallyResetActualValuesToNullOnApproval(
            PaymentSchedule.Allocation allocation, ConnectionInfo connectionInfo)
        {
            bool anyNotNullDeliverablePaymentsForAllocation =
                AreAnyNotNullDeliverablePaymentsForAllocation(allocation.AllocationNumber, allocation.ContractVersionNumber, connectionInfo);

            return CreateAllocationWithNullActualValues(allocation, anyNotNullDeliverablePaymentsForAllocation);
        }

        private PaymentSchedule.Allocation CreateAllocationWithNullActualValues(PaymentSchedule.Allocation allocation, bool anyNotNullDeliverablePaymentsForAllocation)
        {
            return new PaymentSchedule.Allocation
            {
                AllocationNumber = allocation.AllocationNumber,
                ContractNumber = allocation.ContractNumber,
                ContractVersionNumber = allocation.ContractVersionNumber,
                FundingStreamPeriodCode = allocation.FundingStreamPeriodCode,
                VersionNumber = allocation.VersionNumber,
                schemaVersion = allocation.schemaVersion,
                ProvisionIdentifiers = allocation.ProvisionIdentifiers.Select(pi => new PaymentSchedule.ProvisionIdentifier
                {
                    ProvisionIdentifierCode = pi.ProvisionIdentifierCode,
                    ProvisionIdentifierName = pi.ProvisionIdentifierName
                }).ToList(),
                Organisation = new PaymentSchedule.Organisation
                {
                    MainOrganisationIdentifier = allocation.Organisation.MainOrganisationIdentifier,
                    OrganisationIdentifiers = allocation.Organisation.OrganisationIdentifiers.Select(oi => new PaymentSchedule.OrganisationIdentifier
                    {
                        OrganisationId = oi.OrganisationId,
                        OrganisationIdentifierName = oi.OrganisationIdentifierName 
                    }).ToList()
                },
                AllocationDeliverables = allocation.AllocationDeliverables
                    .Select(ad => new PaymentSchedule.AllocationDeliverable
                    {
                        DeliverableCode = ad.DeliverableCode,
                        ScheduledPayments = ad.ScheduledPayments.Select(sp => 
                            new PaymentSchedule.ScheduledPayment
                            {
                                ActualValue = anyNotNullDeliverablePaymentsForAllocation ? sp.ActualValue : null,
                                ActualVolume = sp.ActualVolume,
                                BalancingPaymentAmount = sp.BalancingPaymentAmount,
                                CappedPaymentAmount = sp.CappedPaymentAmount,
                                CollectionReturnCode = sp.CollectionReturnCode,
                                NetPaymentAmount = sp.NetPaymentAmount,
                                PeriodTypeCode =  sp.PeriodTypeCode,
                                Period = sp.Period,
                                PlannedValue = sp.PlannedValue,
                                PlannedVolume = sp.PlannedVolume,
                                ProfilePaymentAmount = sp.ProfilePaymentAmount,
                                ReconciliationPaymentAmount = sp.ReconciliationPaymentAmount
                            }).ToList()
                    }).ToList()
            };
        }

        private bool AreAnyNotNullDeliverablePaymentsForAllocation(string allocationNumber, int versionNumber, ConnectionInfo connectionInfo)
        {
            if (_allocationRepository.HasPreviousAllocationVersion(allocationNumber, versionNumber, connectionInfo))
            {
                int previousContractVersion =
                    _allocationRepository.GetPreviousApprovedContractVersionNumberFromPaymentSchedule(allocationNumber,
                        versionNumber, connectionInfo);

                return _deliverablePaymentRepository
                    .GetDeliverablePaymentsForAllocation(allocationNumber, previousContractVersion, connectionInfo)
                    .Any(dp => dp.ActualValue != null);
            }

            return false;
        }
    }
}
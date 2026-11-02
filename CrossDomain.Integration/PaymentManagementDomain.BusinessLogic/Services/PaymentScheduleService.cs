namespace SFA.FCT.PaymentManagementDomain.BusinessLogic.Services
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Common;
    using CrossDomain.Integration.Entities.Data;
    using CrossDomain.Integration.Entities.PaymentSchedule;
    using Framework.Logging.Interfaces;
    using MoreLinq;
    using PaymentSchedule.DataStore.Model;
    using PaymentSchedule.DataStore.Repositories;
    using Allocation = CrossDomain.Integration.Entities.PaymentSchedule.Allocation;

    public class PaymentScheduleService : IPaymentScheduleService
    {
        private readonly IAllocationRepository _allocationRepository;
        private readonly IProvisionIdentifierRepository _provisionIdentifierRepository;
        private readonly IOrganisationIdentifierRepository _organisationIdentifierRepository;
        private readonly IDeliverablePaymentRepository _deliverablePaymentRepository;
        private readonly ILogger _logger;

        public PaymentScheduleService(
            IAllocationRepository allocationRepository,
            IProvisionIdentifierRepository provisionIdentifierRepository,
            IOrganisationIdentifierRepository organisationIdentifierRepository,
            IDeliverablePaymentRepository deliverablePaymentRepository, ILogger logger)
        {
            _allocationRepository = allocationRepository;
            _provisionIdentifierRepository = provisionIdentifierRepository;
            _organisationIdentifierRepository = organisationIdentifierRepository;
            _deliverablePaymentRepository = deliverablePaymentRepository;
            _logger = logger;
        }

        public void SavePaymentSchedule(
            Allocation paymentScheduleForAllocation,
            IReadOnlyCollection<DeliverablePayment> deliverablePayments,
            ProcessingMode processingMode,
            DateTime? allocationStartDate,
            DateTime? allocationEndDate,
            ConnectionInfo connectionInfo)
        {
            _logger.LogInformation(
               PaymentManagementLoggingEvents.PaymentScheduleWriteTODB,
               $"Payment Schedule: Saving - {paymentScheduleForAllocation}");

            if (processingMode != ProcessingMode.ActualsReceived)
            {
                AddOrUpdateAllocation(paymentScheduleForAllocation, allocationStartDate, allocationEndDate, connectionInfo);
            }

            AddOrUpdateProvisionIdentifiers(paymentScheduleForAllocation, connectionInfo);
            AddOrUpdateOrganisationIdentifiers(paymentScheduleForAllocation, connectionInfo);

            _deliverablePaymentRepository.AddOrUpdateDeliverablePaymentsForAllocation(deliverablePayments,
                paymentScheduleForAllocation.AllocationNumber, paymentScheduleForAllocation.ContractVersionNumber, connectionInfo);          

            _logger.LogInformation(
               PaymentManagementLoggingEvents.PaymentScheduleWriteTODB,
               $"Payment Schedule: Saved - {paymentScheduleForAllocation}");
        }

        private void AddOrUpdateOrganisationIdentifiers(Allocation allocation, ConnectionInfo connectionInfo)
        {
            allocation.Organisation.OrganisationIdentifiers.Select(oi => CreateNewOrganisationIdentifier(allocation, oi))
                .ForEach(oi => _organisationIdentifierRepository.AddOrUpdate(oi, connectionInfo));
        }

        private PaymentSchedule.DataStore.Model.OrganisationIdentifer CreateNewOrganisationIdentifier(Allocation allocation, OrganisationIdentifier organisationIdentifier)
        {
            PaymentSchedule.DataStore.Model.OrganisationIdentifer organisationIdentiferDataStore = new PaymentSchedule.DataStore.Model.OrganisationIdentifer
            {
                AllocationNumber = allocation.AllocationNumber,
                VersionNumber = allocation.VersionNumber,
                MainOrganisationIdentifier = allocation.Organisation.MainOrganisationIdentifier,
                OrganisationId = organisationIdentifier.OrganisationId,
                LastModifiedDate = DateTime.UtcNow
            };

            OrganisationIdentifierName parsedValue;

            // we have a test for this in the UnitTest area
            // UpdateDeliverablePaymentsForAllocation_PaymentScheduleOrganisationIdentifierOrganisationIdentifierName_AllValuesShouldEnumParseTo_DataModelOrganisationIdentifierName
            Enum.TryParse(organisationIdentifier.OrganisationIdentifierName.ToString(),
                out parsedValue);

            organisationIdentiferDataStore.OrganisationIdentifierName = parsedValue;

            return organisationIdentiferDataStore;
        }

        private void AddOrUpdateProvisionIdentifiers(CrossDomain.Integration.Entities.PaymentSchedule.Allocation allocation, ConnectionInfo connectionInfo)
        {
            allocation.ProvisionIdentifiers.Select(pi => new PaymentSchedule.DataStore.Model.ProvisionIdentifier()
            {
                AllocationNumber = allocation.AllocationNumber,
                VersionNumber = allocation.VersionNumber,
                ProvisionIdentifierCode = pi.ProvisionIdentifierCode,
                ProvisionIdentifierName = pi.ProvisionIdentifierName,
                LastModifiedDate = DateTime.UtcNow
            })
            .ForEach(pi => _provisionIdentifierRepository.AddOrUpdate(pi, connectionInfo));
        }

        private void AddOrUpdateAllocation(CrossDomain.Integration.Entities.PaymentSchedule.Allocation allocation,
            DateTime? allocationStartDate, DateTime? allocationEndDate, ConnectionInfo connectionInfo)
        {
            PaymentSchedule.DataStore.Model.Allocation dataStoreAllocation = new PaymentSchedule.DataStore.Model.
                Allocation()
            {
                AllocationNumber = allocation.AllocationNumber,
                ContractNumber = allocation.ContractNumber,
                ContractVersionNumber = allocation.ContractVersionNumber,
                VersionNumber = allocation.VersionNumber,
                FundingStreamPeriodCode = allocation.FundingStreamPeriodCode,
                AllocationStartDate = allocationStartDate,
                AllocationEndDate = allocationEndDate,
                LastModifiedDate = DateTime.UtcNow
            };

            _allocationRepository.AddOrUpdate(dataStoreAllocation, connectionInfo);
        }
    }
}

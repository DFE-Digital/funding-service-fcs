namespace PerformanceManagementDomain.ReconciliationCalculationEndpoint.Handlers
{
    using SFA.FCT.PerformanceManagementDomain.Common.Commands;
    using SFA.FCT.PerformanceManagementDomain.Common.Logging;
    using Integration = SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;
    using AllocationModel = SFA.FCT.PerformanceManagementDomain.DataStore.Models.Allocation;
    using SFA.FCT.CrossDomain.Integration.Events;
    using SFA.FCT.PerformanceManagementDomain.DataStore.Models;
    using SFA.FCT.Framework.Logging.Interfaces;
    using NServiceBus;
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using CrmRepositories;
    using Services;
    using System.Threading.Tasks;
    using Infrastructure;
    using Repositories;
    using SFA.FCT.CrossDomain.Integration.Entities.Data;

    public class ContractApprovedEventHandler : IHandleMessages<ContractApprovedEvent>
    {
        private readonly ILogger _logger;
        private readonly IContractAllocationRepository _contractAllocationRepository;
        private readonly IFundingStreamPeriodQueryRepository _fundingStreamPeriodQueryRepository;
        private readonly IContractAllocationDeliverableRepository _contractAllocationDeliverableRepository;
        private readonly IFcrRecalculationRequiredChecker _fcrRecalculationRequiredChecker;
        private readonly ISessionConnectionFactory _sessionConnectionFactory;

        public ContractApprovedEventHandler(
            ILogger logger,
            IContractAllocationRepository contractAllocationRepository,
            IFundingStreamPeriodQueryRepository fundingStreamPeriodQueryRepository,
            IContractAllocationDeliverableRepository contractAllocationDeliverableRepository,
            IFcrRecalculationRequiredChecker fcrRecalculationRequiredChecker,
            ISessionConnectionFactory sessionConnectionFactory)
        {
            _logger = logger;
            _contractAllocationRepository = contractAllocationRepository;
            _fundingStreamPeriodQueryRepository = fundingStreamPeriodQueryRepository;
            _contractAllocationDeliverableRepository = contractAllocationDeliverableRepository;
            _fcrRecalculationRequiredChecker = fcrRecalculationRequiredChecker;
            _sessionConnectionFactory = sessionConnectionFactory;
        }

        public async Task Handle(ContractApprovedEvent message, IMessageHandlerContext context)
        {
            Integration.contractType contract = message.CorporateContract.contracts.First();

            _logger.LogInformation(PerformanceManagementLoggingId.StartProcessingContractApprovedEvent,
                $"Beginning handler to process ContractApprovedEvent for Contract: {contract.contractNumber}, Version: {contract.contractVersionNumber}");

            ConnectionInfo connectionInfo = _sessionConnectionFactory.GetConnection(context);

            var payOnProfilesFspCodes = await GetPayOnProfileFundingStreamPeriodCodes(contract.contractAllocations, connectionInfo)
                .ConfigureAwait(continueOnCapturedContext: false);

            if (IsAmendment(contract.contractVersionNumber))
            {
                IEnumerable<FundingClaimReconciliationInformation> fcrsToRecalculate =
                    await GetFundingClaimsThatRequiredRecalculation(contract.contractAllocations, payOnProfilesFspCodes, connectionInfo)
                        .ConfigureAwait(continueOnCapturedContext: false);

                fcrsToRecalculate.ToList().ForEach(async fc =>
                {
                    var command = new RecalculateFundingClaimReconciliationCommand
                    {
                        OrganisationIdentifier = fc.OrganisationIdentifier,
                        ClaimTypeName = fc.ClaimTypeName,
                        Period = fc.Period,
                        PeriodTypeCode = fc.PeriodTypeCode,
                        VersionNumber = fc.Version,
                        AllocationGroupCode = fc.AllocationGroupCode,
                        FcrCrmId = fc.FcrCrmId,
                        CappedClaimAdjustment = fc.CappedClaimAdjustment
                    };

                    _logger.LogInformation(PerformanceManagementLoggingId.StartProcessingContractApprovedEvent, $"Sending RecalculateFundingClaimReconciliationCommand: {command}");

                    await context.Send(command).ConfigureAwait(continueOnCapturedContext: false);
                });
            }

            await PersistContractToPaas(contract, payOnProfilesFspCodes, connectionInfo).ConfigureAwait(continueOnCapturedContext: false);

            _logger.LogInformation(PerformanceManagementLoggingId.StopProcessingContractApprovedEvent,
                $"Finished processing ContractApprovedEvent for Contract: {contract.contractNumber}, Version: {contract.contractVersionNumber}");
        }

        private static bool IsAmendment(int contractVersionNumber)
        {
            return contractVersionNumber > 1;
        }

        private async Task<IEnumerable<FundingClaimReconciliationInformation>> GetFundingClaimsThatRequiredRecalculation(
            IReadOnlyCollection<Integration.contractAllocationsContractAllocation> allocations, 
            IReadOnlyCollection<string> payOnProfilesFspCodes, ConnectionInfo connectionInfo)
        {
            IReadOnlyCollection<string> allocationNumbers = allocations.Select(ca => ca.contractAllocationNumber).ToList();

            IReadOnlyCollection<DTOs.AllocationInfo> allocationsPlannedValue = await _contractAllocationRepository.GetAllocationsWithPlannedValue(
                    allocationNumbers, connectionInfo)
                .ConfigureAwait(continueOnCapturedContext: false);
            
            return allocations
                .Where(a => payOnProfilesFspCodes.Contains(a.fundingStreamPeriodCode))
                .Select(a => _fcrRecalculationRequiredChecker.CheckIfRecalculationRequired(allocationsPlannedValue,
                             a.contractAllocationNumber,
                             a.TotalAggregatedPlannedValue()))
                .Where(a => a.IsCalculationRequired)
                .Select(a => a.FundingClaimReconciliationInformation)
                .Distinct();
        }

        private async Task PersistContractToPaas(Integration.contractType contract, IReadOnlyCollection<string> payOnProfilesFspCodes, ConnectionInfo connectionInfo)
        {
            AllocationModel.Contract allocationContract = CreateAllocationContract(contract);
            AllocationModel.FundingType fundingType = CreateAllocationFundingType(contract.fundingType);
            AllocationModel.Period period = CreatePeriod(contract.period);
            DateTime utcNow = DateTime.UtcNow;

            var payOnProfileAllocations = contract.contractAllocations.Where(a => payOnProfilesFspCodes.Contains(a.fundingStreamPeriodCode)).ToList();

            foreach (var allocation in payOnProfileAllocations)
            {
                await _contractAllocationRepository.AddOrUpdateAllocation(
                    new AllocationModel.ContractAllocation(allocation.contractAllocationNumber, allocation.startDate, allocation.endDate)
                    {
                        Contract = allocationContract,
                        Contractor = CreateAllocationContractor(contract.GetOrganisation(allocation.contractAllocationNumber)),
                        FundingType = fundingType,
                        Period = period,
                        LastModifiedDate = utcNow
                    }, connectionInfo).ConfigureAwait(continueOnCapturedContext: false);

                await _contractAllocationDeliverableRepository.StoreContractAllocationDeliverables(
                    allocation.FlattenDeliverables(allocation.contractDeliverables)
                        .Select(d =>
                            new ContractAllocationDeliverable(
                                allocation.contractAllocationNumber,
                                d.deliverable.deliverableCode,
                                d.AggregatedPlannedValue))
                        .ToList(),
                    connectionInfo).ConfigureAwait(continueOnCapturedContext: false);
            };
        }

        private static AllocationModel.Contract CreateAllocationContract(Integration.contractType contract)
        {
            return new AllocationModel.Contract
            {
                ContractNumber = contract.contractNumber,
                ApprovalDate = contract.ContractApprovalDate.Value,
                VersionNumber = contract.contractVersionNumber,
                SubVersionNumber = contract.contractSubVersionNumber
            };
        }

        private static AllocationModel.Contractor CreateAllocationContractor(Integration.Contractor contractor)
        {
            return new AllocationModel.Contractor
            {
                LegalName = contractor.legalName,
                OrganisationIdentifier = contractor.organisationIdentifier,
                UKPRN = contractor.ukprn
            };
        }

        private static AllocationModel.FundingType CreateAllocationFundingType(Integration.fundingType fundingType)
        {
            return new AllocationModel.FundingType
            {
                FundingTypeCode = fundingType.fundingTypeCode,
                FundingTypeName = fundingType.fundingTypeName
            };
        }

        private static AllocationModel.Period CreatePeriod(Integration.Period period)
        {
            return new AllocationModel.Period
            {
                PeriodTypeName = period.periodType.periodTypeName.ToString()
            };
        }

        private async Task<IReadOnlyCollection<string>> GetPayOnProfileFundingStreamPeriodCodes(
            List<Integration.contractAllocationsContractAllocation> contractAllocations, ConnectionInfo connectionInfo)
        {
            IReadOnlyCollection<string> fundingStreamPeriodCodes = contractAllocations.Select(ca => ca.fundingStreamPeriodCode).ToList();

            return await _fundingStreamPeriodQueryRepository.GetPayOnProfileFundingStreamPeriodCodes(fundingStreamPeriodCodes, connectionInfo)
                .ConfigureAwait(continueOnCapturedContext: false);
        }
    }
}
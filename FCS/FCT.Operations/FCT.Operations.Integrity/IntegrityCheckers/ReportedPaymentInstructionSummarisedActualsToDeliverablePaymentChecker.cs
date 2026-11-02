namespace SFA.FCT.Operations.Integrity.IntegrityCheckers
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using AllocationDeliveryDomain.Common.Storage;
    using CrossDomain.Integration.Common;
    using DTOs;
    using MoreLinq;
    using Repositories;
    using Services;
    using Utils;
    using ClosedCollectionRepository = Repositories.ClosedCollectionRepository;
    using global::AllocationDeliveryDomain.Endpoint.Services;

    public class ReportedPaymentInstructionSummarisedActualsToDeliverablePaymentChecker : IIntegrityChecker
    {
        private static readonly List<string> CollectionTypesToValidate = new List<string> { "APPS" };
        private readonly PaasDeliverablePaymentLazyRepository _paasDeliverablePaymentLazyRepository;
        private readonly IPaasFundingStreamPeriodRepository _fundingStreamPeriodRepository;
        private readonly ReportedPaymentEnricher _reportedPaymentEnricher;
        private readonly SummarisedActualRepository _summarisedActualRepository;
        private readonly ClosedCollectionRepository _closedCollectionRepository;
        private readonly bool _forceCheck;

        public ReportedPaymentInstructionSummarisedActualsToDeliverablePaymentChecker(
            PaasDeliverablePaymentLazyRepository paasDeliverablePaymentLazyRepository,
            ReportedPaymentEnricher reportedPaymentEnricher,
            SummarisedActualRepository summarisedActualRepository,
            ClosedCollectionRepository closedCollectionRepository,
            IPaasFundingStreamPeriodRepository fundingStreamPeriodRepository,
            bool forceCheck = false)
        {
            _paasDeliverablePaymentLazyRepository = paasDeliverablePaymentLazyRepository;
          
            _reportedPaymentEnricher = reportedPaymentEnricher;
            _summarisedActualRepository = summarisedActualRepository;
            _closedCollectionRepository = closedCollectionRepository;
            _fundingStreamPeriodRepository = fundingStreamPeriodRepository;
            _forceCheck = forceCheck;
        }

        public IntegrityCheckResult CheckValues()
        {
            IReadOnlyCollection<ReportedPaymentInstructionDifferenceItem> differenceItems =
                CollectionTypesToValidate
                .SelectMany(GetDifferenceItemsForCollectionType)
                .ToList();

            return new IntegrityCheckResult(differenceItems.Any(), CreateCsv(differenceItems));
        }

        private IReadOnlyCollection<ReportedPaymentInstructionDifferenceItem> GetDifferenceItemsForCollectionType(string collectionType)
        {
            var differenceItems = new List<ReportedPaymentInstructionDifferenceItem>();

            if (_closedCollectionRepository.WasCollectionPulledInTheLast6Hours(collectionType) || _forceCheck)
            {
                string latestCollectionReturnCode = _closedCollectionRepository.GetLatestCollectionCodeForCollectionType(collectionType);

                if (latestCollectionReturnCode != null)
                {
                    DateTime lastCollectionClosedTime = _closedCollectionRepository.GetLastClosedTime(collectionType);

                    var reportedPaymentInstructionsByOrganisation =
                        GetActualsForCollectionReturnGroupedByOrganisation(collectionType, latestCollectionReturnCode);

                    foreach (var organisationReportedPaymentInstructions in reportedPaymentInstructionsByOrganisation)
                    {
                        EnrichReportedPaymentInstructions(organisationReportedPaymentInstructions);
                        RemoveInvalidEnrichedPaymentInstructions(organisationReportedPaymentInstructions, lastCollectionClosedTime);

                        if (organisationReportedPaymentInstructions.EnrichedReportedActuals.Any())
                        {
                            var allocationPaymentInstructions = SplitOrganisationActualsByAllocation(organisationReportedPaymentInstructions);

                            IReadOnlyCollection<AllocationActualsPaas> checkablePaymentInstructions =
                                allocationPaymentInstructions
                                    .Where(ArePaymentInstructionsReceivedForFundingStreamPeriod)
                                    .ToList();

                            foreach (var allocation in checkablePaymentInstructions)
                            {
                                if (!string.IsNullOrEmpty(allocation.AllocationNumber))
                                {
                                    var period = allocation.EnrichedReportedActuals.First().Period;

                                    var summarisedActualPaymentValue = allocation.GetTotalActualValue();

                                    var paasReconciliationPaymentAmount =
                                        _paasDeliverablePaymentLazyRepository.SumReconcilationPaymentAmountsForPeriod(allocation.AllocationNumber, allocation.VersionNumber, period);

                                    var paasNetPaymentAmount =
                                        _paasDeliverablePaymentLazyRepository.SumNetPaymentAmountsForPeriod(allocation.AllocationNumber, allocation.VersionNumber, period);

                                    if (summarisedActualPaymentValue != paasReconciliationPaymentAmount || summarisedActualPaymentValue != paasNetPaymentAmount)
                                    {
                                        differenceItems.Add(new ReportedPaymentInstructionDifferenceItem(
                                            key: allocation.Key.ToString(),
                                            allocationNumber: allocation.AllocationNumber,
                                            versionNumber: allocation.VersionNumber,
                                            summarisedActualPaymentValue: allocation.GetTotalActualValue(),
                                            paasReconciliationPaymentAmount: paasReconciliationPaymentAmount,
                                            paasNetPaymentAmount: paasNetPaymentAmount,
                                            message: "Differences in payment values between SummarisedActuals and PaaS"));
                                    }
                                }
                                else
                                {
                                    differenceItems.Add(new ReportedPaymentInstructionDifferenceItem(
                                        key: allocation.Key.ToString(),
                                        allocationNumber: allocation.AllocationNumber,
                                        versionNumber: allocation.VersionNumber,
                                        summarisedActualPaymentValue: allocation.GetTotalActualValue(),
                                        paasReconciliationPaymentAmount: 0,
                                        paasNetPaymentAmount: 0,
                                        message: "Allocation exists in SummarisedActuals but not in PaaS"));
                                }
                            }
                        }
                    }
                }
            }

            return differenceItems;
        }

        private static string CreateCsv(IReadOnlyCollection<ReportedPaymentInstructionDifferenceItem> differenceItems)
        {
            return differenceItems.Any() ? new CsvWriter<ReportedPaymentInstructionDifferenceItem>().CreateCsv(differenceItems) : null;
        }

        private void EnrichReportedPaymentInstructions(OrganisationActualsPaas organisation)
        {
            organisation.EnrichedReportedActuals = (List<EnrichedReportedActual>)_reportedPaymentEnricher.Enrich(organisation.ReportedActuals.ToList());
        }

        private static void RemoveInvalidEnrichedPaymentInstructions(OrganisationActualsPaas organisationActuals, DateTime lastCollectionClosedTime)
        {
            var validator = new PaymentInstructionValidator(new DateProvider(lastCollectionClosedTime));

            organisationActuals.EnrichedReportedActuals.ForEach(validator.Validate);
            organisationActuals.EnrichedReportedActuals = organisationActuals.EnrichedReportedActuals.Where(pi => pi.IsValid).ToList();
        }

        private static IReadOnlyCollection<AllocationActualsPaas> SplitOrganisationActualsByAllocation(OrganisationActualsPaas organisationActuals)
        {
            return organisationActuals.EnrichedReportedActuals
                .GroupBy(era => era.ContractAllocationNumber)
                .Select(grp => new AllocationActualsPaas(
                    key: organisationActuals.Key,
                    contractNumber: grp.First().ContractNumber,
                    allocationNumber: grp.Key,
                    versionNumber: grp.First().ContractVersion,
                    enrichedReportedActuals: grp.ToList()))
                .ToList();
        }

        private bool ArePaymentInstructionsReceivedForFundingStreamPeriod(AllocationActualsPaas allocationActuals)
        {
            EnrichedReportedActual firstActual = allocationActuals.EnrichedReportedActuals.FirstOrDefault();
            
            if (firstActual != null)
            {
                return _fundingStreamPeriodRepository.IsFundingStreamPeriodPayOnInstruction(firstActual.FundingStreamPeriodCode);
            }

            throw new ArgumentException($"Could not retrieve Funding Stream Period configuration for allocation {allocationActuals.AllocationNumber}.");
        }

        private IReadOnlyCollection<OrganisationActualsPaas> GetActualsForCollectionReturnGroupedByOrganisation(string collectionType, string collectionReturnCode)
        {
            var allSummarisedActuals = _summarisedActualRepository.GetSummarisedActualsForCollectionTypeAndReturnCode(collectionType, collectionReturnCode);

            allSummarisedActuals.ForEach(c =>
            {
                c.CollectionType = collectionType;
                c.CollectionReturnCode = collectionReturnCode;
            });

            var summarisedActualsGroupedByKey = allSummarisedActuals.GroupBy(sag => new
            {
                sag.CollectionType,
                sag.CollectionReturnCode,
                sag.OrganisationId,
                sag.FundingStreamPeriodCode,
                sag.UopCode
            });

            var groupedReportedActuals = new List<OrganisationActualsPaas>();

            foreach (var groupItemSummarisedActuals in summarisedActualsGroupedByKey)
            {
                var summarisedActuals = groupItemSummarisedActuals;

                var reportedActuals = summarisedActuals
                    .Select(SummarisedActualTransformer.ToReportedActual)
                    .ToList();

                groupedReportedActuals.Add(new OrganisationActualsPaas(new SummarisedActualOrgFspGroupKey(
                        groupItemSummarisedActuals.Key.CollectionType,
                        groupItemSummarisedActuals.Key.CollectionReturnCode,
                        groupItemSummarisedActuals.Key.OrganisationId,
                        groupItemSummarisedActuals.Key.FundingStreamPeriodCode,
                        groupItemSummarisedActuals.Key.UopCode),
                    reportedActuals));
            }
            
            return groupedReportedActuals;
        }

        private class ReportedPaymentInstructionDifferenceItem
        {
            public ReportedPaymentInstructionDifferenceItem(
                string key,
                string allocationNumber,
                int versionNumber,
                decimal summarisedActualPaymentValue,
                decimal? paasReconciliationPaymentAmount,
                decimal? paasNetPaymentAmount,
                string message)
            {
                Key = key;
                AllocationNumber = allocationNumber;
                VersionNumber = versionNumber;
                SummarisedActualPaymentValue = summarisedActualPaymentValue;
                PaasReconciliationPaymentAmount = paasReconciliationPaymentAmount;
                PaasNetPaymentAmount = paasNetPaymentAmount;
                Message = message;
            }

            [Order(1)]
            public string Key { get; }

            [Order(2)]
            public string AllocationNumber { get; }

            [Order(3)]
            public int VersionNumber { get; }

            [Order(4)]
            public decimal? SummarisedActualPaymentValue { get; }

            [Order(5)]
            public decimal? PaasReconciliationPaymentAmount { get; }

            [Order(6)]
            public decimal? PaasNetPaymentAmount { get; }

            [Order(7)]
            public string Message { get; }
        }

        private class DateProvider : IDate
        {
            private readonly DateTime _date;

            public DateProvider(DateTime date)
            {
                _date = date;
            }

            public DateTime GetCalculationDate()
            {
                return _date;
            }

            public DateTime GetCalculationDateWithKey(string key)
            {
                return _date;
            }
        }
    }
}
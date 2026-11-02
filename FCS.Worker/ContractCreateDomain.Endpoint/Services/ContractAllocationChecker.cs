namespace ContractCreateDomain.Endpoint.Services
{
    using System.Linq;
    using DTOs;
    using Infrastructure;
    using Optional;
    using SFA.FCT.CrossDomain.Integration.Entities.ContractRequest;

    public static class ContractAllocationChecker
    {
        public static Either<bool, CrmAllocationAndImportAllocation> HasTheSameDeliverableCodes(CrmAllocationAndImportAllocation matchedAllocation)
        {
            bool HaveEquivalentDeliverableCodes(contractAllocation sourceAllocation, CrmAllocation destinationAllocation)
            {
                return sourceAllocation.contractDeliverables
                    .All(sourceDeliverable => destinationAllocation.Deliverables.Select(destinationDeliverable => destinationDeliverable.CodeAsNumber)
                    .Contains(sourceDeliverable.deliverable.deliverableCode));
            }

            bool areEquivalent =
                HaveEquivalentDeliverableCodes(matchedAllocation.ImportAllocation, matchedAllocation.CrmAllocation);
              
            if (areEquivalent)
            {
                return matchedAllocation;
            }

            return false;
        }

        public static Either<bool, CrmAllocationAndImportAllocation> HasTheSamePlannedValues(CrmAllocationAndImportAllocation matchedAllocation)
        {
            bool arePlannedValuesTheSame = matchedAllocation.ImportAllocation.contractDeliverables.All(importedD =>
            {
                var crmDeliverable = matchedAllocation.CrmAllocation.Deliverables.FirstOrDefault(d =>
                    d.CodeAsNumber == importedD.deliverable.deliverableCode)
                    .SomeWhen(d => d != null);

                return ArePlannedValuesTheSameForDeliverable(importedD, crmDeliverable);
            });

            if (arePlannedValuesTheSame)
            {
                return matchedAllocation;
            }

            return false;
        }

        public static Either<bool, CrmAllocationAndImportAllocation> HasTheSameAllocationDates(CrmAllocationAndImportAllocation matchedAllocation)
        {
            bool areEquivalent =
                matchedAllocation.CrmAllocation.StartDate == matchedAllocation.ImportAllocation.startDate &&
                matchedAllocation.CrmAllocation.EndDate == matchedAllocation.ImportAllocation.endDate;

            if (areEquivalent)
            {
                return matchedAllocation;
            }

            return false;
        }

        private static bool ArePlannedValuesTheSameForDeliverable(contractDeliverable importedDeliverable, Option<CrmDeliverable> crmDeliverableOption)
        {
            bool areEquivalent = false;

            bool HaveEquivalentPlannedValues(contractDeliverable sourceDeliverable, CrmDeliverable destinationDeliverable)
            {
                return sourceDeliverable.contractDeliverablePeriods
                    .All(d1Dp => destinationDeliverable.Periods.Any(d2Dp => d1Dp.period == d2Dp.Period && d1Dp.plannedValue.GetValueOrDefault(0) == d2Dp.PlannedValue.GetValueOrDefault(0) && d1Dp.year == d2Dp.Year));
            }

            crmDeliverableOption.MatchSome(crmDeliverable =>
            {
                areEquivalent = HaveEquivalentPlannedValues(importedDeliverable, crmDeliverable);
            });

            return areEquivalent;
        }
    }
}

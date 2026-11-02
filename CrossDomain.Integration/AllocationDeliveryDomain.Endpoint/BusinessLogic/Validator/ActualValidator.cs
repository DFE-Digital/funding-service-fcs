namespace SFA.FCT.AllocationDeliveryDomain.Endpoint.BusinessLogic.Validator
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using CrossDomain.Integration.Entities.Data;
    using global::AllocationDeliveryDomain.Endpoint.BusinessLogic.Extensions;
    using global::AllocationDeliveryDomain.Endpoint.Repositories;
    using SFA.FCT.AllocationDeliveryDomain.Common;
    using SFA.FCT.AllocationDeliveryDomain.Common.BusinessLogic.Repository;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Common;
    using SFA.FCT.Framework.Logging.Interfaces;

    public class ActualValidator : IActualValidator
    {
        public IDate Date { get; set; }

        public ILogger Logger { get; set; }

        public IFundingStreamConfigurationStore Store { get; set; }

        public IAllocationsUnderTerminationQueryRepository AllocationsUnderTerminationQueryRepository { get; set; }

        public List<EnrichedReportedActual> GetValidActuals(List<EnrichedReportedActual> listToValidate, ConnectionInfo connectionInfo)
        {
            bool processFutureActuals = ShouldProcessFutureActuals(listToValidate, connectionInfo);

            listToValidate.ForEach(
                actual =>
                {
                    var validationResults = Validate(actual, processFutureActuals, connectionInfo);
                    
                    if (!actual.IsValid && validationResults.Any())
                    {
                        Logger.LogInformation(
                            AllocationDeliverDomainEventLoggingId.ActualVerificationFailed,
                            "Enriched reported actual invalid: OrganisationID {0}, Funding Stream Period: {1}, Period: {2}, UoP Code: {3}, Deliverable Code: {4}, Actual Value: {5}, Actual Volume: {6}. Reason: {7}",
                            actual.OrganisationId,
                            actual.FundingStreamPeriodCode,
                            actual.Period,
                            actual.UoPCode,
                            actual.DeliverableCode,
                            actual.ActualValue,
                            actual.ActualVolume,
                            string.Join(",", validationResults));
                    }
                });

            return listToValidate.Where(a => a.IsValid).ToList();
        }

        private bool ShouldProcessFutureActuals(List<EnrichedReportedActual> listToValidate, ConnectionInfo connectionInfo)
        {
            var processFutureActuals = false;
            var firstActual = listToValidate.FirstOrDefault();

            if (firstActual != null)
            {
                var fsp = Store.GetFundingStreamPeriod(firstActual.FundingStreamPeriodCode, connectionInfo);
                if (fsp != null)
                {
                    processFutureActuals = fsp.ProcessFutureActuals;
                }
            }

            return processFutureActuals;
        }

        public IList<string> Validate(EnrichedReportedActual actual, bool processFutureActuals, ConnectionInfo connectionInfo)
        {
            var validationErrors = new List<string>();

            if (!HasAllocation(actual))
            {
                validationErrors.Add("No contract allocation number found on on actual");
            }
            else if (!HasDeliverable(actual))
            {
                validationErrors.Add("No deliverable code found on actual");
            }

            if (!IsActualWithinContractAllocationDuration(actual))
            {
                validationErrors.Add(
                    $"Period '{actual.Period}' is not within the range of '{actual.AllocationStartDate}' and '{actual.AllocationEndDate}'");
            }

            if (IsPeriodAfterAllocationTerminationDatePeriod(actual, connectionInfo))
            {
                validationErrors.Add($"Period '{actual.Period}' is after allocation termination date");
            }

            actual.IsValid = !validationErrors.Any() && IsActualForYtdPeriod(actual, processFutureActuals);

            return validationErrors;
        }

        public bool IsCalcDateAfterFspActivityCloseDate(string fsp, ConnectionInfo connectionInfo)
        {
            var activityCloseDate = Store.GetFundingStreamPeriod(fsp, connectionInfo).ActivityCloseDate;
            return activityCloseDate.HasValue && Date.GetCalculationDate().Date > activityCloseDate.Value;
        }

        private bool HasAllocation(EnrichedReportedActual actual)
        {
            return actual.ContractAllocationNumber != null;
        }

        private bool HasDeliverable(EnrichedReportedActual actual)
        {
            return actual.EnrichedDeliverableCode != null;
        }

        private bool IsActualWithinContractAllocationDuration(EnrichedReportedActual actual)
        {
            var actualPeriod = Convert.ToInt32(actual.Period);
            var allocationStartPeriod = Convert.ToInt32(actual.AllocationStartDate.ToString("yyyyMM"));

            var allocationEndPeriod = Convert.ToInt32(actual.AllocationEndDate.ToString("yyyyMM"));

            return actualPeriod >= allocationStartPeriod && actualPeriod <= allocationEndPeriod;
        }

        private bool IsActualForYtdPeriod(EnrichedReportedActual actual, bool processFutureActuals)
        {
            var result = true;
            if (!processFutureActuals)
            {
                var actualPeriod = Convert.ToInt32(actual.Period);
                var currentPeriod = Convert.ToInt32(Date.GetCurrentPeriod(Date.GetCalculationDate()));
                    result = actualPeriod <= currentPeriod;
            }

            return result;
        }

        private bool IsPeriodAfterAllocationTerminationDatePeriod(EnrichedReportedActual actual, ConnectionInfo connectionInfo)
        {
            DateTime? terminationDate = AllocationsUnderTerminationQueryRepository.GetTerminationDate(actual.ContractAllocationNumber, connectionInfo);

            if (terminationDate.HasValue)
            {
                int actualPeriod = int.Parse(actual.Period);
                int terminationPeriod = int.Parse(terminationDate.Value.ToString("yyyyMM"));
                return actualPeriod > terminationPeriod;
            }

            return false;
        }
    }
}

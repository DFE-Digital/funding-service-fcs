namespace AllocationDeliveryDomain.Endpoint.BusinessLogic.Mapper
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using SFA.FCT.AllocationDeliveryDomain.Common.Storage;
    using SFA.FCT.CrossDomain.Integration.Entities.AllocationActuals;

    public class EnrichedActualMapper : IMapper<EnrichedReportedActual, ContractAllocationActualsType>
    {
        public IEnumerable<ContractAllocationActualsType> Map(IEnumerable<EnrichedReportedActual> source)
        {
            List<ContractAllocationActualsType> result = new List<ContractAllocationActualsType>();
            var allocations = source.GroupBy(s => new { s.ContractAllocationNumber, s.FundingStreamPeriodCode });

            foreach (var allocation in allocations)
            {
                var firstActual = allocation.First();
                var contractAllocation = new ContractAllocationActualsType
                {
                    ActualsSummary = new List<ActualsSummaryType>(),
                    CollectionReturnCode = firstActual.CollectionReturnCode,
                    CollectionType = firstActual.CollectionType,
                    ContractAllocationNumber = allocation.Key.ContractAllocationNumber,
                    ContractorReference = new OrganisationReferenceType
                    {
                        OrganisationIdentifier = firstActual.OrganisationId,
                        AlternativeOrganisationIdentifiers = new List<organisationIdentifiersOrganisationIdentifier>
                        {
                            new organisationIdentifiersOrganisationIdentifier
                            {
                                organisationIdentifier = firstActual.Ukprn,
                                organisationIdentifierType = organisationIdentifierType.UKPROVIDERREFERENCENUMBER
                            }
                        }
                    },
                    ContractReference =
                        new ContractReferenceType
                        {
                            ContractNumber = firstActual.ContractNumber,
                            ContractVersionNumber = firstActual.ContractVersion,
                            ContractSubVersionNumber = firstActual.ContractSubVersion
                        },
                    FundingStreamPeriodCode = allocation.Key.FundingStreamPeriodCode,
                    UoPCode = firstActual.UoPCode
                };

                foreach (var actual in allocation)
                {
                    var actualSummary = new ActualsSummaryType
                    {
                        ActualValue = (decimal)actual.ActualValue,
                        ActualVolume = (int)actual.ActualVolume,
                        Period = actual.Period,
                        PeriodType = new PeriodTypeType { PeriodTypeCode = actual.PeriodTypeCode }
                    };

                    int deliverableCode;
                    if (int.TryParse(actual.DeliverableCode, out deliverableCode))
                    {
                        actualSummary.DeliverableCode = deliverableCode;
                    }

                    contractAllocation.ActualsSummary.Add(actualSummary);
                }

                result.Add(contractAllocation);
            }

            return result;
        }
    }
}

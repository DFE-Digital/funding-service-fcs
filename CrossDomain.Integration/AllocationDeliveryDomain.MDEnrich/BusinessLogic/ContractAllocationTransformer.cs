namespace SFA.FCT.AllocationDeliveryDomain.MDEnrich.BusinessLogic
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using Common;
    using CrossDomain.Integration.Entities.DeliveryAllocation;
    using Framework.Logging.Interfaces;
    using contractDeliverablePeriodsTypeContractDeliverablePeriod = CrossDomain.Integration.Entities.DeliveryAllocation.contractDeliverablePeriodsTypeContractDeliverablePeriod;
    using CorporateContract = CrossDomain.Integration.Entities.CorporateContract;
    using deliverableType = CrossDomain.Integration.Entities.DeliveryAllocation.deliverableType;
    using periodType = CrossDomain.Integration.Entities.DeliveryAllocation.periodType;
    using periodTypeCodeType = CrossDomain.Integration.Entities.DeliveryAllocation.periodTypeCodeType;
    using periodTypeNameType = CrossDomain.Integration.Entities.DeliveryAllocation.periodTypeNameType;
    using periodTypeType = CrossDomain.Integration.Entities.DeliveryAllocation.periodTypeType;

    public class ContractAllocationTransformer : IContractAllocationTransformer
    {
        public ILogger Logger { get; set; }

        public allocationType Transform(CorporateContract.contractType contract, CorporateContract.contractAllocationsContractAllocation contractAllocation, string correlationId)
        {
            Logger.LogInformation(
                AllocationDeliverDomainEventLoggingId.TransformingAllocation,
                "Transforming contractAllocation to DeliveryAllocation.allocationType, CorrelationId: {0}, allocation: {1}",
                correlationId,
                contractAllocation.contractAllocationNumber);

            CorporateContract.Contractor organisationForAllocation = contract.GetOrganisation(contractAllocation.contractAllocationNumber);

            allocationType newAllocation = new allocationType
            {
                contractAllocationNumber = contractAllocation.contractAllocationNumber,
                contractReference = new contractReferenceType
                {
                    contractNumber = contract.contractNumber,
                    contractVersionNumber = contract.contractVersionNumber,
                    contractSubVersionNumber = contract.contractSubVersionNumber
                },
                description = contractAllocation.description,
                // Changed for Nullable start and end date
                maximumContractValue = contract.contractValue.GetValueOrDefault(),
                endDate = contractAllocation.endDate,
                startDate = contractAllocation.startDate,
                contractorReference = new organisationReferenceType
                {
                    organisationIdentifier = organisationForAllocation.organisationIdentifier,
                    alternativeOrganisationIdentifiers = new List<alternativeOrganisationIdentifierType>
                    {
                        new alternativeOrganisationIdentifierType
                        {
                            OrganisationIdentifier = organisationForAllocation.ukprn.ToString(),
                            OrganisationIdentifierName = alternativeOrganisationIdentifierTypeOrganisationIdentifierName.UKPROVIDERREFERENCENUMBER,
                        }
                    }
                },
                fundingStreamPeriod = new allocationTypeFundingStreamPeriod
                {
                    endDate = contractAllocation.period.endDate,
                    fundingStreamPeriodCode = contractAllocation.fundingStreamPeriodCode,
                    period = new periodType
                    {
                        periodType1 = TransformPeriodTypes(contractAllocation.period.periodType),
                        periodValue = contractAllocation.period.period1
                    },
                    startDate = contractAllocation.period.startDate,
                },
                uopCode = contractAllocation.uopCode,
                contractDeliverables = GetContractDeliverables(contractAllocation.contractDeliverables)
            };

            return newAllocation;
        }

        private List<contractDeliverableType> GetContractDeliverables(List<CorporateContract.contractDeliverablesTypeContractDeliverable>  contractDeliverables)
        {
            return (from d in contractDeliverables
                select new contractDeliverableType
                {
                    deliverable = new deliverableType
                    {
                        deliverableCode = d.deliverable.deliverableCode,
                        deliverableName = d.deliverable.deliverableName,
                        isLegal = true,
                        isMonitoring = false,
                    },
                    deliverableDescription = d.deliverableDescription,
                    plannedValue = d.plannedValue,
                    plannedVolume = d.plannedVolume,
                    contractDeliverablePeriods = (from dp in d.contractDeliverablePeriods
                        select new contractDeliverablePeriodsTypeContractDeliverablePeriod
                        {
                            plannedValue = dp.plannedValue,
                            plannedVolume = dp.plannedVolume,
                            period = new periodType
                            {
                                periodType1 = TransformPeriodTypes(dp.periodType),
                                periodValue = GetPeriodValue(dp.year, dp.period)
                            }
                        }).ToList(),
                    contractDeliverables = GetContractDeliverables(d.contractDeliverables)
                }).ToList();
        }

        private string GetPeriodValue(int year, int period)
        {
            return string.Format("{0:0000}{1:00}", year, period);
        }

        private periodTypeType TransformPeriodTypes(CorporateContract.periodTypeType pt)
        {
            return new periodTypeType
            {
                periodTypeCode = (periodTypeCodeType)Enum.Parse(typeof(periodTypeCodeType), pt.periodTypeCode.ToString()),
                periodTypeName = (periodTypeNameType)Enum.Parse(typeof(periodTypeNameType), pt.periodTypeName.ToString()),
            };
        }
    }
}
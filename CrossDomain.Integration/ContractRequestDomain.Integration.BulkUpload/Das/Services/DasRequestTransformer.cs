namespace SFA.FCT.ContractRequestDomain.Integration.BulkUpload.Das.Services
{
    using System;
    using System.Collections.Generic;
    using CrossDomain.Integration.Entities.ContractRequest;

    public static class DasRequestTransformer
    {
        private const string Period = "1799";
        private const string PeriodTypeCode = "LEVY";
        private const string FundingStreamCode = "LEVY";
        private const string PeriodTypeName = "";
        private const decimal MaximumContractValue = 0.0m;
        private const string FundingStreamPeriodCode = "LEVY1799";
            private const string ContractType = "Provider Agreement";
        private const int AmendmentType = 0;
        private const int VersionNumber = 1;

        public static contractRequestType Transform(DasRequest request)
        {
            contractAllocation allocation = new contractAllocation
            {
                period = new periodType
                {
                    period = Period,
                    startDate = DateTime.MinValue,
                    endDate = DateTime.MinValue,
                    periodType1 = new periodTypeType
                    {
                        periodTypeCode = PeriodTypeCode,
                        periodTypeName = PeriodTypeName
                    }
                },
                ukprn = request.Ukprn,
                fundingStreamCode = FundingStreamCode,
                startDate = request.StartDate,
                maximumContractValue = MaximumContractValue,
                fundingStreamPeriodCode = FundingStreamPeriodCode,
                contractDeliverables = new List<contractDeliverable>(),
                correlationId = Guid.NewGuid().ToString("D")
            };

            contractType contract = new contractType
            {
                ApprovedAllocationValues = new List<AllocationValueData>(),
                contracts = new List<contractType>(),
                fundingTypeCode = request.FundingType,
                period = new periodType
                {
                    period = Period,
                    startDate = DateTime.MinValue,
                    endDate = DateTime.MinValue,
                    periodType1 = new periodTypeType
                    {
                        periodTypeName = PeriodTypeName,
                        periodTypeCode = PeriodTypeCode
                    }
                },
                contractAllocations = new List<contractAllocation> { allocation },
                contractVersionNumber = VersionNumber,
                contractor = new Contractor
                {
                    ukprn = request.Ukprn
                },
                hierarchyType = hierarchyType.CONTRACT,
                contractType1 = ContractType,
                startDate = request.StartDate.ToUniversalTime(),
                amendmentType = AmendmentType,
                correlationId = Guid.NewGuid().ToString("D")
            };

            contractType masterContract = new contractType
            {
                ApprovedAllocationValues = new List<AllocationValueData>(),
                contracts = new List<contractType> { contract },
                fundingTypeCode = request.FundingType,
                contractAllocations = new List<contractAllocation>(),
                contractVersionNumber = VersionNumber,
                contractor = new Contractor
                {
                    ukprn = request.Ukprn
                },
                hierarchyType = 0,
                startDate = request.StartDate.ToUniversalTime(),
                CRMIntent = 0, // or the appropriate value/type for your context
                amendmentType = AmendmentType,
                correlationId = contract.correlationId,
                period = null
            };

            contractRequestType transformedRequest = new contractRequestType
            {
                contract = masterContract,
                errorInfo = new List<errorInfoType>(),
                FundingConfiguration = GetFundingConfiguration(),
                correlationInfo = new correlationInfoType
                                      {
                                          correlationId = Guid.NewGuid().ToString("D"),
                                          batchId = ""
                                      }
            };

            return transformedRequest;
        }

        private static List<FundingConfigurationDataType> GetFundingConfiguration()
        {
            return new List<FundingConfigurationDataType>
                       {
                           new FundingConfigurationDataType
                               {
                                   FundingTypeCode = "LEVY", // Not using constant, in case FSC/PTC changes - not using request data
                                   FundingStreamCode = FundingStreamCode,
                                   FundingStreamPeriodCode = FundingStreamPeriodCode,
                                   Period = Period,
                                   PeriodTypeCode = PeriodTypeCode
                               }
                       };
        }
    }
}
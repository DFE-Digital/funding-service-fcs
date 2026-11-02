namespace SFA.FCT.ContractCreateDomain.Implementation.Persistence.Entities
{
    using System;
    using System.Linq;
    using System.Diagnostics.CodeAnalysis;
    using Microsoft.Xrm.Sdk;
    using Repositories;

    [ExcludeFromCodeCoverage]
    public class AllocationNumberRequest : NumberRequest
    {
        private readonly string _fundingStreamPeriodCode;
        private const int ContractTypeId = 229660002;

        public AllocationNumberRequest(string contractType, string fundingtype, string fundingStreamCode, string period, string periodTypeCode, string fundingStreamPeriodCode)
        {
            ContractType = contractType;
            FundingType = fundingtype;
            FundingStreamCode = fundingStreamCode;
            Period = period;
            PeriodTypeCode = periodTypeCode;
            _fundingStreamPeriodCode = fundingStreamPeriodCode;
        }

        public string FundingStreamCode { get; set; }

        public string Period { get; set; }

        public string PeriodTypeCode { get; set; }

        public override void SetContractNumber(EntityCollection referenceData)
        {
            // Populate entity collections into their entity types
            var contractNumberEntities = referenceData.Entities.Where(e => e.LogicalName == "sfa_contractnumber");

            var fundingStreams = referenceData.Entities.Where(e => e.LogicalName == "sfa_fundingstream");
            var periodTypes = referenceData.Entities.Where(e => e.LogicalName == "sfa_periodtype");
            var fundingPeriods = referenceData.Entities.Where(e => e.LogicalName == "sfa_period");
            var fundingStreamsPeriods = referenceData.Entities.Where(e => e.LogicalName == "sfa_fundingstreamperiod");

            Entity fundingStreamEntity = fundingStreams.FirstOrDefault(
                fs => fs.GetAttributeValue<string>("sfa_fundingstreamcode") == FundingStreamCode);
            if (fundingStreamEntity == null)
            {
                throw new ApplicationException($"Funding Stream Code '{FundingStreamCode}' not found");
            }

            Entity periodTypeEntity = periodTypes.FirstOrDefault(
                p => p.GetAttributeValue<string>("sfa_periodtypecode") == PeriodTypeCode);
            if (periodTypeEntity == null)
            {
                throw new Exception($"Period Type '{PeriodTypeCode}' not found");
            }

            Entity periodEntity = fundingPeriods.FirstOrDefault(
                fp => fp.GetAttributeValue<string>("sfa_period") == Period 
                  && fp.GetAttributeValue<EntityReference>("sfa_periodtypeid").Id == periodTypeEntity.Id);
            if (periodEntity == null)
            {
                throw new Exception($"Funding Period Entity '{periodTypeEntity.Id}' not found");
            }

            Entity fundingStreamPeriodEntity = fundingStreamsPeriods.FirstOrDefault(
                fsp => fsp.GetAttributeValue<EntityReference>("sfa_fundingstreamcodeid").Id.Equals(fundingStreamEntity.Id)
                     && fsp.GetAttributeValue<EntityReference>("sfa_periodid").Id.Equals(periodEntity.Id));
            if (fundingStreamPeriodEntity == null)
            {
                throw new Exception($"Funding Stream Period Entity '{fundingStreamEntity.Id}' with PeriodId '{periodEntity.Id}' not found");
            }

            ContractNumberEntity = contractNumberEntities.Where(e => e.Attributes.Contains("sfa_fundingstreamid"))
                .FirstOrDefault(e => e.GetAttributeValue<EntityReference>("sfa_fundingstreamid").Id.Equals(fundingStreamEntity.Id) 
                             && e.GetAttributeValue<OptionSetValue>("sfa_contractnumbertype").Value.Equals(ContractTypeId));
            if (ContractNumberEntity == null)
            {
                throw new Exception($"Contract Number Entity '{ContractTypeId}' with fundingStreamId '{fundingStreamEntity.Id}' not found");
            }

            ContractNumberPrefix = fundingStreamPeriodEntity.GetAttributeValue<string>("sfa_allocationreferenceprefix");
        }

        public override SequenceType GetSequenceType()
        {
            return SequenceType.Allocation;
        }

        public override string GetPrefixContext()
        {
            return _fundingStreamPeriodCode;
        }
    }
}
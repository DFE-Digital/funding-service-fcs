namespace SFA.FCT.ContractCreateDomain.Implementation.Persistence.Entities
{
    using System;
    using System.Linq;
    using System.Diagnostics.CodeAnalysis;
    using Microsoft.Xrm.Sdk;
    using Repositories;

    [ExcludeFromCodeCoverage]
    public class ContractNumberRequest : NumberRequest
    {
        private const int ContractTypeId = 229660000;

        public ContractNumberRequest(string contractType, string fundingtype)
        {
            ContractType = contractType;
            FundingType = fundingtype;
        }

        public override void SetContractNumber(EntityCollection referenceData)
        {
            // Populate entity collections into their entity types
            var contractNumberEntities = referenceData.Entities.Where(e => e.LogicalName == "sfa_contractnumber");

            var fundingTypes = referenceData.Entities.Where(e => e.LogicalName == "sfa_fundingtype");

            var fundingTypeEntity = fundingTypes.FirstOrDefault(e => e.Attributes["sfa_fundingtypecode"].ToString() == FundingType);

            if (fundingTypeEntity == null)
            {
                throw new ApplicationException(string.Format("Funding Type Code '{0}' not found", FundingType));
            }

            ContractNumberEntity = contractNumberEntities.Where(e => e.Attributes.Contains("sfa_fundingtypeid"))
                .FirstOrDefault(e => e.GetAttributeValue<EntityReference>("sfa_fundingtypeid").Id.Equals(fundingTypeEntity.Id)
                                     && e.GetAttributeValue<OptionSetValue>("sfa_contractnumbertype").Value.Equals(ContractTypeId));

            if (ContractNumberEntity == null)
            {
                throw new ApplicationException(string.Format("Contract Number Entity '{0}' not found for", FundingType));
            }

            ContractNumberPrefix = fundingTypeEntity.GetAttributeValue<string>("sfa_contractreferenceprefix");
        }

        public override SequenceType GetSequenceType()
        {
            return SequenceType.Contract;
        }

        public override string GetPrefixContext()
        {
            return FundingType;
        }
    }
}
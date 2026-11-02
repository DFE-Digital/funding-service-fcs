namespace SFA.FCT.ContractCreateDomain.Implementation.Persistence.Entities
{
    using System.Linq;
    using System.Diagnostics.CodeAnalysis;
    using Microsoft.Xrm.Sdk;
    using Repositories;

    [ExcludeFromCodeCoverage]
    public class MasterContractNumberRequest : NumberRequest
    {
        private const int ContractTypeId = 229660001;

        public MasterContractNumberRequest(string contractType, string fundingtype)
        {
            ContractType = contractType;
            FundingType = fundingtype;
        }

        public override void SetContractNumber(EntityCollection referenceData)
        {
            var contractNumberEntities = referenceData.Entities.Where(e => e.LogicalName == "sfa_contractnumber");

            var agencyCollection = referenceData.Entities.Where(e => e.LogicalName == "sfa_agency");

            var fundingTypes = referenceData.Entities.Where(e => e.LogicalName == "sfa_fundingtype");

            Entity fundingTypeEntity = fundingTypes.First(e => e.GetAttributeValue<string>("sfa_fundingtypecode") == FundingType);
            Entity agencyEntity = agencyCollection.First(e => e.Attributes["sfa_agencyid"].Equals(((EntityReference)fundingTypeEntity.Attributes["sfa_agencyid"]).Id));
            ContractNumberEntity = contractNumberEntities.Where(e => e.Attributes.Contains("sfa_agencyid"))
                .First(a => a.GetAttributeValue<EntityReference>("sfa_agencyid").Id.Equals(agencyEntity.Id)
                         && a.GetAttributeValue<OptionSetValue>("sfa_contractnumbertype").Value.Equals(ContractTypeId));
            ContractNumberPrefix = agencyEntity.GetAttributeValue<string>("sfa_contractreferenceprefix");
        }

        public override SequenceType GetSequenceType()
        {
            return SequenceType.Master;
        }

        public override string GetPrefixContext()
        {
            return FundingType;
        }
    }
}
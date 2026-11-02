namespace FundingAllocation.Endpoints.ReleaseGroup
{
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    public interface IExtendedContractTypeTransformer
    {
        contract TransformToCorpContract(ExtendedContractType extendedContractType);
    }
}
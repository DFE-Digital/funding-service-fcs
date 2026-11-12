namespace FundingAllocation.Endpoints.ReleaseGroup
{
    using SFA.FCT.CrossDomain.Integration.Entities.CorporateContract;

    public interface IExtendedContractTypeTransformer
    {
        Contract TransformToCorpContract(ExtendedContractType extendedContractType);
    }
}
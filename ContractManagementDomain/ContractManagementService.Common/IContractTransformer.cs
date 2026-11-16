namespace SFA.FCT.ContractManagementService.Common
{
    using CorporateContract = CrossDomain.Integration.Entities.CorporateContract;
    using CorporateSchema = CrossDomain.Integration.Entities.CorporateSchema.Contract;

    public interface IContractTransformer
    {
        CorporateSchema.Contract TransformToCorporateSchemaContract(CorporateContract.Contract contract);
        CorporateSchema.contractDeliverablesTypeContractDeliverable ToCorporateSchemaDeliverable(
            CorporateContract.contractDeliverablesTypeContractDeliverable deliverable);
    }
}

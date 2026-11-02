namespace SFA.FCT.ContractRequestDomain.BusinessLogic.Interfaces
{
    using CrossDomain.Integration.Entities.ContractRequest;
    using CrossDomain.Integration.Entities.ExcelUpload;
    using NSBFramework;

    public interface ITransformToContractRequest : ITransform<dataLoadResults, contractRequestType[]>
    {
    }
}

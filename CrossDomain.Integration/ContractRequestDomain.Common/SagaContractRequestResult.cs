namespace SFA.FCT.ContractRequestDomain.Common
{
    using System.IO;
    using System.Text.Json;
    using CrossDomain.Integration.Entities.ContractRequest;

    public class SagaContractRequestResult 
    {
        public SagaContractRequestResult()
        {
            SerializedContractRequestResult = null;
        }

        public SagaContractRequestResult(contractRequestType contractRequestType)
        {
            ContractRequestResult result = new ContractRequestResult(contractRequestType);
            SerializedContractRequestResult = JsonSerializer.SerializeToUtf8Bytes(result);
        }

        public virtual byte[] SerializedContractRequestResult { get; set; }

        public ContractRequestResult GetContractRequestResult()
        {
            return JsonSerializer.Deserialize<ContractRequestResult>(SerializedContractRequestResult);
        }
    }
}

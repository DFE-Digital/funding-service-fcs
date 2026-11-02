namespace SFA.FCT.ContractRequestDomain.Common
{
    using System.IO;
    using System.Runtime.Serialization.Formatters.Binary;
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
            BinaryFormatter formatter = new BinaryFormatter();
            using (MemoryStream stream = new MemoryStream())
            {
                formatter.Serialize(stream, result);
                SerializedContractRequestResult = stream.ToArray();
            }
        }

        public virtual byte[] SerializedContractRequestResult { get; set; }

        public ContractRequestResult GetContractRequestResult()
        {
            ContractRequestResult result;

            using (var stream = new MemoryStream(SerializedContractRequestResult))
            {
                result = new BinaryFormatter().Deserialize(stream) as ContractRequestResult;
            }

            return result;
        }
    }
}

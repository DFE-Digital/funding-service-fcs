using System.ServiceModel;
using FctServices.MessageContract.GatewayService;

namespace FctServices.ServiceContract.GatewayService
{
    [ServiceContract(Namespace = "http://schemas.sfa.gov.uk/cpds.gatewayservice")]
    public interface GatewayServiceContract
    {

        [OperationContract(Action = "GetProvidersByUKPRN", ReplyAction = "http://schemas.sfa.gov.uk/cpds.gatewayservice/GatewayServiceContract/GetProvidersByUKPRNResponse")]
        GProvByUKPRNResponse GetProvidersByUKPRN(GProvByUKPRINRequest request);

        [OperationContract(Action = "GetProviderSummaryByName", ReplyAction = "http://schemas.sfa.gov.uk/cpds.gatewayservice/GatewayServiceContract/GetProviderSummaryByNameResponse")]
        GProvByNameResponse GetProviderSummaryByName(GProvByNameRequest request);

        [OperationContract(Action = "GetProvidersByUpin", ReplyAction = "http://schemas.sfa.gov.uk/cpds.gatewayservice/GatewayServiceContract/GetProvidersByUpinResponse")]
        GProvByUPINResponse GetProvidersByUpin(GProvByUPINRequest request);
    }
}

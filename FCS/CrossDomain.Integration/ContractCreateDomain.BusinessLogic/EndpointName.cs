namespace SFA.FCT.ContractCreateDomain.BusinessLogic
{
    using CrossDomain.Integration.Common;

    public static class EndpointName
    {
        public static string ContractCreateRequest
        {
            get { return FctEndpoint.GenerateEndpointName("ContractCreateDomain.CreateContract"); }
        }

        public static string ContractCreateInternalRequest
        {
            get { return FctEndpoint.GenerateEndpointName("ContractCreateDomain.CreateContractInternal"); }
        }

        public static string ContractUpdateRequest
        {
            get { return FctEndpoint.GenerateEndpointName("ContractCreateDomain.UpdateContract"); }
        }

        public static string ContractAmendmentRequest
        {
            get { return FctEndpoint.GenerateEndpointName("ContractCreateDomain.AmendContract"); }
        }

        public static string UpdateDraftContractAmendmentRequest
        {
            get { return FctEndpoint.GenerateEndpointName("ContractCreateDomain.UpdateDraftContractAmendment"); }
        }

        public static string XrmService
        {
            get { return FctEndpoint.GenerateEndpointName("ContractCreateDomain.XrmService"); }
        }

        public static string BulkUpload
        {
            get { return FctEndpoint.GenerateEndpointName("ContractRequestDomain.BulkUpload"); }
        }

        public static string DocumentGeneration
        {
            get { return FctEndpoint.GenerateEndpointName("DocumentsDomain.GenerateDocument"); }
        }

        public static string EngagementWatcher
        {
            get { return FctEndpoint.GenerateEndpointName("ContractRequestDomain.EngagementWatcher"); }
        }

        public static string IncrementContractVersion => "ContractCreateDomain.IncrementContractVersion";
    }
}

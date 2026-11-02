namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.DTO
{
    public class AzureAuthenticationConfig
    {
        public string AadInstance { get; set; } 

        public string Tenant { get; set; }

        public string ClientId { get; set; }

        public string AppKey { get; set; }

        public string ResourceId { get; set; }
    }
}

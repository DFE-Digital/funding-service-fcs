namespace SFA.FCT.DocumentsDomain.Common.Commands
{
    using CrossDomain.Integration.Entities.CorporateContract;

    public class UpdateContractPublishedToProviderFailedCommand
    {
        public contract CorporateContract { get; set; }

        public string ReasonForFailure { get; set; }
    }
}

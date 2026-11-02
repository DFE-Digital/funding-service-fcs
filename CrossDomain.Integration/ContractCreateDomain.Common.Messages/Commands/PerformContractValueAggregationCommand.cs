namespace SFA.FCT.ContractCreateDomain.Common.Messages.Commands
{
    using CrossDomain.Integration.Entities.CorporateContract;

    public class PerformContractValueAggregationCommand
    {
        public ExtendedContractType Contract { get; set; }
    }
}

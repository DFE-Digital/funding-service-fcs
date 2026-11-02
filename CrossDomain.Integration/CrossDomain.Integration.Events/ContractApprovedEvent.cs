namespace SFA.FCT.CrossDomain.Integration.Events
{
    using Entities.CorporateContract;

    public class ContractApprovedEvent
    {
        public contract CorporateContract { get; set; }

        public override string ToString()
        {
            return CorporateContract.ToString();
        }
    }
}

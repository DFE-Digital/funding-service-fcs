namespace SFA.FCT.CrossDomain.Integration.Entities.ContractRequest
{
    [System.Diagnostics.CodeAnalysis.ExcludeFromCodeCoverage]
    public class AllocationIdentityInfo
    {
        public AllocationIdentityInfo(string allocationNumber, string deliveryOrganisation)
        {
            AllocationNumber = allocationNumber;
            DeliveryOrganisation = deliveryOrganisation;
        }

        public string AllocationNumber { get; }

        public string DeliveryOrganisation { get; }
    }
}

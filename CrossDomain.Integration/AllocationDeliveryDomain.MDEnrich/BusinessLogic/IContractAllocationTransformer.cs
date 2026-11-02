namespace SFA.FCT.AllocationDeliveryDomain.MDEnrich.BusinessLogic
{
    using CrossDomain.Integration.Entities.DeliveryAllocation;
    using CorporateContract = CrossDomain.Integration.Entities.CorporateContract;

    public interface IContractAllocationTransformer
    {
        allocationType Transform(CorporateContract.contractType contract, CorporateContract.contractAllocationsContractAllocation contractAllocation, string corrorationId);
    }
}

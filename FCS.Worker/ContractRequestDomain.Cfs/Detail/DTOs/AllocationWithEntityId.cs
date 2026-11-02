namespace ContractRequestDomain.Cfs.Detail.DTOs
{
    using ContractRequestDomain.Cfs.Common.Dtos;

    public class AllocationWithEntityId
    {
        public AllocationWithEntityId(int entityId, Allocation allocation)
        {
            EntityId = entityId;
            Allocation = allocation;
        }

        public int EntityId { get; }

        public Allocation Allocation { get; }
    }
}

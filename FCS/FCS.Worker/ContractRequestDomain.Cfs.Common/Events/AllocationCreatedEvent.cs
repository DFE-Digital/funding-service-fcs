namespace ContractRequestDomain.Cfs.Common.Events
{
    using Dtos;

    public class AllocationCreatedEvent
    {
        public Allocation Allocation { get; set; }

        public override string ToString()
        {
            return Allocation.ToString();
        }
    }
}
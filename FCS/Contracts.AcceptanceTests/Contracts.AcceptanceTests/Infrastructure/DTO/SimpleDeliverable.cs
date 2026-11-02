namespace SFA.FCT.Contracts.AcceptanceTests.Infrastructure.DTO
{
    public class SimpleDeliverable
    {
        public SimpleDeliverable(string allocationNumber, int deliverableCode, decimal? actualValue, int? actualVolume)
        {
            AllocationNumber = allocationNumber;
            DeliverableCode = deliverableCode;
            ActualValue = actualValue;
            ActualVolume = actualVolume;
        }

        public string AllocationNumber { get; }

        public int DeliverableCode { get; }

        public decimal? ActualValue { get; }

        public int? ActualVolume { get; }
    }
}

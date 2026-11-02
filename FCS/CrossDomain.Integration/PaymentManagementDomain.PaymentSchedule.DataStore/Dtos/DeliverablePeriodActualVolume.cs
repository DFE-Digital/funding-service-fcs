namespace SFA.FCT.PaymentManagementDomain.PaymentSchedule.DataStore.Dtos
{
    public class DeliverablePeriodActualVolume
    {
        public DeliverablePeriodActualVolume(string period, int deliverableCode, int? volume)
        {
            Period = period;
            DeliverableCode = deliverableCode;
            Volume = volume;
        }

        public string Period { get; }

        public int DeliverableCode { get; }

        public int? Volume { get; }
    }
}

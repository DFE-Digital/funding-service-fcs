namespace SFA.FCT.Operations.Integrity.DTOs
{
    public class DeliverablePaymentKey
    {
        public DeliverablePaymentKey(string allocationNumber, int versionNumber, int deliverableCode, int period, string fsp)
        {
            AllocationNumber = allocationNumber;
            VersionNumber = versionNumber;
            DeliverableCode = deliverableCode;
            Period = period;
            Fsp = fsp;
        }

        public string AllocationNumber { get; }
        public int VersionNumber { get; }
        public int DeliverableCode { get; }
        public int Period { get; }
        public string Fsp { get; }
        public string Key => $"{AllocationNumber}_{VersionNumber}_{DeliverableCode}_{Period}";

        

        public override bool Equals(object obj)
        {
            if (obj is DeliverablePaymentKey other)
            {
                return AllocationNumber == other.AllocationNumber &&
                       VersionNumber == other.VersionNumber &&
                       DeliverableCode == other.DeliverableCode &&
                       Period == other.Period;
            }

            return false;
        }

        public override int GetHashCode()
        {
            return AllocationNumber.GetHashCode() ^ VersionNumber.GetHashCode() ^
                   DeliverableCode.GetHashCode() ^ Period.GetHashCode();
        }
    }
}

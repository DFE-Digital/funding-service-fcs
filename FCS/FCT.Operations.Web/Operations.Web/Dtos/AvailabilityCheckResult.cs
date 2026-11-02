namespace Operations.Web.Dtos
{
    public class AvailabilityCheckResult
    {
        public AvailabilityCheckResult(string serviceName, bool isAvailable)
        {
            ServiceName = serviceName;
            IsAvailable = isAvailable;
        }

        public string ServiceName { get; set; }

        public bool IsAvailable { get; } 

        public string Details { get; set; }

        public string SupplementaryInfo { get; set; }
    }
}
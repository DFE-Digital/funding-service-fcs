namespace FundingAllocation.DataStore.Model
{
    public class StatusSubStatusConfig
    {
        private StatusSubStatusConfig() 
        { }

        public StatusSubStatusConfig(string status, string subStatus)
        {
            Status = status;
            SubStatus = subStatus;
        }

        public string Status { get; private set; }

        public string SubStatus { get; private set; }
    }
}

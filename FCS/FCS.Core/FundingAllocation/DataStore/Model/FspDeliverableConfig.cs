namespace FundingAllocation.DataStore.Model
{
    using System.Collections.Generic;

    public class FspDeliverableConfig
    {
        private FspDeliverableConfig()
        {
        }

        public FspDeliverableConfig(string fspCode, int deliverableCode, string deliverableName, int displayOrder)
        {
            FspCode = fspCode;
            DeliverableCode = deliverableCode;
            DeliverableName = deliverableName;
            DisplayOrder = displayOrder;
        }

        public string FspCode { get; private set; }
        public int DeliverableCode { get; private set; }
        public string DeliverableName { get; private set; }
        public int DisplayOrder { get; private set; }

        public List<AllocationLineConfig> AllocationLineConfigs { get; private set; }
    }
}
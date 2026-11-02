namespace Operations.Web.Dtos
{
    using System;
    using System.Globalization;
    using ContractManagement.DataStore.Model;

    public class ContractAtomFeedInfo
    {
        public ContractAtomFeedInfo()
        {
        }
        public ContractAtomFeedInfo(int id, int itemType, string businessKey, DateTime createdDate)
        {
            Id = id;
            ItemType = itemType;
            BusinessKey = businessKey;
            CreatedDate = createdDate;
        }

        public string BusinessKey { get; set; }
        public int Id { get; set; }
        public DateTime CreatedDate { get; set; }
        public string CreatedDateString => CreatedDate.ToString("g", new CultureInfo("en-GB"));
        public int ItemType { get; set; }
        public string ItemTypeString => ((AtomItemType)ItemType).ToString();
        public string ContractNumber => BusinessKey.Split(':')[0];
        public int Version => int.Parse(BusinessKey.Split(':')[1].Split('.')[0]);
        public int SubVersion => int.Parse(BusinessKey.Split(':')[1].Split('.')[1]);
    }
}
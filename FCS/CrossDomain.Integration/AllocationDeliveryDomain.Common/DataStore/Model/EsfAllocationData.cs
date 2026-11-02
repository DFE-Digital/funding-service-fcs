namespace SFA.FCT.AllocationDeliveryDomain.Common.DataStore.Model
{
    using System;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;

    public class EsfAllocationData
    {
       
        [Key,Column(Order=0)]
        public string ContractNumber { get; set; }

        [Index("IX_ContractAllocationNumber", 1, IsUnique = false)]
        [Key, Column(Order = 1)]
        public string ContractAllocationNumber { get; set; }

        public string TenderSpecReference { get; set; }
        
        public string LotReference { get; set; }

        public string SpecificationTitle { get; set; }

        public string AwardReference { get; set; }

        public string ActivityDescription { get; set; }

        public string InvestmentPriority { get; set; }

        public string LEPCode { get; set; }

        public string LEPName { get; set; }

        public string RegionType { get; set; }

        public string AgreementNumber { get; set; }

        public string LearningRatePremium { get; set; }

        public decimal InvestmentPriorityNumber
        {
            get
            {
                const char space = ' ';
                string[] investmentPrioritySplit = InvestmentPriority.Split(space);

                return decimal.Parse(investmentPrioritySplit[0]);
            }
        }

        public string RegionTypeTrimmed
        {
            get
            {
                const string space =  " ";
                return RegionType.Replace(space, String.Empty);
            }
        }
    }
}

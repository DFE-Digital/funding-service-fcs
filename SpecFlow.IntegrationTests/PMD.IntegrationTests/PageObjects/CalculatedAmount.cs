using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PMD.IntegrationTests.PageObjects
{
    public class CalculatedAmount
    {
        public CalculatedAmount()
        {
            Amounts = new List<PeriodAmount>();
        }

        public string ContractNumber { get; set; }

        public string AllocationNumber { get; set; }

        public int DeliverableOrSubnominalCode { get; set; }

        public List<PeriodAmount> Amounts { get; set; }
    }


    public class PeriodAmount
    {
        public string Period { get; set; }

        public decimal? Amount { get; set; }
    }

    public enum CalculationType
    {
        Reconcilliation,
        Net,
        Capping,
        Profile,
        Balancing
    }
}

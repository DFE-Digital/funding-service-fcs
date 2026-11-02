using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EndToEndTests.ValueObjects
{
    public class Payment
    {
        public string ContractId { get; set; }
        public int ValuePounds { get; set; }
        public int PeriodNumber { get; set; }

        public Payment Clone()
        {
            return new Payment
            {
                ContractId = ContractId,
                ValuePounds = ValuePounds,
                PeriodNumber = PeriodNumber
            };
        }
    }
}

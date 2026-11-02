using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace FundingAllocation.Dto
{
    public class FundingLineValue
    {
        public FundingLineValue(decimal fundingValue, string fundingLineCode, string fundingId) 
        { 
            FundingLineCode = fundingLineCode;
            FundingValue = fundingValue;
            FundingId = fundingId;
        }

        public string FundingLineCode { get; set; }
        public decimal FundingValue { get; set; }
        public string FundingId { get; set; }
    }
}

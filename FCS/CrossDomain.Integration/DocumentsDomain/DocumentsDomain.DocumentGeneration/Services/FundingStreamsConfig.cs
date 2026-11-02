using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SFA.FCT.DocumentsDomain.DocumentGeneration.Services
{
    internal class FundingStreamsConfig
    {
        public List<string> ExcludeSchedulesAndTnC { get; set; }
        public List<int> ExcludeYears { get; set; }
        public int AllowedPeriod { get; set; }

    }
}

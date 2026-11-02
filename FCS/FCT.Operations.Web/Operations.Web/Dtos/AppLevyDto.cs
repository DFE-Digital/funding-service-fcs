using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Operations.Web.Dtos
{
    public class AppLevyDto
    {
        public string ContractNumber { get; set; }
        public string ContractStatus { get; set; }
        public string ContractSubStatus { get; set; }
        public string IsLetterBespoke { get; set; }
        public string IsTnCBespoke { get; set; }
    }
}

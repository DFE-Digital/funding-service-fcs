namespace SFA.FCT.DocumentsDomain.Common.Models
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
    using System.Threading.Tasks;

    public class DocumentDeleteRequest
    {
        public string DocumentFilename { get; set; }

        public string DocumentLocation { get; set; }
    }
}

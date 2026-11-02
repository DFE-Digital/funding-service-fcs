using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace Operations.Web.Dtos
{
    public class CopyDocumentsRequest
    {
        public string SourceContainer { get; set; }
        public string DestinationContainer { get; set; }
    }
}
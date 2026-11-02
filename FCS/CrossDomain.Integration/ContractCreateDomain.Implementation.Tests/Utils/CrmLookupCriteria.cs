using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SFA.FCT.Contract.XrmAdapterService.Tests.Utils
{
    public class CrmLookupCriteria
    {
        public string EntityName { get; set; }

        public List<ColumnValueCriteria> LookupCriteria { get; set; }

    }
}

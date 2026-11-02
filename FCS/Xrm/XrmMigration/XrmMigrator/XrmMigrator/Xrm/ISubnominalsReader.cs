using System.Collections.Generic;
using XrmMigrator.Dto;

namespace XrmMigrator.Xrm
{
    public interface ISubnominalsReader
    {
        IEnumerable<DeliverablePeriodSubnominal> Read();
    }
}
